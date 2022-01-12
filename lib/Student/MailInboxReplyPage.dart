import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Modules/Management.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Modules/Staff.dart';
import '../Modules/Student.dart';
import '../Networking/ApiConstants.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/LoginPage.dart';
import 'package:path/path.dart' as path;
import 'package:schooleverywhere/config/flavor_config.dart';

class MailInboxReplyPage extends StatefulWidget {
  final String type;
  final String id;
  final String title;
  const MailInboxReplyPage(this.id, this.title, this.type);
  @override
  State<StatefulWidget> createState() {
    return new _MailInboxReplyPageState();
  }
}

class _MailInboxReplyPageState extends State<MailInboxReplyPage> {
  Staff? loggedStaff;
  Parent? loggedParent;
  Student? loggedStudent;
  Management? loggedManagement;

  TextEditingController messageValue = new TextEditingController();
  TextEditingController subjectValue = new TextEditingController();
  FileType? _pickingType;
  File? filepath;
  String Url = ApiConstants.FILE_UPLOAD_Mail_Inbox_Student_API;
  bool isLoading = false;
  List<File> selectedFilesList = [];
  List<File> TempselectedFilesList = [];
  List NewFileName = [];
  String? _extension,
      userSection,
      userAcademicYear,
      userStage,
      userGrade,
      userId,
      userType,
      userClass,
      childern;
  bool _loadingPath = false;
  bool _hasValidMime = false;
  bool datasend = false;
  List? teacherSelected;
  bool filesize = true;

  final uploader = FlutterUploader();
  initState() {
    super.initState();
    subjectValue.text = "Re: " + widget.title;
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
      childern = loggedParent!.regno;
    } else if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userAcademicYear = loggedStudent!.academicYear;
      userSection = loggedStudent!.section;
      userStage = loggedStudent!.stage;
      userGrade = loggedStudent!.grade;
      userClass = loggedStudent!.studentClass;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      childern = loggedStudent!.id;
    } else if (widget.type == MANAGEMENT_TYPE) {
      loggedManagement = await getUserData() as Management;
      userAcademicYear = loggedManagement!.academicYear;
      userSection = loggedManagement!.section;
      userStage = "";
      userGrade = "";
      userClass = "";
      userId = loggedManagement!.id;
      userType = loggedManagement!.type;
      childern = loggedManagement!.id;
    } else {
      loggedStaff = await getUserData() as Staff;
      userAcademicYear = loggedStaff!.academicYear;
      userSection = loggedStaff!.section;
      userStage = loggedStaff!.stage;
      userGrade = loggedStaff!.grade;
      userClass = loggedStaff!.staffClass;
      userId = loggedStaff!.id;
      userType = loggedStaff!.type;
      childern = loggedStaff!.id;
    }
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        FilePickerResult? result = await FilePicker.platform
            .pickFiles(allowMultiple: true, type: FileType.any);

        if (result != null) {
          TempselectedFilesList =
              result.paths.map((path) => File(path!)).toList();
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        _loadingPath = false;
        if (TempselectedFilesList.length > 0)
          selectedFilesList = TempselectedFilesList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: Column(
          children: <Widget>[
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
                      //subtitle: new Text(path),
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
                          var lengthoffile = 0, toto;
                          for (int y = 0; y < selectedFilesList.length; y++) {
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
                                    builder: (context) => MailInboxReplyPage(
                                        widget.id, widget.title, widget.type)),
                              );
                              /*   Flushbar(
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
                            NewFileName =
                                await uploadFile(selectedFilesList, Url);
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MailInboxReplyPage(
                                      widget.id, widget.title, widget.type)),
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
                        }
                        if (filesize) {
                          if (subjectValue.text.isNotEmpty) {
                            EventObject eventObject =
                                await ReplyMailIboxStudent(
                                    NewFileName,
                                    widget.id,
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
                                    builder: (context) => MailInboxReplyPage(
                                        widget.id, widget.title, widget.type)),
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
                              /* Flushbar(
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
                            /*  Flushbar(
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
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(FlavorConfig.instance.values.schoolName!),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => HomePage(
                        type: userType!,
                        sectionid: userSection!,
                        Id: childern!,
                        Academicyear: userAcademicYear!)));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    AssetImage('${FlavorConfig.instance.values.imagePath!}'),
              ),
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
        child: body,
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
