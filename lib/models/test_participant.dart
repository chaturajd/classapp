import 'package:classapp/models/test_category.dart';

class TestParticipant{
  String studentName;
  String studentId;
  String classId;
  String className;
  double marks;
  List<TestCategory> subMarks;

  TestParticipant({this.studentName,this.className,this.classId, this.studentId, this.marks, this.subMarks});

}