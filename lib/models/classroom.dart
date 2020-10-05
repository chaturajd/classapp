import 'dart:convert';

import 'package:classapp/models/class_schedule.dart';
import 'package:classapp/models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Classroom {
  String name;
  String id;
  String classFee;
  String location;
  String description;
  List<ClassSchedule> schedule;

  static var dbPath = FirebaseFirestore.instance.collection("classes");
  static var dbPathClassStudents =
      FirebaseFirestore.instance.collection("class_students");

  Classroom({
    this.name,
    this.id,
    this.classFee,
    this.location,
    this.description,
    this.schedule,
  });

  Classroom.fromJson(Map<String, dynamic> data, id) {
    this.id = id;
    this.description = data['description'];
    this.location = data['location'];
    this.classFee = data['fees'];
    this.name = data['name'];

    schedule = new List<ClassSchedule>();
    for (var s in data['schedule'].entries) {
      schedule.add(
        ClassSchedule(s.key, start: s.value['start'], end: s.value['end']),
      );
    }
  }

  static Future<List<Classroom>> getAll() async {
    var classes = await dbPath
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();

    List<Classroom> classrooms = new List<Classroom>();

    classes.docs.forEach((element) {
      classrooms.add(Classroom.fromJson(element.data(), element.id));
    });

    return classrooms;
  }

  static Future<List<Student>> getStudents(String classId) async {
    var studentList =
        await dbPathClassStudents.doc(classId).collection("all").get();

    List<Student> studentsInClassroom = List<Student>();

    for (var student in studentList.docs) {
      debugPrint("Fetched students in class " + student.data()['name']);
      studentsInClassroom
          .add(Student(id: student.id, name: student.data()['name']));
    }

    return studentsInClassroom;
  }

  static _updateStudentClasses(String id) {
    dbPathClassStudents.doc(id).get().then((value) {
      if (value.exists) {
        //Update date
        // dbPathClassStudents.doc(id).set(
        //   {'modified_at': DateTime.now()},
        // );
      } else {
        //Create document
        dbPathClassStudents.doc(id).set({
          'user_id': FirebaseAuth.instance.currentUser.uid,
          'modified_at': DateTime.now()
        });
      }
    });
  }

  static Stream<QuerySnapshot> classesStream() {
    return FirebaseFirestore.instance
        .collection("classes")
        .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots();
  }

  addStudents(List<Student> students) {
    var batch = FirebaseFirestore.instance.batch();
    _updateStudentClasses(id);
    for (var student in students) {
      batch.set(dbPathClassStudents.doc(id).collection("all").doc(student.id), {
        'name': student.name,
      });
    }
    batch.commit();
  }

  static void addToClasses(
    List<String> classIds,
    String studentId,
    String studentName,
  ) {
    var batch = FirebaseFirestore.instance.batch();
    for (var classId in classIds) {
      _updateStudentClasses(classId);
      batch.set(
          dbPathClassStudents.doc(classId).collection('all').doc(studentId),
          {'name': studentName});
    }
    batch.commit();
  }
}
