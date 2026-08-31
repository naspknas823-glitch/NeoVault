import 'package:flutter/material.dart';
import '../../core/utils/format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/goal_repository.dart';
import '../dashboard/add_money_sheet.dart';
import '../../data/repositories/retention_repositories.dart';
import '../../data/repositories/ui_providers.dart';
import '../../domain/pet/pet_engine.dart';
import '../../domain/quests/quest_engine.dart';
import '../../shared/widgets/widgets.dart';

/// 6.25 Vault Pet (§10.1/§6.25): animated pet scene, mood, evolution
/// progress, feed (10 Chips), wardrobe (skins), stats, timeline; empty =
/// egg state with CTA (§6.25). ⛔ Pet never dies, progress never lost.
class PetScreen extends ConsumerStatefulWidget {
  const PetScreen({super.key});

  @override
  ConsumerState<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends ConsumerState<PetScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _ctrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final repo = ref.read(petRepositoryProvider);
      await repo.stateNow(); // mood + open-day bookkeeping (§10.1)
      ref.read(goalRepositoryProvider).trackScreenVisit('pet');
      ref.read(questRepositoryProvider).track(QuestType.visitPet);
    });
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final pet = ref.watch(petStateProvider);
    final wallet = ref.watch(chipsWalletProvider).valueOrNull;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('pet.title'))),
      body: AsyncValueView<PetState>(
        value: pet,
        empty: EmptyState(
          title: t('pet.empty'),
          body: '',
          ctaLabel: t('pet.empty_cta'),
          onCta: () async {
            final outcome = await showAddMoneySheet(context, ref);
            if (outcome != null && outcome.result.goalCompleted && context.mounted) {
              context.push('/victory');
            }
          },
          icon: Icons.egg_alt_rounded,
        ),
        content: (state) => state.form == PetForm.egg
            ? EmptyState(
                title: t('pet.empty'),
                body: '',
                ctaLabel: t('pet.empty_cta'),
                onCta: () async {
                  final outcome = await showAddMoneySheet(context, ref);
                  if (outcome != null &&
                      outcome.result.goalCompleted &&
                      context.mounted) {
                    context.push('/victory');
                  }
                },
                icon: Icons.egg_alt_rounded,
              )
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            NeonCard(
              accentBorder: true,
              child: Column(
                children: [
                  _PetScene(
                      form: state.form,
                      mood: state.mood,
                      ctrl: _ctrl ??= AnimationController(
                        vsync: this,
                        duration: const Duration(milliseconds: 2400),
                      )..repeat(reverse: true)),
                  const SizedBox(height: 12),
                  Text(
                    '${t('pet.form_${state.form.name}')} • ${t('pet.mood_${state.mood.name}')}',
                    style: NvType.h2(c).copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${t('pet.next_form')}: ${_nextCondition(state.form, t)}',
                    style: NvType.caption(c),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: NeonGradientButton(
                    label: t('pet.feed'),
                    icon: Icons.restaurant_rounded,
                    onPressed: wallet == null || wallet.balance < petFeedCostChips
                        ? () => context.toast(t('pet.no_chips'))
                        : () async {
                            final ok =
                                await ref.read(petRepositoryProvider).feed();
                            ref.read(petVisitTickProvider.notifier).state++;
                            if (context.mounted) {
                              context.toast(ok
                                  ? t('pet.fed_toast')
                                  : t('pet.no_chips'));
                            }
                          },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _wardrobe(context),
                    icon: const Icon(Icons.checkroom_rounded, size: 18),
                    label: Text(t('pet.wardrobe')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            NeonCard(
              child: Column(
                children: [
                  _statRow(t('pet.stats_together'), '${state.daysTogether}', c),
                  _statRow(t('pet.stats_fed'), '${state.feedCount}', c),
                  _statRow(t('pet.stats_nearby'),
                      '${state.contributionsNearby}', c),
                ],
              ),
            ),
            const SizedBox(height: 12),
            NeonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t('pet.timeline'), style: NvType.button(c)),
                  const SizedBox(height: 10),
                  for (final form in PetForm.values)
                    _timelineRow(
                      form,
                      reached: PetForm.values.indexOf(form) <=
                          PetForm.values.indexOf(state.form),
                      t: t,
                      c: c,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statRow(String label, String value, AppColors c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: NvType.bodySecondary(c))),
          Text(value, style: NvType.button(c)),
        ],
      ),
    );
  }

  Widget _timelineRow(PetForm form,
      {required bool reached, required t, required AppColors c}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            reached ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: 16,
            color: reached ? c.success : c.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(t('pet.form_${form.name}'), style: NvType.body(c))),
        ],
      ),
    );
  }

  String _nextCondition(PetForm form,
      String Function(String, [Map<String, Object?>]) t) {
    return switch (form) {
      PetForm.egg => t('pet.cond_hatch'),
      PetForm.hatchling => t('pet.cond_baby'),
      PetForm.baby => t('pet.cond_adult'),
      PetForm.adult => t('pet.cond_legendary'),
      PetForm.legendary => t('pet.not_enough'),
    };
  }

  Future<void> _wardrobe(BuildContext context) async {
    final skins = await ref.read(petRepositoryProvider).skins();
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Consumer(builder: (context, ref, _) {
          final c = ref.watch(appColorsProvider);
          final t = ref.watch(tProvider);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(t('pet.wardrobe'), style: NvType.h2(c)),
              const SizedBox(height: 12),
              for (final skin in skins)
                ListTile(
                  leading: Icon(Icons.palette_rounded,
                      color: skin.owned ? c.accent : c.secondary),
                  title: Text(
                    t(_skinNameKey(skin.id)),
                    style: NvType.body(c),
                  ),
                  trailing: skin.owned
                      ? TextButton(
                          onPressed: () async {
                            await ref.read(petRepositoryProvider).setSkin(skin.id);
                            ref.read(petVisitTickProvider.notifier).state++;
                            if (ctx.mounted) {
                              ctx.toast(t('pet.skin_applied'));
                              Navigator.pop(ctx);
                            }
                          },
                          child: Text(t('common.apply')),
                        )
                      : Icon(Icons.lock_outline_rounded, size: 18, color: c.secondary),
                ),
            ],
          );
        }),
      ),
    );
  }

  String _skinNameKey(String id) => switch (id) {
        'neon_cyan' => 'pet.skin_default',
        'neon_magenta' => 'pet.skin_magenta',
        'gold_rush' => 'pet.skin_gold',
        _ => 'pet.skin_default',
      };
}

/// The pet itself: form-dependent vector (egg / hatchling / baby / adult /
/// legendary), micro-motion breathing (§10.1 creative freedom).
class _PetScene extends ConsumerWidget {
  const _PetScene({
    required this.form,
    required this.mood,
    required this.ctrl,
  });

  final PetForm form;
  final PetMood mood;
  final AnimationController ctrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final reduced = ref.watch(reduceMotionProvider);
    final icon = switch (form) {
      PetForm.egg => Icons.egg_alt_rounded,
      PetForm.hatchling => Icons.emoji_nature_rounded,
      PetForm.baby => Icons.cruelty_free_rounded,
      PetForm.adult => Icons.pets_rounded,
      PetForm.legendary => Icons.auto_awesome_rounded,
    };
    final size = switch (form) {
      PetForm.egg => 96.0,
      PetForm.hatchling => 88.0,
      PetForm.baby => 96.0,
      PetForm.adult => 108.0,
      PetForm.legendary => 120.0,
    };
    if (reduced) {
      return Icon(icon, size: size, color: c.accent);
    }
    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) {
        final breath = 1 + ctrl.value * 0.05;
        final glow = 0.25 + ctrl.value * 0.25;
        return Transform.scale(
          scale: breath,
          child: Container(
            width: size + 40,
            height: size + 40,
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.background,
              boxShadow: [
                BoxShadow(
                  color: c.accent.withOpacity(glow),
                  blurRadius: 36,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(icon, size: size, color: c.accent),
          ),
        );
      },
    );
  }
}
