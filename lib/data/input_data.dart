import 'dart:math';

import 'package:latlong/latlong.dart';

import 'lat_sign.dart';
import 'long_sign.dart';

class InputData {
  DateTime date = DateTime.now();
  DateTime time = DateTime.now();
  int latDeg = 0;
  double latMin = 0;
  LatSign latSign = LatSign.S;
  int longDeg = 0;
  double longMin = 0;
  LongSign longSign = LongSign.W;
  double azimuth = 0.0;

  String getLatString() {
    return "$latDeg° $latMin' $latSign";
  }

  String getLongString() {
    return "$longDeg° $longMin' $longSign";
  }

  double getLatDecimal() {
    double minDecimal = latMin.abs() / 60;
    double latDecimal = latDeg.abs() + minDecimal;
    if (latSign == LatSign.N) {
      return latDecimal;
    } else {
      return -latDecimal;
    }
  }

  double getLongDecimal() {
    double minDecimal = longMin.abs() / 60;
    double longDecimal = longDeg.abs() + minDecimal;
    if (longSign == LongSign.W) {
      return -longDecimal;
    } else {
      return longDecimal;
    }
  }

  DateTime getDateTime() {
    return DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
        time.second);
  }



}


