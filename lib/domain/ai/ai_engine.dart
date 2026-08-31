import '../../core/utils/format.dart';

/// AI Guardian engine (§6.8, §7.2): 3 modes, daily limits (100 authed /
/// 20 guest per device ID ⛔), local fallback presets when LLM unavailable.
enum AiMode { advisor, guardian, motivator }

class AiUsageState {
  const AiUsageState({required this.usedToday, required this.limit, required this.dayKey});
  final int usedToday;
  final int limit;
  final String dayKey;

  bool get exhausted => usedToday >= limit;
  int get left => (limit - usedToday).clamp(0, limit);
}

/// Aggregated context sent to the server (§6.8) — never raw DB access.
class AiContext {
  const AiContext({
    required this.balance,
    required this.goalPercent,
    required this.ps5Price,
    required this.monitorPrice,
    required this.level,
    required this.streakDays,
    required this.lastContributionDate,
    required this.achievementsCount,
    required this.lowestPrice,
    required this.priceTrend,
  });

  final num balance;
  final double goalPercent;
  final num ps5Price;
  final num monitorPrice;
  final int level;
  final int streakDays;
  final String? lastContributionDate;
  final int achievementsCount;
  final num lowestPrice;
  final String priceTrend; // 'up' | 'down' | 'flat'

  Map<String, Object> toPayload() => {
        'balance': balance,
        'goal_percent': goalPercent,
        'ps5_price': ps5Price,
        'monitor_price': monitorPrice,
        'level': level,
        'streak_days': streakDays,
        'last_contribution_date': lastContributionDate ?? '',
        'achievements_count': achievementsCount,
        'lowest_price': lowestPrice,
        'price_trend': priceTrend,
      };
}

class AiReply {
  const AiReply({
    required this.text,
    required this.fromFallback,
  });
  final String text;
  final bool fromFallback;
}

/// Chat message model (mirrors Drift table chat_messages).
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.mode,
    required this.text,
    required this.createdAt,
    this.fromFallback = false,
    this.synced = false,
  });

  final String id;
  final String role; // 'user' | 'assistant'
  final String mode;
  final String text;
  final DateTime createdAt;
  final bool fromFallback;
  final bool synced;
}

abstract final class AiEngine {
  static const int limitAuthed = 100;
  static const int limitGuest = 20;

  static AiUsageState usageFor({
    required bool isAuthed,
    required String todayKey,
    required int usedToday,
  }) =>
      AiUsageState(
        usedToday: usedToday,
        limit: isAuthed ? limitAuthed : limitGuest,
        dayKey: todayKey,
      );

  /// Can a request be made right now?
  static bool canRequest(AiUsageState s) => !s.exhausted;

  /// Local fallback presets (§6.8, §7.2) — used when the Cloud Function /
  /// network is unavailable. Indexed by mode; light templating by context.
  static AiReply fallbackReply(AiMode mode, AiContext ctx) {
    final t = switch (mode) {
      AiMode.advisor =>
        'Аналізую твій темп: накопичено ${formatMoneyShort(ctx.balance)} '
            '(${ctx.goalPercent.toStringAsFixed(1)}% цілі), рівень ${ctx.level}, '
            'стрик ${ctx.streakDays} дн. Тримай стабільний темп — ETA оновиться на Dashboard.',
      AiMode.guardian =>
        'Ціни під контролем: найнижча ${formatMoneyShort(ctx.lowestPrice)}, '
            'тренд — ${_trendWord(ctx.priceTrend)}. Скан оновлюється щодня о 08:00; '
            'при падінні нижче середньої на 5% побачиш «Вигідно зараз».',
      AiMode.motivator =>
        'GG! ${ctx.streakDays > 0 ? 'Стрик ${ctx.streakDays} дн — тримай ритм! ' : ''}'
            'Кожне поповнення це XP, кожен день це бонус до стрику. Ти впораєшся!',
    };
    return AiReply(text: t, fromFallback: true);
  }

  static String _trendWord(String trend) => switch (trend) {
        'down' => 'вниз',
        'up' => 'вгору',
        _ => 'без змін',
      };
}
