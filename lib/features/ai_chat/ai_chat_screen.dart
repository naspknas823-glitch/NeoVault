import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/system_repositories.dart';
import '../../data/repositories/ui_providers.dart';
import '../../core/db/app_database.dart' show ChatMessage;
import '../../domain/ai/ai_engine.dart' hide ChatMessage;
import '../../shared/widgets/widgets.dart';

/// 6.8 AI Guardian (§6.8): animated neon character, 3 mode tabs (Advisor /
/// Guardian / Motivator), chat bubbles, daily limits 100/20 ⛔, offline
/// fallback presets + indicator.
class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen>
    with SingleTickerProviderStateMixin {
  AiMode _mode = AiMode.advisor;
  final _inputCtrl = TextEditingController();
  late final AnimationController _charCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('ai');
    });
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _charCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    final t = ref.read(tProvider);
    final messenger = ScaffoldMessenger.of(context);
    _inputCtrl.clear();
    try {
      await ref.read(aiRepositoryProvider).send(mode: _mode, text: text);
    } on AiLimitReached {
      final usage = await ref.read(aiRepositoryProvider).usage();
      messenger.showSnackBar(SnackBar(
        content: Text(
          usage.limit == AiEngine.limitGuest
              ? t('ai.limit_reached_guest')
              : t('ai.limit_reached'),
        ),
      ));
    }
    ref.read(aiTickProvider.notifier).state++;
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final messages = ref.watch(chatMessagesProvider);
    final usage = ref.watch(aiUsageProvider).valueOrNull;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(t('ai.title')),
        actions: [
          if (usage != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  t('ai.limit_left', {'n': usage.left}),
                  style: NvType.caption(c),
                ),
              ),
            ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
          // Animated neon character (§6.8) — alive when replying.
          _GuardianAvatar(ctrl: _charCtrl, accent: c.accent),
          // Mode tabs.
          TabBar(
            tabs: [
              Tab(text: t('ai.mode_advisor')),
              Tab(text: t('ai.mode_guardian')),
              Tab(text: t('ai.mode_motivator')),
            ],
            onTap: (i) => setState(
                () => _mode = AiMode.values[i]),
          ),
          Expanded(
            child: AsyncValueView<List<ChatMessage>>(
              value: messages,
              content: (list) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                reverse: false,
                itemBuilder: (context, i) => _Bubble(
                  message: list[i],
                  accent: c.accent,
                ),
              ),
            ),
          ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _inputCtrl,
                        decoration: InputDecoration(
                          hintText: t('ai.input_hint'),
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _send,
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuardianAvatar extends ConsumerWidget {
  const _GuardianAvatar({required this.ctrl, required this.accent});
  final AnimationController ctrl;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduced = ref.watch(reduceMotionProvider);
    if (reduced) {
      return Icon(Icons.shield_moon_rounded, size: 48, color: accent);
    }
    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) {
        final breath = 1 + ctrl.value * 0.06;
        return Transform.scale(
          scale: breath,
          child: Container(
            width: 56,
            height: 56,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: accent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: accent.withOpacity(0.3 + ctrl.value * 0.2),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Icon(Icons.shield_moon_rounded, size: 30, color: accent),
          ),
        );
      },
    );
  }
}

class _Bubble extends ConsumerWidget {
  const _Bubble({required this.message, required this.accent});
  final ChatMessage message;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isUser ? accent.withOpacity(0.16) : c.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: Border.all(
            color: isUser ? accent : c.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.content, style: NvType.body(c)),
            if (!isUser && message.fromFallback)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const StatusDot(level: TrustDotLevel.yellow),
                    const SizedBox(width: 4),
                    Text(t('ai.offline_mode'), style: NvType.caption(c)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Mode names helper for tests.
String aiModeName(AiMode m) => m.name;
