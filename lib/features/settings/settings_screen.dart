import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/social_repositories.dart';
import '../../data/repositories/providers.dart' show syncPendingProvider;
import '../../data/repositories/system_repositories.dart';
import '../../data/repositories/ui_providers.dart';
import '../../domain/gamification/xp_engine.dart';
import '../../shared/widgets/widgets.dart';
import 'auth_sheet.dart';

/// 6.11 Profile / Settings (§6.11): profile block (avatar, nick, rank, XP,
/// stats), Appearance, Notifications (types + DnD + fixed reminder),
/// Security (PIN/biometrics/autolock), 🔐 API, Bundle Search settings,
/// Account, Premium, Referral (stub), About, Leaderboard opt-in, Buddy,
/// Live-card.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('settings');
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final stats = ref.watch(statsRowProvider).valueOrNull;
    final goal = ref.watch(goalProvider).valueOrNull;
    final pendingSync = ref.watch(syncPendingProvider).valueOrNull ?? 0;

    final xp = stats?.totalXp ?? 0;
    final level = stats?.level ?? 1;
    final rank = Gamification.rankForLevel(level);
    final lvl = Gamification.levelForXp(xp);
    final xpToNext =
        lvl >= 20 ? 0 : Gamification.levelThresholds()[lvl] - xp;
    final achUnlocked = ref
            .watch(achievementsProvider)
            .valueOrNull
            ?.where((e) => e.$2 != null)
            .length ??
        0;
    final nick = (stats?.nickname.isNotEmpty ?? false)
        ? stats!.nickname
        : t('dashboard.guest');

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('settings.title'))),
      bottomNavigationBar: const DashboardBottomBar(currentIndex: 3),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // ── Profile block ──
          NeonCard(
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: c.accent.withOpacity(0.15),
                      child: Text(nick[0].toUpperCase(),
                          style: NvType.h2(c).copyWith(color: c.accent)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nick, style: NvType.h2(c).copyWith(fontSize: 18)),
                          Text(
                            '${rank.name.toUpperCase()} • ${t('common.level')} $level • $xp XP • ${stats?.contributionsCount ?? 0} ${t('settings.stat_contribs').toLowerCase()}',
                            style: NvType.caption(c),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                NeonProgressBar(value: Gamification.levelProgress(xp), height: 8),
                const SizedBox(height: 6),
                if (lvl < 20)
                  Text(
                    t('settings.to_next_level', {'n': lvl + 1, 'xp': xpToNext}),
                    style: NvType.caption(c).copyWith(color: c.secondary),
                  ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat(t('settings.stat_total_saved'),
                        formatMoneyShort(goal?.saved ?? 0), c),
                    _stat(t('settings.stat_contribs'),
                        '${stats?.contributionsCount ?? 0}', c),
                    _stat(
                        t('settings.stat_avg'),
                        formatMoneyShort(
                          (stats?.contributionsCount ?? 0) > 0
                              ? (goal?.saved ?? 0) / (stats!.contributionsCount)
                              : 0,
                        ),
                        c),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat(t('settings.stat_streak'),
                        '${stats?.streakDays ?? 0}', c),
                    _stat(t('settings.stat_checks'),
                        '${stats?.scannerChecks ?? 0}', c),
                    _stat(t('settings.stat_achievements'), '$achUnlocked', c),
                  ],
                ),
                if (pendingSync > 0) ...[
                  const SizedBox(height: 10),
                  Text(
                    t('settings.sync_pending', {'n': pendingSync}),
                    style: NvType.caption(c).copyWith(color: c.accent2),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section(t('settings.appearance'), c),
          NeonCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _tile(
                  c,
                  icon: Icons.palette_outlined,
                  title: t('settings.theme'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/themes'),
                ),
                _SoundSlider(),
                _HapticsSlider(),
                _ReduceMotionTile(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section(t('settings.notifications_sec'), c),
          NeonCard(
            padding: EdgeInsets.zero,
            child: _NotifSection(),
          ),
          const SizedBox(height: 16),
          _section(t('settings.security'), c),
          NeonCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _tile(
                  c,
                  icon: Icons.pin_rounded,
                  title: t('settings.pin_setup'),
                  onTap: () => context.push('/pin-setup'),
                ),
                _BiometricTile(),
                _AutolockTile(),
                _tile(
                  c,
                  icon: Icons.key_rounded,
                  title: t('settings.api_section'),
                  subtitle: t('settings.api_hint'),
                  onTap: () => context.push('/api-settings'),
                ),
                _tile(
                  c,
                  icon: Icons.shopping_cart_checkout_rounded,
                  title: t('settings.bundle_settings'),
                  onTap: () => context.push('/bundle-search'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section('Advanced Mechanics', c),
          NeonCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _tile(
                  c,
                  icon: Icons.calculate_rounded,
                  title: 'Expense Simulator',
                  subtitle: 'Simulate Round-ups & Micro-deposits',
                  onTap: () => context.push('/expense-simulator'),
                ),
                _tile(
                  c,
                  icon: Icons.handyman_rounded,
                  title: 'Tools & Utilities',
                  subtitle: 'Cost of Waiting, Median Comparison',
                  onTap: () => context.push('/tools'),
                ),
                _tile(
                  c,
                  icon: Icons.emoji_events_rounded,
                  title: 'Visual Progress',
                  subtitle: 'Water level, Puzzle, Tree, Pixel art...',
                  onTap: () => context.push('/gamification'),
                ),
                _tile(
                  c,
                  icon: Icons.view_in_ar_rounded,
                  title: t('preview.title'),
                  subtitle: t('preview.hint'),
                  onTap: () => context.push('/room-preview'),
                ),
                _tile(
                  c,
                  icon: Icons.show_chart_rounded,
                  title: 'Savings Curve',
                  subtitle: 'Cumulative chart of your savings over time',
                  onTap: () => context.push('/savings-curve'),
                ),
                _tile(
                  c,
                  icon: Icons.card_giftcard_rounded,
                  title: 'Gift Top-up',
                  subtitle: 'Send a gift contribution link',
                  onTap: () => context.push('/gift-topup'),
                ),
                _VacationModeTile(),
                const _SalaryDayTile(),
                const _QuickPhrasesTile(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section(t('settings.account'), c),
          NeonCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _tile(
                  c,
                  icon: Icons.person_add_alt_rounded,
                  title: t('settings.sign_in'),
                  onTap: () => showAuthSheet(context, ref),
                ),
                _LeaderboardOptInTile(),
                ListTile(
                  leading: Icon(Icons.sports_martial_arts_rounded,
                      color: c.secondary),
                  title: Text(t('settings.buddy_section'), style: NvType.body(c)),
                  onTap: () => context.push('/buddy'),
                ),
                ListTile(
                  leading: Icon(Icons.public_rounded, color: c.secondary),
                  title: Text(t('settings.progress_card_section'),
                      style: NvType.body(c)),
                  onTap: () => context.push('/progress-card'),
                ),
                _tile(
                  c,
                  icon: Icons.workspace_premium_rounded,
                  title: t('settings.premium'),
                  onTap: () => context.push('/premium'),
                ),
                _tile(
                  c,
                  icon: Icons.card_giftcard_rounded,
                  title: t('settings.referral'),
                  onTap: () => context.push('/referral'),
                ),
                _tile(
                  c,
                  icon: Icons.delete_forever_rounded,
                  title: t('settings.delete_account'),
                  danger: true,
                  onTap: () => context.push('/delete-account'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section(t('settings.about'), c),
          NeonCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _tile(
                  c,
                  icon: Icons.star_border_rounded,
                  title: t('settings.rate_app'),
                  onTap: () => showRateAppDialog(context, ref),
                ),
                ListTile(
                  leading: Icon(Icons.info_outline, color: c.secondary),
                  title: Text(t('settings.version'), style: NvType.body(c)),
                  trailing: const Text('0.9.0'),
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined, color: c.secondary),
                  title: Text(t('settings.privacy'), style: NvType.body(c)),
                  onTap: () => context.toast(t('settings.licenses')),
                ),
                ListTile(
                  leading: Icon(Icons.description_outlined, color: c.secondary),
                  title: Text(t('settings.terms'), style: NvType.body(c)),
                  onTap: () => context.toast(t('settings.licenses')),
                ),
                ListTile(
                  leading: Icon(Icons.policy_outlined, color: c.secondary),
                  title: Text(t('settings.licenses'), style: NvType.body(c)),
                  onTap: () => showLicensePage(context: context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, AppColors c) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title.toUpperCase(),
          style: NvType.caption(c).copyWith(color: c.accent)),
    );
  }

  Widget _stat(String label, String value, AppColors c) {
    return Column(
      children: [
        Text(value, style: NvType.button(c).copyWith(color: c.accent)),
        const SizedBox(height: 2),
        Text(label, style: NvType.caption(c), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _tile(
    AppColors c, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool danger = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: danger ? c.danger : c.secondary),
      title: Text(title,
          style: NvType.body(c).copyWith(color: danger ? c.danger : c.text)),
      subtitle: subtitle == null ? null : Text(subtitle, style: NvType.caption(c)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SoundSlider extends ConsumerStatefulWidget {
  @override
  ConsumerState<_SoundSlider> createState() => _SoundSliderState();
}

class _SoundSliderState extends ConsumerState<_SoundSlider> {
  int _volume = 70;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final v = await ref.read(settingsRepositoryProvider).soundVolume();
    if (mounted) setState(() { _volume = v; _loaded = true; });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return ListTile(
      leading: Icon(Icons.volume_up_rounded, color: c.secondary),
      title: Text(t('settings.sounds'), style: NvType.body(c)),
      trailing: Text('$_volume%',
          style: NvType.caption(c).copyWith(color: c.accent)),
      subtitle: Slider(
        value: _volume.toDouble(),
        min: 0,
        max: 100,
        onChanged: _loaded
            ? (v) {
                setState(() => _volume = v.round());
                ref.read(settingsRepositoryProvider).setSoundVolume(_volume);
              }
            : null,
      ),
    );
  }
}

class _HapticsSlider extends ConsumerStatefulWidget {
  @override
  ConsumerState<_HapticsSlider> createState() => _HapticsSliderState();
}

class _HapticsSliderState extends ConsumerState<_HapticsSlider> {
  int _intensity = 100;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final v = await ref.read(settingsRepositoryProvider).haptics();
    if (mounted) setState(() { _intensity = v; _loaded = true; });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return ListTile(
      leading: Icon(Icons.vibration_rounded, color: c.secondary),
      title: Text(t('settings.haptics'), style: NvType.body(c)),
      trailing: Text('$_intensity%',
          style: NvType.caption(c).copyWith(color: c.accent)),
      subtitle: Slider(
        value: _intensity.toDouble(),
        min: 0,
        max: 100,
        onChanged: _loaded
            ? (v) {
                setState(() => _intensity = v.round());
                ref.read(settingsRepositoryProvider).setHaptics(_intensity);
              }
            : null,
      ),
    );
  }
}

/// ⛔ §9.4 / §8.5: mandatory «Reduce Motion & Flash Effects» toggle.
class _ReduceMotionTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final reduced = ref.watch(reduceMotionProvider);
    return SwitchListTile(
      secondary: Icon(Icons.accessibility_new_rounded, color: c.secondary),
      title: Text(t('settings.reduce_motion'), style: NvType.body(c)),
      subtitle: Text(t('settings.reduce_motion_hint'), style: NvType.caption(c)),
      value: reduced,
      onChanged: (v) => ref.read(reduceMotionProvider.notifier).state = v,
    );
  }
}

class _NotifSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<_NotifSection> createState() => _NotifSectionState();
}

class _NotifSectionState extends ConsumerState<_NotifSection> {
  bool dnd = false;
  bool prices = true;
  bool achievements = true;
  bool contrib = true;
  bool retention = true;
  int reminderDay = 1;
  int reminderHour = 10;
  int reminderMinute = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = ref.read(settingsRepositoryProvider);
    final dndV = await s.dnd();
    final pricesV = await s.notifPref('prices');
    final achV = await s.notifPref('achievements');
    final contribV = await s.notifPref('contrib');
    final retV = await s.notifPref('retention');
    final rem = await s.reminder();
    if (mounted) {
      setState(() {
        dnd = dndV;
        prices = pricesV;
        achievements = achV;
        contrib = contribV;
        retention = retV;
        if (rem != null) {
          reminderDay = rem.$1;
          reminderHour = rem.$2;
          reminderMinute = rem.$3;
        }
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    if (!_loaded) return const SizedBox(height: 8);
    return Column(
      children: [
        SwitchListTile(
          secondary: Icon(Icons.do_not_disturb_on_rounded, color: c.secondary),
          title: Text(t('settings.notif_dnd'), style: NvType.body(c)),
          subtitle: Text(t('settings.notif_dnd_hint'), style: NvType.caption(c)),
          value: dnd,
          onChanged: (v) {
            setState(() => dnd = v);
            ref.read(settingsRepositoryProvider).setDnd(v);
          },
        ),
        _switchRow(c, t('settings.notif_prices'), prices,
            (v) => ref.read(settingsRepositoryProvider).setNotifPref('prices', v)),
        _switchRow(c, t('settings.notif_achievements'), achievements,
            (v) => ref.read(settingsRepositoryProvider).setNotifPref('achievements', v)),
        _switchRow(c, t('settings.notif_contrib'), contrib,
            (v) => ref.read(settingsRepositoryProvider).setNotifPref('contrib', v)),
        _switchRow(c, t('settings.notif_retention'), retention,
            (v) => ref.read(settingsRepositoryProvider).setNotifPref('retention', v)),
        ListTile(
          leading: Icon(Icons.alarm_rounded, color: c.secondary),
          title: Text(t('settings.notif_reminder'), style: NvType.body(c)),
          subtitle: Text(
            '${_dayName(reminderDay)} $reminderHour:${reminderMinute.toString().padLeft(2, '0')}',
            style: NvType.caption(c),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _pickReminder(context),
        ),
      ],
    );
  }

  Widget _switchRow(
      AppColors c, String label, bool value, ValueChanged<bool> onSave) {
    return SwitchListTile(
      dense: true,
      title: Text(label, style: NvType.body(c)),
      value: value,
      onChanged: (v) {
        onSave(v);
      },
    );
  }

  Future<void> _pickReminder(BuildContext context) async {
    final day = await showDialog<int>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(ref.read(tProvider)('settings.notif_reminder_day')),
        children: [
          for (var i = 1; i <= 7; i++)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, i),
              child: Text(_dayName(i)),
            ),
        ],
      ),
    );
    if (day == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: reminderHour, minute: reminderMinute),
    );
    if (time == null) return;
    setState(() {
      reminderDay = day;
      reminderHour = time.hour;
      reminderMinute = time.minute;
    });
    await ref
        .read(settingsRepositoryProvider)
        .setReminder(weekday: day, hour: time.hour, minute: time.minute);
  }

  String _dayName(int weekday) {
    // 1 = Monday … 7 = Sunday.
    final t = ref.read(tProvider);
    return t('reminder.day$weekday');
  }
}

class _BiometricTile extends ConsumerStatefulWidget {
  @override
  ConsumerState<_BiometricTile> createState() => _BiometricTileState();
}

class _BiometricTileState extends ConsumerState<_BiometricTile> {
  bool enabled = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final v = await ref.read(pinRepositoryProvider).biometricEnabled();
    if (mounted) setState(() => enabled = v);
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return SwitchListTile(
      secondary: Icon(Icons.fingerprint_rounded, color: c.secondary),
      title: Text(t('settings.biometric'), style: NvType.body(c)),
      subtitle: Text(t('settings.biometric_hint'), style: NvType.caption(c)),
      value: enabled,
      onChanged: (v) async {
        await ref.read(pinRepositoryProvider).setBiometric(v);
        setState(() => enabled = v);
      },
    );
  }
}

class _AutolockTile extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AutolockTile> createState() => _AutolockTileState();
}

class _AutolockTileState extends ConsumerState<_AutolockTile> {
  int minutes = 5;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final v = await ref.read(pinRepositoryProvider).autolockMinutes();
    if (mounted) setState(() => minutes = v);
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return ListTile(
      leading: Icon(Icons.lock_clock_rounded, color: c.secondary),
      title: Text(t('settings.autolock'), style: NvType.body(c)),
      trailing: SegmentedButton<int>(
        segments: [
          ButtonSegment(value: 5, label: Text(t('settings.autolock_5'))),
          ButtonSegment(value: 10, label: Text(t('settings.autolock_10'))),
          ButtonSegment(value: 15, label: Text(t('settings.autolock_15'))),
        ],
        selected: {minutes},
        onSelectionChanged: (s) async {
          final v = s.first;
          await ref.read(pinRepositoryProvider).setAutolock(v);
          setState(() => minutes = v);
        },
      ),
    );
  }
}

class _LeaderboardOptInTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final optIn = ref.watch(leaderboardOptInProvider).valueOrNull;
    return SwitchListTile(
      secondary: Icon(Icons.leaderboard_rounded, color: c.secondary),
      title: Text(t('settings.opt_in_leaderboard'), style: NvType.body(c)),
      subtitle:
          Text(t('settings.opt_in_leaderboard_hint'), style: NvType.caption(c)),
      value: optIn?.optedIn ?? false,
      onChanged: (v) =>
          ref.read(leaderboardRepositoryProvider).setOptIn(v),
    );
  }
}

/// (30) Vacation Mode — pauses streak/reminder pressure without losing
/// progress. User picks a duration (1 week / 1 month / custom date). The
/// streak engine already honours `vacation_mode` in its daily processing.
class _VacationModeTile extends ConsumerStatefulWidget {
  @override
  ConsumerState<_VacationModeTile> createState() =>
      _VacationModeTileState();
}

class _VacationModeTileState extends ConsumerState<_VacationModeTile> {
  bool _loading = true;
  bool _enabled = false;
  DateTime? _until;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(settingsRepositoryProvider);
    final enabled = await repo.vacationMode();
    final until = await repo.vacationUntil();
    if (!mounted) return;
    setState(() {
      _enabled = enabled &&
          (until == null || until.isAfter(DateTime.now()));
      _until = enabled ? until : null;
      _loading = false;
    });
  }

  Future<void> _setEnabled(bool v) async {
    final repo = ref.read(settingsRepositoryProvider);
    final t = ref.read(tProvider);
    if (v) {
      final choice = await showModalBottomSheet<String?>(
        context: context,
        builder: (ctx) {
          final c = ref.watch(appColorsProvider);
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.beach_access_rounded,
                      color: c.accent),
                  title: Text(t('settings.vacation_week'),
                      style: NvType.body(c)),
                  onTap: () => Navigator.pop(ctx, 'week'),
                ),
                ListTile(
                  leading: Icon(Icons.travel_explore_rounded,
                      color: c.accent),
                  title: Text(t('settings.vacation_month'),
                      style: NvType.body(c)),
                  onTap: () => Navigator.pop(ctx, 'month'),
                ),
                ListTile(
                  leading: Icon(Icons.event_rounded, color: c.accent),
                  title: Text(t('settings.vacation_custom'),
                      style: NvType.body(c)),
                  onTap: () => Navigator.pop(ctx, 'custom'),
                ),
              ],
            ),
          );
        },
      );
      if (choice == null || !mounted) return;
      DateTime? until;
      if (choice == 'week') {
        until = DateTime.now().add(const Duration(days: 7));
      } else if (choice == 'month') {
        until = DateTime.now().add(const Duration(days: 30));
      } else {
        until = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 7)),
          firstDate: DateTime.now().add(const Duration(days: 1)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
      }
      if (until == null || !mounted) return;
      await repo.setVacationMode(true, until: until);
      ref.invalidate(vacationModeProvider);
      setState(() {
        _enabled = true;
        _until = until;
      });
    } else {
      await repo.setVacationMode(false);
      ref.invalidate(vacationModeProvider);
      setState(() {
        _enabled = false;
        _until = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final subtitle = _enabled && _until != null
        ? t('settings.vacation_active_until',
            {'date': formatDate(_until!)})
        : t('settings.vacation_hint');
    return SwitchListTile(
      secondary: Icon(Icons.luggage_rounded, color: c.secondary),
      title: Text(t('settings.vacation_mode'), style: NvType.body(c)),
      subtitle: Text(subtitle, style: NvType.caption(c)),
      value: _enabled,
      onChanged: _loading ? null : (v) => _setEnabled(v),
    );
  }
}

/// (27) Quick Phrases — user's motivational lines. Managed here; shown at
/// random on the Dashboard and as comment chips in Add-Money.
class _QuickPhrasesTile extends ConsumerWidget {
  const _QuickPhrasesTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final phrases =
        ref.watch(quickPhrasesProvider).valueOrNull ?? const <String>[];
    return ListTile(
      leading: Icon(Icons.format_quote_rounded, color: c.secondary),
      title: Text(t('settings.quick_phrases'), style: NvType.body(c)),
      subtitle: Text(t('settings.quick_phrases_hint'),
          style: NvType.caption(c)),
      trailing: Text(
        phrases.isEmpty ? t('settings.quick_phrases_add') : '${phrases.length}',
        style: NvType.caption(c).copyWith(color: c.accent),
      ),
      onTap: () async {
        final current =
            await ref.read(settingsRepositoryProvider).quickPhrases();
        if (!context.mounted) return;
        await showDialog<void>(
          context: context,
          builder: (_) => _QuickPhrasesDialog(initial: current),
        );
      },
    );
  }
}

/// Manage (add/remove) quick phrases in a dialog.
class _QuickPhrasesDialog extends ConsumerStatefulWidget {
  const _QuickPhrasesDialog({required this.initial});
  final List<String> initial;

  @override
  ConsumerState<_QuickPhrasesDialog> createState() =>
      _QuickPhrasesDialogState();
}

class _QuickPhrasesDialogState extends ConsumerState<_QuickPhrasesDialog> {
  late List<String> _phrases = List.of(widget.initial);
  final _inputCtrl = TextEditingController();

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  Future<void> _savePhrases() async {
    await ref
        .read(settingsRepositoryProvider)
        .setQuickPhrases(_phrases);
    ref.invalidate(quickPhrasesProvider);
  }

  Future<void> _add() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _phrases = [..._phrases, text]);
    _inputCtrl.clear();
    await _savePhrases();
  }

  Future<void> _remove(int i) async {
    setState(() => _phrases = [..._phrases]..removeAt(i));
    await _savePhrases();
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return AlertDialog(
      title: Text(t('settings.quick_phrases')),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _inputCtrl,
              decoration: InputDecoration(
                hintText: t('settings.quick_phrases_add_hint'),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: _add,
                ),
              ),
              onSubmitted: (_) => _add(),
            ),
            const SizedBox(height: 8),
            if (_phrases.isEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  t('settings.quick_phrases_empty'),
                  style: NvType.bodySecondary(c),
                ),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (var i = 0; i < _phrases.length; i++)
                      ListTile(
                        dense: true,
                        leading: Icon(Icons.format_quote_rounded,
                            color: c.accent2, size: 18),
                        title: Text(_phrases[i], style: NvType.body(c)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded),
                          tooltip: t('settings.quick_phrases_deleted'),
                          onPressed: () => _remove(i),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t('common.done')),
        ),
      ],
    );
  }
}

/// (11) Salary-day reminder — configured here, triggered by
/// ContextTriggerService.checkSalaryTrigger on payday (+1).
class _SalaryDayTile extends ConsumerStatefulWidget {
  const _SalaryDayTile();

  @override
  ConsumerState<_SalaryDayTile> createState() => _SalaryDayTileState();
}

class _SalaryDayTileState extends ConsumerState<_SalaryDayTile> {
  int _day = 15;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await ref.read(settingsRepositoryProvider).salaryDay();
    if (mounted) {
      setState(() {
        _day = d;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return ListTile(
      leading: Icon(Icons.payments_outlined, color: c.secondary),
      title: Text(t('settings.salary_day'), style: NvType.body(c)),
      subtitle: Text(t('settings.salary_day_hint'),
          style: NvType.caption(c)),
      trailing: _loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2))
          : DropdownButton<int>(
              value: _day,
              dropdownColor: c.surface,
              underline: const SizedBox.shrink(),
              items: [
                for (var d = 1; d <= 31; d++)
                  DropdownMenuItem(value: d, child: Text('$d')),
              ],
              onChanged: (v) async {
                if (v == null) return;
                await ref
                    .read(settingsRepositoryProvider)
                    .setSalaryDay(v);
                setState(() => _day = v);
              },
            ),
    );
  }
}
