import 'package:drift/drift.dart';

/// Drift tables per spec §3. All timestamps stored as UTC epoch ms (int).

class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get ps5Price => integer()();
  IntColumn get monitorPrice => integer()();
  IntColumn get createdAt => integer()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

/// goal_items: PS5 + monitor sub-items of the goal (§3).
class GoalItems extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text()();
  TextColumn get kind => text()(); // 'ps5' | 'monitor'
  TextColumn get title => text()();
  IntColumn get targetPrice => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class Contributions extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text()();
  IntColumn get amount => integer()(); // kopiykas? — store UAH as int (whole hryvnias allowed cents via /100)
  TextColumn get comment => text().nullable()();
  TextColumn get receiptPath => text().nullable()();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  IntColumn get streakBonus => integer().withDefault(const Constant(0))();
  IntColumn get occurredAt => integer()(); // user-chosen date
  IntColumn get createdAt => integer()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

/// Static achievement definitions stored locally for filtering/unlock state.
class Achievements extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()();
  IntColumn get bonusXp => integer()();
  BoolColumn get secret => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class AchievementsUnlocked extends Table {
  TextColumn get achievementId => text()();
  IntColumn get unlockedAt => integer()();
  @override
  Set<Column> get primaryKey => {achievementId};
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  IntColumn get updatedAt => integer()();
  @override
  Set<Column> get primaryKey => {key};
}

class UserStatsTable extends Table {
  TextColumn get id => text()(); // singleton 'main'
  IntColumn get totalXp => integer().withDefault(const Constant(0))();
  IntColumn get level => integer().withDefault(const Constant(1))();
  IntColumn get streakDays => integer().withDefault(const Constant(0))();
  TextColumn get lastContributionDay => text().nullable()();
  IntColumn get contributionsCount => integer().withDefault(const Constant(0))();
  IntColumn get maxSingleContribution => integer().withDefault(const Constant(0))();
  IntColumn get scannerChecks => integer().withDefault(const Constant(0))();
  IntColumn get priceDropsSeen => integer().withDefault(const Constant(0))();
  BoolColumn get goodDealSeen => boolean().withDefault(const Constant(false))();
  TextColumn get visitedScreens => text().withDefault(const Constant(''))(); // csv
  IntColumn get themeChanges => integer().withDefault(const Constant(0))();
  IntColumn get aiQuestions => integer().withDefault(const Constant(0))();
  BoolColumn get historyViewed30d => boolean().withDefault(const Constant(false))();
  IntColumn get installDate => integer()();
  TextColumn get nickname => text().withDefault(const Constant(''))();
  TextColumn get avatarSeed => text().withDefault(const Constant('nv'))();
  TextColumn get userId => text()(); // local device id / firebase uid
  TextColumn get email => text().nullable()();
  BoolColumn get authed => boolean().withDefault(const Constant(false))();
  IntColumn get registeredAt => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class ChatMessages extends Table {
  TextColumn get id => text()();
  TextColumn get role => text()(); // user | assistant
  TextColumn get mode => text()(); // advisor | guardian | motivator
  TextColumn get content => text()();
  IntColumn get createdAt => integer()();
  BoolColumn get fromFallback => boolean().withDefault(const Constant(false))();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class PriceHistory extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  TextColumn get product => text()(); // ps5 | monitor
  IntColumn get price => integer()();
  TextColumn get url => text().withDefault(const Constant(''))();
  BoolColumn get urlVerified => boolean().withDefault(const Constant(false))();
  IntColumn get checkedAt => integer()();
  TextColumn get availability => text()();
  IntColumn get warrantyMonths => integer().withDefault(const Constant(12))();
  IntColumn get returnDays => integer().withDefault(const Constant(14))();
  TextColumn get kit => text().withDefault(const Constant('full'))();
  TextColumn get state => text().withDefault(const Constant('new'))();
  TextColumn get source => text().withDefault(const Constant('server_scrape'))();
  TextColumn get city => text().nullable()();
  IntColumn get deliveryCost => integer().withDefault(const Constant(0))();
  IntColumn get otherCosts => integer().withDefault(const Constant(0))();
  BoolColumn get isSeed => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class ScanRuns extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get product => text()();
  IntColumn get scannedAt => integer()();
  IntColumn get lowestPrice => integer()();
  IntColumn get averagePrice => integer()();
  IntColumn get avg30dPrice => integer()();
  RealColumn get changePercent => real().withDefault(const Constant(0))();
  TextColumn get changeDir => text().withDefault(const Constant('flat'))();
}

/// Extra JSON specs for monitor offers (specs don't fit tabular price_history).
class MonitorSpecs extends Table {
  TextColumn get priceId => text()();
  TextColumn get model => text()();
  RealColumn get diagonal => real()();
  TextColumn get resolution => text()();
  IntColumn get refreshHz => integer()();
  IntColumn get hdmiVersion => integer()();
  BoolColumn get vrr => boolean().withDefault(const Constant(false))();
  TextColumn get hdr => text().withDefault(const Constant('hdr10'))();
  BoolColumn get allm => boolean().withDefault(const Constant(true))();
  TextColumn get vesa => text().withDefault(const Constant('100x100'))();
  @override
  Set<Column> get primaryKey => {priceId};
}

/// PS5-specific specs.
class Ps5Specs extends Table {
  TextColumn get priceId => text()();
  TextColumn get consoleType => text()(); // disc | digital
  IntColumn get memoryGb => integer()();
  BoolColumn get isSlim => boolean().withDefault(const Constant(true))();
  @override
  Set<Column> get primaryKey => {priceId};
}

class NotificationsCache extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()(); // prices | achievements | levels | contrib | system
  TextColumn get titleKey => text()();
  TextColumn get bodyKey => text()();
  TextColumn get bodyParamsJson => text().withDefault(const Constant('{}'))();
  TextColumn get deepLink => text().nullable()();
  IntColumn get createdAt => integer()();
  BoolColumn get read => boolean().withDefault(const Constant(false))();
  BoolColumn get isPush => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityId => text()();
  TextColumn get entityType => text()(); // contribution | settings | chips | ...
  TextColumn get payloadJson => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get nextAttemptAt => integer()();
  TextColumn get lastError => text().nullable()();
  IntColumn get createdAt => integer()();
}

class ChipsWalletTable extends Table {
  TextColumn get id => text()(); // singleton 'main'
  IntColumn get balance => integer().withDefault(const Constant(0))();
  IntColumn get dust => integer().withDefault(const Constant(0))();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class ChipsLedger extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get reason => text()(); // quest | chest | ghost | buddy | feed | pack | dust
  IntColumn get delta => integer()();
  TextColumn get refId => text().nullable()();
  IntColumn get createdAt => integer()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

class Pets extends Table {
  TextColumn get id => text()(); // singleton 'main'
  TextColumn get form => text().withDefault(const Constant('egg'))();
  TextColumn get mood => text().withDefault(const Constant('happy'))();
  TextColumn get skin => text().withDefault(const Constant('neon_cyan'))();
  IntColumn get hatchedAt => integer().nullable()();
  IntColumn get feedCount => integer().withDefault(const Constant(0))();
  TextColumn get lastOpenDay => text().nullable()();
  TextColumn get lastFedDay => text().nullable()();
  IntColumn get lastSadPushAt => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class PetSkins extends Table {
  TextColumn get id => text()();
  BoolColumn get owned => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class QuestsDaily extends Table {
  TextColumn get id => text()(); // quest def id + dayKey
  TextColumn get questId => text()();
  TextColumn get dayKey => text()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  BoolColumn get claimed => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class QuestsWeekly extends Table {
  TextColumn get id => text()();
  TextColumn get questId => text()();
  TextColumn get weekKey => text()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  BoolColumn get claimed => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class Chests extends Table {
  TextColumn get id => text()(); // singleton 'main'
  TextColumn get lastOpenedDay => text().nullable()();
  IntColumn get chain => integer().withDefault(const Constant(0))();
  IntColumn get totalOpened => integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {id};
}

class HoloSets extends Table {
  TextColumn get id => text()();
  TextColumn get nameKey => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class HoloCards extends Table {
  TextColumn get id => text()();
  TextColumn get setId => text()();
  TextColumn get rarity => text()(); // c | r | e | l
  TextColumn get nameKey => text()();
  TextColumn get condKey => text()();
  TextColumn get loreKey => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class HoloOwned extends Table {
  TextColumn get cardId => text()();
  IntColumn get copies => integer().withDefault(const Constant(1))();
  IntColumn get firstOwnedAt => integer()();
  @override
  Set<Column> get primaryKey => {cardId};
}

class EventsCache extends Table {
  TextColumn get id => text()();
  TextColumn get titleKey => text()();
  TextColumn get bannerKey => text()();
  IntColumn get startsAt => integer()();
  IntColumn get endsAt => integer()();
  TextColumn get questsJson => text()();
  TextColumn get rewardsJson => text()();
  TextColumn get rulesKey => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('active'))(); // active|finished
  @override
  Set<Column> get primaryKey => {id};
}

class EventQuests extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text()();
  TextColumn get titleKey => text()();
  IntColumn get target => integer()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  BoolColumn get claimed => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class BuddyCache extends Table {
  TextColumn get id => text()(); // singleton 'main'
  TextColumn get inviteCode => text().nullable()();
  TextColumn get buddyId => text().nullable()();
  TextColumn get buddyNick => text().nullable()();
  RealColumn get buddyGoalPercent => real().withDefault(const Constant(0))();
  RealColumn get buddyWeeklyPercent => real().withDefault(const Constant(0))();
  IntColumn get buddyStreak => integer().withDefault(const Constant(0))();
  TextColumn get buddyRank => text().withDefault(const Constant('Bronze'))();
  IntColumn get buddyWeeklyContribs => integer().withDefault(const Constant(0))();
  IntColumn get pingsToday => integer().withDefault(const Constant(0))();
  TextColumn get pingsDay => text().nullable()();
  BoolColumn get weekRewardClaimed => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class GhostCache extends Table {
  TextColumn get id => text()();
  TextColumn get nick => text()();
  RealColumn get percent => real()();
  IntColumn get weeklyXp => integer()();
  TextColumn get rankLabel => text()();
  IntColumn get streakDays => integer()();
  TextColumn get weekKey => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class LeaderboardOptIn extends Table {
  TextColumn get id => text()(); // singleton 'main'
  BoolColumn get optedIn => boolean().withDefault(const Constant(false))();
  BoolColumn get ghostRewardClaimedThisWeek => boolean().withDefault(const Constant(false))();
  TextColumn get ghostRewardWeek => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class ApiKeys extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get storeId => text()();
  TextColumn get keyHash => text()(); // stored hashed — never plain (⛔ §7.1quin.1)
  TextColumn get keyPreview => text()(); // last 4 chars
  TextColumn get salt => text()(); // per-key salt for the hash
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('unset'))();
  IntColumn get lastOkAt => integer().nullable()();
  TextColumn get lastError => text().nullable()();
  IntColumn get rateLimitPerHour => integer().nullable()();
  IntColumn get createdAt => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class ProgressCards extends Table {
  TextColumn get id => text()(); // singleton 'main'
  BoolColumn get enabled => boolean().withDefault(const Constant(false))();
  TextColumn get token => text().nullable()();
  BoolColumn get showRank => boolean().withDefault(const Constant(true))();
  BoolColumn get showStreak => boolean().withDefault(const Constant(true))();
  BoolColumn get showPercent => boolean().withDefault(const Constant(true))();
  BoolColumn get showAmount => boolean().withDefault(const Constant(false))();
  IntColumn get views => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class SearchHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bundleName => text()();
  IntColumn get totalPrice => integer()();
  IntColumn get score => integer()();
  TextColumn get status => text()();
  BoolColumn get isCurrent => boolean().withDefault(const Constant(false))();
  IntColumn get searchedAt => integer()();
}

class AppConfigTable extends Table {
  TextColumn get key => text()();
  TextColumn get valueJson => text()();
  IntColumn get updatedAt => integer()();
  @override
  Set<Column> get primaryKey => {key};
}

class PinMeta extends Table {
  TextColumn get id => text()(); // singleton 'main'
  // PBKDF2-HMAC-SHA256 digest in the self-describing format
  // `pbkdf2-sha256$<iterations>$<base64>` (legacy rows: bare base64).
  TextColumn get pinHash => text().nullable()();
  // ⚠️ The salt lives in THIS table, not in the Keystore. What protects it is
  // the SQLCipher encryption of the whole database, whose passphrase is
  // Keystore-only (see data/repositories/providers.dart).
  TextColumn get salt => text().nullable()();
  IntColumn get failedAttempts => integer().withDefault(const Constant(0))();
  IntColumn get lockedUntil => integer().nullable()();
  BoolColumn get biometricEnabled => boolean().withDefault(const Constant(false))();
  IntColumn get autolockMinutes => integer().withDefault(const Constant(5))();
  @override
  Set<Column> get primaryKey => {id};
}

class AiUsageTable extends Table {
  TextColumn get id => text()(); // dayKey
  IntColumn get used => integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {id};
}

class RateAppState extends Table {
  TextColumn get id => text()(); // singleton 'main'
  IntColumn get contribsAtLastPrompt => integer().withDefault(const Constant(0))();
  IntColumn get lastPromptAt => integer().nullable()();
  BoolColumn get neverAsk => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

/// Streak-freeze style «очікує розблокування» XP-gated theme changes (O3 stat).
class Meta extends Table {
  TextColumn get key => text()();
  IntColumn get value => integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {key};
}
