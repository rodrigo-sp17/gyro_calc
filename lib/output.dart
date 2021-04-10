import 'package:flutter/material.dart';

import 'InputData.dart';

class OutputPage extends StatefulWidget {
  OutputPage({Key key, this.title, this.inputData}) : super(key: key);
  final String title;
  final InputData inputData;

  @override
  _OutputPageState createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: Column(
        children: [

        ],
      )
    );
  }
}