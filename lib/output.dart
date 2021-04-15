import 'package:flutter/material.dart';
import 'package:gyro_error/data/output_data.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:spa/spa.dart';

import 'data/input_data.dart';

class OutputPage extends StatefulWidget {
  OutputPage({Key key, this.title, @required this.inputData}) : super(key: key);
  final String title;
  final InputData inputData;

  @override
  _OutputPageState createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  OutputData outputData;

  var azFormatter = new MaskTextInputFormatter(
      mask: '###.#',
      filter: { "#": RegExp(r'[0-9]') }
  );

  final _lhaController = TextEditingController();
  final _ghaController = TextEditingController();
  final _sunDecController = TextEditingController();
  final _trueAzController = TextEditingController();
  final _gyroAzController = TextEditingController();
  final _gyroHdgController = TextEditingController();
  final _magHdgController = TextEditingController();
  final _magDecController = TextEditingController();
  final _gyroErrorController = TextEditingController();
  final _magErrorController = TextEditingController();


  @override
  void initState() {
    outputData = OutputData(widget.inputData);
    _lhaController.text = '252 deg 54.1\'';
    _ghaController.text = 'Some degree';
    _sunDecController.text = outputData.getSunDeclination().toStringAsFixed(2);
    _trueAzController.text = widget.inputData.azimuth.toStringAsFixed(1);
    _gyroAzController.text = outputData.inputData.azimuth.toString();
    _gyroHdgController.text = 000.0.toString();
    _magHdgController.text = 000.0.toString();
    _gyroErrorController.text = outputData.getGyroError(123.0)
        .toString();
    _magErrorController.text = 000.0.toString();
  }

  @override
  void dispose() {
    _lhaController.dispose();
    _ghaController.dispose();
    _sunDecController.dispose();
    _trueAzController.dispose();
    _gyroAzController.dispose();
    _gyroHdgController.dispose();
    _magHdgController.dispose();
    _magDecController.dispose();
    _gyroErrorController.dispose();
    _magErrorController.dispose();
    super.dispose();
  }

  String _validateGyroHdg(String value) {
/*    if (value.length != 5) {
      return 'Heading format must be 000.0';
    }*/
    var hdg = double.tryParse(value);
    if (hdg == null || hdg < 0 || hdg >= 360) {
      return 'Invalid heading';
    }
    return null;
  }

  String _validateMagHdg(String value) {
/*    if (value.length != 5) {
      return 'Heading format must be 000.0';
    }*/
    var hdg = double.tryParse(value);
    if (hdg == null || hdg < 0 || hdg >= 360) {
      return 'Invalid heading';
    }
    return null;
  }

  void _updateValues() {
    print('updating values...');
  }


  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 15);

    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 12),
        child: Scrollbar(
            child: ListView(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              children: [
                TextField(
                  controller: _lhaController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'LHA'
                  ),
                ),
                sizedBox,
                TextField(
                  controller: _ghaController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'GHA'
                  ),
                ),
                sizedBox,
                TextField(
                  controller: _sunDecController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sun Declination'
                  ),
                ),
                Divider(
                  height: 40,
                  thickness: 5,
                  indent: 20,
                  endIndent: 20,
                ),
                TextField(
                  controller: _trueAzController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sun True Bearing'
                  ),
                ),
                sizedBox,
                TextField(
                  controller: _gyroAzController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sun Gyro Bearing',
                      suffixText: '°'
                  ),
                ),
                sizedBox,
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: _gyroHdgController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            filled: true,
                            labelText: 'Gyro HDG',
                            suffixText: '°'
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [azFormatter],
                        validator: _validateGyroHdg,
                        onFieldSubmitted: (value) {
                          if (_validateGyroHdg(value) == null) {
                            setState(() {
                              _gyroHdgController.text = double.parse(value)
                                  .toStringAsFixed(1).padLeft(5, '0');
                            });
                            _updateValues();
                          }
                        },

                      ),
                    ),
                    SizedBox(width: 20,),
                    Flexible(
                      child: TextFormField(
                        controller: _magHdgController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            filled: true,
                            labelText: 'Magnetic HDG',
                            suffixText: '°'
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [azFormatter],
                        validator: _validateMagHdg,
                        onFieldSubmitted: (value) {
                          if (_validateMagHdg(value) == null) {
                            setState(() {
                              _magHdgController.text = double.parse(value)
                                  .toStringAsFixed(1).padLeft(5, '0');
                            });
                            _updateValues();
                          }
                        },
                      ),
                    )
                  ],
                ),
                sizedBox,
                TextField(
                  controller: _magDecController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Magnetic Declination',
                      suffixText: '°'
                  ),
                ),
                sizedBox,
                TextField(
                  controller: _gyroErrorController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Gyro Error',
                      suffixText: '°'
                  ),
                ),
                sizedBox,
                TextField(
                  controller: _magErrorController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Magnetic Error',
                      suffixText: '°'
                  ),
                )
              ],
          )
        )
      )
    );
  }

}

