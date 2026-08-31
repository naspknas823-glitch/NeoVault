import '../prices/price_models.dart';

/// Trust Score (§7.1sex): weighted 0–100 with High/Medium/Low levels.
enum TrustLevel { high, medium, low }

class TrustScore {
  const TrustScore({required this.value, required this.level});
  final int value; // 0..100
  final TrustLevel level;

  static TrustLevel levelFor(int v) {
    if (v >= 75) return TrustLevel.high;
    if (v >= 40) return TrustLevel.medium;
    return TrustLevel.low;
  }
}

class TrustInput {
  const TrustInput({
    required this.priceAge,
    required this.availability,
    required this.yearsOnMarket,
    required this.isMajorNetwork,
    required this.warrantyMonths,
    required this.returnDays,
    required this.kit,
    required this.source,
  });

  final Duration priceAge;
  final Availability availability;
  final int yearsOnMarket;
  final bool isMajorNetwork;
  final int warrantyMonths;
  final int returnDays;
  final KitContents kit;
  final SourceKind source;
}

/// §7.1sex.3 weights.
abstract final class TrustCalculator {
  static TrustScore compute(TrustInput i) {
    // Price confirmation: ≤24h → 100, ≤72h → 70, else 30.
    final h = i.priceAge.inHours;
    final priceScore = h <= 24 ? 100 : (h <= 72 ? 70 : 30);

    // Seller reliability: major network >3y → 100, known 1–3y → 60, new → 30.
    final sellerScore = i.isMajorNetwork && i.yearsOnMarket > 3
        ? 100
        : (i.yearsOnMarket >= 1 ? 60 : 30);

    // Warranty: ≥24m official → 100, 12–23 → 70, 6–11 → 40, <6 → 10.
    final warrantyScore = i.warrantyMonths >= 24
        ? 100
        : i.warrantyMonths >= 12
            ? 70
            : i.warrantyMonths >= 6
                ? 40
                : 10;

    // Return policy: ≥14d → 100, 7–13 → 70, <7 → 40 (none → 10).
    final returnScore = i.returnDays >= 14
        ? 100
        : i.returnDays >= 7
            ? 70
            : i.returnDays > 0
                ? 40
                : 10;

    // Kit: full → 100, controller+cables (partial) → 70, none → 40.
    final kitScore = switch (i.kit) {
      KitContents.full => 100,
      KitContents.partial => 70,
      KitContents.none => 40,
    };

    // Source: official API → 100, server scrape → 60, third-party → 20.
    final sourceScore = switch (i.source) {
      SourceKind.officialApi => 100,
      SourceKind.serverScrape => 60,
      SourceKind.thirdParty => 20,
    };

    final value = (priceScore * 0.20 +
            sellerScore * 0.20 +
            warrantyScore * 0.15 +
            returnScore * 0.15 +
            kitScore * 0.15 +
            sourceScore * 0.15)
        .round();

    return TrustScore(value: value, level: TrustScore.levelFor(value));
  }

  static TrustScore fromOffer(PriceOffer o) => compute(
        TrustInput(
          priceAge: DateTime.now().difference(o.checkedAt),
          availability: o.availability,
          yearsOnMarket: 5,
          isMajorNetwork: true,
          warrantyMonths: o.warrantyMonths,
          returnDays: o.returnDays,
          kit: o.kit,
          source: o.source,
        ),
      );
}
