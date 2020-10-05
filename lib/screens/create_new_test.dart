import 'package:classapp/models/classroom.dart';
import 'package:classapp/models/test.dart';
import 'package:classapp/models/test_category.dart';
import 'package:classapp/models/test_class.dart';
import 'package:flutter/material.dart';

class CreateNewTest extends StatefulWidget {
  CreateNewTest({Key key}) : super(key: key);

  @override
  _CreateNewTestState createState() => _CreateNewTestState();
}

class _CreateNewTestState extends State<CreateNewTest> {
  final titleController = new TextEditingController();
  List<TestClass> classes = new List<TestClass>();
  List<TestCategory> categories = new List<TestCategory>();

  InputDecoration textInputDecration({hint}) {
    return InputDecoration(labelText: hint, border: OutlineInputBorder());
  }

  Padding formTextInput(TextEditingController controller,
      {String hint = "",
      keyboardType = TextInputType.text,
      Function validator}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        decoration: textInputDecration(hint: hint),
        validator: validator == null ? null : (value) => validator(value),
      ),
    );
  }

  String getSelectedDate(id) {
    debugPrint("Getting date");
    final c = classes.firstWhere(
      (element) => element.classId == id,
      orElse: () {
        return null;
      },
    );

    if (c == null || c.testDate == null)
      return "Select Date";
    else
      return '${c.testDate.year} - ${c.testDate.month} - ${c.testDate.day}';
  }

  submitTest() {
    Test test = new Test(
        title: titleController.value.text,
        testClasses: classes,
        categories: categories);

    test.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Test"),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                formTextInput(titleController, hint: "Title of the"),
                Text(
                  "Select classes",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                ),
                Flexible(
                  flex: 7,
                  child: FutureBuilder(
                      future: Classroom.getAll(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List<Classroom> classrooms = snapshot.data;
                          return Container(
                            child: Scrollbar(
                              isAlwaysShown: true,
                              controller:
                                  ScrollController(initialScrollOffset: 0),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: classrooms.length,
                                  itemBuilder: (context, index) {
                                    Classroom c = classrooms[index];
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                                value: classes.firstWhere(
                                                            (element) =>
                                                                element
                                                                    .classId ==
                                                                c.id,
                                                            orElse: () =>
                                                                null) ==
                                                        null
                                                    ? false
                                                    : true,
                                                onChanged: (value) {
                                                  if (value) {
                                                    setState(() {
                                                      classes.add(new TestClass(
                                                        classId: c.id,
                                                        className: c.name,
                                                      ));
                                                    });
                                                  } else {
                                                    setState(() {
                                                      classes.removeWhere(
                                                          (element) =>
                                                              element.classId ==
                                                              classrooms[index]
                                                                  .id);
                                                    });
                                                  }
                                                }),
                                            Text(
                                              classrooms[index].name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 64),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey[200])),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8,
                                                        horizontal: 16),
                                                    child: Text("Test day "),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    var date =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now()
                                                          .subtract(Duration(
                                                              days: 30)),
                                                      lastDate:
                                                          DateTime.now().add(
                                                        Duration(days: 365 * 2),
                                                      ),
                                                    );
                                                    setState(() {
                                                      classes.firstWhere(
                                                          (element) =>
                                                              element.classId ==
                                                              c.id, orElse: () {
                                                        return null;
                                                      })?.testDate = date;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all()),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8,
                                                          horizontal: 64),
                                                      child: Text(
                                                        getSelectedDate(c.id),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.indigo),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error loading Classes"),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Select categories",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                ),
                Flexible(
                  flex: 5,
                  child: FutureBuilder(
                      future: TestCategory.getAll(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          var cats = snapshot.data;
                          return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 3),
                              itemCount: cats.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Checkbox(
                                        value: null,
                                        onChanged: (value) {
                                          if (value) {
                                            setState(() {
                                              categories.add(cats[index]);
                                            });
                                          } else {
                                            setState(() {
                                              // categories.removeWhere((element) => element.)
                                            });
                                            debugPrint("Remove from list");
                                          }
                                        }),
                                    Text(cats[index].title),
                                  ],
                                );
                              });
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error Loading categories"),
                          );
                        }

                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
                FlatButton(
                  onPressed: () => submitTest(),
                  child: Text("Save"),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
