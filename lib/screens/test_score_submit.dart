import 'package:flutter/material.dart';

class SubmitTestScores extends StatefulWidget {
  final testId;
  SubmitTestScores(this.testId, {Key key}) : super(key: key);

  @override
  _SubmitTestScoresState createState() => _SubmitTestScoresState();
}

class _SubmitTestScoresState extends State<SubmitTestScores> {
  bool singleSubmitView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                setState(() {
                  singleSubmitView = !singleSubmitView;
                });
              })
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: Container(
              child: Text("Filters"),
            ),
            flex: 2,
          ),
          Flexible(
            child: singleSubmitView
                ? Container(child: Text("Single Submit View"))
                : Container(child: Text("All List")),
          )
        ],
      ),
    );
  }
}
