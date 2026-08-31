import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/data/repositories/tavily_repository.dart';
import 'package:neovault/domain/trust/trust_score.dart';
import 'package:neovault/domain/prices/price_models.dart';

/// Tavily web-price pipeline: response parser, price extraction, offer
/// building and the honest scan composition (no fake «Вигідно зараз»).
void main() {
  group('parseTavilyResponse', () {
    test('parses the results array', () {
      final body = jsonEncode({
        'results': [
          {
            'title': 'Sony PS5 Slim — 24 799 ₴',
            'url': 'https://rozetka.com.ua/ua/ps5/p1/',
            'content': '24 799 ₴ в наявності',
          },
          {'title': 'no price', 'url': 'https://example.com/x', 'content': ''},
        ],
      });
      final hits = parseTavilyResponse(body);
      expect(hits, hasLength(2));
      expect(hits.first.url, contains('rozetka'));
      expect(hits.last.title, 'no price');
    });
  });

  group('extractPrice', () {
    test('handles spaced and plain UAH formats', () {
      expect(extractPrice('24 799 ₴'), 24799);
      expect(extractPrice('ціна 24 799 грн.'), 24799);
      expect(extractPrice('24799UAH'), 24799);
      expect(extractPrice('3 ₴'), isNull); // out of sanity range
      expect(extractPrice('немає ціни'), isNull);
    });
  });

  group('offersFromTavilyHits', () {
    test('maps stores, dedupes hosts, skips priceless hits', () {
      final offers = offersFromTavilyHits('ps5', [
        TavilyHit(
            title: 'Sony PS5 Slim — 24 799 ₴',
            url: 'https://rozetka.com.ua/ua/ps5/p1/',
            content: 'в наявності'),
        TavilyHit(
            title: 'PS5',
            url: 'https://www.rozetka.com.ua/ua/ps5/p2/',
            content: '25 100 грн'),
        TavilyHit(
            title: 'PS5 Foxtrot',
            url: 'https://foxtrot.com.ua/ua/ps5',
            content: 'ціна 26 499 грн.'),
        TavilyHit(
            title: 'unknown shop',
            url: 'https://some-shop.com.ua/a',
            content: 'без ціни'),
      ]);
      expect(offers, hasLength(2)); // www-host deduped; no price → skipped
      expect(offers.first.storeId, StoreId.rozetka); // sorted cheapest first
      expect(offers.first.price, 24799);
      expect(offers.first.source, SourceKind.thirdParty);
      expect(offers.first.urlVerified, isFalse);
      expect(offers.last.storeId, StoreId.foxtrot);
      expect(offers.last.price, 26499);
    });

    test('trust calculator tolerates third-party offers (no crash)', () {
      final offers = offersFromTavilyHits('ps5', [
        TavilyHit(
            title: 'PS5 24 799 ₴',
            url: 'https://rozetka.com.ua/ua/ps5/p1/',
            content: ''),
      ]);
      final trust = TrustCalculator.fromOffer(offers.first);
      expect(trust.level, isNotNull);
    });
  });

  group('scanFromOffers', () {
    test('lowest/average are honest; no fake deal badge', () {
      final offers = offersFromTavilyHits('ps5', [
        TavilyHit(
            title: '24 799 ₴', url: 'https://rozetka.com.ua/p1/', content: ''),
        TavilyHit(
            title: '26 000 грн', url: 'https://foxtrot.com.ua/p2/', content: ''),
      ]);
      final scan = scanFromOffers('ps5', offers);
      expect(scan.lowestPrice, 24799);
      expect(scan.averagePrice, closeTo(25399.5, 0.01));
      expect(scan.isGoodDealNow, isFalse); // no 30d baseline → no badge
      expect(scan.changeDir, PriceChangeDir.flat);
      expect(scan.offers, hasLength(2));
    });
  });

  group('prettyStoreName', () {
    test('known store → label; unknown host → capitalized base', () {
      expect(prettyStoreName(StoreId.rozetka, 'rozetka.com.ua'), 'Rozetka');
      expect(prettyStoreName(StoreId.other, 'some-shop.com.ua'), 'Some-shop');
    });
  });
}