import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../domain/ai/ai_engine.dart' hide ChatMessage;
import '../../domain/pet/pet_engine.dart' hide PetSkin;
import '../../domain/gamification/achievements.dart';
import '../../domain/leaderboard/leaderboard_engine.dart';
import '../../domain/prices/price_models.dart';
import 'goal_repository.dart';
import 'providers.dart';
import 'retention_repositories.dart';
import 'scanner_repositories.dart';
import 'social_repositories.dart';
import 'system_repositories.dart';

/// ── UI-facing stream providers (Drift → Riverpod) ───────────────────────

/// Unread notifications badge.
final unreadCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.notificationsCache)
        ..where((t) => t.read.equals(false)))
      .watch()
      .map((rows) => rows.length);
});

/// Scanner product scans.
final scanProvider = StreamProvider.family<ProductScan?, String>((ref, product) async* {
  final repo = ref.watch(scannerRepositoryProvider);
  // Initial + on tick (no server push locally; re-scan on demand).
  yield await repo.scanFor(product);
  ref.watch(scanTickProvider);
  yield await repo.scanFor(product);
});

final scanTickProvider = StateProvider<int>((ref) => 0);

/// Chest / pet / quests / events live providers.
final chestStateProvider = FutureProvider.autoDispose<ChestState>((ref) async {
  ref.watch(chestOpenedTickProvider);
  ref.watch(chestDayTickProvider);
  return ref.watch(chestRepositoryProvider).stateNow();
});

final chestDayTickProvider = StateProvider<int>((ref) => 0);

final petStateProvider = FutureProvider.autoDispose<PetState>((ref) async {
  ref.watch(petVisitTickProvider);
  return ref.watch(petRepositoryProvider).stateNow();
});

final petVisitTickProvider = StateProvider<int>((ref) => 0);

final questsDailyProvider = FutureProvider.autoDispose<List<QuestState>>((ref) async {
  ref.watch(questTickProvider);
  return ref.watch(questRepositoryProvider).dailyNow();
});

final questsWeeklyProvider = FutureProvider.autoDispose<List<QuestState>>((ref) async {
  ref.watch(questTickProvider);
  return ref.watch(questRepositoryProvider).weeklyNow();
});

final questTickProvider = StateProvider<int>((ref) => 0);

final activeEventProvider = FutureProvider.autoDispose((ref) async {
  ref.watch(eventTickProvider);
  return ref.watch(eventsRepositoryProvider).activeEvent();
});

final eventTickProvider = StateProvider<int>((ref) => 0);

final chipsWalletProvider = StreamProvider<ChipsWalletTableData>((ref) {
  return ref.watch(chipsRepositoryProvider).watch();
});

/// Countdown tick (1s) for quests reset / event countdown / next scan.
final countdownTickProvider = StreamProvider<int>((ref) {
  final ctrl = StreamController<int>();
  var i = 0;
  final timer = Timer.periodic(const Duration(seconds: 1), (_) => ctrl.add(i++));
  ref.onDispose(() {
    timer.cancel();
    unawaited(ctrl.close());
  });
  return ctrl.stream;
});

/// Chat messages stream.
final chatMessagesProvider = StreamProvider<List<ChatMessage>>((ref) {
  return ref.watch(aiRepositoryProvider).watchMessages();
});

/// AI usage stream-ish provider.
final aiUsageProvider = FutureProvider.autoDispose<AiUsageState>((ref) async {
  ref.watch(aiTickProvider);
  return ref.watch(aiRepositoryProvider).usage();
});

final aiTickProvider = StateProvider<int>((ref) => 0);

/// Notifications list.
final notificationsProvider = StreamProvider<List<NotificationsCacheData>>((ref) {
  return ref.watch(notificationsRepositoryProvider).watchAll();
});

/// History contributions with filters.
class HistoryQuery {
  const HistoryQuery({
    this.filter = HistoryFilter.all,
    this.newestFirst = true,
    this.search = '',
  });
  final HistoryFilter filter;
  final bool newestFirst;
  final String search;

  HistoryQuery copyWith({
    HistoryFilter? filter,
    bool? newestFirst,
    String? search,
  }) =>
      HistoryQuery(
        filter: filter ?? this.filter,
        newestFirst: newestFirst ?? this.newestFirst,
        search: search ?? this.search,
      );
}

final historyQueryProvider = StateProvider<HistoryQuery>((ref) => const HistoryQuery());

final historyProvider = StreamProvider<List<ContributionView>>((ref) {
  final q = ref.watch(historyQueryProvider);
  return ref.watch(goalRepositoryProvider).watchContributions(
        filter: q.filter,
        newestFirst: q.newestFirst,
        searchQuery: q.search.isEmpty ? null : q.search,
      );
});

/// Cumulative curve for the History chart.
final cumulativeCurveProvider = FutureProvider.autoDispose<List<(DateTime, int)>>((ref) async {
  ref.watch(historyQueryProvider);
  return ref.watch(goalRepositoryProvider).cumulativeCurve();
});

/// Achievements list.
final achievementsProvider =
    FutureProvider.autoDispose<List<(AchievementDef, DateTime?)>>((ref) async {
  ref.watch(questTickProvider);
  return ref.watch(goalRepositoryProvider).getAchievements();
});

/// Ghost race + self row.
final ghostPairProvider = FutureProvider.autoDispose<GhostPair>((ref) async {
  ref.watch(questTickProvider);
  return ref.watch(leaderboardRepositoryProvider).ghostPairNow();
});

/// Buddy snapshot stream.
final buddyProvider = StreamProvider<BuddyCacheData>((ref) {
  return ref.watch(buddyRepositoryProvider).watch();
});

/// Progress card stream.
final progressCardProvider = StreamProvider<ProgressCard>((ref) {
  return ref.watch(progressCardRepositoryProvider).watch();
});

/// API keys stream.
final apiKeysProvider = StreamProvider<List<ApiKey>>((ref) {
  return ref.watch(apiKeysRepositoryProvider).watchAll();
});

/// Bundle search result (recomputed on tick).
final bundleResultProvider = FutureProvider.autoDispose((ref) async {
  ref.watch(scanTickProvider);
  final repo = ref.watch(bundleRepositoryProvider);
  final previous = await repo.previousResult();
  return repo.search(previous: previous);
});

/// App theme override + reduce motion + reveal flags.
final amountRevealedProvider = StateProvider<bool>((ref) => false);

/// Leaderboard opt-in stream (settings toggle + first-entry dialog).
final leaderboardOptInProvider = StreamProvider<LeaderboardOptInData>((ref) {
  return ref.watch(leaderboardRepositoryProvider).watchOptIn();
});

/// Holo-cards providers (§10.6).
final holoCardsProvider = StreamProvider<List<HoloCard>>((ref) {
  return ref.watch(holoRepositoryProvider).watchCards();
});

final holoOwnedProvider = StreamProvider<List<HoloOwnedData>>((ref) {
  return ref.watch(holoRepositoryProvider).watchOwned();
});

/// ── Connectivity (ONLINE-ONLY app, v0.9.2) ──────────────────────────────
/// The app has no offline mode: when the device loses the internet a global
/// honest banner appears and network features surface errors instead of
/// falling back to local/seed/mock data (⛔ no fake substitution).
final onlineProvider = StreamProvider<bool>((ref) {
  return Connectivity().onConnectivityChanged.map(
        (results) => results.any((s) => s != ConnectivityResult.none),
      );
});
