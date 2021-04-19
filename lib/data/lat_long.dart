import 'package:validate/validate.dart';

/// Class that stores Lat Long data in degrees, minutes and minute decimals
/// instead of standard representation
///
class LatLong {
  int _latDeg;
  double _latMin;
  LatSign _latSign;
  int _longDeg;
  double _longMin;
  LongSign _longSign;

  LatLong(int latDeg, this._latMin, int longDeg, this._longMin) {
    Validate.inclusiveBetween(-90, 90, latDeg,
        "Latitude must be between -90 and 90 degrees but was $latDeg");
    Validate.inclusiveBetween(-180, 180, longDeg,
        "Longitude must be between -180 and 180 degrees but was $longDeg");
    Validate.inclusiveBetween(0.0, 60.0, _latMin,
        "Latitude minutes must be between 0 and 60 but was $_latMin");
    Validate.inclusiveBetween(0.0, 60.0, _longMin,
        "Longitude minutes must be between 0 and 60 but was $_longMin");
    _latDeg = latDeg;
    _longDeg = longDeg;

    _latSign = _latDeg >= 0 ? LatSign.N : LatSign.S;
    _longSign = _longDeg >= 0 ? LongSign.E : LongSign.W;
  }

  LatLong.fromDoubles(double latitude, double longitude) {
    Validate.inclusiveBetween(-90.0, 90.0, latitude,
        "Latitude must be between -90 and 90 degrees but was $latitude");
    Validate.inclusiveBetween(-180.0, 180.0, longitude,
        "Longitude must be between -90 and 90 degrees but was $longitude");
    var absLat = latitude.abs();
    _latDeg = (absLat.floor() * latitude.sign).toInt();
    _latMin = (absLat - absLat.floor()) * 60;
    _latSign = latitude >= 0 ? LatSign.N : LatSign.S;

    var absLong = longitude.abs();
    _longDeg = (absLong.floor() * longitude.sign).toInt();
    _longMin = (absLong - absLong.floor()) * 60;
    _longSign = longitude >= 0 ? LongSign.E : LongSign.W;
  }

  String getLatString() {
    var absLatDeg = _latDeg.abs();
    return "$absLatDeg° $latMin' $_latSign";
  }

  String getLongString() {
    var absLongDeg = _longDeg.abs();
    return "$absLongDeg° $longMin' $_longSign";
  }

  double getLatDecimal() {
    double minDecimal = _latMin / 60;
    double latDecimal = _latDeg.abs() + minDecimal;
    if (_latSign == LatSign.N) {
      return latDecimal;
    } else {
      return -latDecimal;
    }
  }

  double getLongDecimal() {
    double minDecimal = _longMin / 60;
    double longDecimal = _longDeg.abs() + minDecimal;
    if (_longSign == LongSign.W) {
      return -longDecimal;
    } else {
      return longDecimal;
    }
  }

  double get longMin => _longMin;

  set longMin(double value) {
    Validate.inclusiveBetween(0.0, 60.0, value,
        "Longitude minutes must be between 0 and 60 but was $value");
    _longMin = value;
  }

  int get longDeg => _longDeg;

  set longDeg(int value) {
    Validate.inclusiveBetween(-180, 180, value,
        "Longitude must be between -180 and 180 degrees but was $value");
    _longDeg = value;
    _longSign = value > 0 ? LongSign.E : LongSign.W;
  }

  double get latMin => _latMin;

  set latMin(double value) {
    Validate.inclusiveBetween(0.0, 60.0, value,
        "Latitude minutes must be between 0 and 60 but was $value");
    _latMin = value;
  }

  int get latDeg => _latDeg;

  set latDeg(int value) {
    Validate.inclusiveBetween(-90, 90, value,
        "Latitude must be between -90 and 90 degrees but was $value");
    _latDeg = value;
    _latSign = value > 0 ? LatSign.N : LatSign.S;
  }

  LatSign get latSign => _latSign;

  set latSign(LatSign value) {
    if (value == LatSign.N) {
      _latDeg = _latDeg.abs();
      _latSign = LatSign.N;
    } else {
      _latDeg = -1 * _latDeg.abs();
      _latSign = LatSign.S;
    }
  }

  LongSign get longSign => _longSign;

  set longSign(LongSign value) {
    if (value == LongSign.E) {
      _longDeg = _longDeg.abs();
      _longSign = LongSign.E;
    } else {
      _longDeg = -1 * _longDeg.abs();
      _longSign = LongSign.W;
    }
  }
}

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
