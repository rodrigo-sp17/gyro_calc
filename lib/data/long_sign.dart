enum LongSign { W, E }

extension LongSignExtension on LongSign {
  String get value {
    switch (this) {
      case LongSign.W:
        return 'W';
      case LongSign.E:
        return 'E';
      default:
        return null;
    }
  }
}