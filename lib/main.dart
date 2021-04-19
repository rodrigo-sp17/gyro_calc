// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyro_calc/view/input.dart';

void main() => runApp(GyroCalcApp());

class GyroCalcApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gyro Calc',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: InputPage(title: 'Inputs for Calculation'));
  }
}
