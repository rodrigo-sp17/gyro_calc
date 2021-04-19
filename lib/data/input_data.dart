import 'dart:math';

import 'package:gyro_calc/data/lat_long.dart';

class InputData {
  DateTime date = DateTime.now().toUtc();
  DateTime time = DateTime.now().toUtc();
  LatLong position = LatLong(0, 0 ,0, 0);
  double azimuth = 0.0;

  DateTime getDateTime() {
    return DateTime.utc(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
        time.second);
  }
}


