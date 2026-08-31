import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/prices/price_models.dart';

/// ── Tavily web-search integration (user opt-in price source) ────────────
/// The key NEVER touches the SQLCipher DB: store API keys are stored as
/// salted SHA-256 (non-recoverable by design, ⛔ §7.1quin.1), but the scanner
/// must SEND the Tavily key with each request — so it lives in
/// FlutterSecureStorage (Android Keystore), the same lifecycle family as the
/// DB passphrase (§8.3).
///
/// Lifecycle: [hydrate] runs ONCE at splash bootstrap and mirrors the key
/// into memory; [read] is then a pure in-memory lookup — instant and
/// platform-channel-free (in widget tests unmocked platform channels never
/// answer, so awaiting them would hang the scan stream forever). Any
/// Keystore/platform failure degrades to «no key» (offline-first, ⛔ §1).
class TavilyKeyRepository {
  static const _storageKey = 'nv_tavily_key';

  final FlutterSecureStorage _secure = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  String? _cached;
  bool _hydrated = false;

  /// Memory-first read: instant, never touches a platform channel.
  Future<String?> read() async => _cached;

  /// One-time Keystore load (splash bootstrap). Short virtual-time timeout:
  /// on-device reads complete in milliseconds; in widget tests the unmocked
  /// channel would never answer, and only a virtual timer can break the wait.
  Future<void> hydrate() async {
    if (_hydrated) return;
    _hydrated = true;
    try {
      final v = await _secure
          .read(key: _storageKey)
          .timeout(const Duration(milliseconds: 500));
      _cached = (v == null || v.isEmpty) ? null : v;
    } catch (_) {
      _cached = null; // graceful degradation: no key this session
    }
  }

  Future<void> write(String key) async {
    _cached = key; // works immediately, even if the Keystore write fails
    try {
      await _secure.write(key: _storageKey, value: key);
    } catch (_) {
      // Keystore unavailable → session-only key; surfaced via preview.
    }
  }

  Future<void> delete() async {
    _cached = null;
    try {
      await _secure.delete(key: _storageKey);
    } catch (_) {
      // Best effort: the in-memory removal already cut the access.
    }
  }

  /// Masked UI preview — only the last 4 chars are ever shown (⛔ §7.1quin.1).
  Future<String?> preview() async {
    final k = await read();
    if (k == null) return null;
    return '•••• ${k.length >= 4 ? k.substring(k.length - 4) : k}';
  }
}

class TavilyException implements Exception {
  const TavilyException(this.statusCode);
  final int statusCode;
}

class TavilyHit {
  const TavilyHit({
    required this.title,
    required this.url,
    required this.content,
  });

  final String title;
  final String url;
  final String content;
}

/// Thin REST client for https://api.tavily.com/search (dart:io — no extra
/// dependencies). 10-minute in-memory cache: the scanner stream re-yields on
/// ticks and repeated screen opens must not burn API credits.
class TavilyClient {
  TavilyClient({HttpClient? client}) : _client = client ?? HttpClient() {
    _client.connectionTimeout = const Duration(seconds: 10);
  }

  final HttpClient _client;
  static const _timeout = Duration(seconds: 12);
  final Map<String, (DateTime, List<TavilyHit>)> _cache = {};

  Future<List<TavilyHit>> search(
    String query, {
    required String apiKey,
    int maxResults = 10,
  }) async {
    final cached = _cache[query];
    if (cached != null &&
        DateTime.now().difference(cached.$1) < const Duration(minutes: 10)) {
      return cached.$2;
    }
    final req =
        await _client.postUrl(Uri.parse('https://api.tavily.com/search'));
    req.headers.contentType = ContentType.json;
    req.write(jsonEncode(<String, Object?>{
      'api_key': apiKey,
      'query': query,
      'search_depth': 'basic',
      'include_answer': false,
      'max_results': maxResults,
    }));
    final res = await req.close().timeout(_timeout);
    if (res.statusCode != 200) {
      await res.drain<void>().catchError((_) {});
      throw TavilyException(res.statusCode);
    }
    final body = await res.transform(utf8.decoder).join().timeout(_timeout);
    final hits = parseTavilyResponse(body);
    _cache[query] = (DateTime.now(), hits);
    return hits;
  }
}

/// Pure parser — unit-testable without network.
List<TavilyHit> parseTavilyResponse(String body) {
  final json = jsonDecode(body) as Map<String, dynamic>;
  final results = json['results'] as List<dynamic>? ?? const [];
  return [
    for (final r in results.whereType<Map<String, dynamic>>())
      TavilyHit(
        title: (r['title'] as String?) ?? '',
        url: (r['url'] as String?) ?? '',
        content: (r['content'] as String?) ?? '',
      ),
  ];
}

/// Ukrainian price patterns: «24 799 ₴», «24 799 грн», «24799UAH».
final RegExp _priceRegex = RegExp(
  r'(\d{1,3}(?:[ \u00A0]\d{3})+|\d{3,7})[ \u00A0]*(?:₴|грн\.?|гривень|UAH)',
  caseSensitive: false,
);

/// Extracts the first plausible UAH price from a title/snippet.
/// Sanity range 500–250 000 ₴ keeps out footnotes like «3 ₴» or order IDs.
num? extractPrice(String text) {
  for (final m in _priceRegex.allMatches(text)) {
    final digits = m.group(1)!.replaceAll(RegExp(r'[ \u00A0]'), '');
    final value = num.tryParse(digits);
    if (value != null && value >= 500 && value <= 250000) return value;
  }
  return null;
}

String _hostOf(String url) {
  try {
    return Uri.parse(url).host.toLowerCase().replaceFirst('www.', '');
  } on FormatException {
    return '';
  }
}

StoreId storeForHost(String host) {
  if (host.contains('rozetka')) return StoreId.rozetka;
  if (host.contains('foxtrot')) return StoreId.foxtrot;
  if (host.contains('compx')) return StoreId.compx;
  if (host.contains('citrus')) return StoreId.citrus;
  if (host.contains('eldorado')) return StoreId.eldorado;
  return StoreId.other;
}

String prettyStoreName(StoreId id, String host) {
  const known = <StoreId, String>{
    StoreId.rozetka: 'Rozetka',
    StoreId.foxtrot: 'Foxtrot',
    StoreId.compx: 'Compx',
    StoreId.citrus: 'Citrus',
    StoreId.eldorado: 'Eldorado',
  };
  final mapped = known[id];
  if (mapped != null) return mapped;
  if (host.isEmpty) return 'Web';
  final base = host.split('.').first;
  return base.isEmpty ? 'Web' : '${base[0].toUpperCase()}${base.substring(1)}';
}

/// Builds offers from search hits: one per shop host (the highest-score hit
/// wins), the price parsed from the title/snippet. Every offer is explicitly
/// marked third-party + unverified so the UI shows «НЕ ПІДТВЕРДЖЕНО».
List<PriceOffer> offersFromTavilyHits(
  String product,
  List<TavilyHit> hits,
) {
  final now = DateTime.now();
  final seenHosts = <String>{};
  final offers = <PriceOffer>[];
  for (final hit in hits) {
    if (hit.url.isEmpty) continue;
    final host = _hostOf(hit.url);
    if (host.isEmpty || !seenHosts.add(host)) continue;
    final price = extractPrice('${hit.title} ${hit.content}');
    if (price == null) continue;
    final storeId = storeForHost(host);
    offers.add(PriceOffer(
      storeId: storeId,
      storeName: prettyStoreName(storeId, host),
      product: product,
      price: price,
      url: hit.url,
      // ⛔ A search result was never visited — the «Перейти» button stays
      // disabled until the Cloud Function verifies the URL (§7.1bis).
      urlVerified: false,
      checkedAt: now,
      availability: Availability.inStock, // optimistic; corrected later
      warrantyMonths: 0,
      returnDays: 0,
      kit: KitContents.full,
      state: ItemState.newState,
      source: SourceKind.thirdParty,
    ));
  }
  offers.sort((a, b) => a.price.compareTo(b.price)); // cheapest first
  return offers;
}

/// ProductScan from a list of offers. avg30dPrice = current average → the
/// «Вигідно зараз» badge stays OFF: a single snapshot has no honest 30-day
/// baseline (⛔ no fake deal signals).
ProductScan scanFromOffers(String product, List<PriceOffer> offers) {
  final lowest = offers.map((o) => o.price).reduce((a, b) => a < b ? a : b);
  final avg =
      offers.map((o) => o.price).reduce((a, b) => a + b) / offers.length;
  return ProductScan(
    product: product,
    offers: offers,
    lowestPrice: lowest,
    averagePrice: avg,
    avg30dPrice: avg,
    changePercent: 0,
    changeDir: PriceChangeDir.flat,
    scannedAt: DateTime.now(),
    isGoodDealNow: false,
  );
}

final tavilyKeyRepositoryProvider =
    Provider<TavilyKeyRepository>((ref) => TavilyKeyRepository());

final tavilyClientProvider = Provider<TavilyClient>((ref) => TavilyClient());

/// Reactive «key connected» flag (API-status dot, Tavily card).
final tavilyHasKeyProvider = FutureProvider.autoDispose<bool>(
    (ref) async => await ref.watch(tavilyKeyRepositoryProvider).read() != null);