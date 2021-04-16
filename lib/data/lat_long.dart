import 'package:validate/validate.dart';

/// Class that stores Lat Long data in degrees, minutes and minute decimals
/// instead of standard representation
///
class LatLong {
  int _latDeg;
  double _latMin;
  LatSign latSign;
  int _longDeg;
  double _longMin;
  LongSign longSign;

  LatLong(int latDeg, this._latMin, int longDeg, this._longMin) {
    Validate.inclusiveBetween(-90, 90, latDeg,
        "Latitude must be between -90 and 90 degrees but was $latDeg");
    Validate.inclusiveBetween(-180, 180, longDeg,
        "Longitude must be between -180 and 180 degrees but was $longDeg");
    Validate.inclusiveBetween(0.0, 60.0, _latMin,
        "Latitude minutes must be between 0 and 60 but was $_latMin");
    Validate.inclusiveBetween(0.0, 60.0, _longMin,
        "Longitude minutes must be between 0 and 60 but was $_longMin");
    _latDeg = latDeg.abs();
    _longDeg = longDeg.abs();

    latSign = _latDeg > 0 ? LatSign.N : LatSign.S;
    longSign = _latMin > 0 ? LongSign.E : LongSign.W;
  }

  LatLong.fromDoubles(double latitude, double longitude) {
    Validate.inclusiveBetween(-90.0, 90.0, latitude,
        "Latitude must be between -90 and 90 degrees but was $latitude");
    Validate.inclusiveBetween(-180.0, 180.0, longitude,
        "Longitude must be between -90 and 90 degrees but was $longitude");
    var absLat = latitude.abs();
    _latDeg = absLat.floor();
    _latMin = (absLat - absLat.floor()) * 60;
    latSign = latitude > 0 ? LatSign.N : LatSign.S;

    var absLong = longitude.abs();
    _longDeg = absLong.floor();
    _longMin = (absLong - absLong.floor()) * 60;
    longSign = longitude > 0 ? LongSign.E : LongSign.W;
  }

  String getLatString() {
    return "$latDeg° $latMin' $latSign";
  }

  String getLongString() {
    return "$longDeg° $longMin' $longSign";
  }

  double getLatDecimal() {
    double minDecimal = latMin / 60;
    double latDecimal = latDeg + minDecimal;
    if (latSign == LatSign.N) {
      return latDecimal;
    } else {
      return -latDecimal;
    }
  }

  double getLongDecimal() {
    double minDecimal = longMin / 60;
    double longDecimal = longDeg + minDecimal;
    if (longSign == LongSign.W) {
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
    _longDeg = value.abs();
    longSign = value > 0 ? LongSign.E : LongSign.W;
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
    _latDeg = value.abs();
    latSign  = value > 0 ? LatSign.N : LatSign.S;
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