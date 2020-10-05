import 'package:classapp/components/student_list_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddRemoveStudents extends StatefulWidget {
  final id;
  final className;

  AddRemoveStudents(this.id, {Key key, this.className}) : super(key: key);

  @override
  _AddRemoveStudentsState createState() => _AddRemoveStudentsState();
}

class _AddRemoveStudentsState extends State<AddRemoveStudents> {
  List<QueryDocumentSnapshot> searchResult = new List<QueryDocumentSnapshot>();
  final searchTextController = new TextEditingController();
  var inClass = new List<Map>();
  var newStudents = new List<Map>();
  var inClassIds = new List<String>();

  searchStudents() async {
    final result = await FirebaseFirestore.instance
        .collection("students")
        .where('name', isGreaterThanOrEqualTo: searchTextController.value.text)
        .limit(10)
        .get();

    setState(() {
      searchResult = result.docs;
    });
  }

  addStudentToClass(String name, String id) {
    var data = {'name': name, 'id': id};
    setState(() {
      debugPrint("Adding Student");
      inClass.add(data);
      newStudents.add(data);
      inClassIds.add(id);
      debugPrint("Added");
    });
  }

  getStudentsInClass() async {
    //Get students
    debugPrint("Ela");
    final snapshots = await FirebaseFirestore.instance
        .collection("class_students")
        .doc(widget.id)
        .collection("all")
        .get();

    //Set State
    if (mounted) {
      setState(() {
        //Insert into inClass
        inClass = snapshots.docs
            .map((doc) => ({'name': doc.data()['name'], 'id': doc.id}))
            .toList();

        //Insert into inClassIds
        inClassIds = snapshots.docs.map((doc) => (doc.id)).toList();
      });
    }
  }

  submitChanges() {
    //TODO reset <newStudents>
    final batch = FirebaseFirestore.instance.batch();

    for (var student in newStudents) {
      batch.set(
          FirebaseFirestore.instance
              .collection('class_students')
              .doc(widget.id)
              .collection("all")
              .doc(student['id']),
          {'name': student['name']});
    }

    batch.commit();
    debugPrint("Done");
  }

  removeStudentFromClass(String id) {
    setState(() {
      inClass.removeWhere((student) => student['id'] == id);
      inClassIds.retainWhere((stdId) => stdId == id);
    });
  }

  @override
  void initState() {
    getStudentsInClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var searchBar = Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            children: [
              Flexible(
                flex: 5,
                child: TextField(
                  controller: searchTextController,
                  decoration: InputDecoration(
                    hintText: ' Search Students',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: FlatButton(
                  onPressed: () => searchStudents(),
                  child: Text("Search"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    var searchResults = Flexible(
      flex: 1,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height,
        child: searchResult.length < 1
            ? Center(
                child: Text("Search students to add to class"),
              )
            : ListView.builder(
                itemCount: searchResult.length,
                itemBuilder: (context, index) {
                  // return Text(searchResult[index].data()['name']);
                  final student = searchResult[index].data();
                  final id = searchResult[index].id;
                  final alreadyIn = inClassIds.contains(id);
                  return StudentListItem(
                    student['name'] ?? "---NO NAME---",
                    id,
                    bgColor: alreadyIn ? Colors.grey[300] : null,
                    grade: student['grade'],
                    onClick: () => alreadyIn
                        ? null
                        : addStudentToClass(
                            student['name'],
                            id,
                          ),
                  );
                },
              ),
      ),
    );
    var alreadyInClassPane = Flexible(
      flex: 1,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        color: Colors.grey[100],
        height: MediaQuery.of(context).size.height,
        child: inClass.length < 1
            ? Center(
                child: Text("No studets in this class"),
              )
            : ListView.builder(
                itemCount: inClass.length,
                itemBuilder: (context, index) {
                  return StudentListItem(
                      inClass[index]['name'], inClass[index]['id']);
                }),
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
          context: context,
          builder: (contex) {
            return AlertDialog(
              content: Text("Save Changes ?"),
              actions: [
                FlatButton(
                  onPressed: () {
                    submitChanges();
                    return Navigator.of(context).pop(true);
                  },
                  child: Text("Save and Exit"),
                ),
                FlatButton(
                  onPressed: () {
                    return Navigator.of(context).pop(true);
                    // Navigator.pop(context, true);
                  },
                  child: Text("Exit without saving"),
                ),
                FlatButton(
                  onPressed: () {
                    return Navigator.pop(context, false);
                  },
                  child: Text("Cancel"),
                )
              ],
            );
          },
        );
        return value;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () => submitChanges(),
            )
          ],
        ),
        body: Column(
          children: [
            searchBar,
            Flexible(
              flex: 10,
              child: Row(
                children: [
                  searchResults,
                  alreadyInClassPane,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
