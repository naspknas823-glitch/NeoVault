import '../prices/price_models.dart';
import '../trust/trust_score.dart';

/// Bundle domain models (§7.1ter, §7.1bis).
enum BundleStatus { green, yellow, orange, red }

enum PurchaseType { physicalSumy, delivery }

/// PS5 Slim 1TB specific offer (§7.1bis).
class Ps5Offer {
  const Ps5Offer({
    required this.base,
    required this.consoleType, // Disc | Digital
    required this.memoryGb, // must be exactly 1024
    required this.city,
  });

  final PriceOffer base;
  final ConsoleType consoleType;
  final int memoryGb;
  final String city; // 'Суми' for physical stores

  bool get isPhysical => base.city != null;
}

enum ConsoleType { disc, digital }

/// Monitor offer with HDMI-relevant specs (§7.1ter.2).
class MonitorOffer {
  const MonitorOffer({
    required this.base,
    required this.model,
    required this.diagonalInches,
    required this.resolution,
    required this.refreshHz,
    required this.hdmiVersion,
    required this.hasVrr,
    required this.hdr, // none | hdr10 | dolbyVision
    required this.hasAllm,
    required this.vesa,
  });

  final PriceOffer base;
  final String model;
  final double diagonalInches;
  final MonitorResolution resolution;
  final int refreshHz;
  final int hdmiVersion; // 2.1 → 21, 2.0 → 20, 1.4 → 14
  final bool hasVrr;
  final HdrSupport hdr;
  final bool hasAllm;
  final String vesa;
}

enum MonitorResolution { r4k, r1440p, r1080p }

enum HdrSupport { none, hdr10, dolbyVision }

/// Compatibility checks PS5 ↔ monitor (§7.1ter.2). CRITICAL: monitor is
/// judged by what the PS5 can REALLY output over HDMI, not by max specs.
class CompatibilityReport {
  const CompatibilityReport({
    required this.hdmi21,
    required this.hz120Supported, // full | partial | no
    required this.vrr,
    required this.hdr,
    required this.hz4k60,
    required this.allm,
    required this.score,
    required this.realModeLabel,
  });

  final bool hdmi21;
  final Hz120Support hz120Supported;
  final bool vrr;
  final bool hdr;
  final bool hz4k60;
  final bool allm;
  final int score; // 0..100
  final String realModeLabel; // '4K@120Hz' | '1440p@120Hz' | '1080p@120Hz' | '4K@60Hz'...
}

enum Hz120Support { full, partial, no }

/// Evaluate what the PS5 can really do through this monitor's HDMI (7.1ter.2.1/.2.2).
CompatibilityReport checkCompatibility(MonitorOffer m) {
  final hdmi21 = m.hdmiVersion >= 21;
  final hz4k60 = m.resolution == MonitorResolution.r4k && m.refreshHz >= 60;

  Hz120Support support120;
  String realMode;
  if (hdmi21 && m.refreshHz >= 120) {
    support120 = Hz120Support.full;
    realMode = switch (m.resolution) {
      MonitorResolution.r4k => '4K@120Hz',
      MonitorResolution.r1440p => '1440p@120Hz',
      MonitorResolution.r1080p => '1080p@120Hz',
    };
  } else if (!hdmi21 && m.hdmiVersion >= 20 && m.refreshHz >= 120) {
    support120 = Hz120Support.partial; // only 1080p@120Hz
    realMode = '1080p@120Hz';
  } else {
    support120 = Hz120Support.no;
    realMode = switch (m.resolution) {
      MonitorResolution.r4k => '4K@60Hz',
      MonitorResolution.r1440p => '1440p@60Hz',
      MonitorResolution.r1080p => '1080p@60Hz',
    };
  }

  // Compatibility score: HDMI2.1 30, 120Hz 25 (partial 12), VRR 15,
  // HDR 15 (DolbyVision 20), ALLM 10, 4K@60 5.
  var score = 0;
  score += hdmi21 ? 30 : (m.hdmiVersion >= 20 ? 15 : 0);
  score += switch (support120) { Hz120Support.full => 25, Hz120Support.partial => 12, Hz120Support.no => 0 };
  score += m.hasVrr ? 15 : 0;
  score += switch (m.hdr) { HdrSupport.none => 0, HdrSupport.hdr10 => 15, HdrSupport.dolbyVision => 20 };
  score += m.hasAllm ? 10 : 0;
  score += hz4k60 ? 5 : 0;

  return CompatibilityReport(
    hdmi21: hdmi21,
    hz120Supported: support120,
    vrr: m.hasVrr,
    hdr: m.hdr != HdrSupport.none,
    hz4k60: hz4k60,
    allm: m.hasAllm,
    score: score,
    realModeLabel: realMode,
  );
}

/// A bundle = one PS5 + one monitor (§7.1ter.5).
class Bundle {
  const Bundle({
    required this.ps5,
    required this.monitor,
    required this.compatibility,
    required this.trustPs5,
    required this.trustMonitor,
    required this.trustBundle,
    required this.totalPrice,
    required this.deliveryTotal,
    required this.otherCosts,
    required this.score,
    required this.status,
  });

  final Ps5Offer ps5;
  final MonitorOffer monitor;
  final CompatibilityReport compatibility;
  final TrustScore trustPs5;
  final TrustScore trustMonitor;
  final TrustScore trustBundle;
  final num totalPrice;
  final num deliveryTotal;
  final num otherCosts;
  final int score; // bundle score 0..100 (§7.1ter.9)
  final BundleStatus status;

  String get name => '${ps5.base.storeName} + ${monitor.model}';
}

/// The 3 variants shown on the main screen (§7.1ter.16).
class BundleVariants {
  const BundleVariants({required this.cheapest, required this.optimal, required this.best});
  final Bundle cheapest;
  final Bundle optimal;
  final Bundle best;
}

/// Full search result (ONE SCREEN content, §7.1ter.16).
class BundleResult {
  const BundleResult({
    required this.recommended,
    required this.variants,
    required this.budget,
    required this.leftover,
    required this.allOffersCount,
    required this.staleCount,
    this.previous,
    this.savings,
    this.recommendationChanged = false,
    required this.explanation,
    required this.decisionBuy,
    required this.whyNotReasons,
  });

  final Bundle recommended;
  final BundleVariants variants;
  final num budget;
  final num leftover; // negative → shortage
  final int allOffersCount;
  final int staleCount;
  final PreviousRecommendation? previous;
  final num? savings;
  final bool recommendationChanged;
  final String explanation;
  final bool decisionBuy;
  final List<String> whyNotReasons;
}
