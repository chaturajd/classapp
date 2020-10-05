import 'package:classapp/models/class_schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateNewClass extends StatefulWidget {
  CreateNewClass({Key key}) : super(key: key);

  @override
  _CreateNewClassState createState() => _CreateNewClassState();
}

class _CreateNewClassState extends State<CreateNewClass> {
  final _formKey = GlobalKey<FormState>();

  var showDayTimeSelectors = false;

  final nameController = new TextEditingController();
  final startTimeController = new TextEditingController();
  final endTimeController = new TextEditingController();
  final classFeesController = new TextEditingController();
  final locationController = new TextEditingController();
  final descriptionController = new TextEditingController();
  final classDaysController = new TextEditingController();

  Map<String, bool> selectDays = {
    "Sunday": false,
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
  };
  var classTimes = List<ClassSchedule>();

  var classSchedule = new List<Map<dynamic, dynamic>>();

  CollectionReference classes =
      FirebaseFirestore.instance.collection("classes");

  InputDecoration textInputDecration({hint}) {
    return InputDecoration(
      // counter: Icon(Icons.terrain),
      labelText: hint,
      border: OutlineInputBorder(
          // borderRadius: BorderRadius.all(
          //   Radius.circular(16),
          // ),
          ),
      // hintText: hint,
    );
  }

  submitForm() {
    debugPrint("Adding Class");
    if (_formKey.currentState.validate()) {
      var schedules = Map<String, Map<String, String>>();

      for (var time in classTimes) {
        schedules[time.day] = {'start': time.start, 'end': time.end};
      }

      debugPrint(schedules.toString());

      final toSave = {
        'user_id': FirebaseAuth.instance.currentUser.uid,
        'name': nameController.value.text,
        'schedule': schedules,
        'fees': classFeesController.value.text,
        'location': locationController.value.text,
        'description': descriptionController.value.text
      };

      classes
          .add(toSave)
          .then((value) => debugPrint("Class Added"))
          .catchError((error) => (debugPrint("Failed to add Class : $error")));

      nameController.value = TextEditingValue();
      startTimeController.value = TextEditingValue();
      endTimeController.value = TextEditingValue();
      classFeesController.value = TextEditingValue();
      locationController.value = TextEditingValue();
      descriptionController.value = TextEditingValue();
      classDaysController.value = TextEditingValue();
    }
  }

  onTimeSet(String time, String day, {bool isStartTime = true}) {
    final schedule = classTimes.firstWhere((element) => element.day == day);

    setState(() {
      if (schedule != null) {
        if (isStartTime) {
          schedule.start = time;
        } else {
          schedule.end = time;
        }
      } else {
        debugPrint("NO SCHEDULE OBJECT");
      }
    });
  }

  Widget dayTimeSelector(String day, bool isChecked) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              onChanged: (value) {
                setState(() {
                  selectDays[day] = value;
                  if (value) {
                    classTimes.add(
                      ClassSchedule(day),
                    );
                  } else {
                    classTimes.removeWhere((element) => element.day == day);
                  }
                });
              },
              value: selectDays[day],
            ),
            Text(day),
          ],
        ),
        selectDays[day]
            ? Container(
                padding: EdgeInsets.only(left: 64),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]),
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Start"),
                          FlatButton(
                            onPressed: () async {
                              TimeOfDay time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: TimeOfDay.now().hour,
                                  minute: 0,
                                ),
                                helpText: "Start time",
                              );

                              if (time != null) {
                                onTimeSet(
                                  time.format(context),
                                  day,
                                );
                                debugPrint("START TIME SELECTED " +
                                    time.format(context));
                              }
                            },
                            child: Text(
                              classTimes
                                      .firstWhere(
                                          (element) => element.day == day)
                                      .start ??
                                  "Select",
                              style: TextStyle(color: Colors.indigo[400]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]),
                      ),
                      child: Row(
                        children: [
                          Text("End"),
                          FlatButton(
                            onPressed: () async {
                              TimeOfDay time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: TimeOfDay.now().hour, minute: 0),
                                helpText: "Start time",
                              );

                              if (time != null) {
                                onTimeSet(
                                  time.format(context),
                                  day,
                                  isStartTime: false,
                                );
                                debugPrint("END TIME SELECTED " +
                                    time.format(context));
                              }
                            },
                            child: Text(
                              classTimes
                                      .firstWhere(
                                          (element) => element.day == day)
                                      .end ??
                                  "Select",
                              style: TextStyle(color: Colors.indigo[400]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox()
      ],
    );
  }

  Widget getDayTimeSelectors() {
    return Column(
      children: selectDays.entries
          .map((e) => dayTimeSelector(e.key, e.value))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(icon: Icon(Icons.done), onPressed: null)],
        title: Center(
          child: Text(
            "Create New Class",
            // style: TextStyle(color: Colors.black),
          ),
        ),
        elevation: 0,
        // backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Flexible(
            child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: ListView(
                  children: [
                    formTextInput(nameController, hint: "Name"),
                    formTextInput(
                      classFeesController,
                      keyboardType: TextInputType.number,
                      hint: "Class fee",
                    ),
                    formTextInput(locationController, hint: "Location"),
                    formTextInput(descriptionController, hint: "Description"),

                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Select class days and times,",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          getDayTimeSelectors(),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () => submitForm(),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   // width: ,
                    //   child: Button(
                    //     text: "Save",
                    //     action: () => (submitForm()),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding formTextInput(TextEditingController controller,
      {String hint = "", keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        decoration: textInputDecration(hint: hint),
        validator: (value) {
          if (value.isEmpty) {
            return "This field is needed";
          }
          return null;
        },
      ),
    );
  }

  Widget textFormField1(hint, controller) {
    return TextFormField(
      controller: controller,
      decoration: textInputDecration(
        hint: hint,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "This field is needed";
        }
        return null;
      },
    );
  }
}
