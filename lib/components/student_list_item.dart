import 'package:classapp/screens/student_profile.dart';
import 'package:flutter/material.dart';

class StudentListItem extends StatelessWidget {
  final id;
  final String name;
  final grade;
  final school;
  final classesIn;
  final notes;
  final navigatableToProfile;
  final bgColor;
  final Function() onClick;

  const StudentListItem(this.name, this.id,
      {Key key,
      this.grade,
      this.navigatableToProfile = true,
      this.classesIn,
      this.notes,
      this.school,
      this.onClick, this.bgColor})
      : super(key: key);

  navigateToProfile(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentProfile(
          name,
          grade: grade,
          classesIn: classesIn,
          notes: notes,
          school: school,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick != null
          ? () => onClick()
          : navigatableToProfile ? () => (navigateToProfile(context)) : null,
      child: Container(
        height: 48,
        color: bgColor ?? null,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.indigo[300],
                minRadius: 18,
                child: Text(
                  name[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(grade ?? ""),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
