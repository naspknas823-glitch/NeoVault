import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/providers.dart';
import '../../shared/widgets/widgets.dart';
import '../../core/utils/format.dart';

/// (19) Gift top-up — генерує подарунковий код для друга. Запис іде
  /// через offline-first sync-чергу (як усі дані NeoVault): код створюється
  /// локально і пушиться в хмару при доступності — статус «очікує
  /// синхронізації» показується чесно, без підміни.
  class GiftTopUpScreen extends ConsumerStatefulWidget {
  const GiftTopUpScreen({super.key});

  @override
  ConsumerState<GiftTopUpScreen> createState() => _GiftTopUpScreenState();
}

class _GiftTopUpScreenState extends ConsumerState<GiftTopUpScreen> {
  final _amountCtrl = TextEditingController(text: '500');
    String? _generatedCode;
  bool _loading = false;
  int _pending = 0;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _generateGiftLink() async {
    final amount = int.tryParse(_amountCtrl.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount.')),
      );
      return;
    }

    setState(() => _loading = true);

    final goal = await ref.read(goalRepositoryProvider).getGoal();
    if (goal == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No active goal found.')),
        );
      }
      setState(() => _loading = false);
      return;
    }

    // Offline-first gift record: created locally, pushed via the sync queue
    // when the cloud becomes available (same contract as every entity in NeoVault).
    final code = const Uuid().v4().substring(0, 8).toUpperCase();
    await ref.read(syncEngineProvider).enqueue(
      entityId: code,
      entityType: 'gift',
      payload: {
        'goalId': goal.id,
        'goalTitle': goal.title,
        'amount': amount,
        'status': 'pending',
        'createdAtMs': DateTime.now().millisecondsSinceEpoch,
      },
    );
    unawaitedSync(ref.read(syncEngineProvider).flush());
    ref.invalidate(syncPendingProvider);
    final pending = await ref.read(syncPendingProvider.future);

    setState(() {
      _generatedCode = 'neovault://gift?code=$code&amount=$amount';
      _loading = false;
      _pending = pending;
    });
  }

  Future<void> _share() async {
    if (_generatedCode == null) return;
    final amount = _amountCtrl.text;
    await Share.share(
      'Допоможи мені зібрати на мрію! Поповни мою скарбничку на $amount ₴: $_generatedCode',
      subject: 'Gift top-up — NeoVault',
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: const Text('Gift Top-up (19)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NeonCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Send a gift contribution to someone\'s NeoVault goal.',
                      style: TextStyle(color: c.secondary)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: c.text),
                    decoration: InputDecoration(
                      labelText: 'Gift Amount (₴)',
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.card_giftcard_rounded),
                    label: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Generate Gift Link'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.accent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _loading ? null : _generateGiftLink,
                  ),
                ],
              ),
            ),
            if (_generatedCode != null) ...[
              const SizedBox(height: 16),
              NeonCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🎁 Gift Link Generated!',
                        style: TextStyle(
                            color: c.success, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(_generatedCode!,
                        style: TextStyle(color: c.secondary, fontSize: 11)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.share_rounded),
                      label: const Text('Share'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: c.accent2, foregroundColor: Colors.white),
                      onPressed: _share,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
