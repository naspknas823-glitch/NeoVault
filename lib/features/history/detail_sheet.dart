import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../shared/widgets/widgets.dart';

/// 6.6 Transaction Detail (§6.6 bottom sheet): amount, date/time, comment,
/// receipt (tap → full), XP, goal; Edit / Delete-with-undo (5s toast).
Future<void> showTransactionDetailSheet(
  BuildContext context,
  WidgetRef ref,
  String contributionId,
) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(kSheetRadius)),
    ),
    builder: (_) => _TransactionDetailSheet(contributionId: contributionId),
  );
}

class _TransactionDetailSheet extends ConsumerStatefulWidget {
  const _TransactionDetailSheet({required this.contributionId});
  final String contributionId;

  @override
  ConsumerState<_TransactionDetailSheet> createState() =>
      _TransactionDetailSheetState();
}

class _TransactionDetailSheetState
    extends ConsumerState<_TransactionDetailSheet> {
  bool _loading = true;
  ContributionView? _item;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final item =
        await ref.read(goalRepositoryProvider).getContribution(widget.contributionId);
    if (mounted) {
      setState(() {
        _item = item;
        _loading = false;
      });
    }
  }

  Future<void> _delete() async {
    final t = ref.read(tProvider);
    final goals = ref.read(goalRepositoryProvider);
    final item = _item;
    if (item == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t('history.delete_confirm_title')),
        content: Text(t('history.delete_confirm_body')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t('common.cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t('common.delete')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final removed = await goals.deleteContribution(item.id);
    if (!mounted) return;
    Navigator.of(context).pop();
    if (removed == null) return;

    // Undo toast 5s (§6.6).
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(t('history.deleted')),
            action: SnackBarAction(
              label: t('add_money.undo'),
              onPressed: () => goals.restoreContribution(removed),
            ),
          ),
        )
        .closed;
  }

  Future<void> _edit() async {
    final t = ref.read(tProvider);
    final item = _item;
    if (item == null) return;
    final amountCtrl = TextEditingController(text: '${item.amount}');
    final commentCtrl = TextEditingController(text: item.comment ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t('history.edit_title')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(suffixText: '₴'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: commentCtrl,
              decoration: InputDecoration(labelText: t('add_money.comment')),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t('common.cancel'))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t('common.save'))),
        ],
      ),
    );
    if (saved != true) return;
    await ref.read(goalRepositoryProvider).updateContribution(
          id: item.id,
          amount: int.tryParse(amountCtrl.text),
          comment: commentCtrl.text.trim(),
        );
    if (mounted) {
      context.toast(t('history.edited'));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final item = _item;
    if (item == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: ErrorState(onRetry: _load),
      );
    }
    final hh = item.occurredAt.hour.toString().padLeft(2, '0');
    final mi = item.occurredAt.minute.toString().padLeft(2, '0');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('+${formatMoney(item.amount.toDouble())}',
                style: NvType.amount(c, size: 36).copyWith(color: c.success),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            _row(t('detail.date'), '${formatDate(item.occurredAt)} $hh:$mi'),
            _row(t('detail.comment'), item.comment ?? t('detail.no_comment')),
            _row(t('detail.xp'), '+${item.xpEarned} XP'),
            if (item.receiptPath != null && item.receiptPath!.startsWith('file://'))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(item.receiptPath!.replaceFirst('file://', '')),
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            if (item.receiptPath != null &&
                !item.receiptPath!.startsWith('file://'))
              _row(t('detail.receipt'), t('add_money.receipt_attached')),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _edit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(t('common.edit')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _delete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: c.danger,
                      side: BorderSide(color: c.danger),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: Text(t('common.delete')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    final c = ref.watch(appColorsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: NvType.bodySecondary(c)),
          ),
          Expanded(child: Text(value, style: NvType.body(c))),
        ],
      ),
    );
  }
}
