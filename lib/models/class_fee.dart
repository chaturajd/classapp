import 'package:classapp/models/classroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class ClassFee {
  String id;
  bool hasPaid;
  String studentId;
  String paidDate;
  String studentName;

  ClassFee(
      {this.id, this.hasPaid, this.studentId, this.paidDate, this.studentName});

  static final dbPath = FirebaseFirestore.instance.collection("fees");

  ClassFee.fromJson(Map<String, dynamic> data, String id) {
    this.id = id;
    this.hasPaid = data['has_paid'];
    this.studentId = data['student_id'];
    this.paidDate = data['paid_date'];
    this.studentName = data['student_name'];
  }

  static Future<Map<String, List<ClassFee>>> getPaymentDetails(String classId,
      {int year, int month}) async {
    // /fees/class_id/2020/march/all/student_id

    if (year == null) year = DateTime.now().year;
    if (month == null) month = DateTime.now().month;

    var query = dbPath
        .doc(classId)
        .collection(year.toString())
        .doc(month.toString())
        .collection("all");

    var info = await query.get();

    debugPrint("Loaded Fee info count : " + info.size.toString());

    if (info.size < 1) {
      var studentsInClass = await Classroom.getStudents(classId);
      debugPrint(
          "number of students in class" + studentsInClass.length.toString());
      final batch = FirebaseFirestore.instance.batch();

      for (var student in studentsInClass) {
        batch.set(query.doc(student.id), {
          'has_paid': false,
          'paid_date': '',
          'student_id': student.id,
          'student_name': student.name
        });
      }
      batch.commit();

      dbPath.doc(classId).set({"last_modified": DateTime.now()});

      dbPath
          .doc(classId)
          .collection(year.toString())
          .doc(month.toString())
          .set({"last_modified": DateTime.now()});

      info = await query.get();
    }

    return _separatePaidUnpaid(info.docs);
  }

  static Map<String, List<ClassFee>> _separatePaidUnpaid(
      List<QueryDocumentSnapshot> payments) {
    var toPay = new List<ClassFee>();
    var paid = new List<ClassFee>();

    for (var payment in payments) {
      final ClassFee fee = ClassFee(
          id: payment.id,
          hasPaid: payment.data()["has_paid"],
          studentId: payment.data()["student_id"],
          // paidDate: DateTime.parse(payment.data()["paid_date"].toDate().toString()).toString(),
          studentName: payment.data()["student_name"]);
      if (fee.hasPaid) {
        paid.add(fee);
      } else {
        toPay.add(fee);
      }
    }
    debugPrint("TODO:class_fees._separatePaidUnpaid - paidDate");

    return {"toPay": toPay, "paid": paid};
  }

  static savePayments(
      String classId, int year, int month, List<ClassFee> newPayments) {
    var batch = FirebaseFirestore.instance.batch();

    for (var payment in newPayments) {
      batch.update(
        dbPath
            .doc(classId)
            .collection(year.toString())
            .doc(month.toString())
            .collection("all")
            .doc(payment.id),
        {
          'has_paid': true,
          'paid_date': DateTime.now(),
        },
      );
    }

    batch.commit();

    debugPrint(
        "TODO(class_fees.savePayments) : Transaction to commit and update month's income, total income ...");
  }
}
