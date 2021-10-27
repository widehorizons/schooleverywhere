import 'dart:io';
import '../Modules/Management.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as path;
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Networking/ApiConstants.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';

import '../Pages/LoginPage.dart';

class StaffMail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _StaffMailState();
  }
}

class _StaffMailState extends State<StaffMail> {
  Management? loggedManagement;

  String? StaffSectionId;
  Map DepOneOptions = new Map();
  Map DepTwoOptions = new Map();
  Map DepThreeOptions = new Map();
  Map DepFourOptions = new Map();

  String Url = ApiConstants.STAFF_MAIL_UPLOAD_API;
  bool isLoading = false;
  List<File> selectedFilesList = [];
  List<File> TempselectedFilesList = [];
  List NewFileName = [];
  String? _extension;
  bool _loadingPath = false;
  bool _hasValidMime = false;
  FileType? _pickingType;
  File? filepath;

  // bool datasend = false;
  EventObject? datasend;
  final uploader = FlutterUploader();
  dynamic taskId;
  bool filesize = true;

  TextEditingController MessageValue = new TextEditingController();
  TextEditingController titleValue = new TextEditingController();
  TextEditingController StaffIdValue = new TextEditingController();

  String? DepOneValue,
      DepOneName,
      DepTwoValue,
      DepTwoName,
      DepThreeValue,
      DepThreeName,
      DepFourValue,
      DepFourName;
  bool DepOneSelected = false,
      DepTwoSelected = false,
      DepThreeSelected = false,
      DepFourSelected = false;

  initState() {
    super.initState();
    getLoggedStaff();
  }

  Future<void> getLoggedStaff() async {
    loggedManagement = await getUserData() as Management;
    StaffSectionId = loggedManagement!.section;

    setState(() {
      syncDepOneOptions();
    });
  }

  Future<void> syncDepOneOptions() async {
    EventObject objectEventSection = await depOneOptions();
    if (objectEventSection.success!) {
      Map? toto = objectEventSection.object as Map?;
      List<dynamic> x = toto!['idDep'];
      Map DepOnearr = new Map();
      for (int i = 0; i < x.length; i++) {
        DepOnearr[toto['idDep'][i]] = toto['DepName'][i];
      }
      setState(() {
        DepOneOptions = DepOnearr;
        print("DepOne map:" + DepOnearr.toString());
      });
    } else {
      String? msg = objectEventSection.object as String?;
      /*Flushbar(
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

  Future<void> syncDepTwoOptions() async {
    EventObject objectEventSection = await depTwoOptions(DepOneValue!);
    if (objectEventSection.success!) {
      Map? toto = objectEventSection.object as Map?;
      List<dynamic> x = toto!['idDep'];
      Map DepTwoarr = new Map();
      for (int i = 0; i < x.length; i++) {
        DepTwoarr[toto['idDep'][i]] = toto['DepName'][i];
      }
      setState(() {
        DepTwoOptions = DepTwoarr;
        print("DepTwo map:" + DepTwoarr.toString());
      });
    } else {
      String? msg = objectEventSection.object as String?;
      /*Flushbar(
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

  Future<void> syncDepThreeOptions() async {
    EventObject objectEventSection =
        await depThreeOptions(DepOneValue!, DepTwoValue!);
    if (objectEventSection.success!) {
      Map? toto = objectEventSection.object as Map?;
      List<dynamic> x = toto!['idDep'];
      Map DepThreearr = new Map();
      for (int i = 0; i < x.length; i++) {
        DepThreearr[toto['idDep'][i]] = toto['DepName'][i];
      }
      setState(() {
        DepThreeOptions = DepThreearr;
        print("DepThree map:" + DepThreearr.toString());
      });
    } else {
      String? msg = objectEventSection.object as String?;
      /*Flushbar(
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

  Future<void> syncDepFourOptions() async {
    EventObject objectEventSection =
        await depFourOptions(DepOneValue!, DepTwoValue!, DepThreeValue!);
    if (objectEventSection.success!) {
      Map? toto = objectEventSection.object as Map?;
      List<dynamic> x = toto!['idDep'];
      Map DepFourarr = new Map();
      for (int i = 0; i < x.length; i++) {
        DepFourarr[toto['idDep'][i]] = toto['DepName'][i];
      }
      setState(() {
        DepFourOptions = DepFourarr;
        print("DepFour map:" + DepFourarr.toString());
      });
    } else {
      Object? msg = objectEventSection.object;
      /*Flushbar(
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

  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final DepOne = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: DepOneValue,
          hint: Text("Select First Department"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              DepOneSelected = true;
              DepOneValue = newValue!;
              DepOneName = DepOneOptions[newValue];
              DepTwoOptions.clear();
              DepTwoValue;
              DepTwoName;
              DepTwoSelected = false;
              DepThreeOptions.clear();
              DepThreeValue;
              DepThreeName;
              DepThreeSelected = false;
              DepFourOptions.clear();
              DepFourValue;
              DepFourName;
              DepFourSelected = false;
              syncDepTwoOptions();
            });
          },
          items: DepOneOptions.map((key, value) {
            return MapEntry(
                value,
                DropdownMenuItem<String>(
                  value: key,
                  child: Text(value),
                ));
          }).values.toList()),
    );
    final DepTwo = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: DepTwoValue,
          hint: Text("Select Second Department"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              DepTwoValue = newValue!;
              DepTwoName = DepTwoOptions[newValue];
              DepTwoSelected = true;
              DepThreeOptions.clear();
              DepThreeValue;
              DepThreeName;
              DepThreeSelected = false;
              DepFourOptions.clear();
              DepFourValue;
              DepFourName;
              DepFourSelected = false;
              syncDepThreeOptions();
            });
          },
          items: DepTwoOptions.map((key, value) {
            return MapEntry(
                value,
                DropdownMenuItem<String>(
                  value: key,
                  child: Text(value),
                ));
          }).values.toList()),
    );
    final DepThree = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: DepThreeValue,
          hint: Text("Select Third Department"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              DepThreeValue = newValue!;
              DepThreeName = DepTwoOptions[newValue];
              DepThreeSelected = true;
              DepFourOptions.clear();
              DepFourValue;
              DepFourName;
              DepFourSelected = false;
              syncDepFourOptions();
            });
          },
          items: DepThreeOptions.map((key, value) {
            return MapEntry(
                value,
                DropdownMenuItem<String>(
                  value: key,
                  child: Text(value),
                ));
          }).values.toList()),
    );
    final DepFour = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: DepFourValue,
          hint: Text("Select Fourth Department"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              DepFourValue = newValue!;
              DepFourName = DepTwoOptions[newValue];
              DepFourSelected = true;
            });
          },
          items: DepFourOptions.map((key, value) {
            return MapEntry(
                value,
                DropdownMenuItem<String>(
                  value: key,
                  child: Text(value),
                ));
          }).values.toList()),
    );

    final data = Center(
        widthFactor: 2,
        child: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  height: MediaQuery.of(context).size.height * 1.5,
                ),
                child: Container(
                    width: MediaQuery.of(context).size.width * .75,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * .02),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .8,
                          child: DepOne,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .8,
                          child: DepTwo,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .8,
                          child: DepThree,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .8,
                          child: DepFour,
                        ),
                        Text(" Staff ID ",
                            style: TextStyle(
                                color: AppTheme.appColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: TextField(
                            controller: StaffIdValue,
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppTheme.appColor)),
                            ),
                          ),
                        ),
                        Text(" Title ",
                            style: TextStyle(
                                color: AppTheme.appColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: TextField(
                            controller: titleValue,
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppTheme.appColor)),
                            ),
                          ),
                        ),
                        Text(" Message ",
                            style: TextStyle(
                                color: AppTheme.appColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: TextField(
                            controller: MessageValue,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppTheme.appColor)),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: RaisedButton(
                            color: AppTheme.appColor,
                            textColor: Colors.white,
                            onPressed: () => _openFileExplorer(),
                            child: new Text("Choose File"),
                          ),
                        ),
                        Expanded(
                          child: Container(
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
                                      path.basename(
                                          selectedFilesList[index].path),
                                    ),
                                    //subtitle: new Text(path),
                                  );
                                } else {
                                  return Center(
                                      child: new Text("No file chosen"));
                                }
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      new Divider(),
                            )),
                          ),
                        ),
                        isLoading
                            ? loadingSign
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
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
                                          print("Unsupported File" +
                                              e.toString());
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StaffMail()),
                                          );
                                          /*Flushbar(
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
                                              backgroundColor:
                                                  AppTheme.appColor,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      }
                                      if (filesize) {
                                        NewFileName = await uploadFile(
                                            selectedFilesList, Url);
                                      } else {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StaffMail()),
                                        );
                                        /*Flushbar(
                                          title: "Failed",
                                          message:
                                              "max size of one file allowed 5 MB",
                                          icon: Icon(Icons.close),
                                          backgroundColor: AppTheme.appColor,
                                          duration: Duration(seconds: 3),
                                        )..show(context);*/
                                        Fluttertoast.showToast(
                                            msg:
                                                "max size of one file allowed 5 MB",
                                            toastLength: Toast.LENGTH_LONG,
                                            timeInSecForIosWeb: 3,
                                            backgroundColor: AppTheme.appColor,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    }
                                    if (filesize) {
                                      if (DepOneValue != null ||
                                          StaffIdValue.text.isNotEmpty) {
                                        if (selectedFilesList.isNotEmpty ||
                                            titleValue.text.isNotEmpty ||
                                            MessageValue.text.isNotEmpty) {
                                          datasend = await addStaffMail(
                                              NewFileName,
                                              loggedManagement!.academicYear!,
                                              loggedManagement!.id!,
                                              titleValue.text,
                                              MessageValue.text,
                                              StaffIdValue.text,
                                              DepOneValue!,
                                              DepTwoValue!,
                                              DepThreeValue!,
                                              DepFourValue!);
                                          setState(() {
                                            isLoading = false;
                                          });
                                          if (datasend!.success!) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StaffMail()),
                                            );
                                            /*Flushbar(
                                              title: "Success",
                                              message:
                                                  "Message Sent and File Uploaded",
                                              icon: Icon(Icons.done_outline),
                                              backgroundColor:
                                                  AppTheme.appColor,
                                              duration: Duration(seconds: 3),
                                            )..show(context);*/
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Message Sent and File Uploaded",
                                                toastLength: Toast.LENGTH_LONG,
                                                timeInSecForIosWeb: 3,
                                                backgroundColor:
                                                    AppTheme.appColor,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            //  }
                                          } else {
                                            String? msg =
                                                datasend!.object as String?;
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StaffMail()),
                                            );
                                            /*Flushbar(
                                              title: "Failed",
                                              message: msg.toString(),
                                              icon: Icon(Icons.close),
                                              backgroundColor:
                                                  AppTheme.appColor,
                                              duration: Duration(seconds: 3),
                                            )..show(context);*/
                                            Fluttertoast.showToast(
                                                msg: msg.toString(),
                                                toastLength: Toast.LENGTH_LONG,
                                                timeInSecForIosWeb: 3,
                                                backgroundColor:
                                                    AppTheme.appColor,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        } else {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StaffMail()),
                                          );
                                          /*Flushbar(
                                            title: "Failed",
                                            message:
                                                "Please Enter Message or Choose File",
                                            icon: Icon(Icons.close),
                                            backgroundColor: AppTheme.appColor,
                                            duration: Duration(seconds: 3),
                                          )..show(context);*/
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please Enter Message or Choose File",
                                              toastLength: Toast.LENGTH_LONG,
                                              timeInSecForIosWeb: 3,
                                              backgroundColor:
                                                  AppTheme.appColor,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      } else {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StaffMail()),
                                        );
                                        /*Flushbar(
                                          title: "Failed",
                                          message:
                                          "Please Select Department or Enter Staff ID",
                                          icon: Icon(Icons.close),
                                          backgroundColor: AppTheme.appColor,
                                          duration: Duration(seconds: 3),
                                        )..show(context);*/
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please Select Department or Enter Staff ID",
                                            toastLength: Toast.LENGTH_LONG,
                                            timeInSecForIosWeb: 3,
                                            backgroundColor: AppTheme.appColor,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    }
                                  },
                                  padding: EdgeInsets.all(12),
                                  color: AppTheme.appColor,
                                  child: Text('Send',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              )
                      ],
                    )))));

    return Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(SCHOOL_NAME),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => HomePage(
                        type: loggedManagement!.type!,
                        sectionid: loggedManagement!.section!,
                        Id: "",
                        Academicyear: "")));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('img/logo.png'),
              ),
            )
          ],
        ),
        backgroundColor: AppTheme.appColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              height: MediaQuery.of(context).size.height * .88,
            ),
            child: Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: data,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: () {
            logOut(loggedManagement!.type!, loggedManagement!.id!);
            removeUserData();
            while (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
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
