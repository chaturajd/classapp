import 'package:classapp/components/info_list_item.dart';
import 'package:classapp/models/classroom.dart';
import 'package:classapp/screens/class_info.dart';
import 'package:classapp/screens/create_new_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyClasses extends StatefulWidget {
  MyClasses({Key key}) : super(key: key);

  @override
  _MyClassesState createState() => _MyClassesState();
}

class _MyClassesState extends State<MyClasses> {
  final onClickNewClass = (context) => (Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return CreateNewClass();
      })));

  List<Classroom> getClasses(String day, QuerySnapshot snapshot) {
    // debugPrint("class info "+snapshot.docs[0].data().toString());
    if (day == "all") {
      var classrooms = List<Classroom>();
      for (var doc in snapshot.docs) {
        classrooms.add(Classroom.fromJson(doc.data(), doc.id));
      }
      return classrooms;
    } else {
      return new List<Classroom>();
    }
  }

  final days = [
    'all',
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () => onClickNewClass(context),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        leading: BackButton(),
        title: Text("My Classes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DefaultTabController(
          length: 8,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: TabBar(
                    isScrollable: true,
                    tabs: [
                      for (var day in days)
                        Tab(
                          child: Text(
                            day.toUpperCase(),
                            overflow: TextOverflow.fade,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 11,
                child: Container(
                  // height: 500,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: StreamBuilder(
                    stream: Classroom.classesStream(),
                    builder: (context, stream) {
                      if (stream.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (stream.hasError) {
                        return Center(
                          child: Text("Error"),
                        );
                      }

                      QuerySnapshot querySnapshot = stream.data;

                      List<Widget> views = new List<Widget>();

                      for (var day in days) {
                        final classes = getClasses(day, querySnapshot);
                        if (classes.isEmpty) {
                          views.add(Center(
                              child: Text(
                            "No Classes on this day",
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          )));
                        } else {
                          views.add(
                            ListView.builder(
                              itemCount: classes.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ClassInfo(
                                        classes[index].name,
                                        classes[index].id,
                                      );
                                    }));
                                  },
                                  child: InfoListItem(
                                    classes[index].name,
                                    subtitle1: classes[index].description,
                                    subtitle2: classes[index].location,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }

                      return TabBarView(children: views);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
