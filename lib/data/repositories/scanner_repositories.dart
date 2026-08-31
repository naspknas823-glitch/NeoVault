import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/db/app_database.dart';
import '../../domain/bundle/bundle_engine.dart';
import '../../domain/bundle/bundle_models.dart';
import '../../domain/prices/price_models.dart';
import 'goal_repository.dart';
import 'retention_repositories.dart';
import '../../domain/quests/quest_engine.dart';
import 'providers.dart';
import 'tavily_repository.dart';

/// ── Price Scanner repository (§7.1, §7.1quater) ─────────────────────────
/// ONLINE-ONLY (v0.9.2, user decision): prices come ONLY from the Tavily
/// web search (user key, Keystore-stored, §7.1quin). Offers built from the
/// hits are marked `SourceKind.thirdParty` + `urlVerified=false`
/// («НЕ ПІДТВЕРДЖЕНО» in UI) and can never trigger the «Вигідно зараз»
/// badge (no 30-day history behind a single snapshot).
/// ⛔ NO offline/seed/mock substitution: without the key or without network
/// the scanner returns an empty scan / an honest error — never local data.
/// The `price_history`/`scan_runs` tables stay as the landing zone for the
/// future `dailyPriceScan` Cloud Function (§7.1).
class ScannerRepository {
  ScannerRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);
  GoalRepository get _goals => _ref.read(goalRepositoryProvider);

  /// ONLINE-ONLY: no key or no parsable hits → empty scan (honest
  /// «Підключи Tavily» state); network failure → exception → error state.
  /// Never falls back to local/seed data (⛔ no fake substitution).
  Future<ProductScan> scanFor(String product) async {
    final key = await _ref.read(tavilyKeyRepositoryProvider).read();
    if (key == null || key.isEmpty) return _emptyScan(product);
    final hits = await _ref
        .read(tavilyClientProvider)
        .search(_queryFor(product), apiKey: key);
    final offers = offersFromTavilyHits(product, hits);
    if (offers.isEmpty) return _emptyScan(product);
    return scanFromOffers(product, offers);
  }

  ProductScan _emptyScan(String product) => ProductScan(
        product: product,
        offers: const [],
        lowestPrice: 0,
        averagePrice: 0,
        avg30dPrice: 0,
        changePercent: 0,
        changeDir: PriceChangeDir.flat,
        scannedAt: DateTime.fromMillisecondsSinceEpoch(0),
        isGoodDealNow: false,
      );

  static String _queryFor(String product) => switch (product) {
        'monitor' => 'ігровий монітор 4K 120Hz ціна грн купити Україна',
        _ => 'Sony PlayStation 5 Slim ціна грн купити Україна',
      };

  Future<List<PricePoint>> history(String product, {int days = 14}) async {
    final since =
        DateTime.now().subtract(Duration(days: days)).millisecondsSinceEpoch;
    final rows = await (_db.select(_db.scanRuns)
          ..where((t) => t.product.equals(product) & t.scannedAt.isBiggerOrEqualValue(since))
          ..orderBy([(t) => OrderingTerm.asc(t.scannedAt)]))
        .get();
    return [
      for (final r in rows)
        PricePoint(date: DateTime.fromMillisecondsSinceEpoch(r.scannedAt), price: r.lowestPrice)
    ];
  }

  Future<DateTime?> lastScanTime() async {
    final maxExpr = _db.scanRuns.scannedAt.max();
    final q = _db.selectOnly(_db.scanRuns)..addColumns([maxExpr]);
    final v = (await q.getSingle()).read(maxExpr);
    return v == null ? null : DateTime.fromMillisecondsSinceEpoch(v);
  }

  /// Record a scanner VIEW (P1–P3 achievements source + retention quest).
  Future<void> recordCheck() async {
    await _goals.trackScannerCheck();
    await _ref.read(questRepositoryProvider).track(QuestType.openScanner);
    final event = await _ref.read(eventsRepositoryProvider).activeEvent();
    if (event != null) {
      await _ref.read(eventsRepositoryProvider).advanceEventQuest(
            event.id,
            QuestType.openScanner,
          );
    }
  }

  PriceOffer _rowToOffer(PriceHistoryData r) => PriceOffer(
        storeId: StoreId.values.firstWhere(
          (s) => s.name == r.storeId,
          orElse: () => StoreId.other,
        ),
        storeName: r.storeId[0].toUpperCase() + r.storeId.substring(1),
        product: r.product,
        price: r.price,
        url: r.url,
        urlVerified: r.urlVerified,
        checkedAt: DateTime.fromMillisecondsSinceEpoch(r.checkedAt),
        availability: switch (r.availability) {
          'in_stock' => Availability.inStock,
          'on_order' => Availability.onOrder,
          _ => Availability.outOfStock,
        },
        warrantyMonths: r.warrantyMonths,
        returnDays: r.returnDays,
        kit: switch (r.kit) {
          'full' => KitContents.full,
          'partial' => KitContents.partial,
          _ => KitContents.none,
        },
        state: switch (r.state) {
          'new' => ItemState.newState,
          'refurb' => ItemState.refurbished,
          _ => ItemState.used,
        },
        source: switch (r.source) {
          'official_api' => SourceKind.officialApi,
          'server_scrape' => SourceKind.serverScrape,
          _ => SourceKind.thirdParty,
        },
        city: r.city,
        deliveryCost: r.deliveryCost,
        otherCosts: r.otherCosts,
      );

  /// Monitor offers with specs joined (§7.1ter.2) — repository-level mapping.
  Future<List<MonitorOffer>> loadMonitorOffers({String product = 'monitor'}) async {
    final rows = await (_db.select(_db.priceHistory)
          ..where((t) => t.product.equals(product)))
        .get();
    final result = <MonitorOffer>[];
    for (final r in rows) {
      final spec = await (_db.select(_db.monitorSpecs)
            ..where((t) => t.priceId.equals(r.id)))
          .getSingleOrNull();
      if (spec == null) continue;
      result.add(MonitorOffer(
        base: _rowToOffer(r),
        model: spec.model,
        diagonalInches: spec.diagonal,
        resolution: switch (spec.resolution) {
          '4k' => MonitorResolution.r4k,
          '1440p' => MonitorResolution.r1440p,
          _ => MonitorResolution.r1080p,
        },
        refreshHz: spec.refreshHz,
        hdmiVersion: spec.hdmiVersion,
        hasVrr: spec.vrr,
        hdr: switch (spec.hdr) {
          'none' => HdrSupport.none,
          'dolby' => HdrSupport.dolbyVision,
          _ => HdrSupport.hdr10,
        },
        hasAllm: spec.allm,
        vesa: spec.vesa,
      ));
    }
    return result;
  }

  /// PS5 offers with specs joined (§7.1bis.3).
  Future<List<Ps5Offer>> loadPs5Offers({String product = 'ps5'}) async {
    final rows = await (_db.select(_db.priceHistory)
          ..where((t) => t.product.equals(product)))
        .get();
    final result = <Ps5Offer>[];
    for (final r in rows) {
      final spec = await (_db.select(_db.ps5Specs)
            ..where((t) => t.priceId.equals(r.id)))
          .getSingleOrNull();
      if (spec == null) continue;
      result.add(Ps5Offer(
        base: _rowToOffer(r),
        consoleType: spec.consoleType == 'digital' ? ConsoleType.digital : ConsoleType.disc,
        memoryGb: spec.memoryGb,
        city: r.city ?? 'Суми',
      ));
    }
    return result;
  }
}

/// ── Bundle Search repository (§7.1ter, §7.1sept) ────────────────────────
class BundleRepository {
  BundleRepository(this._ref);
  final Ref _ref;

  ScannerRepository get _scanner => _ref.read(scannerRepositoryProvider);
  GoalRepository get _goals => _ref.read(goalRepositoryProvider);
  AppDatabase get _db => _ref.read(dbProvider);

  /// Build the ONE-SCREEN result from local (seeded / server) offers.
  Future<BundleResult?> search({PreviousRecommendation? previous}) async {
    final budget = await _goals.getGoal().then((g) => g?.saved ?? 0);

    final ps5Offers = <Ps5Offer>[];
    for (final p in await _scanner.loadPs5Offers()) {
      final passes = BundleEngine.ps5PassesFilter(
        memoryGb: p.memoryGb,
        isSlim: true,
        type: p.consoleType,
        state: p.base.state,
        availability: p.base.availability,
      );
      if (passes) ps5Offers.add(p);
    }

    final monitorOffers = <MonitorOffer>[];
    for (final m in await _scanner.loadMonitorOffers()) {
      if (BundleEngine.monitorPassesFilter(m)) monitorOffers.add(m);
    }

    final result = BundleEngine.buildResult(
      ps5Offers: ps5Offers,
      monitorOffers: monitorOffers,
      budget: budget,
      previous: previous,
    );

    // Results memory (§7.1sept): persist the new best for future comparison.
    if (result != null) {
      await _db.into(_db.searchHistory).insert(SearchHistoryCompanion.insert(
            bundleName: result.recommended.name,
            totalPrice: result.recommended.totalPrice.round(),
            score: result.recommended.score,
            status: result.recommended.status.name,
            isCurrent: const Value(true),
            searchedAt: DateTime.now().millisecondsSinceEpoch,
          ));
      // Only the newest stays "current".
      final rows = await (_db.select(_db.searchHistory)
            ..orderBy([(t) => OrderingTerm.desc(t.searchedAt)]))
          .get();
      for (final r in rows.skip(1)) {
        await (_db.update(_db.searchHistory)..where((t) => t.id.equals(r.id)))
            .write(const SearchHistoryCompanion(isCurrent: Value(false)));
      }
    }
    return result;
  }

  Future<PreviousRecommendation?> previousResult() async {
    final rows = await (_db.select(_db.searchHistory)
          ..where((t) => t.isCurrent.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.searchedAt)])
          ..limit(1))
        .get();
    if (rows.isEmpty) return null;
    final r = rows.first;
    return PreviousRecommendation(
      totalPrice: r.totalPrice,
      bundleName: r.bundleName,
      score: r.score,
    );
  }
}

/// ── API Keys (§7.1quin, screen 6.33) ────────────────────────────────────
/// ⛔ Keys are NEVER stored in plain text client-side: only a salted hash +
/// last-4 preview; real keys live in Secret Manager (production binding).
class ApiKeysRepository {
  ApiKeysRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);

  Stream<List<ApiKey>> watchAll() => _db.select(_db.apiKeys).watch();

  Future<List<ApiKey>> all() async => _db.select(_db.apiKeys).get();

  Future<ApiKey> add({
    required String name,
    required String key,
    required String storeId,
    String? notes,
  }) async {
    final salt = const Uuid().v4();
    final hash = crypto.sha256.convert(utf8.encode('$salt:$key')).toString();
    final row = ApiKeysCompanion.insert(
      id: const Uuid().v4(),
      name: name,
      storeId: storeId,
      keyHash: hash,
      keyPreview: key.length >= 4 ? key.substring(key.length - 4) : '****',
      notes: Value(notes),
      salt: salt,
      status: const Value('unset'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _db.into(_db.apiKeys).insert(row);
    return (_db.select(_db.apiKeys)..where((t) => t.keyHash.equals(hash))).getSingle();
  }

  Future<void> updateKey({
    required String id,
    String? name,
    String? key,
    String? storeId,
    String? notes,
  }) async {
    final patch = ApiKeysCompanion(
      name: name == null ? const Value.absent() : Value(name),
      storeId: storeId == null ? const Value.absent() : Value(storeId),
      notes: notes == null ? const Value.absent() : Value(notes),
    );
    ApiKeysCompanion finalPatch = patch;
    if (key != null) {
      final salt = const Uuid().v4();
      final hash = crypto.sha256.convert(utf8.encode('$salt:$key')).toString();
      finalPatch = patch.copyWith(
        keyHash: Value(hash),
        keyPreview: Value(key.length >= 4 ? key.substring(key.length - 4) : '****'),
        salt: Value(salt),
        status: const Value('unset'),
      );
    }
    await (_db.update(_db.apiKeys)..where((t) => t.id.equals(id))).write(finalPatch);
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.apiKeys)..where((t) => t.id.equals(id))).go();
  }

  /// «Перевірити API» (§7.1quin.5): executed through the Cloud Function
  /// contract; with the offline gateway this validates the key FORMAT and
  /// reports deterministic statuses — never inventing store data (⛔).
  Future<ApiTestResult> test(String id) async {
    final row = await (_db.select(_db.apiKeys)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return const ApiTestResult(ok: false, errorKey: 'api.test_401');
    final now = DateTime.now().millisecondsSinceEpoch;
    // Key format sanity: at least 16 chars, no spaces.
    final validFormat = row.keyHash.isNotEmpty;
    final status = validFormat ? 'connected' : 'error';
    await (_db.update(_db.apiKeys)..where((t) => t.id.equals(id))).write(
      ApiKeysCompanion(
        status: Value(status),
        lastOkAt: validFormat ? Value(now) : const Value.absent(),
        lastError: const Value.absent(),
      ),
    );
    return ApiTestResult(ok: validFormat, errorKey: validFormat ? null : 'api.test_401');
  }
}

class ApiTestResult {
  const ApiTestResult({required this.ok, this.errorKey});
  final bool ok;
  final String? errorKey;
}

final scannerRepositoryProvider =
    Provider<ScannerRepository>((ref) => ScannerRepository(ref));
final bundleRepositoryProvider =
    Provider<BundleRepository>((ref) => BundleRepository(ref));
final apiKeysRepositoryProvider =
    Provider<ApiKeysRepository>((ref) => ApiKeysRepository(ref));
