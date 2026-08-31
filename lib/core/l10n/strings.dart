import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Lightweight JSON-based l10n per spec §8.4.
/// Locales: UA (default) + EN. Format: `1 234,56 ₴`, dates `DD.MM.YYYY`.
class NvStrings {
  NvStrings._(this.localeCode, Map<String, String> flat) : _flat = flat;

  final String localeCode;
  final Map<String, String> _flat;

  static const String ua = 'uk';
  static const String en = 'en';

  /// Main translate function with {placeholder} interpolation.
  String t(String key, [Map<String, Object?> params = const {}]) {
    var s = _flat[key] ?? key;
    params.forEach((k, v) {
      s = s.replaceAll('{$k}', '$v');
    });
    return s;
  }

  static Future<NvStrings> load(String localeCode) async {
    final code = (localeCode.toLowerCase().startsWith('uk')) ? ua : en;
    final raw = await rootBundle.loadString('assets/l10n/$code.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final flat = <String, String>{};
    void walk(Map<String, dynamic> node, String prefix) {
      node.forEach((k, v) {
        final key = prefix.isEmpty ? k : '$prefix.$k';
        if (v is Map<String, dynamic>) {
          walk(v, key);
        } else {
          flat[key] = v.toString();
        }
      });
    }

    walk(json, '');
    return NvStrings._(code, flat);
  }

  /// All keys (used by the parity test).
  Set<String> keys() => _flat.keys.toSet();

  /// Synchronous fallback used before async load completes (rare).
  static NvStrings loadSyncDefault() {
    final s = NvStrings._(ua, <String, String>{});
    return s;
  }

  static Future<Set<String>> keysOf(String localeCode) async {
    final s = await load(localeCode);
    return s.keys();
  }
}
