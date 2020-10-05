import 'package:classapp/components/student_list_item.dart';
import 'package:classapp/models/student.dart';
import 'package:classapp/screens/register_new_student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllStudents extends StatefulWidget {
  AllStudents({Key key}) : super(key: key);

  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  final students = Student();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (contex) {
            return RegisterStudent();
          }));
        },
        backgroundColor: Colors.indigo[400],
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: BackButton(),
        elevation: 0,
        title: Text("All Students"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PageHeader("All Students"),
              Expanded(
                child: StreamBuilder(
                    stream: students.studentsStream,
                    builder: (context, stream) {
                      if (stream.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (stream.hasError) {
                        return Center(
                          child: Text("An error ocurred :("),
                        );
                      }

                      if (stream.hasData) {
                        QuerySnapshot querySnapshot = stream.data;
                        if (querySnapshot.size < 1) {
                          return Center(
                            child: Text("No Students registered yet. \nClick plus icon below to register new students.",textAlign: TextAlign.center,),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 32),
                          child: ListView.builder(
                              itemCount: querySnapshot.size,
                              itemBuilder: (context, index) {
                                final doc = querySnapshot.docs[index].data();
                                final id = querySnapshot.docs[index].id;
                                return Row(
                                  children: [
                                    Flexible(
                                      flex: 12,
                                      child: StudentListItem(
                                        doc["name"] ?? "---",
                                        id,
                                        grade: doc['grade'] != null
                                            ? doc['grade'].toString()
                                            : "",
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red[200],
                                      ),
                                      onPressed: () =>
                                          Student.delete(id),
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.blue[200],
                                        ),
                                        onPressed: null)
                                  ],
                                );
                              }),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
