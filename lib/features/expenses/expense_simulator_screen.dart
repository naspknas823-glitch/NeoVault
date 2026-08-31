import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/goal_repository.dart';
import '../../../shared/widgets/widgets.dart';
import '../../../core/utils/format.dart' show tProvider;

class ExpenseSimulatorScreen extends ConsumerStatefulWidget {
  const ExpenseSimulatorScreen({super.key});

  @override
  ConsumerState<ExpenseSimulatorScreen> createState() => _ExpenseSimulatorScreenState();
}

class _ExpenseSimulatorScreenState extends ConsumerState<ExpenseSimulatorScreen> {
  final _amountController = TextEditingController();
  bool _useRoundUp = true;
  bool _useMicroDeposit = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _simulate() async {
    final amountText = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (amountText.isEmpty) return;

    final expense = int.parse(amountText);
    if (expense <= 0) return;

    int deposit = 0;

    // (17) Round-ups: round expense up to nearest 100, deposit the difference.
    if (_useRoundUp) {
      final remainder = expense % 100;
      if (remainder > 0) {
        deposit += (100 - remainder);
      }
    }

    // (18) Micro-deposits: add 5% of the expense.
    if (_useMicroDeposit) {
      deposit += (expense * 0.05).round();
    }

    if (deposit > 0) {
      final repo = ref.read(goalRepositoryProvider);
      await repo.addContribution(
        amount: deposit,
        comment: 'Expense-tied savings (expense: $expense ₴)',
      );

      if (mounted) {
        final accent = ref.read(appColorsProvider).accent;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Simulated expense! Auto-deposited $deposit ₴.'),
            backgroundColor: accent,
          ),
        );
        context.pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No deposit calculated. Change settings or amount.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('expenses.simulator_title', {'default': 'Expense Simulator'}))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              t('expenses.simulator_hint', {'default': 'Enter a simulated expense amount (e.g., buying coffee).'}),
              style: TextStyle(fontSize: 16, color: c.secondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: c.text),
              decoration: InputDecoration(
                labelText: t('expenses.expense_label', {'default': 'Expense Amount (₴)'}),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: Text(t('expenses.roundup_title', {'default': 'Enable Round-ups (17)'}),
                  style: TextStyle(color: c.text)),
              subtitle: Text(
                  t('expenses.roundup_desc',
                      {'default': 'Rounds expense to nearest 100 ₴ and deposits the difference.'}),
                  style: TextStyle(color: c.secondary)),
              value: _useRoundUp,
              activeThumbColor: c.accent,
              onChanged: (val) => setState(() => _useRoundUp = val),
            ),
            SwitchListTile(
              title: Text(t('expenses.micro_title', {'default': 'Enable Micro-deposits (18)'}),
                  style: TextStyle(color: c.text)),
              subtitle: Text(
                  t('expenses.micro_desc', {'default': 'Deposits 5% of the expense amount.'}),
                  style: TextStyle(color: c.secondary)),
              value: _useMicroDeposit,
              activeThumbColor: c.accent,
              onChanged: (val) => setState(() => _useMicroDeposit = val),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _simulate,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                t('expenses.simulate_btn', {'default': 'Simulate Transaction'}),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
