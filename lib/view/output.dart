import 'package:flutter/material.dart';
import 'package:gyro_calc/data/lat_long.dart';
import 'package:gyro_calc/data/output_data.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../data/input_data.dart';

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
  bool _isFetchingMagDec = false;
  LongSign _magDecSign;
  final _gyroErrorController = TextEditingController();
  final _magErrorController = TextEditingController();


  @override
  void initState() {
    super.initState();
    outputData = OutputData(widget.inputData);
    _lhaController.text = outputData.lha;
    _ghaController.text = outputData.gha;
    _sunDecController.text = outputData.getSunDeclAsString();
    _trueAzController.text = outputData.trueAzimuth.toStringAsFixed(1);
    _gyroAzController.text = outputData.gyroAzimuth.toStringAsFixed(1);
    _gyroHdgController.text = outputData.gyroHdg.toStringAsFixed(1);
    _magHdgController.text = outputData.magHdg.toStringAsFixed(1);
    _magDecController.text = outputData.magDeclination.abs().toStringAsFixed(1);
    _magDecSign = outputData.magDeclination.isNegative ? LongSign.W : LongSign.E;
    _fetchMagDeclination();
    _gyroErrorController.text = outputData.getGyroErrorAsString();
    _magErrorController.text = outputData.getMagErrorAsString();
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

  void _fetchMagDeclination() {
    setState(() {
      _isFetchingMagDec = true;
    });
    var magDeclination = outputData.fetchMagDeclination();
    magDeclination.then((value) => {
      _magDecController.text = value.abs().toStringAsFixed(1),
      _magDecSign = value.isNegative ? LongSign.W : LongSign.E,
      this._handleDataChanges()
    });
    magDeclination.whenComplete(() => this.setState(() {
      _isFetchingMagDec = false;
    }));
  }

  String _validateHdg(String value) {
    var hdg = double.tryParse(value);
    if (hdg == null || hdg < 0 || hdg >= 360) {
      return 'Invalid heading';
    }
    return null;
  }

  String _validateMagDecl(String value) {
    var decl = double.tryParse(value);
    if (decl == null || decl < 0 || decl > 360) {
      return 'Invalid declination';
    }
    return null;
  }

  void _handleDataChanges() {
    setState(() {
      _magErrorController.text = outputData.getMagErrorAsString();
    });
  }

  void _handleMagDecChanges(String value) {
    if (_validateMagDecl(value) == null) {
      var dec = double.parse(value);
      setState(() {
        _magDecController.text = dec.toStringAsFixed(1)
            .padLeft(5, '0');
        outputData.magDeclination =
        _magDecSign == LongSign.E ? dec.abs() : dec.abs() * -1;
      });
      _handleDataChanges();
    }
  }

  void _handleMagDecSign() {
    var sign;
    if (_magDecSign == LongSign.E) {
      sign = LongSign.W;
    } else {
      sign = LongSign.E;
    }
    setState(() {
      _magDecSign = sign;
    });
    _handleMagDecChanges(_magDecController.text);
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
                      labelText: 'LHA (Approx.)'
                  ),
                ),
                sizedBox,
                TextField(
                  controller: _ghaController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'GHA (Approx.)'
                  ),
                ),
                sizedBox,
                TextField(
                  controller: _sunDecController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sun Declination',
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
                      labelText: 'Sun True Bearing',
                      suffixText: '°'
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
                        validator: _validateHdg,
                        onFieldSubmitted: (value) {
                          if (_validateHdg(value) == null) {
                            var hdg = double.parse(value);
                            setState(() {
                              _gyroHdgController.text = hdg.toStringAsFixed(1)
                                  .padLeft(5, '0');
                              outputData.gyroHdg = hdg;
                            });
                            _handleDataChanges();
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
                        validator: _validateHdg,
                        onFieldSubmitted: (value) {
                          if (_validateHdg(value) == null) {
                            var hdg = double.parse(value);
                            setState(() {
                              _magHdgController.text = hdg.toStringAsFixed(1)
                                  .padLeft(5, '0');
                              outputData.magHdg = hdg;
                            });
                            _handleDataChanges();
                          }
                        },
                      ),
                    )
                  ],
                ),
                sizedBox,
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        controller: _magDecController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            filled: true,
                            labelText: 'Magnetic Declination',
                            suffixText: '°'
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [azFormatter],
                        validator: _validateMagDecl,
                        onFieldSubmitted: _handleMagDecChanges,
                      )
                    ),
                    SizedBox(width: 20,),
                    ElevatedButton(
                        onPressed: _handleMagDecSign,
                        child: Text(_magDecSign.value)
                    ),
                    Visibility(
                      visible: _isFetchingMagDec,
                      child: Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: CircularProgressIndicator(
                            value: null,
                          )
                        )
                      )
                    )
                  ],
                ),
                sizedBox,
                TextField(
                  controller: _gyroErrorController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Gyro Error',
                  ),
                ),
                sizedBox,
                TextField(
                  controller: _magErrorController,
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Magnetic Error',
                  ),
                )
              ],
          )
        )
      )
    );
  }

}

