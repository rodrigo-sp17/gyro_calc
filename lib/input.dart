import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gyro_error/output.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:latlong/latlong.dart';

import 'data/input_data.dart';
import 'data/lat_sign.dart';
import 'data/long_sign.dart';

class InputPage extends StatefulWidget {
  InputPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const InputForm(),
    );
  }
}

class InputForm extends StatefulWidget {
  const InputForm({Key key}) : super(key: key);

  @override
  InputFormState createState() => InputFormState();
}

class InputFormState extends State<InputForm> {
  InputData inputData = new InputData();

  final timeTemplate = DateFormat("HH:mm:ss");

  var timeFormatter = new MaskTextInputFormatter(
      mask: '##:##:##',
      filter: { "#": RegExp(r'[0-9]') });

  var minFormatter = new MaskTextInputFormatter(
    mask: '##.###',
    filter: { "#": RegExp(r'[0-9]') }
  );

  var azFormatter = new MaskTextInputFormatter(
    mask: '###.#',
    filter: { "#": RegExp(r'[0-9]') }
  );

  FocusNode _date, _time, _latDeg, _latMin, _longDeg, _longMin, _az;

  final _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _date = FocusNode();
    _time = FocusNode();
    _latDeg = FocusNode();
    _latMin = FocusNode();
    _longDeg = FocusNode();
    _longMin = FocusNode();
    _az = FocusNode();
    _timeController.text = timeTemplate.format(inputData.time);
  }

  @override
  void dispose() {
    _date.dispose();
    _time.dispose();
    _latDeg.dispose();
    _latMin.dispose();
    _longDeg.dispose();
    _longMin.dispose();
    _az.dispose();
    _timeController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      // calculate form
      log('Calculating data');
      log(inputData.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OutputPage(inputData: inputData))
      );
    }
  }

  String _validateLatDeg(String value) {
    try {
      int lat = int.parse(value);
      if (lat < 0 || lat > 90) {
        return 'Invalid latitude degrees';
      }
      return null;
    } on FormatException {
      return 'Invalid latitude';
    }
  }

  String _validateLatMin(String value) {
    try {
      double min = double.parse(value);
      if (min < 0 || min >= 60) {
        return 'Invalid latitude minutes';
      }
      return null;
    } on FormatException {
      return 'Invalid latitude minutes';
    }
  }

  String _validateLongDeg(String value) {
    try {
      int deg = int.parse(value);
      if (deg < 0 || deg > 180) {
        return 'Invalid longitude degrees';
      }
    } on FormatException {
      return 'Invalid longitude degrees';
    }
    return null;
  }

  String _validateLongMin(String value) {
    try {
      double min = double.parse(value);
      if (min < 0 || min >= 60) {
        return 'Invalid longitude minutes';
      }
    } on FormatException {
      return 'Invalid longitude minutes';
    }
    return null;
  }

  String _validateTime(String value) {
    final timeExp = RegExp(r'^\d\d:\d\d:\d\d$');
    if (!timeExp.hasMatch(value)) {
      return "Invalid time format";
    }

    try {
      var parsed = timeTemplate.parse(value);
      if (parsed.hour >= 24) {
        return "Invalid time";
      }
    } on FormatException {
      return "Invalid time";
    }

    return null;
  }

  String _validateAz(String value) {
    try {
      double az = double.parse(value);
      if (az < 0 || az >= 360) {
        return 'Azimuth must be between 0 and 359.5';
      }
    } on FormatException {
      return 'Azimuth must be between 0 and 359.5';
    }
    return null;
  }

  void _handleLatSign() {
    if (inputData.latSign == LatSign.S) {
      setState(() {
        inputData.latSign = LatSign.N;
      });
    } else {
      setState(() {
        inputData.latSign = LatSign.S;
      });
    }
  }

  void _handleLongSign() {
    LongSign result;
    if (inputData.longSign == LongSign.W) {
      result = LongSign.E;
    } else {
      result = LongSign.W;
    }
    setState(() {
      inputData.longSign = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 15);
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Scrollbar(
        child: ListView(
          padding: EdgeInsets.only(left: 8, right: 8),
          children: [
            InputDecorator(
              decoration: InputDecoration(
                filled: true,
                icon: Icon(Icons.calendar_today),
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 2)
              ),
              child: InputDatePickerFormField(
                initialDate: inputData.date,
                firstDate: DateTime(2012, 1),
                lastDate: DateTime(2100),
                errorFormatText: 'Date not recognized',
                errorInvalidText: 'Date is invalid',
                fieldHintText: 'Enter the date for calculation',
                fieldLabelText: 'Date',
                onDateSaved: (date) {
                  setState(() {
                    inputData.date = date;
                  });
                },
              ),
            ),
            sizedBox,
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _timeController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      icon: const Icon(Icons.access_time),
                      labelText: 'Time',
                      hintText: 'Current time',
                      suffixText: 'UTC',
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validateTime,
                    inputFormatters: [timeFormatter],
                    onSaved: (value) {
                      DateTime newTime = timeTemplate.parse(value);
                      setState(() {
                        inputData.time = newTime;
                      });
                    },
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _timeController.text = timeTemplate.format(DateTime.now()
                        .toUtc());
                  },
                  child: Text('UPDATE'),
                )
              ],
            ),
            Divider(
              height: 40,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 55,
                    child: Text('LAT')
                ),
                Flexible(
                  child: TextFormField(
                    textAlign: TextAlign.end,
                    focusNode: _latDeg,
                    initialValue: inputData.latDeg.toString(),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      suffixText: '°',
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validateLatDeg,
                    inputFormatters: <TextInputFormatter>[
                      new MaskTextInputFormatter(
                        mask: "##",
                        filter: { "#": RegExp(r'[0-9]')}
                      )
                    ],
                    onSaved: (value) {
                      setState(() {
                        inputData.latDeg = int.parse(value);
                      });
                    },
                  ),
                ),
                SizedBox(width: 20),
                Flexible(
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      focusNode: _latMin,
                      initialValue: inputData.latMin.toString(),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          filled: true,
                          suffixText: '\''
                      ),
                      keyboardType: TextInputType.number,
                      validator: _validateLatMin,
                      inputFormatters: [minFormatter],
                      onSaved: (value) {
                        setState(() {
                          inputData.latMin = double.parse(value);
                        });
                      },
                    ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                    onPressed: _handleLatSign,
                    child: Text(inputData.latSign.toString().split('.').last)
                )
              ],
            ),
            sizedBox,
            Row(
              children: [
                SizedBox(
                  width: 55,
                  child: Text('LONG')
                ),
                Flexible(
                  child: TextFormField(
                    textAlign: TextAlign.end,
                    focusNode: _longDeg,
                    initialValue: inputData.longDeg.toString(),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        filled: true,
                        suffixText: '°'
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validateLongDeg,
                    inputFormatters: [
                      new MaskTextInputFormatter(
                          mask: "###",
                          filter: { "#": RegExp(r'[0-9]')}
                      )
                    ],
                    onSaved: (value) {
                      setState(() {
                        inputData.longDeg = int.parse(value);
                      });
                    },
                  ),
                ),
                SizedBox(width: 20),
                Flexible(
                  child: TextFormField(
                    textAlign: TextAlign.end,
                    focusNode: _longMin,
                    initialValue: inputData.longMin.toString(),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        filled: true,
                        suffixText: '\''
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validateLongMin,
                    inputFormatters: [minFormatter],
                    onSaved: (value) {
                      setState(() {
                        inputData.longMin = double.parse(value);
                      });
                    },
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                    onPressed: _handleLongSign,
                    child: Text(inputData.longSign.toString().split('.').last)
                )
              ],
            ),
            sizedBox,
            TextFormField(
              focusNode: _az,
              initialValue: '000.0',
              decoration: InputDecoration(
                filled: true,
                icon: const Icon(Icons.wb_sunny_outlined),
                labelText: 'Sun Gyro Heading',
                suffixText: '°'
              ),
              keyboardType: TextInputType.number,
              validator: _validateAz,
              inputFormatters: [azFormatter],
              onSaved: (value) {
                setState(() {
                  var az = double.parse(value);
                  inputData.azimuth = ((az * 2).round()) / 2;
                });
              },
            ),
            sizedBox,
            ElevatedButton(
                onPressed: _handleSubmitted,
                child: Text('CALCULATE'))
          ]
        ),
      ),
    );
  }
 
}


