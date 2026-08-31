import 'package:flutter/material.dart';
import '../../core/utils/format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_controller.dart';
import '../../data/repositories/goal_repository.dart';
import '../../shared/widgets/widgets.dart';

/// 6.12 Theme Gallery (§6.12): 2-column grid, previews, tap-to-apply,
/// long-press full preview with confirm, XP-locked presets (500/1200),
/// AI-theme card with «Незабаром» badge (⛔ §9.8).
class ThemeGalleryScreen extends ConsumerStatefulWidget {
  const ThemeGalleryScreen({super.key});

  @override
  ConsumerState<ThemeGalleryScreen> createState() => _ThemeGalleryScreenState();
}

class _ThemeGalleryScreenState extends ConsumerState<ThemeGalleryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('themes');
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final theme = ref.watch(themeControllerProvider);
    final xp = ref.watch(statsRowProvider).valueOrNull?.totalXp ?? 0;
    final controller = ref.read(themeControllerProvider.notifier);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('themes.title'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(t('themes.tap_apply'), style: NvType.caption(c)),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: NvThemeData.all.length + 1,
              itemBuilder: (context, i) {
                if (i == NvThemeData.all.length) return const _AiThemeCard();
                final td = NvThemeData.all[i];
                final locked = controller.isLocked(td.id, xp);
                final active = td.id == theme.id;
                return _ThemeCard(
                  data: td,
                  active: active,
                  locked: locked,
                  lockXp: ThemeController.unlockXp[td.id],
                  onApply: () async {
                    if (locked) return;
                    await controller.apply(td.id, totalXp: xp);
                    if (context.mounted) context.toast(t('themes.applied'));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends ConsumerWidget {
  const _ThemeCard({
    required this.data,
    required this.active,
    required this.locked,
    required this.lockXp,
    required this.onApply,
  });

  final NvThemeData data;
  final bool active;
  final bool locked;
  final int? lockXp;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return GestureDetector(
      onLongPress: locked
          ? null
          : () => showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(t('themes.preview')),
                  content: _MiniDashboard(data: data),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(t('common.cancel')),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        onApply();
                      },
                      child: Text(t('common.apply')),
                    ),
                  ],
                ),
              ),
      child: NeonCard(
        onTap: locked ? null : onApply,
        padding: const EdgeInsets.all(10),
        accentBorder: active,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _MiniDashboard(data: data)),
            const SizedBox(height: 6),
            Text(themeName(data.id, t), style: NvType.button(c).copyWith(fontSize: 13)),
            if (active)
              Text(t('themes.active'),
                  style: NvType.caption(c).copyWith(color: c.accent))
            else if (locked)
              Text(
                t('themes.locked', {'xp': lockXp ?? 0}),
                style: NvType.caption(c).copyWith(color: c.accent2),
              ),
          ],
        ),
      ),
    );
  }

  String themeName(NvThemeId id, String Function(String, [Map<String, Object?>]) t) {
    return switch (id) {
      NvThemeId.cyberpunkNeon => 'Graphite & Gold',
      NvThemeId.lightMode => 'Light Mode',
      NvThemeId.oceanBlue => 'Ocean Blue',
      NvThemeId.sunsetPurple => 'Sunset Purple',
      NvThemeId.mintFresh => 'Mint Fresh',
    };
  }
}

/// Mini dashboard preview thumbnail (§6.12 превю).
class _MiniDashboard extends StatelessWidget {
  const _MiniDashboard({required this.data});
  final NvThemeData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: data.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: data.borderColor),
      ),
      child: Column(
        children: [
          Container(
            height: 26,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: data.surface,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.centerLeft,
            child: Text('12 400 ₴',
                style: TextStyle(
                  color: data.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                )),
          ),
          const SizedBox(height: 6),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: data.borderColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.62,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [data.accent, data.success]),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(height: 22, color: data.surface),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(height: 22, color: data.surface),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AiThemeCard extends ConsumerWidget {
  const _AiThemeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return NeonCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome_rounded, size: 34, color: c.secondary),
          const SizedBox(height: 6),
          Text(t('themes.ai_theme'), style: NvType.button(c).copyWith(fontSize: 13)),
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.border),
            ),
            child: Text(t('themes.ai_badge'), style: NvType.caption(c)),
          ),
        ],
      ),
    );
  }
}
