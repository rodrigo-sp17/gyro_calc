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
}

enum LatSign { N, S }
enum LongSign { W, E }