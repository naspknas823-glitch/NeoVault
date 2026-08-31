/// Price domain models (§7.1, §7.1quater, §7.1sex, §7.1sept).
/// ⛔ Client NEVER scrapes sites — it only reads prepared JSON via the
/// repository (server-side scraping per §9.1).
enum StoreId { rozetka, foxtrot, compx, citrus, eldorado, citilux, other }

enum Availability { inStock, onOrder, outOfStock }

enum SourceKind { officialApi, serverScrape, thirdParty }

enum PriceChangeDir { up, down, flat }

class Store {
  const Store({
    required this.id,
    required this.name,
    required this.trustYearsOnMarket,
    required this.isMajorNetwork,
    this.status = ApiStatus.unknown,
    this.rateLimitPerHour,
  });

  final StoreId id;
  final String name;
  final int trustYearsOnMarket;
  final bool isMajorNetwork;
  final ApiStatus status;
  final int? rateLimitPerHour;
}

enum ApiStatus { connected, error, unset, unknown }

/// One store offer for a product (§7.1bis.3 / §7.1ter.17.5).
class PriceOffer {
  const PriceOffer({
    required this.storeId,
    required this.storeName,
    required this.product,
    required this.price,
    required this.url,
    required this.urlVerified,
    required this.checkedAt,
    required this.availability,
    required this.warrantyMonths,
    required this.returnDays,
    required this.kit,
    required this.state,
    required this.source,
    this.city,
    this.deliveryCost = 0,
    this.otherCosts = 0,
  });

  final StoreId storeId;
  final String storeName;
  final String product; // 'ps5' | 'monitor'
  final num price;
  final String url;
  final bool urlVerified;
  final DateTime checkedAt;
  final Availability availability;
  final int warrantyMonths;
  final int returnDays;
  final KitContents kit;
  final ItemState state;
  final SourceKind source;
  final String? city; // for physical stores in Sumy
  final num deliveryCost;
  final num otherCosts;

  /// Full end price (§7.1bis.6): price + delivery + mandatory costs.
  num get fullCost => price + deliveryCost + otherCosts;

  bool get isFresh => DateTime.now().difference(checkedAt) <= const Duration(hours: 24);
  bool get isStale => !isFresh;
}

enum KitContents { full, partial, none }

enum ItemState { newState, refurbished, used }

/// Price point for history charts (§7.1bis.8).
class PricePoint {
  const PricePoint({required this.date, required this.price});
  final DateTime date;
  final num price;
}

/// Snapshot for one product from the daily scan (§7.1).
class ProductScan {
  const ProductScan({
    required this.product,
    required this.offers,
    required this.lowestPrice,
    required this.averagePrice,
    required this.avg30dPrice,
    required this.changePercent,
    required this.changeDir,
    required this.scannedAt,
    required this.isGoodDealNow,
  });

  final String product;
  final List<PriceOffer> offers;
  final num lowestPrice;
  final num averagePrice;
  final num avg30dPrice;
  final double changePercent;
  final PriceChangeDir changeDir;
  final DateTime scannedAt;
  final bool isGoodDealNow;
}

/// Simplified Buy Score (§5.4): lowest < avg30d * 0.95 → «Вигідно зараз».
bool isGoodDealNow(num lowestPrice, num avg30dPrice) =>
    avg30dPrice > 0 && lowestPrice < avg30dPrice * 0.95;

/// % below the 30d average for the push text.
double percentBelowAvg(num lowestPrice, num avg30dPrice) =>
    avg30dPrice <= 0 ? 0 : ((avg30dPrice - lowestPrice) / avg30dPrice * 100);

/// Scan schedule (⛔ §9.5): exactly 1 server auto-scan per day ~08:00 Kyiv;
/// NO manual refresh in beta.
const int dailyScanHourKyiv = 8;

DateTime nextScanTime(DateTime kyivNow) {
  final today8 = DateTime(kyivNow.year, kyivNow.month, kyivNow.day, dailyScanHourKyiv);
  if (kyivNow.isBefore(today8)) return today8;
  return today8.add(const Duration(days: 1));
}

/// Previous result memory (§7.1sept) — comparison & savings.
class PreviousRecommendation {
  const PreviousRecommendation({
    required this.totalPrice,
    required this.bundleName,
    required this.score,
    this.wasRecommended = true,
  });
  final num totalPrice;
  final String bundleName;
  final int score;
  final bool wasRecommended;
}
