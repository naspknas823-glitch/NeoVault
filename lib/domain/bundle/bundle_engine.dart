import 'bundle_models.dart';
import '../prices/price_models.dart';
import '../trust/trust_score.dart';

/// Bundle Search engine (§7.1bis, §7.1ter, §7.1oct).
/// The app decides ITSELF — never delegates the choice to the user (⛔).
abstract final class BundleEngine {
  /// ── Autofilter PS5 (§7.1bis.2, §7.1oct.1): ONLY PS5 Slim 1 TB ──
  static bool ps5PassesFilter({
    required int memoryGb,
    required bool isSlim,
    required ConsoleType type,
    required ItemState state,
    required Availability availability,
  }) {
    if (memoryGb != 1024) return false; // exactly 1 TB
    if (!isSlim) return false; // not Pro, not Fat
    if (state == ItemState.used) return false; // B/У відсіюється
    if (availability == Availability.outOfStock) return false;
    return true;
  }

  /// ── Autofilter monitor (§7.1ter.10, §7.1oct.1) ──
  static bool monitorPassesFilter(MonitorOffer m) {
    if (m.hdmiVersion < 20) return false; // no HDMI / HDMI 1.4 only
    if (m.diagonalInches < 24) return false; // <24" не для консолей
    if (m.base.availability == Availability.outOfStock) return false;
    return true;
  }

  /// Suspiciously low price check (§7.1bis.5): ≥15% below market avg
  /// or ≥10% below current min → flagged 🟡.
  static bool isSuspiciousPrice(num price, num marketAvg, num currentMin) {
    if (marketAvg > 0 && price <= marketAvg * 0.85) return true;
    if (currentMin > 0 && price <= currentMin * 0.90) return true;
    return false;
  }

  /// ── Offer quality score 0..100 (§7.1bis.9) ──
  static int offerScore({
    required num price,
    required num minPrice,
    required int warrantyMonths,
    required Availability availability,
    required PurchaseType purchaseType,
    required int returnDays,
    required int yearsOnMarket,
    required bool isMajorNetwork,
    required KitContents kit,
    bool suspicious = false,
  }) {
    // Price metric: 100 − (diff from min / min × 100), floor 0; suspicious −20.
    final priceMetric = minPrice > 0
        ? (100 - ((price - minPrice) / minPrice * 100)).clamp(0.0, 100.0).toDouble()
        : 100.0;
    final priceScore = (suspicious ? priceMetric - 20 : priceMetric).clamp(0, 100);

    final warrantyScore = warrantyMonths >= 24
        ? 100
        : warrantyMonths >= 12
            ? 70
            : warrantyMonths >= 6
                ? 40
                : 10;

    final availabilityScore = switch (availability) {
      Availability.inStock => 100,
      Availability.onOrder => 50,
      Availability.outOfStock => 0,
    };

    final deliveryScore = switch (purchaseType) {
      PurchaseType.physicalSumy => 100,
      PurchaseType.delivery => 60, // 1–5 днів; >5 днів → 30 (approx. via delivery cost>0)
    };

    final returnScore = returnDays >= 14
        ? 100
        : returnDays >= 7
            ? 70
            : returnDays > 0
                ? 40
                : 10;

    final reliabilityScore = isMajorNetwork && yearsOnMarket > 3
        ? 100
        : (yearsOnMarket >= 1 ? 60 : 30);

    final kitScore = switch (kit) {
      KitContents.full => 100,
      KitContents.partial => 70,
      KitContents.none => 40,
    };

    return (priceScore * 0.30 +
            warrantyScore * 0.15 +
            availabilityScore * 0.15 +
            deliveryScore * 0.12 +
            returnScore * 0.08 +
            reliabilityScore * 0.12 +
            kitScore * 0.08)
        .round();
  }

  /// ── Bundle score (§7.1ter.9): price .25, compat .25, warranty .15,
  /// reliability .15, availability .10, kit .10 ──
  static int bundleScore({
    required num totalPrice,
    required num minPossibleTotal,
    required int compatibilityScore,
    required int ps5WarrantyMonths,
    required int monitorWarrantyMonths,
    required bool ps5Reliable,
    required bool monitorReliable,
    required bool bothAvailable,
    required bool fullKit,
  }) {
    final priceMetric = minPossibleTotal > 0
        ? (100 - ((totalPrice - minPossibleTotal) / minPossibleTotal * 100))
            .clamp(0.0, 100.0)
            .toDouble()
        : 100.0;
    final avgWarranty = (ps5WarrantyMonths + monitorWarrantyMonths) / 2;
    final warrantyScore = avgWarranty >= 24
        ? 100
        : avgWarranty >= 12
            ? 70
            : avgWarranty >= 6
                ? 40
                : 10;
    final reliabilityScore = ps5Reliable && monitorReliable ? 100 : (ps5Reliable || monitorReliable ? 60 : 30);
    final availabilityScore = bothAvailable ? 100 : 0;
    final kitScore = fullKit ? 100 : 70;

    return (priceMetric * 0.25 +
            compatibilityScore * 0.25 +
            warrantyScore * 0.15 +
            reliabilityScore * 0.15 +
            availabilityScore * 0.10 +
            kitScore * 0.10)
        .round();
  }

  /// ── Final status (§7.1ter.12) ──
  static BundleStatus finalStatus({
    required int bundleScore,
    required num totalCost,
    required num budget,
    required bool bothAvailable,
    required int compatibilityScore,
    required bool sellersReliable,
    required bool suspiciousPrice,
  }) {
    // 🔴 criteria
    if (!bothAvailable) return BundleStatus.red;
    if (compatibilityScore < 40) return BundleStatus.red;
    if (suspiciousPrice) return BundleStatus.red;
    final shortageRatio = budget > 0 ? (totalCost - budget) / budget : 1.0;
    if (totalCost > budget && shortageRatio > 0.15) return BundleStatus.red;
    if (bundleScore < 40) return BundleStatus.red;

    // 🟢 criteria
    if (bundleScore >= 75 &&
        totalCost <= budget &&
        bothAvailable &&
        compatibilityScore >= 60 &&
        sellersReliable) {
      return BundleStatus.green;
    }

    // 🟠: problems with compat/price/availability
    if (compatibilityScore < 60 || shortageRatio > 0.05) return BundleStatus.orange;

    return BundleStatus.yellow;
  }

  /// Physical store is PREFERRED when price ≤5% above cheapest delivery
  /// and its guarantee/kit/reputation are not worse (§7.1ter.12).
  static bool preferPhysical({
    required num physicalFullCost,
    required num bestDeliveryFullCost,
    required int physicalScore,
    required int deliveryScore,
  }) {
    if (bestDeliveryFullCost <= 0) return true;
    final within5 = physicalFullCost <= bestDeliveryFullCost * 1.05;
    return within5 && physicalScore >= deliveryScore;
  }

  /// Build the full result from filtered offers + budget (§7.1ter.11).
  static BundleResult? buildResult({
    required List<Ps5Offer> ps5Offers,
    required List<MonitorOffer> monitorOffers,
    required num budget,
    PreviousRecommendation? previous,
    String Function(Bundle best)? explain,
  }) {
    if (ps5Offers.isEmpty || monitorOffers.isEmpty) return null;

    // Score every offer.
    num minPs5 = ps5Offers.map((p) => p.base.fullCost).reduce(_min);
    num minMon = monitorOffers.map((m) => m.base.fullCost).reduce(_min);

    final scoredPs5 = ps5Offers.map((p) {
      final suspicious = isSuspiciousPrice(p.base.price, minPs5 * 1.6, minPs5);
      final s = offerScore(
        price: p.base.price,
        minPrice: minPs5,
        warrantyMonths: p.base.warrantyMonths,
        availability: p.base.availability,
        purchaseType: p.isPhysical ? PurchaseType.physicalSumy : PurchaseType.delivery,
        returnDays: p.base.returnDays,
        yearsOnMarket: 5,
        isMajorNetwork: true,
        kit: p.base.kit,
        suspicious: suspicious,
      );
      return (offer: p, score: s, suspicious: suspicious);
    }).toList();

    final scoredMon = monitorOffers.map((m) {
      final suspicious = isSuspiciousPrice(m.base.price, minMon * 1.6, minMon);
      final s = offerScore(
        price: m.base.price,
        minPrice: minMon,
        warrantyMonths: m.base.warrantyMonths,
        availability: m.base.availability,
        purchaseType: m.base.city != null ? PurchaseType.physicalSumy : PurchaseType.delivery,
        returnDays: m.base.returnDays,
        yearsOnMarket: 5,
        isMajorNetwork: true,
        kit: m.base.kit,
        suspicious: suspicious,
      );
      return (offer: m, score: s, suspicious: suspicious);
    }).toList();

    // Form bundles: PS5 score weight 0.6 + monitor score 0.4 (PS5 matters more).
    final combos = <(Ps5Offer, MonitorOffer, int, CompatibilityReport)>[];
    for (final p in scoredPs5) {
      for (final m in scoredMon) {
        final compat = checkCompatibility(m.offer);
        final pairScore = (p.score * 0.6 + m.score * 0.4).round();
        combos.add((p.offer, m.offer, pairScore, compat));
      }
    }

    num minTotal = combos
        .map((c) => c.$1.base.fullCost + c.$2.base.fullCost)
        .reduce(_min);

    final bundles = combos.map((c) {
      final (ps5, mon, pairScore, compat) = c;
      final total = ps5.base.fullCost + mon.base.fullCost;
      final delivery = ps5.base.deliveryCost + mon.base.deliveryCost;
      final others = ps5.base.otherCosts + mon.base.otherCosts;
      final trustP = TrustCalculator.fromOffer(ps5.base);
      final trustM = TrustCalculator.fromOffer(mon.base);
      final bundleTrust = TrustScore(
        value: ((trustP.value + trustM.value) / 2).round(),
        level: TrustScore.levelFor(((trustP.value + trustM.value) / 2).round()),
      );
      final score = bundleScore(
        totalPrice: total,
        minPossibleTotal: minTotal,
        compatibilityScore: compat.score,
        ps5WarrantyMonths: ps5.base.warrantyMonths,
        monitorWarrantyMonths: mon.base.warrantyMonths,
        ps5Reliable: trustP.level != TrustLevel.low,
        monitorReliable: trustM.level != TrustLevel.low,
        bothAvailable: ps5.base.availability == Availability.inStock &&
            mon.base.availability == Availability.inStock,
        fullKit: ps5.base.kit == KitContents.full && mon.base.kit == KitContents.full,
      );
      final status = finalStatus(
        bundleScore: score,
        totalCost: total,
        budget: budget,
        bothAvailable: ps5.base.availability == Availability.inStock &&
            mon.base.availability == Availability.inStock,
        compatibilityScore: compat.score,
        sellersReliable: trustP.level != TrustLevel.low && trustM.level != TrustLevel.low,
        suspiciousPrice: pairScore < 30,
      );
      return Bundle(
        ps5: ps5,
        monitor: mon,
        compatibility: compat,
        trustPs5: trustP,
        trustMonitor: trustM,
        trustBundle: bundleTrust,
        totalPrice: total,
        deliveryTotal: delivery,
        otherCosts: others,
        score: score,
        status: status,
      );
    }).toList();

    if (bundles.isEmpty) return null;

    // Winner: highest score, tie → cheaper. NOT the cheapest automatically (⛔ 7.1ter.9).
    bundles.sort((a, b) {
      final cmp = b.score.compareTo(a.score);
      if (cmp != 0) return cmp;
      return a.totalPrice.compareTo(b.totalPrice);
    });
    final best = bundles.first;

    final cheapest = [...bundles]..sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
    // Optimal: best among affordable (fits budget) with green/yellow status.
    final affordable = bundles.where((b) => b.totalPrice <= budget).toList();
    final optimal = (affordable.isNotEmpty ? affordable : bundles)
        .reduce((a, b) => a.score >= b.score ? a : b);

    final leftover = budget - best.totalPrice;
    final status = best.status;

    // Previous result comparison (§7.1sept).
    num? savings;
    var recChanged = false;
    if (previous != null) {
      savings = previous.totalPrice - best.totalPrice;
      recChanged = previous.bundleName != best.name;
    }

    final decisionBuy = status == BundleStatus.green ||
        (status == BundleStatus.yellow && best.totalPrice <= budget);

    final whyNot = <String>[
      if (!best.compatibility.hdmi21) 'HDMI 2.1 відсутній на моніторі',
      if (best.compatibility.hz120Supported == Hz120Support.no)
        '120Hz на PS5 не підтверджено через цей HDMI',
      if (best.totalPrice > budget)
        'Бюджету недостатньо: бракує ${(best.totalPrice - budget).round()} ₴',
      if (best.ps5.base.availability != Availability.inStock) 'PS5 не в наявності',
      if (best.monitor.base.availability != Availability.inStock) 'Монітор не в наявності',
      if (best.trustBundle.level == TrustLevel.low) 'Низький рівень довіри продавців',
    ];

    final explanation = explain?.call(best) ??
        'Оптимальний баланс ціни та сумісності. Сумісність PS5 + монітор: '
            '${best.compatibility.score}/100. Загальна ціна '
            '${best.totalPrice.toStringAsFixed(0)} ₴.';

    return BundleResult(
      recommended: best,
      variants: BundleVariants(
        cheapest: cheapest.first,
        optimal: optimal,
        best: best,
      ),
      budget: budget,
      leftover: leftover,
      allOffersCount: ps5Offers.length + monitorOffers.length,
      staleCount: ps5Offers.where((p) => p.base.isStale).length +
          monitorOffers.where((m) => m.base.isStale).length,
      previous: previous,
      savings: savings,
      recommendationChanged: recChanged,
      explanation: explanation,
      decisionBuy: decisionBuy,
      whyNotReasons: whyNot,
    );
  }

  static num _min(num a, num b) => a < b ? a : b;
}
