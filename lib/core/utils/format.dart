import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../l10n/strings.dart';

/// Active locale override (null = follow system, default UA per spec §2).
final localeProvider = StateNotifierProvider<LocaleController, String>((ref) {
  return LocaleController();
});

class LocaleController extends StateNotifier<String> {
  LocaleController() : super(NvStrings.ua);

  void set(String code) => state = code;
}

/// Async strings provider — loads once, shared.
final stringsProvider = FutureProvider<NvStrings>((ref) async {
  return NvStrings.load(ref.watch(localeProvider));
});

/// Convenience: `ref.watch(tProvider).t('key')`.
final tProvider = Provider<String Function(String, [Map<String, Object?>])>((ref) {
  final async = ref.watch(stringsProvider);
  final fallback = NvStrings.loadSyncDefault();
  return async.maybeWhen(
    data: (s) => s.t,
    orElse: () => fallback.t,
  );
});

/// Money format §2/§8.4: `1 234,56 ₴` (both locales).
/// Implemented manually for full determinism (no locale quirks).
String formatMoney(num amount, {bool withSymbol = true}) {
  final negative = amount < 0;
  final a = amount.abs();
  final intPart = a.truncate();
  final frac = ((a - intPart) * 100).round();
  final groups = NumberFormat.decimalPattern('uk_UA')
      .format(intPart)
      .replaceAll('\u00A0', ' ');
  final s = '${negative ? '-' : ''}$groups,${frac.toString().padLeft(2, '0')}';
  return withSymbol ? '$s ₴' : s;
}

/// Integer money without kopecks for large displays.
String formatMoneyShort(num amount) {
  final f = NumberFormat.decimalPattern('uk_UA');
  return '${f.format(amount.round()).replaceAll('\u00A0', ' ')} ₴';
}

/// Date format DD.MM.YYYY (both locales per §8.4).
String formatDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  return '$dd.$mm.${d.year}';
}

String formatDateTime(DateTime d) {
  final hh = d.hour.toString().padLeft(2, '0');
  final mi = d.minute.toString().padLeft(2, '0');
  return '${formatDate(d)} $hh:$mi';
}

String formatPercent(num p, {int digits = 0}) {
  final f = NumberFormat.decimalPattern('uk_UA');
  var s = f.format(num.parse(p.toStringAsFixed(digits))).replaceAll('\u00A0', ' ');
  return '$s%';
}

/// Kyiv timezone helper (UTC+2 winter / UTC+3 summer — Europe/Kyiv).
/// Implemented without external tz database: fixed offset via DST rules
/// simplified — spec only needs "00:00 Kyiv" anchors, handled via
/// [kyivNow] and [kyivDateKey].
DateTime kyivNow() {
  final utc = DateTime.now().toUtc();
  // Europe/Kyiv DST: last Sunday of March (03:00) → last Sunday of October (04:00).
  final year = utc.year;
  final isDst = _isKyivDst(utc, year);
  return utc.add(Duration(hours: isDst ? 3 : 2));
}

bool _isKyivDst(DateTime utc, int year) {
  final marchLast = _lastSunday(year, 3);
  final octoberLast = _lastSunday(year, 10);
  // Convert transition instants to UTC (03:00 Kyiv = 01:00 UTC; 04:00 Kyiv = 01:00 UTC).
  final dstStart = DateTime.utc(year, 3, marchLast, 1);
  final dstEnd = DateTime.utc(year, 10, octoberLast, 1);
  return utc.isAfter(dstStart) && utc.isBefore(dstEnd);
}

int _lastSunday(int year, int month) {
  final lastDay = DateTime.utc(year, month + 1, 0);
  var d = lastDay;
  while (d.weekday != DateTime.sunday) {
    d = d.subtract(const Duration(days: 1));
  }
  return d.day;
}

/// Stable local date key in Kyiv tz: yyyy-MM-dd (used for streaks/chests/quests reset).
String kyivDateKey([DateTime? at]) {
  final k = at ?? kyivNow();
  return '${k.year.toString().padLeft(4, '0')}-'
      '${k.month.toString().padLeft(2, '0')}-'
      '${k.day.toString().padLeft(2, '0')}';
}

/// Monday 00:00 Kyiv of the week containing [at] (leaderboard reset §10.4).
DateTime kyivWeekStart([DateTime? at]) {
  final k = at ?? kyivNow();
  final date = DateTime(k.year, k.month, k.day);
  // Dart: Monday == 1.
  final back = (date.weekday - DateTime.monday) % 7;
  return date.subtract(Duration(days: back));
}

/// Next Kyiv midnight (quests/chest reset §10.2/10.3).
DateTime nextKyivMidnight([DateTime? at]) {
  final k = at ?? kyivNow();
  final date = DateTime(k.year, k.month, k.day);
  return date.add(const Duration(days: 1));
}

/// Compact duration for countdowns: 07:42:11.
String formatCountdown(Duration d) {
  if (d.isNegative) return '00:00:00';
  final h = d.inHours.toString().padLeft(2, '0');
  final m = (d.inMinutes % 60).toString().padLeft(2, '0');
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '$h:$m:$s';
}

extension SnackX on BuildContext {
  void toast(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
