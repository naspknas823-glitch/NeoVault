import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/widgets.dart';

/// (35) AR «Room Preview» — the closest honest native analogue: the user
/// takes a real photo of their room and drags/scales an overlay of the target
/// setup (PS5 Slim + 4K monitor) around it. True ARKit/ARCore anchor-based
/// placement is not shipped in this build, so this photo-augmented preview
/// keeps the feature's core intent without fake 3D.
class RoomPreviewScreen extends ConsumerStatefulWidget {
  const RoomPreviewScreen({super.key});

  @override
  ConsumerState<RoomPreviewScreen> createState() => _RoomPreviewScreenState();
}

class _RoomPreviewScreenState extends ConsumerState<RoomPreviewScreen> {
  XFile? _photo;
  Offset _pos = const Offset(60, 120);
  double _scale = 1.0;

  Future<void> _pick(ImageSource source) async {
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 2160,
        imageQuality: 85,
      );
      if (file == null) return;
      setState(() => _photo = file);
    } catch (e) {
      debugPrint('NV room preview pick failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Photo error: $e')),
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
      appBar: AppBar(title: Text(t('preview.title'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              t('preview.note'),
              style: NvType.caption(c),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kCardRadius),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = constraints.biggest;
                    return GestureDetector(
                      onPanUpdate: (d) {
                        setState(() {
                          _pos = Offset(
                            (_pos.dx + d.delta.dx)
                                .clamp(0, size.width - 40),
                            (_pos.dy + d.delta.dy)
                                .clamp(0, size.height - 60),
                          );
                        });
                      },
                      child: Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Positioned.fill(
                            child: _photo != null
                                ? Image.file(File(_photo!.path),
                                    fit: BoxFit.cover)
                                : Container(
                                    color: c.surface,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                            Icons
                                                .photo_camera_front_rounded,
                                            size: 56,
                                            color: c.secondary),
                                        const SizedBox(height: 12),
                                        Text(
                                          t('preview.no_photo'),
                                          style: NvType.bodySecondary(c),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: size.height * 0.28,
                            child: Container(
                              height: 1,
                              color: c.accent.withValues(alpha: 0.35),
                            ),
                          ),
                          Positioned(
                            left: _pos.dx,
                            top: _pos.dy,
                            child: Transform.scale(
                              scale: _scale,
                              child: _SetupOverlay(c: c, t: t),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pick(ImageSource.camera),
                        icon: const Icon(Icons.photo_camera_outlined,
                            size: 18),
                        label: Text(t('preview.take')),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pick(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library_outlined,
                            size: 18),
                        label: Text(t('preview.gallery')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(t('preview.scale'), style: NvType.caption(c)),
                    Expanded(
                      child: Slider(
                        value: _scale,
                        min: 0.4,
                        max: 2.2,
                        activeColor: c.accent,
                        onChanged: (v) => setState(() => _scale = v),
                      ),
                    ),
                    Text('${_scale.toStringAsFixed(1)}×',
                        style: NvType.caption(c)),
                  ],
                ),
                Text(t('preview.hint'),
                    style: NvType.caption(c), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The setup silhouette: monitor on top, PS5 below — simple geo shapes so it
/// works everywhere without shipping 3D assets.
class _SetupOverlay extends StatelessWidget {
  const _SetupOverlay({required this.c, required this.t});
  final AppColors c;
  final String Function(String, [Map<String, Object?>]) t;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 92,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: c.accent, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(t('preview.monitor'),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: c.accent,
                )),
          ),
        ),
        Container(width: 26, height: 22, color: Colors.black45),
        Container(
          width: 74,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.accent, width: 1.5),
          ),
          child: Center(
            child: Text(t('preview.ps5'),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: c.accent,
                )),
          ),
        ),
      ],
    );
  }
}