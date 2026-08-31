import 'package:flutter/material.dart';
import '../../shared/widgets/motion.dart';
import '../../core/utils/format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/system_repositories.dart';
import '../../shared/widgets/widgets.dart';

/// 6.2 Onboarding (§6.2): 5 steps + push permission request.
/// Step 5 first contribution → O1 achievement + pet hatch + XP toast.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  final _ps5Ctrl = TextEditingController(text: '18000');
  final _monCtrl = TextEditingController(text: '8000');
  final _nameCtrl = TextEditingController();
  final _contribCtrl = TextEditingController();
  bool _contributing = false;
  String? _error;
  /// (31) Auto goal correction: reopened from Victory with ?inherit=next →
  /// the target is prefilled at previous × 1.2 as the suggested next goal.
  bool _inherit = false;

  static const quickAmounts = [500, 1000, 2000, 5000];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final uri = GoRouterState.of(context).uri;
      if (uri.queryParameters.containsKey('inherit')) {
        _applyInherit();
      }
    });
  }

  Future<void> _applyInherit() async {
    final prev = await ref.read(goalRepositoryProvider).getGoal();
    if (!mounted) return;
    setState(() {
      if (prev == null) {
        _ps5Ctrl.text = '18000';
        _monCtrl.text = '8000';
      } else {
        _ps5Ctrl.text = '${(prev.ps5Target * 1.2).round()}';
        _monCtrl.text = '${(prev.monitorTarget * 1.2).round()}';
      }
      _inherit = true;
    });
  }

  @override
  void dispose() {
    _ps5Ctrl.dispose();
    _monCtrl.dispose();
    _nameCtrl.dispose();
    _contribCtrl.dispose();
    super.dispose();
  }

  Future<void> _finish({bool withContribution = false}) async {
    setState(() => _contributing = true);
    final goals = ref.read(goalRepositoryProvider);
    final settings = ref.read(settingsRepositoryProvider);

    final ps5 = int.tryParse(_ps5Ctrl.text) ?? 0;
    final mon = int.tryParse(_monCtrl.text) ?? 0;
    if (ps5 <= 0 || mon <= 0) {
      setState(() {
        _error = ref.read(tProvider)('onboarding.invalid_price');
        _contributing = false;
      });
      return;
    }
    final title = _nameCtrl.text.trim().isEmpty
        ? ref.read(tProvider)('onboarding.step4_hint')
        : _nameCtrl.text.trim();

    await goals.createGoal(title: title, ps5Price: ps5, monitorPrice: mon);

    if (withContribution) {
      final amount = int.tryParse(_contribCtrl.text) ?? 0;
      if (amount > 0) {
        final res = await goals.addContribution(
          amount: amount,
          viaOnboarding: true, // O1 «Швидкий старт» (§5.3)
        );
        // Пуш-дозвіл — системний запит наприкінці кроку 5 (§6.2).
        await ref.read(notificationsRepositoryProvider).pushInApp(
              type: NotifType.contrib,
              titleKey: 'notifications.contrib_added',
              bodyKey: 'notifications.contrib_added_body',
              bodyParams: {'xp': res.xp},
            );
      }
    }

    await settings.setOnboarded(true);
    if (mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return Scaffold(
      backgroundColor: c.background,
      appBar: _step > 0
          ? AppBar(
              actions: [
                TextButton(
                  onPressed: () => _finish(),
                  child: Text(t('common.skip')),
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(child: _stepBody(t)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return Semantics(
                    label: t('onboarding.progress_dots_semantics', {'n': i + 1}),
                    child: Container(
                      width: i == _step ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: i == _step ? c.accent : c.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
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

  Widget _stepBody(String Function(String, [Map<String, Object?>]) t) {
    final c = ref.watch(appColorsProvider);
    switch (_step) {
      case 0:
        return _welcome(c, t);
      case 1:
        return _priceStep(
          c,
          t,
          title: t('onboarding.step2_title'),
          hint: t('onboarding.step2_hint'),
          ctrl: _ps5Ctrl,
          icon: Icons.sports_esports_rounded,
        );
      case 2:
        return _priceStep(
          c,
          t,
          title: t('onboarding.step3_title'),
          hint: t('onboarding.step3_hint'),
          ctrl: _monCtrl,
          icon: Icons.desktop_windows_rounded,
        );
      case 3:
        return _nameStep(c, t);
      case 4:
        return _firstContribStep(c, t);
      default:
        return _welcome(c, t);
    }
  }

  Widget _welcome(AppColors c, String Function(String, [Map<String, Object?>]) t) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PetEggPreview(color: c.accent),
        const SizedBox(height: 32),
        Text(t('onboarding.step1_title'), style: NvType.h1(c), textAlign: TextAlign.center),
        const SizedBox(height: 12),
        Text(t('onboarding.step1_body'), style: NvType.bodySecondary(c), textAlign: TextAlign.center),
        const SizedBox(height: 32),
        NeonGradientButton(
          label: t('onboarding.step1_cta'),
          onPressed: () => setState(() => _step = 1),
        ),
      ],
    );
  }

  Widget _priceStep(
    AppColors c,
    String Function(String, [Map<String, Object?>]) t, {
    required String title,
    required String hint,
    required TextEditingController ctrl,
    required IconData icon,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(icon, size: 56, color: c.accent),
        const SizedBox(height: 16),
        Text(title, style: NvType.h2(c), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(hint, style: NvType.caption(c), textAlign: TextAlign.center),
        if (_inherit) ...[
          const SizedBox(height: 8),
          Text(
            t('onboarding.inherit_hint'),
            style: NvType.caption(c).copyWith(color: c.accent),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 24),
        TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: NvType.amount(c, size: 32),
          decoration: const InputDecoration(suffixText: '₴'),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: NvType.caption(c).copyWith(color: c.danger),
              textAlign: TextAlign.center),
        ],
        const SizedBox(height: 24),
        NeonGradientButton(
          label: t('common.continue'),
          onPressed: () {
            final price = int.tryParse(ctrl.text) ?? 0;
            if (price <= 0) {
              setState(() => _error = t('onboarding.invalid_price'));
              return;
            }
            setState(() {
              _error = null;
              _step++;
            });
          },
        ),
      ],
    );
  }

  Widget _nameStep(AppColors c, String Function(String, [Map<String, Object?>]) t) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.flag_rounded, size: 56, color: c.accent),
        const SizedBox(height: 16),
        Text(t('onboarding.step4_title'), style: NvType.h2(c), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        TextField(
          controller: _nameCtrl,
          textAlign: TextAlign.center,
          style: NvType.h2(c),
          decoration: InputDecoration(hintText: t('onboarding.step4_hint')),
        ),
        const SizedBox(height: 24),
        NeonGradientButton(
          label: t('common.continue'),
          onPressed: () => setState(() => _step = 4),
        ),
      ],
    );
  }

  Widget _firstContribStep(AppColors c, String Function(String, [Map<String, Object?>]) t) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.savings_rounded, size: 56, color: c.accent),
        const SizedBox(height: 16),
        Text(t('onboarding.step5_title'), style: NvType.h2(c), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(t('onboarding.step5_body'), style: NvType.bodySecondary(c), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (final amount in quickAmounts)
              ActionChip(
                label: Text('$amount ₴'),
                onPressed: () => _contribCtrl.text = '$amount',
              ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _contribCtrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: NvType.amount(c, size: 32),
          decoration: const InputDecoration(suffixText: '₴'),
        ),
        const SizedBox(height: 24),
        NeonGradientButton(
          label: _contributing ? t('common.loading') : t('add_money.confirm'),
          onPressed: _contributing ? null : () => _finish(withContribution: true),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _contributing ? null : () => _finish(),
          child: Text(t('onboarding.step5_skip')),
        ),
      ],
    );
  }
}

/// Cute egg with neon ring — hints at the pet (§10.1).
class _PetEggPreview extends ConsumerWidget {
  const _PetEggPreview({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduced = ref.watch(reduceMotionProvider);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: NvMotion.celebration,
      curve: Curves.elasticOut,
      builder: (context, v, child) => Transform.scale(scale: reduced ? 1 : v, child: child),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.25), blurRadius: 36, spreadRadius: 6),
          ],
        ),
        child: Icon(Icons.egg_alt_rounded, size: 52, color: color),
      ),
    );
  }
}
