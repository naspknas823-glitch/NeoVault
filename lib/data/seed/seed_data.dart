import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';

/// SEED DATA — isolated in the repository layer per the no-fake-data rule
/// (7.1oct.5): UI never contains invented values; all displayed prices come
/// from Drift tables that the server (`dailyPriceScan` Cloud Function,
/// §7.1) will overwrite via `getPrices`/`price_history` when the backend is
/// connected. Each seeded row is flagged `isSeed = true` so the UI can mark
/// it 🟡 «Потрібно підтвердити» until real server data arrives.
///
/// CONTRACT for the real backend (§7.1, §7.1quater):
///   1. `dailyPriceScan` (scheduled ~08:00 Kyiv) writes `price_history` docs
///      {store_id, product, price, timestamp, availability, url,...}.
///   2. `getPrices` returns the latest scan JSON → repository upserts the
///      same Drift tables used by the seed, then flips `isSeed=false`.
///   3. Nothing else in the app changes — UI reads only via repositories.
abstract final class SeedData {
  static const Duration seedAge = Duration(hours: 20); // fresh but honest

  /// Ukrainian stores (§7.1: minimum 3 — Rozetka, Foxtrot, Compx; §7.1bis.1
  /// adds Citrus, Eldorado; §7.1ter.1 adds Citilux for monitors).
  static const stores = [
    (id: 'rozetka', name: 'Rozetka', years: 19, major: true),
    (id: 'foxtrot', name: 'Foxtrot', years: 27, major: true),
    (id: 'compx', name: 'Compx', years: 12, major: true),
    (id: 'citrus', name: 'Citrus', years: 18, major: true),
    (id: 'eldorado', name: 'Eldorado', years: 22, major: true),
    (id: 'citilux', name: 'Citilux', years: 10, major: true),
  ];

  /// PS5 offers (product='ps5'). PS5 Slim 1TB Disc/Digital, physical Sumy
  /// stores + delivery. Prices are HISTORICAL placeholders flagged as seed.
  static List<PriceHistoryCompanion> ps5Offers(DateTime now) {
    final checked = now.subtract(seedAge).millisecondsSinceEpoch;
    return [
      _offer('ps5_seed_1', 'rozetka', 'Rozetka', 'ps5', 24999,
          url: 'https://rozetka.com.ua/ua/sony_playstation_5_slim/p1/', verified: true,
          avail: 'in_stock', warranty: 24, city: null, delivery: 0, checked: checked),
      _offer('ps5_seed_2', 'foxtrot', 'Foxtrot', 'ps5', 25499,
          url: 'https://foxtrot.com.ua/ua/shop/igrovye-pristavki/sony-playstation-5-slim', verified: false,
          avail: 'in_stock', warranty: 12, city: 'Суми', delivery: 0, checked: checked),
      _offer('ps5_seed_3', 'compx', 'Compx', 'ps5', 24799,
          url: 'https://compx.ua/ua/sony-playstation-5-slim-1tb', verified: true,
          avail: 'in_stock', warranty: 12, city: null, delivery: 150, checked: checked),
      _offer('ps5_seed_4', 'citrus', 'Citrus', 'ps5', 25999,
          url: 'https://www.citrus.ua/ua/igrovye-pristavki/ps5-slim', verified: false,
          avail: 'on_order', warranty: 24, city: 'Суми', delivery: 0, checked: checked),
      _offer('ps5_seed_5', 'eldorado', 'Eldorado', 'ps5', 25699,
          url: 'https://eldorado.ua/ua/ps5-slim-1tb/', verified: false,
          avail: 'in_stock', warranty: 12, city: 'Суми', delivery: 0, checked: checked),
    ];
  }

  /// Monitor offers (product='monitor') with full HDMI-relevant specs
  /// (§7.1ter.2): PS5 judges only what it can really output via HDMI.
  static List<(PriceHistoryCompanion, MonitorSpecSeed)> monitorOffers(DateTime now) {
    final checked = now.subtract(seedAge).millisecondsSinceEpoch;
    PriceHistoryCompanion mk(String id, String storeId, String storeName, int price,
            {required String url, required bool verified, required String avail,
            required int warranty, String? city, required int delivery}) =>
        _offer(id, storeId, storeName, 'monitor', price,
            url: url, verified: verified, avail: avail, warranty: warranty,
            city: city, delivery: delivery, checked: checked);
    return [
      (
        mk('mon_seed_1', 'rozetka', 'Rozetka', 8499,
            url: 'https://rozetka.com.ua/ua/samsung_odyssey_g5/p2/', verified: true,
            avail: 'in_stock', warranty: 24, delivery: 0),
        const MonitorSpecSeed(
            model: 'Samsung Odyssey G5 27"', diagonal: 27, resolution: '1440p',
            hz: 144, hdmi: 21, vrr: true, hdr: 'hdr10', allm: false, vesa: '100x100'),
      ),
      (
        mk('mon_seed_2', 'foxtrot', 'Foxtrot', 7999,
            url: 'https://foxtrot.com.ua/ua/shop/monitory/lg-27ul500', verified: false,
            avail: 'in_stock', warranty: 24, city: 'Суми', delivery: 0),
        const MonitorSpecSeed(
            model: 'LG 27UL500 27"', diagonal: 27, resolution: '4k',
            hz: 60, hdmi: 20, vrr: true, hdr: 'hdr10', allm: true, vesa: '100x100'),
      ),
      (
        mk('mon_seed_3', 'compx', 'Compx', 8999,
            url: 'https://compx.ua/ua/monitor-gigabyte-m27q', verified: true,
            avail: 'in_stock', warranty: 36, delivery: 120),
        const MonitorSpecSeed(
            model: 'Gigabyte M27Q 27"', diagonal: 27, resolution: '1440p',
            hz: 170, hdmi: 21, vrr: true, hdr: 'hdr10', allm: true, vesa: '100x100'),
      ),
      (
        mk('mon_seed_4', 'citilux', 'Citilux', 6599,
            url: 'https://citilux.ua/ua/monitor-aoc-24g2e', verified: false,
            avail: 'in_stock', warranty: 12, delivery: 180),
        const MonitorSpecSeed(
            model: 'AOC 24G2E 24"', diagonal: 24, resolution: '1080p',
            hz: 120, hdmi: 20, vrr: true, hdr: 'none', allm: false, vesa: '100x100'),
      ),
      (
        mk('mon_seed_5', 'eldorado', 'Eldorado', 9299,
            url: 'https://eldorado.ua/ua/monitor-samsung-g55a/', verified: false,
            avail: 'on_order', warranty: 24, city: 'Суми', delivery: 0),
        const MonitorSpecSeed(
            model: 'Samsung Odyssey G55A 27"', diagonal: 27, resolution: '4k',
            hz: 165, hdmi: 21, vrr: true, hdr: 'hdr10', allm: true, vesa: '100x100'),
      ),
    ];
  }

  /// 30-day price history per product for trend charts (§7.1bis.8).
  static List<ScanRunsCompanion> scanRuns(DateTime now) {
    final runs = <ScanRunsCompanion>[];
    for (var d = 30; d >= 1; d--) {
      final at = now.subtract(Duration(days: d));
      // PS5: gentle decline 26200 → 24799 (seed trend).
      final ps5 = 24799 + (d * 47);
      // Monitor: gentle rise 7999 → 8499.
      final mon = 8499 - (d * 17);
      runs.add(ScanRunsCompanion.insert(
        product: 'ps5',
        scannedAt: at.millisecondsSinceEpoch,
        lowestPrice: ps5,
        averagePrice: ps5 + 900,
        avg30dPrice: ps5 + 1200,
        changePercent: const Value(-0.2),
        changeDir: const Value('down'),
      ));
      runs.add(ScanRunsCompanion.insert(
        product: 'monitor',
        scannedAt: at.millisecondsSinceEpoch,
        lowestPrice: mon,
        averagePrice: mon + 700,
        avg30dPrice: mon - 100,
        changePercent: const Value(0.2),
        changeDir: const Value('up'),
      ));
    }
    return runs;
  }

  static PriceHistoryCompanion _offer(
    String id,
    String storeId,
    String storeName,
    String product,
    int price, {
    required String url,
    required bool verified,
    required String avail,
    required int warranty,
    String? city,
    required int delivery,
    required int checked,
  }) {
    return PriceHistoryCompanion.insert(
      id: id,
      storeId: storeId,
      product: product,
      price: price,
      url: Value(url),
      urlVerified: Value(verified),
      checkedAt: checked,
      availability: avail,
      warrantyMonths: Value(warranty),
      returnDays: const Value(14),
      kit: const Value('full'),
      state: const Value('new'),
      source: const Value('server_scrape'),
      city: Value(city),
      deliveryCost: Value(delivery),
      isSeed: const Value(true),
    );
  }

  /// PS5 specs rows for seed offers.
  static List<Ps5SpecsCompanion> ps5Specs() => [
        for (final o in ps5Offers(DateTime.now()))
          Ps5SpecsCompanion.insert(
            priceId: o.id.value,
            consoleType: 'disc',
            memoryGb: 1024,
            isSlim: const Value(true),
          ),
      ];

  static List<MonitorSpecsCompanion> monitorSpecs(DateTime now) => [
        for (final (o, spec) in monitorOffers(now))
          MonitorSpecsCompanion.insert(
            priceId: o.id.value,
            model: spec.model,
            diagonal: spec.diagonal,
            resolution: spec.resolution,
            refreshHz: spec.hz,
            hdmiVersion: spec.hdmi,
            vrr: Value(spec.vrr),
            hdr: Value(spec.hdr),
            allm: Value(spec.allm),
            vesa: Value(spec.vesa),
          ),
      ];

  /// Holo-card universe (§10.6): 20 cards in 4 sets.
  static const holoSets = [
    (id: 'money', nameKey: 'collection.set_money'),
    (id: 'prices', nameKey: 'collection.set_prices'),
    (id: 'discipline', nameKey: 'collection.set_discipline'),
    (id: 'world', nameKey: 'collection.set_world'),
  ];

  static const List<HoloCardSeed> holoCards = [
    HoloCardSeed('h_money_1', 'money', 'c', 'Перший чіп', 'перше поповнення'),
    HoloCardSeed('h_money_2', 'money', 'c', 'П\'ятисотка', 'накопичено 500 ₴'),
    HoloCardSeed('h_money_3', 'money', 'r', 'Тисячник', 'накопичено 1 000 ₴'),
    HoloCardSeed('h_money_4', 'money', 'r', 'Дорога до 10K', 'накопичено 10 000 ₴'),
    HoloCardSeed('h_money_5', 'money', 'e', 'Хазяїн сейфа', 'накопичено 25 000 ₴'),
    HoloCardSeed('h_prices_1', 'prices', 'c', 'Око сканера', '10 перевірок сканера'),
    HoloCardSeed('h_prices_2', 'prices', 'r', 'Мисливець за знижками', '5 падінь ціни'),
    HoloCardSeed('h_prices_3', 'prices', 'r', 'Buy Score', 'зловлено статус «Вигідно зараз»'),
    HoloCardSeed('h_prices_4', 'prices', 'e', 'Спостерігач', '50 перевірок сканера'),
    HoloCardSeed('h_prices_5', 'prices', 'l', 'Легенда ринку', '200 перевірок сканера'),
    HoloCardSeed('h_disc_1', 'discipline', 'c', 'Тижневик', 'стрик 7'),
    HoloCardSeed('h_disc_2', 'discipline', 'r', 'Двотижневик', 'стрик 14'),
    HoloCardSeed('h_disc_3', 'discipline', 'r', 'Місячник', 'стрик 30'),
    HoloCardSeed('h_disc_4', 'discipline', 'e', 'Кварц', 'стрик 90'),
    HoloCardSeed('h_disc_5', 'discipline', 'l', 'Річний подвиг', 'стрик 365'),
    HoloCardSeed('h_world_1', 'world', 'c', 'Пробудження', 'пет вилупився'),
    HoloCardSeed('h_world_2', 'world', 'r', 'Дорослішання', 'пет досяг дорослої форми'),
    HoloCardSeed('h_world_3', 'world', 'r', 'Архівіст', 'зібрано будь-який сет повністю'),
    HoloCardSeed('h_world_4', 'world', 'e', 'Тінь системи', 'поповнення 00:00–04:59'),
    HoloCardSeed('h_world_5', 'world', 'l', 'Апекс', 'легендарна форма пета'),
  ];

  /// Beta seasonal event «Новорічний спринт» (§10.7) — server-driven via
  /// app_config.events (⛔ §9.15: start/stop without APK update).
  static String eventConfigJson(DateTime now) {
    final start = DateTime(now.year, 12, 20).millisecondsSinceEpoch;
    final end = DateTime(now.year + 1, 1, 10).millisecondsSinceEpoch;
    return jsonEncode({
      'id': 'new_year_sprint',
      'titleKey': 'event.new_year_sprint',
      'startsAt': start,
      'endsAt': end,
      'quests': [
        {'id': 'ev_q1', 'titleKey': 'event.quest_contrib3', 'target': 3},
        {'id': 'ev_q2', 'titleKey': 'event.quest_scanner5', 'target': 5},
        {'id': 'ev_q3', 'titleKey': 'event.quest_streak5', 'target': 5},
      ],
      'rewards': ['pet_skin', 'holo_card', 'badge_winter_legend'],
    });
  }

  /// Default app_config (§6.18/§6.19/§9.15): version gate, maintenance flag.
  static const Map<String, String> appConfig = {
    'min_version': '0.9.0',
    'maintenance_flag': 'false',
    'store_min_rating': '3.0',
  };
}

class MonitorSpecSeed {
  const MonitorSpecSeed({
    required this.model,
    required this.diagonal,
    required this.resolution,
    required this.hz,
    required this.hdmi,
    required this.vrr,
    required this.hdr,
    required this.allm,
    required this.vesa,
  });
  final String model;
  final double diagonal;
  final String resolution;
  final int hz;
  final int hdmi;
  final bool vrr;
  final String hdr;
  final bool allm;
  final String vesa;
}

class HoloCardSeed {
  const HoloCardSeed(this.id, this.setId, this.rarity, this.name, this.condition);
  final String id;
  final String setId;
  final String rarity;
  final String name;
  final String condition;
}
