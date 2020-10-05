import 'package:classapp/models/test.dart';
import 'package:classapp/screens/test_score_submit.dart';
import 'package:flutter/material.dart';
import 'create_new_test.dart';

class Tests extends StatefulWidget {
  Tests({Key key}) : super(key: key);

  @override
  _TestsState createState() => _TestsState();
}

class _TestsState extends State<Tests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: GridView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 3,
                ),
                children: [
                  FlatButton(
                    onPressed: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return CreateNewTest();
                      }))
                    },
                    child: Text("New Test"),
                  ),
                  FlatButton(
                    onPressed: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return CreateNewTest();
                      }))
                    },
                    child: Text("All"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SubmitTestScores("nxO0dZ8eD8O6Q3mFabXi");
                      }));
                      // Test.getTest("nxO0dZ8eD8O6Q3mFabXi");
                    },
                    child: Text("Categories"),
                  )
                ],
              ),
            ),
          ),
          Text("Up coming tests"),
          FutureBuilder(
              future: Test.getUpcomingTests(),
              builder: (context, AsyncSnapshot<List<Test>> snapshots) {
                if (snapshots.hasData) {
                  if (snapshots.data.length < 1) {
                    return Center(child: Text("No Upcoming Tests"));
                  }
                  List<Test> upcomingTests = snapshots.data;
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 20,
                      maxHeight: 600,
                    ),
                    child: ListView.builder(
                        itemCount: upcomingTests.length,
                        itemBuilder: (context, index) {
                          return Text(upcomingTests[index].title);
                        }),
                  );
                }
                if (snapshots.hasError) {
                  return Center(
                    child: Text("Something went wrong"),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              })
        ]),
      ),
    );
  }
}

//create new test
//upcoming tests
//submit test scores
//Performance of classes
