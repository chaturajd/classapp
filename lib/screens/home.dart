import 'package:classapp/components/menu_item.dart';
import 'package:classapp/components/my%20classes/classes.dart';
import 'package:classapp/components/noted.dart';
import 'package:classapp/screens/all_students.dart';
import 'package:classapp/screens/tests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final newNoteController = new TextEditingController();

  saveNote() {
    debugPrint("Saving");
    if (newNoteController.value.text.isNotEmpty) {
      try {
        FirebaseFirestore.instance.collection('notes').add({
          'user_id': FirebaseAuth.instance.currentUser.uid,
          'note': newNoteController.value.text,
          'created_at': DateTime.now()
        });
        newNoteController.clear();
        newNoteController.clearComposing();
        FocusScope.of(context).unfocus();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saved...")));
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
//Navigators
    navigateToMyClasses(context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyClasses();
      }));
    }

    navigateToStudents(context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AllStudents();
      }));
    }

    navigateToTests(context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Tests();
      }));
    }

//Widget list
    var menu = Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 130,
            child: ListView(
              shrinkWrap: true,
              children: [
                InkWell(
                  onTap: () => navigateToStudents(context),
                  child: MenuItem(
                    "Students",
                    imageLink: "images/student.png",
                  ),
                ),
                InkWell(
                  onTap: () => {navigateToMyClasses(context)},
                  child: MenuItem(
                    "Classes",
                    imageLink: "images/blackboard.png",
                  ),
                ),
                InkWell(
                  onTap: () => {navigateToTests(context)},
                  child: MenuItem(
                    "Something",
                  ),
                ),
              ],
              scrollDirection: Axis.horizontal,
            ),
          ),
          // StudentListItem("Cas")
        ],
      ),
    );

    var filler = ClipPath(
      clipper: Clipper(),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 32, top: 20),
          child: Text(
            "Siecoms",
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 48,
                fontWeight: FontWeight.bold),
          ),
        ),
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   colors: [
          //     Color(0xFF3383CD),
          //     Color(0xFF11249F),
          //   ],
          // ),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('images/teaching.png'),
          ),
        ),
      ),
    );

    var newNote = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        height: 120,
        child: Row(
          children: [
            Flexible(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: TextField(
                  controller: newNoteController,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                      icon: Icon(Icons.note_add),
                      hintText: "New Note...",
                      fillColor: Colors.lightBlue,
                      border: InputBorder.none),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: FlatButton(
                onPressed: () => saveNote(),
                child: Text(
                  "Save",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: newNote,
      ),
      body: Builder(builder: (context) {
        return SafeArea(
          child: ListView(
            children: [
              filler,
              menu,
              Notes(),
            ],
          ),
        );
      }),
    );
  }
}

class Clipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
