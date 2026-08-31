import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/system_repositories.dart';
import '../../shared/widgets/widgets.dart';

/// (1) Setup Wizard: Initial setup screen before onboarding.
class SetupWizardScreen extends ConsumerStatefulWidget {
  const SetupWizardScreen({super.key});

  @override
  ConsumerState<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends ConsumerState<SetupWizardScreen> {
  int _step = 0;
  bool _saving = false;

  Future<void> _finish() async {
    setState(() => _saving = true);
    final settings = ref.read(settingsRepositoryProvider);
    await settings.setSetupWizardCompleted(true);
    if (mounted) context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: _step == 0 ? _themeStep(c, t) : _notificationsStep(c, t),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (i) {
                  return Container(
                    width: i == _step ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: i == _step ? c.accent : c.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _themeStep(AppColors c, String Function(String, [Map<String, Object?>]) t) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.palette_outlined, size: 56, color: c.accent),
        const SizedBox(height: 16),
        Text(t('settings.appearance'), style: NvType.h2(c), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        NeonCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _ThemeOption(id: 'dark', icon: Icons.dark_mode_rounded, label: t('theme.dark')),
              const Divider(height: 1),
              _ThemeOption(id: 'light', icon: Icons.light_mode_rounded, label: t('theme.light')),
            ],
          ),
        ),
        const SizedBox(height: 32),
        NeonGradientButton(
          label: t('common.continue'),
          onPressed: () => setState(() => _step = 1),
        ),
      ],
    );
  }

  Widget _notificationsStep(AppColors c, String Function(String, [Map<String, Object?>]) t) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.notifications_active_outlined, size: 56, color: c.accent),
        const SizedBox(height: 16),
        Text(t('settings.notifications'), style: NvType.h2(c), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          t('notifications.contrib_added_body', {'xp': '100'}),
          style: NvType.bodySecondary(c),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        NeonGradientButton(
          label: _saving ? t('common.loading') : t('common.continue'),
          onPressed: _saving ? null : _finish,
        ),
      ],
    );
  }
}

class _ThemeOption extends ConsumerWidget {
  const _ThemeOption({required this.id, required this.icon, required this.label});
  final String id;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final current = ref.watch(themeControllerProvider).id;
    final selected = current.id == id;
    return InkWell(
      onTap: () => ref.read(themeControllerProvider.notifier).apply(NvThemeId.fromId(id), totalXp: 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: selected ? c.accent : c.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: NvType.body(c).copyWith(
                  color: selected ? c.text : c.secondary,
                ),
              ),
            ),
            if (selected) Icon(Icons.check_circle_rounded, color: c.accent),
          ],
        ),
      ),
    );
  }
}
