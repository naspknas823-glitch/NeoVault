import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/security/pin.dart';
import '../../core/utils/format.dart';
import '../../domain/ai/ai_engine.dart' hide ChatMessage;
import 'goal_repository.dart';
import 'providers.dart';
import 'scanner_repositories.dart';
import 'retention_repositories.dart';
import '../../domain/prices/price_models.dart';
import '../../domain/quests/quest_engine.dart';
import '../../data/cloud/cloud_gateway.dart';
import 'package:uuid/uuid.dart';

/// ── Settings (key-value; cloud conflict rule: last-write-wins) ──────────
class SettingsRepository {
  SettingsRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);

  Future<String?> get(String key) async {
    final row = await (_db.select(_db.settings)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> set(String key, String value) async {
    await _db.into(_db.settings).insertOnConflictUpdate(SettingsCompanion.insert(
          key: key,
          value: value,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ));
    unawaitedSync(_ref.read(syncEngineProvider).enqueue(
          entityId: key,
          entityType: 'settings',
          payload: {'key': key, 'value': value},
        ));
  }

  Stream<String?> watch(String key) =>
      (_db.select(_db.settings)..where((t) => t.key.equals(key)))
          .watchSingleOrNull()
          .map((r) => r?.value);

  // Typed helpers (§6.11).
  Future<void> setThemeId(String id) => set('theme_id', id);
  Future<String?> themeId() => get('theme_id');

  Future<void> setReduceMotion(bool v) => set('reduce_motion', '$v');
  Future<bool> reduceMotion() async => (await get('reduce_motion')) == 'true';

  Future<void> setSoundVolume(int v) => set('sound_volume', '$v');
  Future<int> soundVolume() async => int.tryParse(await get('sound_volume') ?? '') ?? 70;

  Future<void> setHaptics(int v) => set('haptics_intensity', '$v');
  Future<int> haptics() async => int.tryParse(await get('haptics_intensity') ?? '') ?? 100;

  Future<void> setNotifPref(String type, bool v) => set('notif_$type', '$v');
  Future<bool> notifPref(String type) async =>
      (await get('notif_$type')) != 'false';

  Future<void> setDnd(bool v) => set('dnd', '$v');
  Future<bool> dnd() async => (await get('dnd')) == 'true';

  Future<void> setReminder({required int weekday, required int hour, required int minute}) =>
      set('reminder', '$weekday:$hour:$minute');
  Future<(int, int, int)?> reminder() async {
    final raw = await get('reminder');
    if (raw == null) return null;
    final parts = raw.split(':').map(int.tryParse).toList();
    if (parts.length != 3 || parts.any((p) => p == null)) return null;
    return (parts[0]!, parts[1]!, parts[2]!);
  }

  Future<void> setLocale(String code) => set('locale', code);
  Future<String?> locale() => get('locale');

  Future<void> setOnboarded(bool v) => set('onboarded', '$v');
  Future<bool> onboarded() async => (await get('onboarded')) == 'true';

  Future<void> setSetupWizardCompleted(bool v) => set('setup_wizard', '$v');
  Future<bool> setupWizardCompleted() async => (await get('setup_wizard')) == 'true';

  Future<void> setFirstDepositSurpriseShown(bool v) => set('first_deposit_surprise', '$v');
  Future<bool> firstDepositSurpriseShown() async => (await get('first_deposit_surprise')) == 'true';

  Future<void> setLeaderboardOptIn(bool v) => set('lb_optin', '$v');

  Future<void> setBundlePriority(String p) => set('bundle_priority', p);
  Future<String> bundlePriority() async => await get('bundle_priority') ?? 'optimal';

  Future<void> setRateNeverAsk() => set('rate_never', 'true');

  // (30) Vacation mode — pauses streak penalties while user is away.
  Future<void> setVacationMode(bool enabled, {DateTime? until}) async {
    await set('vacation_mode', enabled ? 'true' : 'false');
    if (until != null) {
      await set('vacation_until', until.millisecondsSinceEpoch.toString());
    } else {
      await set('vacation_until', '0');
    }
  }

  Future<bool> vacationMode() async => (await get('vacation_mode')) == 'true';

  Future<DateTime?> vacationUntil() async {
    final raw = await get('vacation_until');
    final ms = int.tryParse(raw ?? '0') ?? 0;
    if (ms <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  // (27) Quick phrases — saved phrases for comment field.
  Future<void> setQuickPhrases(List<String> phrases) async {
    await set('quick_phrases', phrases.join('|||'));
  }

  Future<List<String>> quickPhrases() async {
    final raw = await get('quick_phrases');
    if (raw == null || raw.isEmpty) {
      return ['☕ Coffee money', '🛒 Groceries', '🎮 Gaming', '💰 Bonus'];
    }
    return raw.split('|||').where((s) => s.isNotEmpty).toList();
  }

  // (25) Sound brand — custom sound enabled flag.
  Future<void> setSoundBrand(bool v) => set('sound_brand', '$v');
  Future<bool> soundBrand() async => (await get('sound_brand')) != 'false';

  // (26) Haptic patterns — pattern intensity level (0-2).
  Future<void> setHapticPattern(int v) => set('haptic_pattern', '$v');
  Future<int> hapticPattern() async =>
      int.tryParse(await get('haptic_pattern') ?? '') ?? 1;

  // (30) Salary day (for context triggers).
  Future<void> setSalaryDay(int day) => set('salary_day', '$day');
  Future<int> salaryDay() async =>
      int.tryParse(await get('salary_day') ?? '') ?? 15;
}

/// ── Notifications cache (§6.10, §7.3) ───────────────────────────────────
/// «Не турбувати» blocks PUSH but never in-app (⛔ §12.5 criterion 12.5).
enum NotifType { prices, achievements, levels, contrib, system }

class NotificationsRepository {
  NotificationsRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);
  SettingsRepository get _settings => _ref.read(settingsRepositoryProvider);

  Stream<List<NotificationsCacheData>> watchAll() =>
      (_db.select(_db.notificationsCache)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<int> unreadCount() async {
    final c = _db.notificationsCache.id.count();
    final q = _db.selectOnly(_db.notificationsCache)
      ..addColumns([c])
      ..where(_db.notificationsCache.read.equals(false));
    return (await q.getSingle()).read(c) ?? 0;
  }

  /// In-app notification: always stored (never blocked by DnD ⛔).
  Future<void> pushInApp({
    required NotifType type,
    required String titleKey,
    required String bodyKey,
    Map<String, Object?> bodyParams = const {},
    String? deepLink,
  }) async {
    await _db.into(_db.notificationsCache).insert(NotificationsCacheCompanion.insert(
          id: const Uuid().v4(),
          type: type.name,
          titleKey: titleKey,
          bodyKey: bodyKey,
          bodyParamsJson: Value(jsonEncode(bodyParams)),
          deepLink: Value(deepLink),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          isPush: const Value(false),
        ));
  }

  /// Push notification: sent ONLY if the type is enabled AND DnD is off.
  Future<bool> pushRemote({
    required NotifType type,
    required String titleKey,
    required String bodyKey,
    Map<String, Object?> bodyParams = const {},
    String? deepLink,
  }) async {
    final typeEnabled = await _settings.notifPref(type.name);
    final dndOn = await _settings.dnd();
    final allowed = typeEnabled && !dndOn;
    if (!allowed) return false;
    // Production: FCM via backend `sendPush` CF. Stored as isPush row for
    // the in-app trace when deliverable.
    await pushInApp(
      type: type,
      titleKey: titleKey,
      bodyKey: bodyKey,
      bodyParams: bodyParams,
      deepLink: deepLink,
    );
    return true;
  }

  Future<void> markRead(String id) async {
    await (_db.update(_db.notificationsCache)..where((t) => t.id.equals(id)))
        .write(const NotificationsCacheCompanion(read: Value(true)));
  }

  Future<void> markAllRead() async {
    await (_db.update(_db.notificationsCache)
          ..where((t) => t.read.equals(false)))
        .write(const NotificationsCacheCompanion(read: Value(true)));
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.notificationsCache)..where((t) => t.id.equals(id))).go();
  }
}

/// ── PIN / biometrics (§6.21–6.23, §8.3) ─────────────────────────────────
class PinRepository {
  PinRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);

  Future<PinMetaData> _row() async =>
      (_db.select(_db.pinMeta)..where((t) => t.id.equals('main'))).getSingle();

  Future<bool> hasPin() async => (await _row()).pinHash != null;

  Future<bool> biometricEnabled() async => (await _row()).biometricEnabled;

  Future<int> autolockMinutes() async => (await _row()).autolockMinutes;

  /// ⛔ Weak-PIN validation happens BEFORE hashing (§6.21).
  Future<String?> setupPin(String pin) async {
    final weak = PinSecurity.validate(pin);
    if (weak != null) return weak;
    final salt = PinSecurity.newSalt();
    final hash = PinSecurity.hash(pin, salt);
    await (_db.update(_db.pinMeta)..where((t) => t.id.equals('main'))).write(
      PinMetaCompanion(
        pinHash: Value(hash),
        salt: Value(salt),
        failedAttempts: const Value(0),
        lockedUntil: const Value(null),
      ),
    );
    return null;
  }

  Future<void> setBiometric(bool enabled) async {
    await (_db.update(_db.pinMeta)..where((t) => t.id.equals('main')))
        .write(PinMetaCompanion(biometricEnabled: Value(enabled)));
  }

  Future<void> setAutolock(int minutes) async {
    await (_db.update(_db.pinMeta)..where((t) => t.id.equals('main')))
        .write(PinMetaCompanion(autolockMinutes: Value(minutes)));
  }

  /// Verify + lockout state machine (⛔ 5 fails → 30 s; 10 → sign out).
  Future<PinVerifyResult> verify(String pin, {required bool isAuthed}) async {
    final row = await _row();
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final lockout = PinLockout(failedAttempts: row.failedAttempts, lockedUntilMs: row.lockedUntil);
    if (lockout.isLocked(nowMs)) return const PinVerifyResult.lockedOut();

    final ok = row.pinHash != null &&
        row.salt != null &&
        PinSecurity.verify(pin, row.salt!, row.pinHash!);
    if (ok) {
      await (_db.update(_db.pinMeta)..where((t) => t.id.equals('main'))).write(
        const PinMetaCompanion(failedAttempts: Value(0), lockedUntil: Value(null)),
      );
      return const PinVerifyResult.success();
    }
    final next = lockout.registerFailure(nowMs);
    await (_db.update(_db.pinMeta)..where((t) => t.id.equals('main'))).write(
      PinMetaCompanion(
        failedAttempts: Value(next.failedAttempts),
        lockedUntil: Value(next.lockedUntilMs),
      ),
    );
    if (next.shouldSignOut) {
      // 10 fails → sign out (guest: local wipe warning handled by UI).
      return const PinVerifyResult.signOut();
    }
    return PinVerifyResult.failure(remaining: next.failedAttempts, locked: next.isLocked(nowMs));
  }

  Future<void> clearPin() async {
    await (_db.update(_db.pinMeta)..where((t) => t.id.equals('main'))).write(
      const PinMetaCompanion(
        pinHash: Value(null),
        salt: Value(null),
        failedAttempts: Value(0),
        lockedUntil: Value(null),
        biometricEnabled: Value(false),
      ),
    );
  }
}

sealed class PinVerifyResult {
  const PinVerifyResult();
  const factory PinVerifyResult.success() = PinSuccess;
  const factory PinVerifyResult.failure({required int remaining, required bool locked}) = PinFailure;
  const factory PinVerifyResult.lockedOut() = PinLockedOut;
  const factory PinVerifyResult.signOut() = PinSignOut;
}

class PinSuccess extends PinVerifyResult {
  const PinSuccess();
}

class PinFailure extends PinVerifyResult {
  const PinFailure({required this.remaining, required this.locked});
  final int remaining;
  final bool locked;
}

class PinLockedOut extends PinVerifyResult {
  const PinLockedOut();
}

class PinSignOut extends PinVerifyResult {
  const PinSignOut();
}

/// ── AI repository (§6.8, §7.2) ──────────────────────────────────────────
class AiRepository {
  AiRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);
  GoalRepository get _goals => _ref.read(goalRepositoryProvider);

  Stream<List<ChatMessage>> watchMessages() =>
      (_db.select(_db.chatMessages)..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();

  Future<AiUsageState> usage() async {
    final stats = await _goals.rawStats();
    final day = kyivDateKey();
    final row = await (_db.select(_db.aiUsageTable)..where((t) => t.id.equals(day)))
        .getSingleOrNull();
    return AiEngine.usageFor(
      isAuthed: stats.authed,
      todayKey: day,
      usedToday: row?.used ?? 0,
    );
  }

  /// Build the aggregated context (§6.8) — aggregates only, no raw DB.
  Future<AiContext> context() async {
    final goal = await _goals.getGoal();
    final stats = await _goals.statsSnapshot();
    final scanner = _ref.read(scannerRepositoryProvider);
    final ps5 = await scanner.scanFor('ps5');
    final mon = await scanner.scanFor('monitor');
    return AiContext(
      balance: goal?.saved ?? 0,
      goalPercent: goal?.percent ?? 0,
      ps5Price: ps5.lowestPrice,
      monitorPrice: mon.lowestPrice,
      level: stats.level,
      streakDays: stats.streakDays,
      lastContributionDate: stats.lastContributionDate?.toIso8601String(),
      achievementsCount: stats.visitedScreens.length, // replaced below
      lowestPrice: ps5.lowestPrice,
      priceTrend: switch (ps5.changeDir) {
        PriceChangeDir.up => 'up',
        PriceChangeDir.down => 'down',
        _ => 'flat',
      },
    );
  }

  /// Send: limit check → Cloud Function (or fallback) → persist both sides.
  Future<AiReply> send({
    required AiMode mode,
    required String text,
  }) async {
    final usageState = await usage();
    if (!AiEngine.canRequest(usageState)) {
      throw const AiLimitReached();
    }
    final day = kyivDateKey();
    await _db.into(_db.aiUsageTable).insertOnConflictUpdate(
          AiUsageTableCompanion.insert(id: day, used: Value(usageState.usedToday + 1)),
        );
    final userMsg = ChatMessagesCompanion.insert(
      id: const Uuid().v4(),
      role: 'user',
      mode: mode.name,
      content: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _db.into(_db.chatMessages).insert(userMsg);
    await _goals.trackAiQuestion();
    await _ref.read(questRepositoryProvider).track(QuestType.askAi);

    // Cloud Function `chatWithAI(mode)` — key stays server-side (⛔ §7.2).
    try {
      final gateway = _ref.read(cloudGatewayProvider);
      final ctx = await context();
      final response = await gateway.callFunction('chatWithAI', {
        'mode': mode.name,
        'message': text,
        'context': ctx.toPayload(),
      });
      final reply = (response['reply'] as String?) ?? '';
      if (reply.isEmpty) throw StateError('empty reply');
      await _insertAssistant(reply, mode, fromFallback: false);
      return AiReply(text: reply, fromFallback: false);
    } on CloudUnavailableException {
      // Fallback presets + offline indicator (§6.8, §7.2).
      final ctx = await context();
      final reply = AiEngine.fallbackReply(mode, ctx);
      await _insertAssistant(reply.text, mode, fromFallback: true);
      return reply;
    }
  }

  Future<void> _insertAssistant(String text, AiMode mode, {required bool fromFallback}) async {
    await _db.into(_db.chatMessages).insert(ChatMessagesCompanion.insert(
          id: const Uuid().v4(),
          role: 'assistant',
          mode: mode.name,
          content: text,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          fromFallback: Value(fromFallback),
        ));
  }

  Future<void> clearHistory() async {
    await _db.chatMessages.deleteAll();
  }
}

class AiLimitReached implements Exception {
  const AiLimitReached();
}

/// ── Rate App (§6.16): 3rd contribution AND 5+ days since install,
/// ≥30 days cooldown; ignore → never within 30 days. ─────────────────────
class RateAppRepository {
  RateAppRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);

  /// Should the In-App Review dialog be shown now?
  Future<bool> shouldPrompt() async {
    final state = await (_db.select(_db.rateAppState)..where((t) => t.id.equals('main')))
        .getSingle();
    if (state.neverAsk) return false;
    final now = DateTime.now();
    final install = await _installDate();
    if (install == null || now.difference(install).inDays < 5) return false;
    final stats = await _ref.read(goalRepositoryProvider).rawStats();
    if (stats.contributionsCount < 3) return false;
    final last = state.lastPromptAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(state.lastPromptAt!);
    if (last != null && now.difference(last).inDays < 30) return false;
    if (state.contribsAtLastPrompt >= stats.contributionsCount &&
        last != null &&
        now.difference(last).inDays < 30) {
      return false;
    }
    return true;
  }

  Future<void> onPromptShown({required bool ignored}) async {
    final stats = await _ref.read(goalRepositoryProvider).rawStats();
    await (_db.update(_db.rateAppState)..where((t) => t.id.equals('main'))).write(
      RateAppStateCompanion(
        lastPromptAt: Value(DateTime.now().millisecondsSinceEpoch),
        contribsAtLastPrompt: Value(stats.contributionsCount),
        neverAsk: const Value(false),
      ),
    );
  }

  Future<void> neverAskAgain() async {
    await (_db.update(_db.rateAppState)..where((t) => t.id.equals('main')))
        .write(const RateAppStateCompanion(neverAsk: Value(true)));
  }

  Future<DateTime?> _installDate() async {
    final row = await _ref.read(goalRepositoryProvider).rawStats();
    return DateTime.fromMillisecondsSinceEpoch(row.installDate);
  }
}

/// ── App config (§6.18/§6.19): force update + maintenance via app_config ─
class AppConfigRepository {
  AppConfigRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);

  Future<String?> value(String key) async {
    final row = await (_db.select(_db.appConfigTable)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.valueJson;
  }

  /// Version gate (§6.18): current < min_version → Force Update screen.
  /// Server responds 426 or min_version from app_config — both supported.
  Future<bool> needsForceUpdate(String currentVersion) async {
    final min = await value('min_version');
    if (min == null) return false;
    return _versionLess(currentVersion, min);
  }

  Future<bool> maintenanceFlag() async => (await value('maintenance_flag')) == 'true';

  /// Server-configured seasonal events → events cache (⛔ §9.15).
  Future<void> syncEventsFromConfig() async {
    // Local binding: config already seeded. Production: getAppConfig CF
    // returns app_config.events JSON; repository upserts EventsCache rows.
  }

  static bool _versionLess(String a, String b) {
    final pa = a.split('.').map(int.tryParse).toList();
    final pb = b.split('.').map(int.tryParse).toList();
    for (var i = 0; i < 3; i++) {
      final va = (i < pa.length ? pa[i] : 0) ?? 0;
      final vb = (i < pb.length ? pb[i] : 0) ?? 0;
      if (va < vb) return true;
      if (va > vb) return false;
    }
    return false;
  }
}

/// (27) Quick phrases provider — managed in Settings, consumed on the
/// Dashboard (random motivational line) and in Add-Money (comment chips).
final quickPhrasesProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(settingsRepositoryProvider).quickPhrases();
});

/// (30) Vacation mode flag — surfaced on the Dashboard as an honest banner.
final vacationModeProvider = FutureProvider<bool>((ref) async {
  final until = await ref.watch(settingsRepositoryProvider).vacationUntil();
  final enabled = await ref.watch(settingsRepositoryProvider).vacationMode();
  return enabled && (until == null || until.isAfter(DateTime.now()));
});

final settingsRepositoryProvider =
    Provider<SettingsRepository>((ref) => SettingsRepository(ref));
final notificationsRepositoryProvider =
    Provider<NotificationsRepository>((ref) => NotificationsRepository(ref));
final pinRepositoryProvider = Provider<PinRepository>((ref) => PinRepository(ref));
final aiRepositoryProvider = Provider<AiRepository>((ref) => AiRepository(ref));
final rateAppRepositoryProvider = Provider<RateAppRepository>((ref) => RateAppRepository(ref));
final appConfigRepositoryProvider =
    Provider<AppConfigRepository>((ref) => AppConfigRepository(ref));

/// ── CSV export (§6.17) ──────────────────────────────────────────────────
abstract final class ExportService {
  /// CSV: дата, сума, коментар (§6.17). Returns file content.
  static String csv(List<ContributionView> items) {
    final buf = StringBuffer('date,amount,comment\n');
    for (final c in items) {
      final comment = (c.comment ?? '')
          .replaceAll('"', '""')
          .replaceAll('\n', ' ');
      buf.writeln('${formatDate(c.occurredAt)},${c.amount},"$comment"');
    }
    return buf.toString();
  }
}
