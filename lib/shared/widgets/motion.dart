/// Motion durations §4.5/§11: interface 150–300ms, celebratory 400–800ms.
abstract final class NvMotion {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 300);
  static const celebration = Duration(milliseconds: 700);
}
