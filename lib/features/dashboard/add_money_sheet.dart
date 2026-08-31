import 'package:flutter/material.dart';
import '../../shared/widgets/motion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/retention_repositories.dart';
import '../../data/repositories/system_repositories.dart';
import '../../domain/quests/quest_engine.dart';
import '../../shared/widgets/widgets.dart';

import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Result surfaced to the caller (XP toast + victory routing).
class AddMoneyOutcome {
  const AddMoneyOutcome({required this.result, required this.amount});
  final ContributionResult result;
  final int amount;
}

Future<AddMoneyOutcome?> showAddMoneySheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<AddMoneyOutcome>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(kSheetRadius)),
    ),
    builder: (_) => const _AddMoneySheet(),
  );
}

/// 6.4 Add Money (§6.4): amount keypad, date, comment, quick sums, receipt,
/// ⛔ SINGLE confirmation — saved immediately; success pipeline: checkmark
/// animation + coin sound + haptic + animated counter + XP toast + background
/// achievement/level/streak checks.
class _AddMoneySheet extends ConsumerStatefulWidget {
  const _AddMoneySheet();

  @override
  ConsumerState<_AddMoneySheet> createState() => _AddMoneySheetState();
}

class _AddMoneySheetState extends ConsumerState<_AddMoneySheet> {
  final _amountCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  String? _receiptPath;
  bool _saving = false;
  bool _saved = false;
  String? _error;
  ContributionResult? _result;

  static const quickAmounts = [500, 1000, 2000, 5000];

  @override
  void dispose() {
    _amountCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _scanReceipt([ImageSource source = ImageSource.gallery]) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: source);
      if (file == null) return;
      
      final inputImage = InputImage.fromFilePath(file.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      double maxVal = 0;
      final regex = RegExp(r'\d+[.,]\d{2}');
      for (var block in recognizedText.blocks) {
        final matches = regex.allMatches(block.text);
        for (var m in matches) {
          final val = double.tryParse(m.group(0)!.replaceAll(',', '.')) ?? 0;
          if (val > maxVal) maxVal = val;
        }
      }
      
      if (maxVal > 0) {
        setState(() {
          _amountCtrl.text = maxVal.toInt().toString();
          _receiptPath = file.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Scanned total: $maxVal ₴')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not find amount on receipt')));
        }
      }
      textRecognizer.close();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Scan failed: $e')));
      }
    }
  }

  Future<void> _listenVoice() async {
    try {
      final stt = SpeechToText();
      final available = await stt.initialize();
      if (available) {
        stt.listen(onResult: (result) {
           final text = result.recognizedWords;
           final regex = RegExp(r'\d+');
           final match = regex.firstMatch(text);
           if (match != null && mounted) {
              setState(() {
                 _amountCtrl.text = match.group(0)!;
              });
           }
           if (result.finalResult && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Heard: $text')));
           }
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Speech recognition not available.')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Voice failed: $e')));
      }
    }
  }

  Future<void> _save() async {
    final t = ref.read(tProvider);
    final amount = int.tryParse(_amountCtrl.text) ?? 0;
    if (amount <= 0) {
      setState(() => _error = t('add_money.invalid_amount'));
      return;
    }
    if (_date.isAfter(DateTime.now().add(const Duration(minutes: 1)))) {
      setState(() => _error = t('add_money.invalid_date'));
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    final goals = ref.read(goalRepositoryProvider);
    final result = await goals.addContribution(
      amount: amount,
      occurredAt: _date,
      comment: _commentCtrl.text.trim().isEmpty ? null : _commentCtrl.text.trim(),
      receiptPath: _receiptPath,
    );

    // Retention quests: main daily quest (§10.2) + event quests.
    await ref.read(questRepositoryProvider).track(QuestType.addContribution);
    final event = await ref.read(eventsRepositoryProvider).activeEvent();
    if (event != null) {
      await ref
          .read(eventsRepositoryProvider)
          .advanceEventQuest(event.id, QuestType.addContribution);
    }

    // In-app notification (§7.3) — never blocked by DnD (⛔ 12.5).
    await ref.read(notificationsRepositoryProvider).pushInApp(
          type: NotifType.contrib,
          titleKey: 'notifications.contrib_added',
          bodyKey: 'notifications.contrib_added_body',
          bodyParams: {'xp': result.xp},
        );

    setState(() {
      _saving = false;
      _saved = true;
      _result = result;
    });
    // Coin sound + double-tick haptic (§4.6/§4.7) bind here (device only).
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 4,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: _saved
          ? _successView(c, t)
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(t('add_money.title'), style: NvType.h2(c)),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountCtrl,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: NvType.amount(c, size: 40),
                  decoration: InputDecoration(
                    hintText: t('add_money.amount_hint'), 
                    suffixText: '₴',
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.document_scanner_rounded),
                          tooltip: 'Scan Receipt (16)',
                          onPressed: _scanReceipt,
                        ),
                        IconButton(
                          icon: const Icon(Icons.mic_rounded),
                          tooltip: 'Voice Assistant (36)',
                          onPressed: _listenVoice,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final a in quickAmounts)
                      ActionChip(
                        label: Text('$a ₴'),
                        onPressed: () => _amountCtrl.text = '$a',
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (d != null) setState(() => _date = d);
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: t('add_money.date'),
                            prefixIcon: const Icon(Icons.calendar_today_rounded),
                          ),
                          child: Text(formatDate(_date)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _QuickPhraseChips(
                  onPick: (p) => setState(() => _commentCtrl.text = p),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _commentCtrl,
                  decoration: InputDecoration(
                    labelText: t('add_money.comment'),
                    hintText: t('add_money.comment_hint'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _scanReceipt(ImageSource.camera),
                      icon: const Icon(Icons.photo_camera_outlined, size: 18),
                      label: Text(t('add_money.receipt_add_camera')),
                    ),
                    const SizedBox(width: 8),
                    if (_receiptPath != null)
                      Icon(Icons.check_circle_rounded,
                          size: 18, color: c.success),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!, style: NvType.caption(c).copyWith(color: c.danger)),
                ],
                const SizedBox(height: 16),
                NeonGradientButton(
                  label: _saving ? t('common.loading') : t('add_money.confirm'),
                  icon: Icons.savings_rounded,
                  onPressed: _saving ? null : _save,
                ),
              ],
            ),
    );
  }

  Widget _successView(AppColors c, String Function(String, [Map<String, Object?>]) t) {
    final result = _result!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            const MiniConfetti(),
            Column(
              children: [
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: NvMotion.celebration,
                  curve: Curves.elasticOut,
                  builder: (context, v, _) => Transform.scale(
                    scale: ref.watch(reduceMotionProvider) ? 1 : v,
                    child: Icon(Icons.check_circle_rounded,
                        size: 64, color: c.success),
                  ),
                ),
                const SizedBox(height: 8),
                Text(t('add_money.success'), style: NvType.h2(c)),
                Text(
                  t('add_money.xp_toast', {'n': result.xp}),
                  style: NvType.h2(c).copyWith(color: c.accent),
                ),
                if (result.leveledUp) ...[
                  const SizedBox(height: 4),
                  Text(
                    t('notifications.level_up_body',
                        {'n': result.newLevel, 'rank': result.rank.name}),
                    style: NvType.body(c).copyWith(color: c.success),
                  ),
                ],
                for (final ach in result.newAchievements)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${t('achievements.unlocked_title')}: ${ach.name} (+${ach.bonusXp} XP)',
                      style: NvType.body(c).copyWith(color: c.accent2),
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        NeonGradientButton(
          label: t('common.done'),
          onPressed: () {
            final res = _result!;
            final amount = int.tryParse(_amountCtrl.text) ?? 0;
            Navigator.of(context).pop(AddMoneyOutcome(result: res, amount: amount));
          },
        ),
      ],
    );
  }
}

/// (27) Quick-phrase chips in the comment field — a tap fills the comment so
/// the user doesn't type the same thing every time.
class _QuickPhraseChips extends ConsumerWidget {
  const _QuickPhraseChips({required this.onPick});
  final void Function(String) onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final phrases =
        ref.watch(quickPhrasesProvider).valueOrNull ?? const <String>[];
    if (phrases.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final p in phrases)
          ActionChip(
            label: Text(p, style: NvType.caption(c)),
            backgroundColor: c.surface,
            onPressed: () => onPick(p),
          ),
      ],
    );
  }
}
