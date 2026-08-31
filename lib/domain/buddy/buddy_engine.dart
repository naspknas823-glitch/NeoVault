/// Buddy Mode engine (§10.8, criterion 12.16).
/// ⛔ Max 3 pings/day per user — the 4th is blocked.
/// NOT a referral program (⛔ §10.8): no rewards for inviting new users.
class BuddyEngine {
  static const int maxPingsPerDay = 3;
  static const int buddyWeekTarget = 3;
  static const int buddyWeekReward = 30;
  static const int inviteCodeLength = 6;

  /// 4th ping of the day → false (blocked).
  static bool canPing(int pingsToday) => pingsToday < maxPingsPerDay;

  static String generateInviteCode({int seed = 0}) {
    const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    var s = seed;
    if (s == 0) s = DateTime.now().millisecondsSinceEpoch;
    final buf = StringBuffer();
    for (var i = 0; i < inviteCodeLength; i++) {
      s = (s * 1103515245 + 12345) & 0x7fffffff;
      buf.write(alphabet[s % alphabet.length]);
    }
    return buf.toString();
  }

  static bool isValidInviteCode(String code) =>
      RegExp(r'^[A-Z0-9]{6}$').hasMatch(code.toUpperCase());
}

/// Race bar: who is faster this week (visible: %, pace, streak, rank only).
double buddyRaceProgress(double selfWeeklyPercent, double buddyWeeklyPercent) {
  final total = selfWeeklyPercent + buddyWeeklyPercent;
  if (total <= 0) return 0.5;
  return (selfWeeklyPercent / total).clamp(0.0, 1.0);
}

/// «Бадді-тиждень»: both made 3+ contributions → +30 Chips to both.
bool buddyWeekComplete(int selfContribsThisWeek, int buddyContribsThisWeek) =>
    selfContribsThisWeek >= BuddyEngine.buddyWeekTarget &&
    buddyContribsThisWeek >= BuddyEngine.buddyWeekTarget;

/// Deep link builder: vault://buddy/join?code=XXXX (§3).
String buddyDeepLink(String code) => 'vault://buddy/join?code=$code';

/// Progress ring pair widget data.
class BuddySnapshot {
  const BuddySnapshot({
    required this.nick,
    required this.goalPercent,
    required this.weeklyPercent,
    required this.streakDays,
    required this.rankLabel,
    required this.contribsThisWeek,
  });
  final String nick;
  final double goalPercent;
  final double weeklyPercent;
  final int streakDays;
  final String rankLabel;
  final int contribsThisWeek;
}

String formatRaceLabel(double v) => '${v.toStringAsFixed(1)}%';
