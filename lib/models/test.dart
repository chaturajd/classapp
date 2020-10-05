import 'package:classapp/models/classroom.dart';
import 'package:classapp/models/test_category.dart';
import 'package:classapp/models/test_class.dart';
import 'package:classapp/models/test_participant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Test {
  String id;
  String title;
  List<TestClass> testClasses;
  List<TestParticipant> participants = new List<TestParticipant>();
  List<TestCategory> categories = new List<TestCategory>();

  static final dbPath = FirebaseFirestore.instance
      .collection("tests")
      .doc(FirebaseAuth.instance.currentUser.uid);

  final testsPath = dbPath.collection("tests");
  final testCategoriesPath = dbPath.collection("categories");

  Test(
      {this.testClasses,
      this.id,
      this.participants,
      this.categories,
      this.title});

  Test.fromJson(Map<String, dynamic> data) {
    this.title = data["title"];
    this.id = data["id"];

    // this.date = data["date"];
  }

  static Future<List<Test>> getUpcomingTests() async {
    var data = await dbPath
        .collection("tests_briefs")
        // .where('last_date', isGreaterThanOrEqualTo: DateTime.now())
        .get();

    debugPrint(data.size.toString());

    List<Test> tests = new List<Test>();

    for (var test in data.docs) {
      tests.add(
        Test(
          id: test.id,
          title: test.data()['test_title'],
        ),
      );
    }
    return tests;
  }

  Future save() async {
    var test = await dbPath.collection("tests").add({
      "title": this.title,
    });

    var batch = FirebaseFirestore.instance.batch();
    DateTime lastDate;
    if (testClasses.length > 0) {
      lastDate = testClasses[0].testDate;
    } else {
      lastDate = DateTime.now();
    }

    await Future.forEach(testClasses, (TestClass testClass) async {
      batch.set(
        testsPath.doc(test.id).collection("test_classes").doc(),
        {
          'class_id': testClass.classId,
          'date': testClass.testDate,
          'class_name': testClass.className,
        },
      );

      if (testClass.testDate.isAfter(lastDate)) lastDate = testClass.testDate;

      Classroom.getStudents(testClass.classId).then((students) async {
        for (var student in students) {
          batch.set(testsPath.doc(test.id).collection("participants").doc(), {
            'student_name': student.name,
            'student_id': student.id,
            'mark': null,
            'class_id': testClass.classId,
            'class_name': testClass.className
          });
        }
      });
    });

    //It is weired that batch is commited here not above or I am just dumb.
    dbPath.set({'modified': DateTime.now()}).then((value) => batch.commit());

    dbPath.collection("tests_briefs").add({
      'test_title': this.title,
      'test_id': test.id,
      'total_students': 0,
      'last_date': lastDate,
    });
  }

  static Future<Test> getTest(String testId) async {
    Test test = new Test();

    var summary = await dbPath.collection("tests").doc(testId).get();
    var participants = await dbPath
        .collection("tests")
        .doc(testId)
        .collection("participants")
        .get();

    test.title = summary.data()['title'];
    test.participants = new List<TestParticipant>();
    for (var participant in participants.docs) {
      test.participants.add(new TestParticipant(
        studentId: participant.id,
        marks: participant.data()['mark'],
        className: participant.data()['class_name'],
        classId: participant.data()['class_id'],
        studentName: participant.data()['student_name'],
        // subMarks:
      ));
    }
    print(test.participants.length.toString());
    return test;
  }
}
