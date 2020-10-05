import 'package:classapp/models/classroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Student {
  String id;
  String initials;
  String name;
  DateTime birthday;
  String school;
  int grade;
  List<Map<String, String>> phones = List<Map<String, String>>();
  List<Map<String, String>> classes = List<Map<String, String>>();

  static const _studentCollection = "students";

  static final dbPath =
      FirebaseFirestore.instance.collection(_studentCollection);
  final studentsStream =
      FirebaseFirestore.instance.collection(_studentCollection).snapshots();

  Student({
    this.id,
    this.initials,
    this.name,
    this.birthday,
    this.school,
    this.grade,
  });

  Student.fromJson(Map<String, dynamic> data) {
    this.name = data["name"];
    this.initials = data["initials"];
    this.id = data["id"];
    this.birthday = data["birthday"];
    this.school = data["school"];
    this.grade = data["grade"];
    // this.phones = data["phones"];

    // debugPrint("The fucking data i received .. " + data.toString());
  }

  save() async {
    final doc = await dbPath.add({
      'name': name,
      'initials': initials,
      'birthday': birthday,
      'school': school,
      'grade': grade,
      'phones': phones,
      'classes': classes
    });

    Classroom.addToClasses(classes.map((e) => e['id']).toList(), doc.id, name);

    debugPrint("Saved Student " + name);
  }

  static delete(id) {
    //Delete From 'students' 
    dbPath.doc(id).delete();

    //Move to Deleted in class_students
    
    
  }

  bool isInClass(String classId) {
    for (var classroom in classes) {
      if (classroom['id'] == classId) return true;
    }
    return false;
  }
}
