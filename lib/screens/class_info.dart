import 'package:classapp/components/button.dart';
import 'package:classapp/screens/add_remove_students.dart';
import 'package:classapp/screens/class_fees.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassInfo extends StatelessWidget {
  final className;
  final time;
  final description;
  final id;

  const ClassInfo(this.className, this.id,
      {Key key, this.time, this.description})
      : super(key: key);

  Future<List<QueryDocumentSnapshot>> getClassFeesInfo(String classId) async {
    debugPrint("Class id " + classId);
    Query query = FirebaseFirestore.instance
        .collection("class_fees")
        .doc(classId)
        .collection(DateTime.now().month.toString());

    var feesSnapshot = await query.get();

    if (feesSnapshot.docs.isEmpty) {
      debugPrint("No previous fees collection found");
      //get all the students for current class
      final students = await FirebaseFirestore.instance
          .collection("class_students")
          .doc(classId.toString())
          .collection("all")
          .get();

      debugPrint("No. of students in this class " + students.docs.length.toString());
      debugPrint("No. of students in this class " + students.docs.toString());

      //Copy all the students to classfees-month collection
      final batch = FirebaseFirestore.instance.batch();
      debugPrint("Creating batch");
      students.docs.forEach((student) {
        batch.set(
          FirebaseFirestore.instance
              .collection('class_fees')
              .doc(classId)
              .collection('all')
              .doc(DateTime.now().month.toString()),
          {
            'name': student.data()['name'],
            'id': student.data()['id'],
            'paid': false
          },
        );
      });
      debugPrint("Commiting batch");
      await batch.commit();
      debugPrint("Batch committed");

      feesSnapshot = await query.get();
    }
    debugPrint("returning ");
    return feesSnapshot.docs.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(className),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              className,
              style: TextStyle(
                fontSize: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              "Saturday 8.00am - 10.00am TODO",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                description ?? "",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: GridView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 3,
                ),
                children: [
                  Button(
                    text: "Mark Attendence",
                    action: null,
                  ),
                  Button(
                    text: "Prev. Attendences",
                    action: null,
                  ),
                  // Button(
                  //   text: "Add/Remove",
                  //   action: null,
                  // ),
                  FlatButton(
                    onPressed: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AddRemoveStudents(id);
                      }))
                    },
                    child: Text("Add/Remove"),
                  ),
                  FlatButton(
                      onPressed: () async {
                        // final info = await getClassFeesInfo(id.toString());
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ClassFees(id,className: className,);
                        }));
                      },
                      child: Text("Fees"))
                  // Button(
                  //   text: "Fees",
                  //   action: null,
                  // ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    //Class fees
                    //Class days
                    //No of students
                    //Class fees received for current month
                    //Total class fees all the time
                    //
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
