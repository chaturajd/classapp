import 'package:classapp/components/button.dart';
import 'package:classapp/models/classroom.dart';
import 'package:classapp/models/student.dart';
import 'package:flutter/material.dart';

class RegisterStudent extends StatefulWidget {
  RegisterStudent({Key key}) : super(key: key);

  @override
  _RegisterStudentState createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  final _formKey = GlobalKey<FormState>();

  final nameController = new TextEditingController();
  final initialsController = new TextEditingController();

  final schoolController = new TextEditingController();
  final gradeController = new TextEditingController();
  final phoneController = new TextEditingController();
  final phoneRelationController = new TextEditingController();

  Student newStudent = new Student();

  //Variables
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

  //Functions
  submitForm(context) {
    if (_formKey.currentState.validate()) {
      newStudent.initials = initialsController.value.text;
      newStudent.name = nameController.value.text;
      newStudent.grade = int.parse(gradeController.value.text);
      newStudent.school = schoolController.value.text;

      newStudent.save();

      setState(() {
        initialsController.value = TextEditingValue();
        nameController.value = TextEditingValue();
        gradeController.value = TextEditingValue();
        schoolController.value = TextEditingValue();
        phoneRelationController.value = TextEditingValue();
        phoneController.value = TextEditingValue();

        newStudent = new Student();

        //TODO
        // Scaffold.of(context).showSnackBar(SnackBar(content: Text("saved")));
        // FocusScope.of(context).unfocus();
      });
    }
  }

  bool gradeValidator(value) {
    try {
      int.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var inputName = Row(
      children: [
        Flexible(
          flex: 1,
          child: formTextInput(initialsController, hint: "Initials"),
        ),
        Flexible(
          flex: 2,
          child: formTextInput(nameController, hint: "Name"),
        )
      ],
    );

    var inputBirthday = FlatButton(
      onPressed: () async {
        var birthday = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(Duration(days: 365 * 30)),
          lastDate: DateTime.now(),
          helpText: "Birthday of student",
        );
        setState(() {
          newStudent.birthday = birthday;
        });
      },
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Text(newStudent.birthday == null
              ? "Select birthday"
              : '${newStudent.birthday.year} - ${newStudent.birthday.month} - ${newStudent.birthday.day} ')),
    );
    var previewPhone = Padding(
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 150,
        ),
        child: Scrollbar(
          isAlwaysShown: true,
          controller: ScrollController(),
          child: newStudent.phones.length < 1
              ? SizedBox()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: newStudent.phones.length,
                  itemBuilder: (context, index) {
                    final relation = newStudent.phones[index]['relation'];
                    final number = newStudent.phones[index]['number'];

                    return Row(
                      // mainAxisAlignment:
                      //     MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                relation,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600]),
                              ),
                              Text(
                                number,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue[200],
                            ),
                            onPressed: () {
                              phoneController.value =
                                  TextEditingValue(text: number);
                              phoneRelationController.value =
                                  TextEditingValue(text: relation);
                              setState(() {
                                newStudent.phones.removeAt(index);
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red[200],
                          ),
                          onPressed: () {
                            setState(() {
                              newStudent.phones.removeAt(index);
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
    var inputPhone = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: formTextInput(
            phoneRelationController,
            hint: "Relation",
          ),
        ),
        Flexible(
          flex: 6,
          child: formTextInput(phoneController,
              hint: "Phone Number", keyboardType: TextInputType.number),
        ),
        Flexible(
          flex: 1,
          child: IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                if (phoneController.value.text.isNotEmpty) {
                  setState(() {
                    debugPrint("Adding Phone number");
                    newStudent.phones.add({
                      "relation": phoneRelationController.value.text,
                      "number": phoneController.value.text
                    });
                  });

                  phoneController.clear();
                  phoneRelationController.clear();
                }
              }),
        )
      ],
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(),
        title: Center(child: Text("Register new student")),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.indigo[200],
          )
        ],
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Personal info"),
                  inputName,
                  inputBirthday,
                  formTextInput(schoolController, hint: "School"),
                  formTextInput(gradeController,
                      hint: "Grade", keyboardType: TextInputType.number),
                  Text("Contact info"),
                  previewPhone,
                  inputPhone,
                  Text("Classes to add"),
                  FutureBuilder(
                      future: Classroom.getAll(),
                      builder:
                          (context, AsyncSnapshot<List<Classroom>> snapshot) {
                        if (snapshot.hasData) {
                          //return (Text(snapshot.data[0].name));
                          return Container(
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                var classData = snapshot.data[index];
                                return Row(
                                  children: [
                                    Checkbox(
                                        value: newStudent.isInClass(classData.id) ,
                                        onChanged: (value) {
                                          if (value) {
                                            setState(() {
                                              newStudent.classes.add({
                                                'id': classData.id,
                                                'name': classData.name
                                              });
                                            });
                                          } else {
                                            setState(() {
                                              newStudent.classes.removeWhere(
                                                  (element) =>
                                                      element['id'] ==
                                                      classData.id);
                                            });
                                          }
                                        }),
                                    Text(classData.name),
                                  ],
                                );
                              },
                            ),
                          );
                        }

                        if (snapshot.error) {
                          return Center(
                            child: Text("Error Loading classes..."),
                          );
                        }

                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                  SizedBox(
                    // width: ,
                    child: Button(
                      text: "Save",
                      action: () => submitForm(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
