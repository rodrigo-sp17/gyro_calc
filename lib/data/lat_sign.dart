enum LatSign { N, S }

extension LatSignExtension on LatSign {
  String get value {
    switch (this) {
      case LatSign.N:
        return 'N';
      case LatSign.S:
        return 'S';
      default:
          return null;
    }
  }
}