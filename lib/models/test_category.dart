import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class TestCategory {
  String id;
  String title;
  double marks;

  static final dbPath = FirebaseFirestore.instance
      .collection("tests")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("categories");

  TestCategory.fromJson(Map<String, dynamic> data, String id) {
    this.id = id;
    this.title = data["title"];
    this.marks = data["marks"];
  }

  static Future<List<TestCategory>> getAll() async {
    debugPrint("TODO : get categories");
    var data = await dbPath.get();
    List<TestCategory> cats = List<TestCategory>();

    for (var cat in data.docs) {
      TestCategory.fromJson(cat.data()['title'], cat.id);
    }

    return cats;
  }

  save() async {
    dbPath.add({'title': title});
  }
}
