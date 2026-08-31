import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';

/// Active theme colors provider (set by ThemeController).
final appColorsProvider = Provider<AppColors>((ref) {
  return AppColors.from(NvThemeData.cyberpunkNeon);
});

/// Reduce Motion flag (⛔ §9.4 — mandatory accessibility toggle §8.5).
final reduceMotionProvider = StateProvider<bool>((ref) => false);

/// ── NeonCard (§4.4: 16dp radius, border, Breathing UI §4.5.1) ───────────
class NeonCard extends ConsumerStatefulWidget {
  const NeonCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.breathing = false,
    this.borderColor,
    this.accentBorder = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool breathing;
  final Color? borderColor;
  final bool accentBorder;

  @override
  ConsumerState<NeonCard> createState() => _NeonCardState();
}

class _NeonCardState extends ConsumerState<NeonCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _ctrl;

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final reduced = ref.watch(reduceMotionProvider);
    final animate = widget.breathing && !reduced;
    AnimationController? ctrl;
    if (animate) {
      ctrl ??= (_ctrl ??= AnimationController(
        vsync: this,
        duration: kBreathingCycle,
      )..repeat(reverse: true));
    }

    final card = Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(
          color: widget.borderColor ??
              (widget.accentBorder ? c.accent.withOpacity(0.35) : c.border),
        ),
      ),
      // Transparent Material between the decorated container and the child:
      // ListTiles/SwitchListTiles inside cards paint their ink on THIS
      // Material instead of the Scaffold's, otherwise newer Flutter versions
      // assert "ListTile background color or ink splashes may be invisible".
      child: Material(
        type: MaterialType.transparency,
        child: Padding(padding: widget.padding, child: widget.child),
      ),
    );

    if (ctrl == null) return card;
    final active = ctrl;

    return AnimatedBuilder(
      animation: active,
      builder: (context, child) => Opacity(
        opacity: 0.95 + active.value * 0.05, // 0.95 → 1.0, cycle 3s
        child: child,
      ),
      child: card,
    );
  }
}

/// ── FAB «Додати гроші» (§4.4 premium rework: solid champagne gold) ───────
class NeonGradientButton extends ConsumerWidget {
  const NeonGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.accent,
        borderRadius: BorderRadius.circular(kButtonRadius),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: c.background,
          shadowColor: Colors.transparent,
          minimumSize: Size(expanded ? double.infinity : 120, 48),
        ),
      ),
    );
  }
}

/// ── Animated counter (Haptic Typography §4.5.4) ─────────────────────────
class AnimatedCounter extends ConsumerStatefulWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.style,
    this.prefix = '',
    this.suffix = '',
  });

  final num value;
  final TextStyle style;
  final String prefix;
  final String suffix;

  @override
  ConsumerState<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends ConsumerState<AnimatedCounter> {
  num _displayed = 0;

  @override
  void initState() {
    super.initState();
    _displayed = widget.value;
  }

  @override
  void didUpdateWidget(covariant AnimatedCounter old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _displayed = old.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduced = ref.watch(reduceMotionProvider);
    if (reduced || _displayed == widget.value) {
      _displayed = widget.value;
      return Text(
        '${widget.prefix}${formatMoney(widget.value, withSymbol: false)}${widget.suffix}',
        style: widget.style,
      );
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: _displayed.toDouble(), end: widget.value.toDouble()),
      duration: kAnimSlow,
      curve: Curves.easeOutCubic,
      onEnd: () => _displayed = widget.value,
      builder: (context, v, _) => Text(
        '${widget.prefix}${formatMoney(v, withSymbol: false)}${widget.suffix}',
        style: widget.style,
      ),
    );
  }
}

/// ── Progressive Blur (§4.5.5): amounts blurred until revealed ───────────
class BlurAmount extends ConsumerStatefulWidget {
  const BlurAmount({
    super.key,
    required this.text,
    required this.style,
    this.revealed = false,
  });

  final String text;
  final TextStyle style;
  final bool revealed;

  @override
  ConsumerState<BlurAmount> createState() => _BlurAmountState();
}

class _BlurAmountState extends ConsumerState<BlurAmount> {
  @override
  Widget build(BuildContext context) {
    final hidden = !widget.revealed;
    final text = Text(widget.text, style: widget.style);
    if (!hidden) return text;
    return Text(
      widget.text,
      style: widget.style.copyWith(color: Colors.transparent),
    );
  }
}

/// ── Progress bar with champagne gradient (§4.2 premium rework) ──────────
class NeonProgressBar extends ConsumerWidget {
  const NeonProgressBar({super.key, required this.value, this.height = 10});

  final double value; // 0..1
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final reduced = ref.watch(reduceMotionProvider);
    final v = value.clamp(0.0, 1.0);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(color: c.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: v),
          duration: reduced ? Duration.zero : kAnimSlow,
          curve: Curves.easeOutCubic,
          builder: (context, anim, _) => FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: anim,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: NvPalette.progressGradient,
              ),
              child: SizedBox(height: height, width: double.infinity),
            ),
          ),
        ),
      ),
    );
  }
}

/// ── Empty state with themed neon illustration (§8.2, §4.4) ──────────────
class EmptyState extends ConsumerWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.body,
    this.ctaLabel,
    this.onCta,
    this.icon = Icons.lock_outline_rounded,
  });

  final String title;
  final String body;
  final String? ctaLabel;
  final VoidCallback? onCta;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlowIcon(icon: icon, color: c.accent, size: 72),
              const SizedBox(height: 16),
              Text(title, style: NvType.h2(c).copyWith(fontSize: 18),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(body,
                  style: NvType.bodySecondary(c), textAlign: TextAlign.center),
              if (ctaLabel != null) ...[
                const SizedBox(height: 20),
                NeonGradientButton(label: ctaLabel!, onPressed: onCta),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Neon vault outline icon (custom drawn — no emoji).
/// Public: used by empty states, system screens, onboarding.
class GlowIcon extends ConsumerWidget {
  const GlowIcon({super.key, 
    required this.icon,
    required this.color,
    this.size = 64,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduced = ref.watch(reduceMotionProvider);
    Widget glyph = Icon(icon, size: size, color: color);
    if (reduced) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: glyph,
      );
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: kAnimCelebration,
      builder: (context, v, child) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.35 * v + 0.15)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.16 * v),
              blurRadius: 14 * v,
              spreadRadius: 1 * v,
            ),
          ],
        ),
        child: child,
      ),
      child: glyph,
    );
  }
}

/// ── Error state «глюк матриці» (§8.2) ───────────────────────────────────
class ErrorState extends ConsumerWidget {
  const ErrorState({super.key, required this.onRetry, this.message});

  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _GlitchIcon(color: c.danger),
            const SizedBox(height: 16),
            Text(message ?? matrixLabel, style: NvType.h2(c).copyWith(fontSize: 18)),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('retry'),
            ),
          ],
        ),
      ),
    );
  }

  static const matrixLabel = 'errors.matrix';
}

class _GlitchIcon extends ConsumerStatefulWidget {
  const _GlitchIcon({required this.color});
  final Color color;

  @override
  ConsumerState<_GlitchIcon> createState() => _GlitchIconState();
}

class _GlitchIconState extends ConsumerState<_GlitchIcon>
    with SingleTickerProviderStateMixin {
  AnimationController? _ctrl;

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = ref.watch(reduceMotionProvider);
    if (reduced) {
      return Icon(Icons.warning_amber_rounded, size: 72, color: widget.color);
    }
    final ctrl = (_ctrl ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat());
    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) {
        final offset = Offset(
          math.sin(ctrl.value * math.pi * 6) * 2,
          math.cos(ctrl.value * math.pi * 4) * 1.2,
        );
        return Transform.translate(
          offset: offset,
          child: Icon(Icons.warning_amber_rounded, size: 72, color: widget.color),
        );
      },
    );
  }
}

/// ── Skeleton shimmer (§8.2) ─────────────────────────────────────────────
class SkeletonBox extends ConsumerStatefulWidget {
  const SkeletonBox({super.key, this.width, this.height = 16, this.radius});
  final double? width;
  final double height;
  final double? radius;

  @override
  ConsumerState<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends ConsumerState<SkeletonBox>
    with SingleTickerProviderStateMixin {
  AnimationController? _ctrl;

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final ctrl = _ctrl ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) {
        final t = ctrl.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius ?? 8),
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * t, 0),
              end: Alignment(0 + 2 * t, 0),
              colors: [
                c.border.withOpacity(0.25),
                c.border.withOpacity(0.55),
                c.border.withOpacity(0.25),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Generic 4-state wrapper (loading / error / empty / content) — §8.2.
class AsyncValueView<T> extends ConsumerWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.content,
    this.empty,
    this.onRetry,
    this.isEmpty,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) content;
  final Widget? empty;
  final VoidCallback? onRetry;
  final bool Function(T data)? isEmpty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return value.when(
      loading: () => const _LoadingSkeleton(),
      error: (e, st) => ErrorState(onRetry: onRetry ?? () {}),
      data: (data) {
        if (isEmpty != null && isEmpty!(data)) {
          return empty ??
              const EmptyState(
                title: 'common.empty_generic',
                body: '',
              );
        }
        return content(data);
      },
    );
  }
}

class _LoadingSkeleton extends ConsumerWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(height: 44, width: double.infinity),
          SizedBox(height: 12),
          SkeletonBox(height: 120, width: double.infinity, radius: kCardRadius),
          SizedBox(height: 12),
          SkeletonBox(height: 80, width: double.infinity, radius: kCardRadius),
        ],
      ),
    );
  }
}

/// Colored status dot (replaces 🟢🟡🔴 emoji per §6.10 note).
class StatusDot extends ConsumerWidget {
  const StatusDot({super.key, required this.level, this.size = 10});
  final TrustDotLevel level;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final color = switch (level) {
      TrustDotLevel.green => c.success,
      TrustDotLevel.yellow => const Color(0xFFE0C368),
      TrustDotLevel.red => c.danger,
      TrustDotLevel.grey => c.secondary,
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

enum TrustDotLevel { green, yellow, red, grey }

/// Confetti overlay (Victory §5.5, unboxing §6.9) — reduce-motion aware.
class ConfettiBurst extends ConsumerStatefulWidget {
  const ConfettiBurst({super.key, this.pieces = 80});
  final int pieces;

  @override
  ConsumerState<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends ConsumerState<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  AnimationController? _ctrl;

  late final List<_ConfettiPiece> _pieces;
  final _rng = math.Random(7);

  @override
  void initState() {
    super.initState();
    _pieces = List.generate(widget.pieces, (i) {
      final angle = _rng.nextDouble() * math.pi * 2;
      final speed = 0.3 + _rng.nextDouble() * 0.7;
      return _ConfettiPiece(
        dx: math.cos(angle) * speed,
        dy: math.sin(angle) * speed - 0.4,
        color: [
          NvPalette.accentGold,
          NvPalette.goldSoft,
          NvPalette.emerald,
        ][i % 3],
        size: 4 + _rng.nextDouble() * 5,
      );
    });
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = ref.watch(reduceMotionProvider);
    if (reduced) {
      return const SizedBox.shrink(); // static icon shown by caller
    }
    _ctrl ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
    final ctrl = _ctrl!;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: ctrl,
        builder: (context, _) => CustomPaint(
          painter: _ConfettiPainter(_pieces, ctrl.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _ConfettiPiece {
  _ConfettiPiece({
    required this.dx,
    required this.dy,
    required this.color,
    required this.size,
  });
  final double dx;
  final double dy;
  final Color color;
  final double size;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.pieces, this.t);
  final List<_ConfettiPiece> pieces;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.35);
    final paint = Paint();
    for (final p in pieces) {
      final progress = Curves.easeOutQuad.transform(t);
      final pos = Offset(
        center.dx + p.dx * size.width * 0.45 * progress,
        center.dy +
            p.dy * size.height * 0.4 * progress +
            240 * progress * progress, // gravity
      );
      paint.color = p.color.withOpacity((1 - t).clamp(0, 1));
      canvas.drawCircle(pos, p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.t != t;
}

/// Mini confetti for claims (§6.26): cheap, short burst.
class MiniConfetti extends StatelessWidget {
  const MiniConfetti({super.key});
  @override
  Widget build(BuildContext context) => const ConfettiBurst(pieces: 30);
}
