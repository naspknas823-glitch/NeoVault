/// Leaderboard with «ghosts» (§10.4, criterion 12.15).
/// ⛔ Rows contain ONLY nick, %, XP, rank, streak — never money amounts.
/// Opt-in required; weekly reset Monday 00:00 Kyiv.
enum LeaderboardTab { tempo, weeklyXp }

class LeaderboardRow {
  const LeaderboardRow({
    required this.userId,
    required this.nick,
    required this.percent,
    required this.weeklyXp,
    required this.rankLabel,
    required this.streakDays,
    this.isSelf = false,
    this.isGhost = false,
  });

  final String userId;
  final String nick;
  final double percent; // tempo: % growth of own goal this week
  final int weeklyXp;
  final String rankLabel; // e.g. 'Bronze' — never money
  final int streakDays;
  final bool isSelf;
  final bool isGhost;
}

class GhostPair {
  const GhostPair({required this.ghosts, required this.self});
  final List<LeaderboardRow> ghosts; // exactly 2, ±15% of last-week tempo
  final LeaderboardRow self;
}

class LeaderboardEngine {
  /// Ghost picking: 2 anonymous rivals with last-week tempo within ±15%
  /// of the player's own tempo. Pure selection over candidate pool.
  static List<LeaderboardRow> pickGhosts({
    required double selfTempo,
    required List<LeaderboardRow> candidates,
    int count = 2,
  }) {
    final inRange = candidates
        .where((c) => !c.isSelf && (c.percent - selfTempo).abs() <= selfTempo * 0.15 + 1.0)
        .toList()
      ..sort((a, b) => (a.percent - selfTempo).abs().compareTo((b.percent - selfTempo).abs()));
    if (inRange.length >= count) return inRange.take(count).toList();
    // Fallback: closest tempo players even outside ±15%.
    final sorted = [...candidates]..sort((a, b) =>
        (a.percent - selfTempo).abs().compareTo((b.percent - selfTempo).abs()));
    return sorted.take(count).toList();
  }

  /// Sort rows: tempo tab → by percent desc; xp tab → by weeklyXp desc.
  static List<LeaderboardRow> sortRows(List<LeaderboardRow> rows, LeaderboardTab tab) {
    final copy = [...rows];
    copy.sort((a, b) => tab == LeaderboardTab.tempo
        ? b.percent.compareTo(a.percent)
        : b.weeklyXp.compareTo(a.weeklyXp));
    return copy;
  }

  /// Player beat at least one ghost this week → +20 Chips (§10.4).
  static bool beatAnyGhost({
    required double selfTempo,
    required int selfWeeklyXp,
    required LeaderboardTab tab,
    required List<LeaderboardRow> ghosts,
  }) {
    for (final g in ghosts) {
      final lost = tab == LeaderboardTab.tempo
          ? selfTempo > g.percent
          : selfWeeklyXp > g.weeklyXp;
      if (lost) return true;
    }
    return false;
  }
}

const int ghostWinRewardChips = 20;
