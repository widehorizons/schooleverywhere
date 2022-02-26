import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Networking/Futures.dart';
import '../Pages/LoginPage.dart';
import '../Style/theme.dart';
import '../SharedPreferences/Prefs.dart';
import 'GeolocationPage.dart';

class GeolocationHome extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return new _GeolocationHomeState();
  }
}


class _GeolocationHomeState extends  State<GeolocationHome>{

   String? routeValue, periodValue;
  Map routeOptions=new Map();
  Map periodOptions=new Map();
  bool routeSelected = false;
  bool periodSelected = false;
   Parent? loggedParent;
  //
  @override
  void initState() {
    super.initState();
    getLoggedParent();
  }

  Future<void> getLoggedParent() async {
    loggedParent = await getUserData() as Parent;
    print( "dataP"+loggedParent!.regno);
    syncStudentRouteOptions();
  }

  Future<void> syncStudentRouteOptions() async {
    EventObject eventObject = await studentRouteOptions(
        loggedParent!.regno.toString(),loggedParent!.academicYear.toString(),
        loggedParent!.semester.toString(),loggedParent!.childeSectionSelected.toString(),
        loggedParent!.stage.toString());
    if(eventObject.success!){
      Map? data =eventObject.object as Map?;

      List<dynamic> toto = data!['id'];
      Map routeArr= new Map();
      for (int i = 0; i < toto.length; i++) {
        routeArr[data['id'][i]]=data['bus'][i];
      }
      setState(() {
        routeOptions=routeArr;
      });
    }else{
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
          fontSize: 16.0
      );
    }

  }

  Future<void> syncStudentPeriodOptions() async {
    EventObject eventObject = await studentPeriodOptions(routeValue!,loggedParent!.academicYear);
    if(eventObject.success!){
      Map? data = eventObject.object as Map?;
      List<dynamic> xoxo = data!['periodId'];
      Map periodArr= new Map();
      for (int i = 0; i < xoxo.length; i++) {
        periodArr[data['periodId'][i]]=data['periodData'][i];
      }
      setState(() {
        periodOptions=periodArr;
      });
    }else{
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
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final route = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
        isExpanded: true,
        value: routeValue,
        hint: Text("Select Bus Route"),
        style: TextStyle(
            color: AppTheme.appColor
        ),
        selectedItemBuilder: (BuildContext context){
         return routeOptions.map<String,Widget>((key, value){
            return MapEntry(value, Text(value,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),));
          }

          ).values.toList();
        },
        underline: Container(
          height: 2,
          color: AppTheme.appColor,
        ),
        onChanged: (String? newValue) {
          setState(() {
            routeSelected = true;
            routeValue = newValue!;
            periodOptions.clear();
            periodValue = '';
            periodSelected = false;
            syncStudentPeriodOptions();
          });
        },
          items: routeOptions.map((key, value){
            return MapEntry(value, DropdownMenuItem<String>(value: key,child: Text(value,),));
          }

          ).values.toList()
      ),
    );

    final period = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: DropdownButton<String>(
            isExpanded: true,
            value: periodValue,
            hint: Text("Select Period"),
            style: TextStyle(
                color: AppTheme.appColor
            ),
            underline: Container(
              height: 2,
              color: AppTheme.appColor,
            ),
            onChanged: (String? newValue) {
              setState(() {
                periodSelected = true;
                periodValue = newValue!;
              });
            },
            items: periodOptions.map((key, value){
              return MapEntry(value, DropdownMenuItem<String>(value: key,child: Text(value),));
            }

            ).values.toList()
        )
    );

    final goButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) =>
          //           GeolocationPage(routeid: routeValue!,periodid: periodValue!, parentSection: loggedParent!.childeSectionSelected,parentAcademicYear: loggedParent!.academicYear)),
          // );
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('GO', style: TextStyle(color: Colors.white)),
      ),
    );

    final body = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width *.8,
            child: route,
          ),
          routeSelected ?
          SizedBox(
            width: MediaQuery.of(context).size.width *.8,
            child: period,
          )
              :Container(),
          periodSelected ?
          SizedBox(
            width: MediaQuery.of(context).size.width *.4,
            child: goButton,
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
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('img/logo.png'),
            )
          ],
        ),
        backgroundColor: AppTheme.appColor,
      ),
      body: Container(
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
            logOut(loggedParent!.type!,loggedParent!.id!);
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