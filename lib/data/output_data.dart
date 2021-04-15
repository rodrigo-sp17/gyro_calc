import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:spa/spa.dart';

import 'input_data.dart';

class OutputData {
  OutputData(this.inputData);

  InputData inputData;
  String lha;
  String gha;
  double magDeclination;
  double gyroHdg;
  double magHdg;
  double magError;
  double gyroError;

  double _getGHA(DateTime time, double longitude) {
    var hourDeg = time.hour * 15;
    var minDeg = time.minute;

  }

  double _getLHA() {

  }

  double getSunDeclination() {
    var dateTime = inputData.getDateTime();
    var diff = dateTime.difference(DateTime(dateTime.year, 1, 1));
    var dayOfYear = diff.inDays - 1;
    return -23.44 * cos(degToRadian(360.0/365 * (dayOfYear + 10)));
  }

  double getGyroError(double gyroBearing) {
    return gyroBearing - inputData.azimuth;
  }

  _getOutputData(InputData inputData) {
    var output = spaCalculate(SPAParams(
        time: inputData.getDateTime(),
        longitude: inputData.getLongDecimal(),
        latitude: inputData.getLatDecimal()));
  }

  void updateErrors(double gyroHdg, double magHdg) {

  }
}