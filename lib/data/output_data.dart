import 'dart:convert';
import 'dart:math';

import 'package:gyro_error/bearing_calc.dart';
import 'package:gyro_error/data/lat_long.dart';
import 'package:latlong/latlong.dart';
import 'package:spa/spa.dart';
import 'package:http/http.dart' as http;

import 'input_data.dart';

class OutputData {
  DateTime _dateTime;
  double _gyroAzimuth;
  LatLong _position;

  double _gyroHdg = 0.0;
  double _magHdg = 0.0;

  String lha;
  String gha;

  double sunDeclination;
  double trueAzimuth;
  double _magDeclination;

  double magError;
  double gyroError;

  OutputData(InputData inputData) {
    _dateTime = inputData.getDateTime();
    _gyroAzimuth = inputData.azimuth;
    _position = inputData.position;

    var inter = new SPAIntermediate();
    var output = _getOutputData(inputData, inter);

    this.sunDeclination = inter.delta;
    this.trueAzimuth = output.azimuth;
    this.lha = decimal2sexagesimal(inter.h);
    this.gha = _getGHA(inter.h, inputData.position.getLongDecimal());

    var gyroErr = _calculateGyroError(output.azimuth, inputData.azimuth);
    this.gyroError = gyroErr;
    this._magDeclination = 0.0;

    // A placeholder magnetic declination of 0,0 is used to allow async fetching
    // on getter, enabling loading disks on view
    this.magError = _calculateMagError(_gyroHdg, gyroErr, _magHdg, 0.0);
  }

  DateTime get dateTime => _dateTime;
  double get gyroAzimuth => _gyroAzimuth;
  LatLong get position => _position;

  double get magHdg => _magHdg;

  set magHdg(double value) {
    _magHdg = value;
    _recalculate(_gyroHdg, value);
  }

  double get gyroHdg => _gyroHdg;

  set gyroHdg(double value) {
    _gyroHdg = value;
    _recalculate(value, _magHdg);
  }

  double get magDeclination => _magDeclination;

  set magDeclination(double value) {
    _magDeclination = value;
    _recalculate(_gyroHdg, _magHdg);
  }

  Future<double> fetchMagDeclination() async {
    final response = await http.get(Uri.https(
            "www.ngdc.noaa.gov",
            "geomag-web/calculators/calculateDeclination",
            {
              "lat1": _position.getLatDecimal().toString(),
              "lon1": _position.getLongDecimal().toString(),
              "startYear": _dateTime.year.toString(),
              "startMonth": _dateTime.month.toString(),
              "resultFormat": "json"
            }
    ));

    if (response.statusCode == 200) {
       Map<String, dynamic> json = jsonDecode(response.body);
       double declination = (json['result'].first)['declination'];
       _magDeclination = declination;
       return declination;
    } else {
      return _magDeclination;
    }
  }

  String _getGHA(double lha, double longitude) {
    double gha;
    gha = lha - longitude;
    return decimal2sexagesimal(gha);
  }

  double _calculateGyroError(
      double trueAzimuth,
      double gyroAzimuth) {
    return BearingCalc.getBearingDiff(trueAzimuth, gyroAzimuth);
  }

  double _calculateMagError(
      double gyroHdg,
      double gyroError,
      double magHdg,
      double magDeclination,
      ) {
    var trueHdg = normalizeBearing(gyroHdg + (gyroError * -1));
    var correctedMagHdg = normalizeBearing(magHdg + magDeclination);
    return BearingCalc.getBearingDiff(trueHdg, correctedMagHdg);
  }

  void _recalculate(double gyroH, double magH) {
    this.magError = _calculateMagError(gyroH, gyroError, magH, _magDeclination);
  }

  SPAOutput _getOutputData(InputData inputData, SPAIntermediate intermediate) {
    return spaCalculate(SPAParams(
        time: inputData.getDateTime(),
        longitude: inputData.position.getLongDecimal(),
        latitude: inputData.position.getLatDecimal()),
        intermediate: intermediate);
  }

}