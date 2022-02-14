import 'dart:io';
import 'dart:math';
import '../Modules/Management.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Modules/Staff.dart';
import '../Modules/Student.dart';
import '../Networking/ApiConstants.dart';
import '../Networking/Futures.dart';
import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import 'package:path/path.dart' as path;
import 'package:schooleverywhere/config/flavor_config.dart';

import 'MailInboxPage.dart';
import 'SendMailInbox.dart';

class MailInboxCompose extends StatefulWidget {
  final String type;
  final String id;

  const MailInboxCompose(this.type, this.id);
  @override
  State<StatefulWidget> createState() {
    return new _MailInboxComposeState();
  }
}

class _MailInboxComposeState extends State<MailInboxCompose> {
  Staff? loggedStaff;
  Parent? loggedParent;
  Student? loggedStudent;
  Management? loggedManagement;
  List<dynamic> mangers = [];
  List<dynamic> teachers = [];
  List<dynamic> studentsList = [];
  List<dynamic> parentsList = [];
  List? mangersSelected;
  TextEditingController regnoValue = new TextEditingController();
  TextEditingController messageValue = new TextEditingController();
  TextEditingController userValue = new TextEditingController();
  TextEditingController subjectValue = new TextEditingController();
  TextEditingController urlValue = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  FileType? _pickingType;
  File? filepath;
  String url = ApiConstants.FILE_UPLOAD_Mail_Inbox_Student_API;
  bool isLoading = false;
  List<File> selectedFilesList = [];
  List<File>? tempSelectedFilesList = [];
  List newFileName = [];
  String? _extension,
      userSection,
      userAcademicYear,
      userStage,
      userGrade,
      userId,
      userType,
      userClass,
      childId;
  bool loadingPath = false;
  bool _hasValidMime = false;
  bool dataSend = false;
  List? teacherSelected, studentSelected, parentSelected;
  bool filesize = true;

  final uploader = FlutterUploader();
  initState() {
    super.initState();
    teacherSelected = [];
    mangersSelected = [];
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    if (widget.type == PARENT_TYPE) {
      loggedParent = await getUserData() as Parent;
      userAcademicYear = loggedParent!.academicYear;
      userSection = loggedParent!.childeSectionSelected;
      userStage = loggedParent!.stage;
      userGrade = loggedParent!.grade;
      userClass = loggedParent!.classChild;
      userId = loggedParent!.id;
      userType = loggedParent!.type;
      childId = loggedParent!.regno;
      syncGetTeacherId();
    } else if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userAcademicYear = loggedStudent!.academicYear;
      userSection = loggedStudent!.section;
      userStage = loggedStudent!.stage;
      userGrade = loggedStudent!.grade;
      userClass = loggedStudent!.studentClass;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      childId = loggedStudent!.id;
      syncGetTeacherId();
    } else if (widget.type == MANAGEMENT_TYPE) {
      loggedManagement = await getUserData() as Management;
      userAcademicYear = loggedManagement!.academicYear;
      userSection = loggedManagement!.section;
      userStage;
      userGrade;
      userClass;
      userId = loggedManagement!.id;
      userType = loggedManagement!.type;
      childId = loggedManagement!.id;
      syncGetStaffStudentId();
      syncGetStaffParentId();
    } else {
      loggedStaff = await getUserData() as Staff;
      userAcademicYear = loggedStaff!.academicYear;
      userSection = loggedStaff!.section;
      userStage = loggedStaff!.stage;
      userGrade = loggedStaff!.grade;
      userClass = loggedStaff!.staffClass;
      userId = loggedStaff!.id;
      userType = loggedStaff!.type;
      childId = loggedStaff!.id;
      syncGetStaffStudentId();
      syncGetStaffParentId();
    }
    syncGetManagersId();
  }

  Future<void> syncGetManagersId() async {
    EventObject eventObject;
    if (widget.type == STAFF_TYPE)
      eventObject = await getStaffManagersId();
    else
      eventObject = await getManagersId(userSection!, userStage!);
    if (eventObject.success!) {
      Map? getManagersValues = eventObject.object as Map?;
      List<dynamic> listOfColumns = getManagersValues!['data'];
      setState(() {
        mangers = listOfColumns;
      });
    } else {
      String? msg = eventObject.object as String?;
      /*  Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> syncGetTeacherId() async {
    EventObject eventObject = await getTeacherId(
        userSection!, userStage!, userGrade!, userClass!, userAcademicYear!);
    if (eventObject.success!) {
      Map? getTeacherValues = eventObject.object as Map?;
      List<dynamic> listOfColumns2 = getTeacherValues!['data'];
      setState(() {
        teachers = listOfColumns2;
      });
    } else {
      String? msg = eventObject.object as String?;
      /* Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> syncGetStaffStudentId() async {
    EventObject objectEventReport = await getStudentOfStaffMailInboxId(
        userSection!, userStage!, userGrade!, userClass!, userAcademicYear!);
    if (objectEventReport.success!) {
      Map? getStudentValues = objectEventReport.object as Map?;
      List<dynamic> listOfStudents = getStudentValues!['data'];
      setState(() {
        studentsList = listOfStudents;
      });
    } else {
      String? msg = objectEventReport.object as String?;
      /*  Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )..show(context);*/
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> syncGetStaffParentId() async {
    EventObject objectEventReport = await getParentOfStaffMailInboxId(
        userSection!, userStage!, userGrade!, userClass!, userAcademicYear!);
    if (objectEventReport.success!) {
      Map? getParentValues = objectEventReport.object as Map?;
      List<dynamic> listOfParents = getParentValues!['data'];
      setState(() {
        parentsList = listOfParents;
      });
    } else {
      String? msg = objectEventReport.object as String?;
      /*  Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )..show(context);*/
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      setState(() => loadingPath = true);
      try {
        FilePickerResult? result = await FilePicker.platform
            .pickFiles(allowMultiple: true, type: FileType.any);

        if (result != null) {
          tempSelectedFilesList =
              result.paths.map((path) => File(path!)).toList();
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        loadingPath = false;
        if (tempSelectedFilesList!.length > 0)
          selectedFilesList = tempSelectedFilesList!;
      });
    }
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => MailInboxCompose(userType!, userId!)));
          break;
        case 1:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => SendMailInbox(userType!)));
          break;
        case 2:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => MailInboxPage(userType!)));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedManagement = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          autovalidate: false,
          title: Text("Managers"),
          validator: (value) {
            if (value == null) return 'Please select one or more option(s)';
          },
          errorText: 'Please select one or more option(s)',
          dataSource: mangers,
          textField: 'display',
          valueField: 'value',
          //required: true,
          initialValue: mangersSelected,
          onSaved: (value) {
            setState(() {
              mangersSelected = value;
            });
          }),
    );

    final selectedTeacher = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          autovalidate: false,
          title: Text("Teacher"),
          validator: (value) {
            if (value == null) {
              return 'Please select one or more option(s)';
            }
          },
          errorText: 'Please select one or more option(s)',
          dataSource: teachers,
          textField: 'display',
          valueField: 'value',
          okButtonLabel: 'OK',
          cancelButtonLabel: 'CANCEL',
          // required: true,
          initialValue: teacherSelected,
          onSaved: (value) {
            setState(() {
              teacherSelected = value;
            });
          }),
    );

    final selectedStudent = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          autovalidate: false,
          title: Text("Student"),
          validator: (value) {
            if (value == null) {
              return 'Please select one or more option(s)';
            }
          },
          errorText: 'Please select one or more option(s)',
          dataSource: studentsList,
          textField: 'display',
          valueField: 'value',
          okButtonLabel: 'OK',
          cancelButtonLabel: 'CANCEL',
          // required: true,
          initialValue: studentSelected,
          onSaved: (value) {
            setState(() {
              studentSelected = value;
            });
          }),
    );

    final selectedParent = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          autovalidate: false,
          title: Text("Parents"),
          validator: (value) {
            if (value == null) {
              return 'Please select one or more option(s)';
            }
          },
          errorText: 'Please select one or more option(s)',
          dataSource: studentsList,
          textField: 'display',
          valueField: 'value',
          okButtonLabel: 'OK',
          cancelButtonLabel: 'CANCEL',
          // required: true,
          initialValue: parentSelected,
          onSaved: (value) {
            setState(() {
              parentSelected = value;
            });
          }),
    );

    final regnoInput = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: regnoValue,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Register Id',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
      ),
    );

//    final usernameInput=Padding(
//      padding: EdgeInsets.symmetric(vertical: 10.0),
//      child: TextFormField(
//        controller: userValue,
//        keyboardType: TextInputType.text,
//        autofocus: false,
//        decoration: InputDecoration(
//          hintText: 'Username',
//          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
//        ),
//      ),
//    );

    final subjectInput = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: subjectValue,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'title',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
      ),
    );
    final urlInput = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: urlValue,
        keyboardType: TextInputType.text,
        validator: (value) {
          if ((urlValue.text.trim() != "") &&
              !RegExp(r"^(http(s)?:\/\/)[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+$")
                  .hasMatch(value!)) {
            return 'Please enter some valid URL';
          }
          return null;
        },
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'url',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
      ),
    );

    final messageInput = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: messageValue,
        keyboardType: TextInputType.multiline,
        maxLines: 7,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Message',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
      ),
    );

    final loadingSign = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SpinKitPouringHourGlass(
        color: AppTheme.appColor,
      ),
    );

    final body = SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: selectedManagement,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: selectedTeacher,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: regnoInput,
              ),
              //          SizedBox(
              //            width:  MediaQuery.of(context).size.width * .75,
              //            child: usernameInput,
              //          ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: subjectInput,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: urlInput,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: messageInput,
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: RaisedButton(
                  color: AppTheme.appColor,
                  textColor: Colors.white,
                  onPressed: () => _openFileExplorer(),
                  child: new Text("Choose File"),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .7,
                padding: const EdgeInsets.only(bottom: 10.0),
                child: new Scrollbar(
                    child: new ListView.separated(
                  shrinkWrap: true,
                  itemCount: selectedFilesList.length > 0 &&
                          selectedFilesList.isNotEmpty
                      ? selectedFilesList.length
                      : 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (selectedFilesList.length > 0) {
                      return new ListTile(
                        title: new Text(
                          path.basename(selectedFilesList[index].path),
                        ),
                      );
                    } else {
                      return Center(child: new Text("No file chosen"));
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      new Divider(),
                )),
              ),

              isLoading
                  ? loadingSign
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            if (selectedFilesList.isNotEmpty) {
                              var lengthoffile = 0, toto;
                              for (int y = 0;
                                  y < selectedFilesList.length;
                                  y++) {
                                File f = selectedFilesList[y];
                                try {
                                  toto = await f.length();
                                  lengthoffile = toto;
                                  print(lengthoffile.toString());
                                  if (lengthoffile > 5000000) {
                                    filesize = false;
                                    break;
                                  }
                                } on PlatformException catch (e) {
                                  print("Unsupported File" + e.toString());
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MailInboxCompose(
                                            widget.type, widget.id)),
                                  );
                                  /* Flushbar(
                          title: "Failed",
                          message: "Unsupported File",
                          icon: Icon(Icons.close),
                          backgroundColor: AppTheme.appColor,
                          duration: Duration(seconds: 3),
                        )..show(context);*/
                                  Fluttertoast.showToast(
                                      msg: "Unsupported File",
                                      toastLength: Toast.LENGTH_LONG,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: AppTheme.appColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              }
                              if (filesize) {
                                newFileName =
                                    await uploadFile(selectedFilesList, url);
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MailInboxCompose(
                                          widget.type, widget.id)),
                                );
                                /*  Flushbar(
                        title: "Failed",
                        message: "max size of one file allowed 5 MB",
                        icon: Icon(Icons.close),
                        backgroundColor: AppTheme.appColor,
                        duration: Duration(seconds: 3),
                      )..show(context);*/
                                Fluttertoast.showToast(
                                    msg: "max size of one file allowed 5 MB",
                                    toastLength: Toast.LENGTH_LONG,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: AppTheme.appColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              print(newFileName);
                            }
                            if (filesize) {
                              if (subjectValue.text.isNotEmpty) {
                                EventObject eventObject =
                                    await addMailIboxStudent(
                                        newFileName,
                                        mangersSelected!,
                                        teacherSelected!,
                                        regnoValue.text,
                                        userValue.text,
                                        subjectValue.text,
                                        messageValue.text,
                                        userAcademicYear!,
                                        userSection!,
                                        userStage!,
                                        userGrade!,
                                        userClass!,
                                        userId!,
                                        widget.type);
                                if (eventObject.success!) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MailInboxCompose(
                                            widget.type, widget.id)),
                                  );
                                  /* Flushbar(
                          title: "Success",
                          message: "Message Sent",
                          icon: Icon(Icons.done_outline),
                          backgroundColor: AppTheme.appColor,
                          duration: Duration(seconds: 3),
                        )..show(context);*/
                                  Fluttertoast.showToast(
                                      msg: "Message Sent",
                                      toastLength: Toast.LENGTH_LONG,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: AppTheme.appColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  String msg = eventObject.object.toString();
                                  /*  Flushbar(
                          title: "Failed",
                          message: msg,
                          icon: Icon(Icons.close),
                          backgroundColor: AppTheme.appColor,
                          duration: Duration(seconds: 3),
                        )..show(context);*/
                                  Fluttertoast.showToast(
                                      msg: msg,
                                      toastLength: Toast.LENGTH_LONG,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: AppTheme.appColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              } else {
                                /*   Flushbar(
                        title: "Failed",
                        message:
                        "Please Enter Comment or Choose File (max size of file 15 MB)",
                        icon: Icon(Icons.close),
                        backgroundColor: AppTheme.appColor,
                        duration: Duration(seconds: 3),
                      )..show(context);*/
                                Fluttertoast.showToast(
                                    msg:
                                        "Please Enter Comment or Choose File (max size of file 15 MB)",
                                    toastLength: Toast.LENGTH_LONG,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: AppTheme.appColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Not Valid URL')));
                          }
                        },
                        padding: EdgeInsets.all(12),
                        color: AppTheme.appColor,
                        child:
                            Text('Send', style: TextStyle(color: Colors.white)),
                      ),
                    )
            ],
          ),
        ),
      ),
    );

    final bodyStaff = SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .75,
                  child: selectedManagement,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .75,
                  child: selectedStudent,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .75,
                  child: selectedParent,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .75,
                  child: subjectInput,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .75,
                  child: urlInput,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .75,
                  child: messageInput,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: RaisedButton(
                    color: AppTheme.appColor,
                    textColor: Colors.white,
                    onPressed: () => _openFileExplorer(),
                    child: new Text("Choose File"),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .7,
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Scrollbar(
                      child: new ListView.separated(
                    shrinkWrap: true,
                    itemCount: selectedFilesList.length > 0 &&
                            selectedFilesList.isNotEmpty
                        ? selectedFilesList.length
                        : 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (selectedFilesList.length > 0) {
                        return new ListTile(
                          title: new Text(
                            path.basename(selectedFilesList[index].path),
                          ),
                        );
                      } else {
                        return Center(child: new Text("No file chosen"));
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        new Divider(),
                  )),
                ),
                isLoading
                    ? loadingSign
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              if (selectedFilesList.isNotEmpty) {
                                newFileName =
                                    await uploadFile(selectedFilesList, url);
                              }
                              if (subjectValue.text.isNotEmpty) {
                                print(newFileName);
                                dataSend = await addMailInboxStaff(
                                    newFileName,
                                    userAcademicYear!,
                                    userId!,
                                    studentSelected!,
                                    mangersSelected!,
                                    parentSelected!,
                                    subjectValue.text,
                                    messageValue.text,
                                    regnoValue.text,
                                    urlValue.text);
                                setState(() {
                                  isLoading = false;
                                });
                                if (dataSend) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MailInboxCompose(
                                            widget.type, widget.id)),
                                  );

                                  Fluttertoast.showToast(
                                      msg: "Message Sent",
                                      toastLength: Toast.LENGTH_LONG,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: AppTheme.appColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  //  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Please Enter Comment or Choose File (max size of file 5 MB)",
                                      toastLength: Toast.LENGTH_LONG,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: AppTheme.appColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              } else {
                                setState(() {
                                  isLoading = false;
                                });

                                Fluttertoast.showToast(
                                    msg: "Please Enter Title",
                                    toastLength: Toast.LENGTH_LONG,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: AppTheme.appColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            } else {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Complete missing data')));
                            }
                          },
                          padding: EdgeInsets.all(12),
                          color: AppTheme.appColor,
                          child: Text('Send',
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
              ],
            ),
          )),
    );

    final bodyManagement = SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * .75,
              child: selectedManagement,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .75,
              child: regnoInput,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .75,
              child: subjectInput,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .75,
              child: messageInput,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: RaisedButton(
                color: AppTheme.appColor,
                textColor: Colors.white,
                onPressed: () => _openFileExplorer(),
                child: new Text("Choose File"),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .7,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: new Scrollbar(
                  child: new ListView.separated(
                shrinkWrap: true,
                itemCount:
                    selectedFilesList.length > 0 && selectedFilesList.isNotEmpty
                        ? selectedFilesList.length
                        : 1,
                itemBuilder: (BuildContext context, int index) {
                  if (selectedFilesList.length > 0) {
                    return new ListTile(
                      title: new Text(
                        path.basename(selectedFilesList[index].path),
                      ),
                    );
                  } else {
                    return Center(child: new Text("No file chosen"));
                  }
                },
                separatorBuilder: (BuildContext context, int index) =>
                    new Divider(),
              )),
            ),
            isLoading
                ? loadingSign
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        if (selectedFilesList.isNotEmpty) {
                          newFileName =
                              await uploadFile(selectedFilesList, url);
                        }
                        if (subjectValue.text.isNotEmpty) {
                          dataSend = await addMailInboxStaff(
                              newFileName,
                              userAcademicYear!,
                              userId!,
                              studentSelected!,
                              mangersSelected!,
                              parentSelected!,
                              subjectValue.text,
                              messageValue.text,
                              regnoValue.text,
                              urlValue.text);
                          setState(() {
                            isLoading = false;
                          });
                          if (dataSend) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MailInboxCompose(widget.type, widget.id)),
                            );
                            /* Flushbar(
                        title: "Success",
                        message: "Message Sent",
                        icon: Icon(Icons.done_outline),
                        backgroundColor: AppTheme.appColor,
                        duration: Duration(seconds: 3),
                      )..show(context);*/
                            Fluttertoast.showToast(
                                msg: "Message Sent",
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 3,
                                backgroundColor: AppTheme.appColor,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            //  }
                          } else {
                            /* Flushbar(
                        title: "Failed",
                        message:
                        "Please Enter Comment or Choose File (max size of file 5 MB)",
                        icon: Icon(Icons.close),
                        backgroundColor: AppTheme.appColor,
                        duration: Duration(seconds: 3),
                      )..show(context);*/
                            Fluttertoast.showToast(
                                msg:
                                    "Please Enter Comment or Choose File (max size of file 5 MB)",
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 3,
                                backgroundColor: AppTheme.appColor,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          /*  Flushbar(
                      title: "Failed",
                      message:
                      "Please Enter Title",
                      icon: Icon(Icons.close),
                      backgroundColor: AppTheme.appColor,
                      duration: Duration(seconds: 3),
                    )
                      ..show(context);*/
                          Fluttertoast.showToast(
                              msg: "Please Enter Title",
                              toastLength: Toast.LENGTH_LONG,
                              timeInSecForIosWeb: 3,
                              backgroundColor: AppTheme.appColor,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      padding: EdgeInsets.all(12),
                      color: AppTheme.appColor,
                      child:
                          Text('Send', style: TextStyle(color: Colors.white)),
                    ),
                  )
          ],
        ),
      ),
    );

    Widget _buildBody() {
      if (widget.type == STAFF_TYPE) {
        return bodyStaff;
      } else if (widget.type == MANAGEMENT_TYPE) {
        return bodyManagement;
      }
      return body;
    }

    return Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(FlavorConfig.instance.values.schoolName!),
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  AssetImage('${FlavorConfig.instance.values.imagePath!}'),
            )
          ],
        ),
        backgroundColor: AppTheme.appColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: _buildBody(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_comment),
            label: 'Compose',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_outline),
            label: 'Send',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: 'Recieve',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.appColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: () {
            logOut(userType!, userId!);
            removeUserData();
            while (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
//          Navigator.pop(context);
            Navigator.of(context).pushReplacement(
                new MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: Icon(
            FontAwesomeIcons.doorOpen,
            color: AppTheme.floatingButtonColor,
            size: 30,
          ),
          backgroundColor: Colors.transparent,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          )),
    );
  }
}
