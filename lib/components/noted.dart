import 'package:classapp/components/info_list_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Notes extends StatelessWidget {
  const Notes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    deleteNote(id) {
      FirebaseFirestore.instance.collection("notes").doc(id).delete();
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notes",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("notes")
                    .where("user_id",
                        isEqualTo: FirebaseAuth.instance.currentUser.uid)
                    .limit(3)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("An Error occurred,cannot fetch notes.");
                  }

                  if (snapshot.hasData) {
                    final notesList = snapshot.data.docs
                        .map((note) => {
                              'id': note.id,
                              'title': note.data()["note"],
                              'subtitle2': DateTime.now().difference(
                                  DateTime.parse(note
                                      .data()['created_at']
                                      .toDate()
                                      .toString()))
                            })
                        .toList();

                    if (notesList.isEmpty) {
                      return Align(
                        alignment: Alignment.center,
                        child: Text(
                            "No Notes to show, add new notes from below."),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: notesList.length,
                          itemBuilder: (context, index) {
                            int days = notesList[index]['subtitle2'].inDays;
                            String timeAgo = "";
                            int hours = 0;
                            if (days > 0) {
                              hours =
                                  notesList[index]['subtitle2'].inHours %
                                      days;
                              timeAgo += days.toString() + " days ";
                              if (hours > 0) {
                                timeAgo += hours.toString() + " hours ";
                              }
                            } else {
                              timeAgo += notesList[index]['subtitle2']
                                      .inHours
                                      .toString() +
                                  " hours ";
                            }

                            if (days < 1 && hours < 1) {
                              timeAgo += notesList[index]['subtitle2']
                                      .inMinutes
                                      .toString() +
                                  " minutes ";
                            }

                            timeAgo += " ago";

                            return Row(
                              children: [
                                Flexible(
                                  flex: 11,
                                  child: InfoListItem(
                                    notesList[index]['title'],
                                    subtitle2: timeAgo,
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red[100],
                                    ),
                                    onPressed: () =>
                                        deleteNote(notesList[index]['id']))
                              ],
                            );
                          });
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
