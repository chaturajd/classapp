import 'package:classapp/components/student_list_item.dart';
import 'package:classapp/models/class_fee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassFees extends StatefulWidget {
  final classId;
  final className;
  var month;

  ClassFees(this.classId, {Key key, this.month, this.className = ""})
      : super(key: key) {
    if (month == null) {
      month = DateTime.now().month;
    }
  }
  @override
  _ClassFeesState createState() => _ClassFeesState();
}

class _ClassFeesState extends State<ClassFees> {
  var paid = List<ClassFee>();
  var toPay = List<ClassFee>();
  var newPayments = List<ClassFee>();

  var batch = FirebaseFirestore.instance.batch();

  newPayment({
    @required String paymentId,
    @required String studentId,
    @required String studentName,
  }) {
    setState(() {
      final fee = ClassFee(
        studentName: studentName,
        studentId: studentId,
        id: paymentId,
      );

      newPayments.add(fee);
      paid.add(fee);
      toPay.removeWhere((payment) => payment.studentId == studentId);
    });
  }

  submitChanges() {
    ClassFee.savePayments(
        widget.classId, DateTime.now().year, DateTime.now().month, newPayments);
  }

  initialize() async {
    var info = await ClassFee.getPaymentDetails(widget.classId);

    setState(() {
      paid = info["paid"];
      toPay = info["toPay"];
    });

  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var paidStudentsPane = Flexible(
      child: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.green[100],
            child: Center(
              child: Text("Paid"),
            ),
          ),
          Flexible(
            child: Container(
              color: Colors.grey[100],
              child: paid.length < 1
                  ? Center(child: Text("No payments"))
                  : ListView.builder(
                      itemCount: paid.length,
                      itemBuilder: (context, index) {
                        final payment = paid[index];
                        return StudentListItem(
                          payment.studentName,
                          payment.studentId,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );

    var yetToPayStudentsPane = Flexible(
      child: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.red[100],
            child: Center(
              child: Text("Yet to pay"),
            ),
          ),
          Flexible(
            child: Container(
              child: toPay.length < 1
                  ? Center(
                      child: Text("Loading, may be"),
                    )
                  : ListView.builder(
                      itemCount: toPay.length,
                      itemBuilder: (context, index) {
                        final payment = toPay[index];
                        return StudentListItem(
                          payment.studentName,
                          payment.studentId,
                          onClick: () => newPayment(
                            paymentId: payment.id,
                            studentId: payment.studentId,
                            studentName: payment.studentName,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        if (newPayments.length > 0) {
          final value = await showDialog<bool>(
            context: context,
            builder: (context) {
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
                    },
                    child: Text("Exit without saving"),
                  ),
                  FlatButton(
                    onPressed: () {
                      return Navigator.of(context).pop(false);
                    },
                    child: Text("Cancel"),
                  )
                ],
              );
            },
          );
          return value;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            widget.className + " (fees) ",
          ),
          actions: [
            IconButton(icon: Icon(Icons.done), onPressed: () => submitChanges())
          ],
        ),
        body: Column(
          children: [
            Flexible(
              child: Row(
                children: [
                  yetToPayStudentsPane,
                  paidStudentsPane,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(
                  "Click on the names of the students in left side to mark them as fee paid students.",
                  // overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
