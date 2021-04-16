import 'dart:math';

import 'package:gyro_error/bearing_calc.dart';
import 'package:gyro_error/data/lat_long.dart';
import 'package:latlong/latlong.dart';
import 'package:spa/spa.dart';

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
  double magDeclination;
  double magError;
  double gyroError;

  OutputData(InputData inputData) {
    _dateTime = inputData.getDateTime();
    _gyroAzimuth = inputData.azimuth;
    _position = inputData.position;
    this.sunDeclination = _getSunDeclination();

    var inter = new SPAIntermediate();
    var output = _getOutputData(inputData, inter);

    this.trueAzimuth = output.azimuth;
    this.lha = decimal2sexagesimal(inter.h);
    this.gha = _getGHA(inter.h, inputData.position.getLongDecimal());

    var gyroErr = _calculateGyroError(output.azimuth, inputData.azimuth);
    this.gyroError = gyroErr;
    var magDecl = _getMagDeclination();
    this.magDeclination = magDecl;
    this.magError = _calculateMagError(_gyroHdg, gyroErr, _magHdg, magDecl);
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

  String _getGHA(double lha, double longitude) {
    double gha;
    if (longitude < 0) {
      gha = lha + longitude;
    } else {
      gha = lha - longitude;
    }
    return decimal2sexagesimal(gha);
  }

  double _getSunDeclination() {
    var diff = _dateTime.difference(DateTime(_dateTime.year, 1, 1));
    var dayOfYear = diff.inDays - 1;
    return -23.44 * cos(degToRadian(360.0/365 * (dayOfYear + 10)));
  }

  double _getMagDeclination() {
    return 0.0; // TODO
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
    var trueHdg = normalizeBearing(gyroHdg + gyroError);
    var correctedMagHdg = normalizeBearing(magHdg + magDeclination);
    return BearingCalc.getBearingDiff(trueHdg, correctedMagHdg);
  }

  void _recalculate(double gyroH, double magH) {
    this.magError = _calculateMagError(gyroH, gyroError, magH, magDeclination);
  }

  SPAOutput _getOutputData(InputData inputData, SPAIntermediate intermediate) {
    return spaCalculate(SPAParams(
        time: inputData.getDateTime(),
        longitude: inputData.position.getLongDecimal(),
        latitude: inputData.position.getLatDecimal()),
        intermediate: intermediate);
  }

}