import 'package:flutter/material.dart';
import '../../core/utils/format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart' show ApiKey;
import '../../core/theme/app_theme.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/scanner_repositories.dart';
import '../../data/repositories/tavily_repository.dart';
import '../../data/repositories/ui_providers.dart';
import '../pin/pin_screens.dart' show showProtectedActionGate;
import '../../shared/widgets/widgets.dart';

/// 6.33 API Settings (§7.1quin): API list (name, masked key, status,
/// last-ok, last-error), add form, test button, edit/delete — ⛔ only after
/// PIN/biometrics confirmation. Keys stored hashed, never plain.
class ApiSettingsScreen extends ConsumerStatefulWidget {
  const ApiSettingsScreen({super.key});

  @override
  ConsumerState<ApiSettingsScreen> createState() => _ApiSettingsScreenState();
}

class _ApiSettingsScreenState extends ConsumerState<ApiSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('api_settings');
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final keys = ref.watch(apiKeysProvider).valueOrNull ?? const [];

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('api.title'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t('api.subtitle'), style: NvType.bodySecondary(c)),
          const SizedBox(height: 12),
          const _TavilyCard(),
          const SizedBox(height: 12),
          for (final key in keys) _ApiKeyCard(row: key),
          const SizedBox(height: 12),
          NeonGradientButton(
            label: t('api.add'),
            icon: Icons.add_rounded,
            onPressed: () => _form(context, ref),
          ),
          const SizedBox(height: 16),
          Text(t('api.gate_body'), style: NvType.caption(c)),
        ],
      ),
    );
  }

  Future<void> _form(BuildContext context, WidgetRef ref,
      {ApiKey? existing}) async {
    final t = ref.read(tProvider);
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final keyCtrl = TextEditingController();
    final storeCtrl = TextEditingController(text: existing?.storeId ?? 'rozetka');
    final notesCtrl = TextEditingController(text: existing?.notes ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? t('api.add') : t('api.edit')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: t('api.form_name')),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: keyCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: t('api.form_key'),
                  helperText: t('api.form_key_hint'),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: storeCtrl.text,
                items: [
                  for (final s in const ['rozetka', 'foxtrot', 'compx', 'citrus', 'eldorado'])
                    DropdownMenuItem(value: s, child: Text(s)),
                ],
                onChanged: (v) => storeCtrl.text = v ?? 'rozetka',
                decoration: InputDecoration(labelText: t('api.form_store')),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: notesCtrl,
                decoration: InputDecoration(labelText: t('api.form_notes')),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t('common.cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t('common.save')),
          ),
        ],
      ),
    );
    if (saved != true) return;

    final valid = nameCtrl.text.trim().isNotEmpty &&
        (existing != null || keyCtrl.text.trim().isNotEmpty) &&
        storeCtrl.text.trim().isNotEmpty;
    if (!valid) {
      if (context.mounted) context.toast(t('api.form_invalid'));
      return;
    }
    final repo = ref.read(apiKeysRepositoryProvider);
    if (existing == null) {
      await repo.add(
        name: nameCtrl.text.trim(),
        key: keyCtrl.text.trim(),
        storeId: storeCtrl.text.trim(),
        notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
      );
    } else {
      // ⛔ Редагування ключа — тільки після PIN/біометрії (§7.1quin.10).
      if (!context.mounted) return;
      final gateOk = await showProtectedActionGate(context, ref);
      if (!gateOk || !context.mounted) return;
      await repo.updateKey(
        id: existing.id,
        name: nameCtrl.text.trim(),
        key: keyCtrl.text.trim().isEmpty ? null : keyCtrl.text.trim(),
        storeId: storeCtrl.text.trim(),
        notes: notesCtrl.text.trim(),
      );
    }
    if (context.mounted) context.toast(t('api.saved'));
  }
}

class _ApiKeyCard extends ConsumerWidget {
  const _ApiKeyCard({required this.row});
  final ApiKey row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final statusLevel = switch (row.status) {
      'connected' => TrustDotLevel.green,
      'error' => TrustDotLevel.red,
      _ => TrustDotLevel.grey,
    };
    final lastOk = row.lastOkAt == null
        ? t('api.never')
        : formatDateTime(DateTime.fromMillisecondsSinceEpoch(row.lastOkAt!));

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: NeonCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StatusDot(level: statusLevel),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('${row.name} (${row.storeId})',
                      style: NvType.button(c)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // ⛔ Key shown ONLY as mask (§7.1quin.3).
            Text('${t('api.key_hidden')}: ${t('api.key_mask')}',
                style: NvType.caption(c)),
            Text('${t('api.last_ok')}: $lastOk', style: NvType.caption(c)),
            if (row.lastError != null)
              Text('${t('api.last_error')}: ${row.lastError}',
                  style: NvType.caption(c).copyWith(color: c.danger)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    final result =
                        await ref.read(apiKeysRepositoryProvider).test(row.id);
                    if (context.mounted) {
                      context.toast(
                          result.ok ? t('api.test_ok') : t(result.errorKey!));
                    }
                  },
                  child: Text(t('api.test'),
                      style: const TextStyle(fontSize: 12)),
                ),
                OutlinedButton(
                  onPressed: () {
                    // Edit — protected (same screen dialog handles gate).
                    // We route through the form with existing data.
                    _editFlow(context, ref);
                  },
                  child: Text(t('api.edit'),
                      style: const TextStyle(fontSize: 12)),
                ),
                OutlinedButton(
                  onPressed: () => _deleteFlow(context, ref),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: c.danger,
                    side: BorderSide(color: c.danger),
                  ),
                  child: Text(t('common.delete'),
                      style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editFlow(BuildContext context, WidgetRef ref) async {
    // ⛔ Захищена дія: PIN/біометрія перед зміною ключа (§7.1quin.10).
    final ok = await showProtectedActionGate(context, ref);
    if (!ok || !context.mounted) return;
    // Reuse the add-form with prefilled data.
    if (context.mounted) {
      await _openForm(context, ref);
    }
  }

  Future<void> _openForm(BuildContext context, WidgetRef ref) async {
    final t = ref.read(tProvider);
    final nameCtrl = TextEditingController(text: row.name);
    final keyCtrl = TextEditingController();
    final storeCtrl = TextEditingController(text: row.storeId);
    final notesCtrl = TextEditingController(text: row.notes ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t('api.edit')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: t('api.form_name'))),
            TextField(
              controller: keyCtrl,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: t('api.form_key'),
                  helperText: t('api.form_key_hint')),
            ),
            TextField(
                controller: storeCtrl,
                decoration: InputDecoration(labelText: t('api.form_store'))),
            TextField(
                controller: notesCtrl,
                decoration: InputDecoration(labelText: t('api.form_notes'))),
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
    await ref.read(apiKeysRepositoryProvider).updateKey(
          id: row.id,
          name: nameCtrl.text.trim(),
          key: keyCtrl.text.trim().isEmpty ? null : keyCtrl.text.trim(),
          storeId: storeCtrl.text.trim(),
          notes: notesCtrl.text.trim(),
        );
    if (context.mounted) context.toast(t('api.saved'));
  }

  Future<void> _deleteFlow(BuildContext context, WidgetRef ref) async {
    final t = ref.read(tProvider);
    // ⛔ Видалення ключа — тільки після PIN/біометрії (§7.1quin.10).
    final gateOk = await showProtectedActionGate(context, ref);
    if (!gateOk || !context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t('api.delete_q')),
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
    if (confirmed == true) {
      await ref.read(apiKeysRepositoryProvider).delete(row.id);
      if (context.mounted) context.toast(t('api.deleted'));
    }
  }
}

/// ── Tavily Search card (user opt-in web-price source) ───────────────────
/// The key is stored in FlutterSecureStorage (Android Keystore) — it must be
/// SENT with every search, unlike store keys (salted hash, never recovered).
/// Save/delete are protected actions (⛔ §7.1quin.10). Only the last 4 chars
/// are ever shown.
class _TavilyCard extends ConsumerStatefulWidget {
  const _TavilyCard();

  @override
  ConsumerState<_TavilyCard> createState() => _TavilyCardState();
}

class _TavilyCardState extends ConsumerState<_TavilyCard> {
  String? _preview;
  bool _busy = false;
  final _keyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _keyCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final p = await ref.read(tavilyKeyRepositoryProvider).preview();
    if (mounted) setState(() => _preview = p);
  }

  Future<void> _save() async {
    final t = ref.read(tProvider);
    final key = _keyCtrl.text.trim();
    if (key.length < 16) {
      if (mounted) context.toast(t('api.tavily_invalid'));
      return;
    }
    // ⛔ Protected action: PIN/biometrics first (§7.1quin.10).
    final gateOk = await showProtectedActionGate(context, ref);
    if (!gateOk || !mounted) return;
    setState(() => _busy = true);
    await ref.read(tavilyKeyRepositoryProvider).write(key);
    _keyCtrl.clear();
    ref.invalidate(tavilyHasKeyProvider);
    await _load();
    if (mounted) {
      setState(() => _busy = false);
      context.toast(t('api.tavily_saved'));
    }
  }

  Future<void> _remove() async {
    final t = ref.read(tProvider);
    // ⛔ Protected action: PIN/biometrics first (§7.1quin.10).
    final gateOk = await showProtectedActionGate(context, ref);
    if (!gateOk || !mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t('api.delete_q')),
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
    if (confirmed != true || !mounted) return;
    await ref.read(tavilyKeyRepositoryProvider).delete();
    ref.invalidate(tavilyHasKeyProvider);
    await _load();
    if (mounted) context.toast(t('api.tavily_removed'));
  }

  Future<void> _test() async {
    final t = ref.read(tProvider);
    setState(() => _busy = true);
    String message;
    try {
      final key = await ref.read(tavilyKeyRepositoryProvider).read();
      if (key == null) throw const TavilyException(0);
      final hits = await ref
          .read(tavilyClientProvider)
          .search('PS5 ціна Україна', apiKey: key, maxResults: 1);
      message = hits.isEmpty ? t('api.tavily_test_fail') : t('api.tavily_test_ok');
    } on TavilyException catch (e) {
      message = (e.statusCode == 401 || e.statusCode == 403)
          ? t('api.tavily_test_401')
          : t('api.tavily_test_fail');
    } on Exception {
      message = t('api.tavily_test_fail');
    }
    if (mounted) {
      setState(() => _busy = false);
      context.toast(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final connected = _preview != null;
    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.travel_explore_rounded, size: 20, color: c.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(t('api.tavily_title'), style: NvType.button(c)),
              ),
              StatusDot(
                  level:
                      connected ? TrustDotLevel.green : TrustDotLevel.grey),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            connected
                ? t('api.tavily_subtitle_set', {'preview': _preview!})
                : t('api.tavily_subtitle_unset'),
            style: NvType.caption(c),
          ),
          const SizedBox(height: 8),
          if (!connected) ...[
            TextField(
              controller: _keyCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: t('api.tavily_enter'),
                helperText: t('api.tavily_note'),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _busy ? null : _save,
              icon: const Icon(Icons.key_rounded, size: 18),
              label: Text(t('api.tavily_save')),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _busy ? null : _test,
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: Text(t('api.tavily_test')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _busy ? null : _remove,
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: Text(t('common.delete')),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
