import 'package:flutter/material.dart';
import '../../shared/widgets/motion.dart';
import '../../core/utils/format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart' show HoloCard;
import '../../core/theme/app_theme.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/retention_repositories.dart';
import '../../data/repositories/ui_providers.dart';
import '../../shared/widgets/widgets.dart';

/// 6.29 Holo-cards Gallery (§10.6/§6.29): 4 set-tabs, 3-column grid
/// (unlocked = neon holo shimmer, locked = silhouette + condition), tap →
/// flip + lore, set progress, dust, «Відкрити пачку» (80 Chips) with pack
/// tear animation.
class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  String _set = 'money';
  bool _opening = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('collection');
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final cards = ref.watch(holoCardsProvider).valueOrNull ?? const [];
    final owned = ref.watch(holoOwnedProvider).valueOrNull ?? const [];
    final chips = ref.watch(chipsWalletProvider).valueOrNull?.balance ?? 0;
    final dust = ref.watch(chipsWalletProvider).valueOrNull?.dust ?? 0;

    final ownedIds = {for (final o in owned) o.cardId};
    final setCards = cards.where((card) => card.setId == _set).toList();
    final setOwned = setCards.where((card) => ownedIds.contains(card.id)).length;

    final grid = DefaultTabController(
      length: 4,
      child: Column(
        children: [
        TabBar(
          tabs: [
            Tab(text: t('collection.set_money')),
            Tab(text: t('collection.set_prices')),
            Tab(text: t('collection.set_discipline')),
            Tab(text: t('collection.set_world')),
          ],
          onTap: (i) => setState(() {
            _set = switch (i) { 0 => 'money', 1 => 'prices', 2 => 'discipline', _ => 'world' };
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Text(
                '${t('collection.set_progress')}: $setOwned/${setCards.length}',
                style: NvType.button(c).copyWith(fontSize: 13, color: c.accent),
              ),
              const Spacer(),
              Icon(Icons.auto_awesome, size: 14, color: c.accent2),
              const SizedBox(width: 4),
              Text('$dust ${t('collection.dust')}', style: NvType.caption(c)),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.72,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: setCards.length,
              itemBuilder: (context, i) {
                final card = setCards[i];
                final isOwned = ownedIds.contains(card.id);
                return _CardTile(card: card, owned: isOwned);
              },
            ),
          ),
        ],
      ),
    );

    final actions = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: NeonGradientButton(
        label: _opening
            ? t('collection.pack_opening')
            : t('collection.open_pack'),
        icon: Icons.style_rounded,
        onPressed: _opening
            ? null
            : () async {
                if (chips < HoloRepository.packCost) {
                  context.toast(t('collection.no_pack'));
                  return;
                }
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(t('collection.open_pack')),
                    content: Text(t('collection.open_pack_confirm')),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(t('common.cancel')),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(t('common.confirm')),
                      ),
                    ],
                  ),
                );
                if (confirmed != true || !context.mounted) return;
                setState(() => _opening = true);
                // Pack tear animation window (§6.29).
                await Future<void>.delayed(const Duration(milliseconds: 900));
                final (card, isNew) =
                    await ref.read(holoRepositoryProvider).openPack();
                ref.read(holoChangedTickProvider.notifier).state++;
                ref.read(chestOpenedTickProvider.notifier).state++;
                if (!context.mounted) return;
                setState(() => _opening = false);
                _revealCard(context, card, isNew);
              },
      ),
    );

    if (widget.embedded) {
      return Column(children: [actions, const SizedBox(height: 4), Expanded(child: grid)]);
    }
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('collection.title'))),
      body: Column(children: [actions, const SizedBox(height: 4), Expanded(child: grid)]),
    );
  }

  void _revealCard(BuildContext context, HoloCard card, bool isNew) {
    final t = ref.read(tProvider);
    final c = ref.read(appColorsProvider);
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  const MiniConfetti(),
                  Icon(
                    Icons.style_rounded,
                    size: 80,
                    color: switch (card.rarity) {
                      'l' => c.accent2,
                      'e' => c.accent,
                      'r' => c.success,
                      _ => c.secondary,
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                isNew ? t('collection.new_card') : t('collection.duplicate'),
                style: NvType.h2(c),
              ),
              Text(card.nameKey, style: NvType.button(c)),
              if (!isNew)
                Text(
                  t('collection.duplicate', {'dust': 15}),
                  style: NvType.caption(c),
                ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(t('common.done')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardTile extends ConsumerStatefulWidget {
  const _CardTile({required this.card, required this.owned});
  final HoloCard card;
  final bool owned;

  @override
  ConsumerState<_CardTile> createState() => _CardTileState();
}

class _CardTileState extends ConsumerState<_CardTile> {
  bool _flipped = false;

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final rarityColor = switch (widget.card.rarity) {
      'l' => c.accent2,
      'e' => c.accent,
      'r' => c.success,
      _ => c.secondary,
    };
    return GestureDetector(
      onTap: widget.owned
          ? () => setState(() => _flipped = !_flipped)
          : () => context.toast(
                t('collection.locked_hint', {'cond': widget.card.condKey}),
              ),
      child: AnimatedSwitcher(
        duration: NvMotion.normal,
        transitionBuilder: (child, anim) => RotationTransition(
          turns: Tween(begin: 0.5, end: 0.0).animate(anim),
          child: child,
        ),
        child: !_flipped
            ? NeonCard(
                key: ValueKey('front_${widget.card.id}'),
                padding: const EdgeInsets.all(8),
                accentBorder: widget.owned,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.owned)
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: rarityColor),
                          boxShadow: widget.owned
                              ? [
                                  BoxShadow(
                                    color: rarityColor.withOpacity(0.4),
                                    blurRadius: 12,
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(Icons.star_rounded,
                            size: 18, color: rarityColor),
                      )
                    else
                      Icon(Icons.help_outline_rounded,
                          size: 30, color: c.secondary),
                    const SizedBox(height: 6),
                    Text(
                      widget.owned ? widget.card.nameKey : '???',
                      style: NvType.caption(c),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      t('collection.rarity_${widget.card.rarity}'),
                      style:
                          NvType.caption(c).copyWith(color: rarityColor, fontSize: 10),
                    ),
                  ],
                ),
              )
            : NeonCard(
                key: ValueKey('back_${widget.card.id}'),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t('collection.lore'),
                      style: NvType.caption(c).copyWith(color: rarityColor),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _lore(widget.card.id),
                      style: NvType.caption(c),
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  String _lore(String id) {
    // Short cyberpunk lore lines (1–2 sentences per §10.6).
    final t = ref.read(tProvider);
    return switch (id) {
      'h_money_1' => t('lore.h_money_1'),
      'h_money_2' => t('lore.h_money_2'),
      'h_money_3' => t('lore.h_money_3'),
      'h_money_4' => t('lore.h_money_4'),
      'h_money_5' => t('lore.h_money_5'),
      'h_prices_1' => t('lore.h_prices_1'),
      'h_prices_2' => t('lore.h_prices_2'),
      'h_prices_3' => t('lore.h_prices_3'),
      'h_prices_4' => t('lore.h_prices_4'),
      'h_prices_5' => t('lore.h_prices_5'),
      'h_disc_1' => t('lore.h_disc_1'),
      'h_disc_2' => t('lore.h_disc_2'),
      'h_disc_3' => t('lore.h_disc_3'),
      'h_disc_4' => t('lore.h_disc_4'),
      'h_disc_5' => t('lore.h_disc_5'),
      'h_world_1' => t('lore.h_world_1'),
      'h_world_2' => t('lore.h_world_2'),
      'h_world_3' => t('lore.h_world_3'),
      'h_world_4' => t('lore.h_world_4'),
      'h_world_5' => t('lore.h_world_5'),
      _ => '',
    };
  }
}

/// Wrapper used inside the Achievements segment switcher (§10.9).
class CollectionView extends StatelessWidget {
  const CollectionView({super.key});
  @override
  Widget build(BuildContext context) => const CollectionScreen(embedded: true);
}
