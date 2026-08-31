import 'package:drift/drift.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// NeoVault local source of truth (spec §3): Drift over SQLCipher-encrypted
/// SQLite on Android; in-memory / plain file in tests & desktop.
@DriftDatabase(tables: [
  Goals,
  GoalItems,
  Contributions,
  Achievements,
  AchievementsUnlocked,
  Settings,
  UserStatsTable,
  ChatMessages,
  PriceHistory,
  ScanRuns,
  MonitorSpecs,
  Ps5Specs,
  NotificationsCache,
  SyncQueue,
  ChipsWalletTable,
  ChipsLedger,
  Pets,
  PetSkins,
  QuestsDaily,
  QuestsWeekly,
  Chests,
  HoloSets,
  HoloCards,
  HoloOwned,
  EventsCache,
  EventQuests,
  BuddyCache,
  GhostCache,
  LeaderboardOptIn,
  ApiKeys,
  ProgressCards,
  SearchHistory,
  AppConfigTable,
  PinMeta,
  AiUsageTable,
  RateAppState,
  Meta,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
      );
}
