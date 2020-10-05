import 'package:classapp/components/info.dart';
import 'package:classapp/components/student%20profile/profile_head.dart';
import 'package:flutter/material.dart';

class StudentProfile extends StatelessWidget {
  final name;
  final school;
  final grade;

  final classesIn;
  final notes;

  const StudentProfile(this.name,
      {Key key, this.classesIn, this.notes, this.school, this.grade})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(name +"'s Profile"),
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              ProfileHead(name, school: school, grade: grade),
              InfoContainer(
                title: "Classes In",
                items: classesIn,
              ),
              InfoContainer(
                title: "Notes",
                items: notes,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
