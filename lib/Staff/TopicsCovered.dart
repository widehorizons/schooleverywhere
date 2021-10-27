import 'package:expandable/expandable.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Staff.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Staff/AddTopicsCovered.dart';
import '../Style/theme.dart';

import '../Pages/LoginPage.dart';

class TopicsCovered extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return new _TopicsCoveredState();
  }
}

class _TopicsCoveredState extends State<TopicsCovered> {
   Staff? loggedStaff;
  Map datesOptions = new Map();
  Map divisions = new Map();
   String? dateValue, topicId, topicsCoveredEditString;
  bool dateSelected = false;
  List<Widget> previousTopicsCovered = [];
  TextEditingController topicsCoveredEditController = new TextEditingController();
  initState() {
    super.initState();
    getLoggedStaff();
  }

  Future<void> getLoggedStaff() async {
    loggedStaff = await getUserData() as Staff;
    syncDates();
  }

  Future<void> syncDates() async {
    EventObject objectEventDates = await getTopicsCoveredDates(
        loggedStaff!.section!, loggedStaff!.academicYear!, loggedStaff!.stage!,
        loggedStaff!.grade!, loggedStaff!.type!);
    if (objectEventDates.success!) {
      Map? data = objectEventDates.object as Map?;
      List<dynamic> toto = data!['id'];
      Map datesArr = new Map();
      for (int i = 0; i < toto.length; i++) {
        datesArr[data['id'][i]] = data['name'][i];
      }
      setState(() {
        datesOptions = datesArr;
      });
    }
    else
    {
      String? msg = objectEventDates.object as String?;
   /*   Flushbar(
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
          fontSize: 16.0
      );
    }
  }

  Future<void> syncPreviousStaffTopics() async {
    EventObject objectEventp = await previousStaffTopics(
        loggedStaff!.section!,
        loggedStaff!.academicYear!,
        loggedStaff!.stage!,
        loggedStaff!.grade!,
        loggedStaff!.staffClass!,
        loggedStaff!.subject!,
        loggedStaff!.id!,
        dateValue!);
    if (objectEventp.success!) {
      Map? data = objectEventp.object as Map?;
      List<dynamic> y = data!['id'];
      List<Widget> topicsCoveredArr = [];
      for (int i = 0; i < y.length; i++) {
        String title = data['namedivision'][i].toString();
        String topicText = data['comment'][i].toString();
        topicsCoveredArr.add(Container(
          child: Card(
            semanticContainer: true,
            margin: EdgeInsets.all(MediaQuery
                .of(context)
                .size
                .width * .05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(MediaQuery
                      .of(context)
                      .size
                      .width * .03),
                  child: ExpandablePanel(
                    header: Text(title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.appColor
                      ),
                    ),
                    collapsed: Text(topicText, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),

                    expanded: Text(topicText,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.appColor
                      ),
                      ),
                  ),
                ),

                Row(
                  children: <Widget>[
                    new IconButton(
                      icon: new Icon(FontAwesomeIcons.trash),
                      color: AppTheme.appColor,
                      onPressed: () {
                        topicId = data['id'][i].toString();
                        deleteTopic();
                      },
                    ),
                    new IconButton(
                      icon: new Icon(FontAwesomeIcons.edit),
                      color: AppTheme.appColor,
                      onPressed: () {
                        topicsCoveredEditController.text = topicText;
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Form(
                                  //          key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextField(
                                          maxLines: 5,
                                          keyboardType: TextInputType.multiline,
                                          controller: topicsCoveredEditController,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          color: AppTheme.appColor,
                                          child: Text("Edit",
                                              style: TextStyle(
                                                  color: Colors.white
                                              )
                                          ),
                                          onPressed: () {
                                            topicId = data['id'][i].toString();
                                            topicsCoveredEditString =
                                                topicsCoveredEditController
                                                    .text;
                                            editTopic();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        )
        );
      }
      setState(() {
        previousTopicsCovered = topicsCoveredArr;
      });
    }
    else
    {
      String? msg = objectEventp.object as String?;
   /*   Flushbar(
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
          fontSize: 16.0
      );
    }
  }
  Future<void> deleteTopic() async {
    EventObject objectEventTopic = await deleteTopicsCovered(topicId!);
    setState(() {
      if (objectEventTopic.success!) {
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => TopicsCovered()),
           );
       /*    Flushbar(
             title: "Success",
             message: "Deleted",
             icon: Icon(Icons.done_outline),
             backgroundColor: AppTheme.appColor,
             duration: Duration(seconds: 2),
           )..show(context);*/
           Fluttertoast.showToast(
               msg: "Deleted",
               toastLength: Toast.LENGTH_LONG,
               timeInSecForIosWeb: 3,
               backgroundColor: AppTheme.appColor,
               textColor: Colors.white,
               fontSize: 16.0
           );
         }else {
        String? msg = objectEventTopic.object as String?;
          /* Flushbar(
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
            fontSize: 16.0
        );
         }
    });
  }
  Future<void> editTopic() async {
    EventObject objectEventTopics  = await editTopicsCovered(topicId! , topicsCoveredEditString!);
    setState(() {
      if(objectEventTopics.success!){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TopicsCovered()),
        );
      /*  Flushbar(
          title: "Success",
          message: "Edit Done",
          icon: Icon(Icons.done_outline),
          backgroundColor: AppTheme.appColor,
          duration: Duration(seconds: 2),
        )..show(context);*/
        Fluttertoast.showToast(
            msg: "Edit Done",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3,
            backgroundColor: AppTheme.appColor,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else {
        String? msg = objectEventTopics.object as String?;
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
            fontSize: 16.0
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    final dateUi = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: dateValue,
          hint: Text("Select Date"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dateSelected = true;
              dateValue = newValue!;
              syncPreviousStaffTopics();
            });
          },
          items: datesOptions
              .map((key, value) {
            return MapEntry(
                value,
                DropdownMenuItem<String>(
                  value: key,
                  child: Text(value),
                ));
          })
              .values
              .toList()),
    );

    final topicsCoveredText = Center(
      child: IconButton(
          icon: Icon(FontAwesomeIcons.plus, color: AppTheme.appColor),
        iconSize: MediaQuery.of(context).size.width * .08,
        onPressed: () async {
         await Navigator.push(
           context,
           MaterialPageRoute(
               builder: (context) =>
             AddTopicsCovered(dateId: dateValue!)
         ));
        },
      ),
    );


    final body = Center(
      child: Column(
          children: <Widget>[
            Padding(
               padding: EdgeInsets.only(top: 10),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              child:Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: dateUi,
                  ),
                  dateSelected ?
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: topicsCoveredText
                  )
                      :Container()
                ],
              ),
            ),
            dateSelected ?
            new Expanded(
                child:ListView(
                  children: previousTopicsCovered,
                )
            )
             :Container(),
          ],
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(SCHOOL_NAME),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    new  MaterialPageRoute(builder: (context) => HomePage(type: loggedStaff!.type!, sectionid: loggedStaff!.section!, Id: "", Academicyear: "")));
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
      body: Container(
        width: MediaQuery.of(context).size.width,
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
          onPressed: (){
            logOut(loggedStaff!.type!,loggedStaff!.id!);
            removeUserData();
            while(Navigator.canPop(context)){
              Navigator.pop(context);
            }
//          Navigator.pop(context);
            Navigator.of(context).pushReplacement(
                new  MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child:Icon(FontAwesomeIcons.doorOpen,color: AppTheme.floatingButtonColor, size: 30,),
          backgroundColor: Colors.transparent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),)

      ),
    );
  }
}