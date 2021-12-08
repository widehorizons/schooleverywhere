import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/LoginPage.dart';
import 'MaintenanceLocation.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class PreviousMaintenanceLocation extends StatefulWidget {
  final String id;
  final String year;
  final String section;
  const PreviousMaintenanceLocation(this.id, this.year, this.section);

  @override
  State<StatefulWidget> createState() {
    return new _PreviousMaintenanceLocationState();
  }
}

class _PreviousMaintenanceLocationState
    extends State<PreviousMaintenanceLocation> {
  bool isLoading = false;
  List<dynamic> maintenanceProblems = [];
  initState() {
    super.initState();
    syncPreviousMaintenanceProblems();
  }

  Future<void> syncPreviousMaintenanceProblems() async {
    EventObject objectEventSt =
        await previousMaintenanceProblems(widget.id, widget.year);
    if (objectEventSt.success!) {
      Map? dataShowContentData = objectEventSt.object as Map?;
      List<dynamic> listOfColumns = dataShowContentData!['data'];
      setState(() {
        maintenanceProblems = listOfColumns;
        isLoading = true;
      });
    } else {
      String? msg = objectEventSt.object as String?;
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

  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => MaintenanceLocation()));
          break;
        case 1:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => PreviousMaintenanceLocation(
                      widget.id, widget.year, widget.section)));
          break;
      }
    });
  }

  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final showData = !isLoading
        ? loadingSign
        : Center(
            child: DataTable(
            columns: [
              DataColumn(
                  label: Text(
                "Employee In Charge",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
              DataColumn(
                  label: Text(
                "Date",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
              DataColumn(
                  label: Text(
                "Action",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
              DataColumn(
                  label: Text(
                "Recommendations",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
              DataColumn(
                  label: Text(
                "Reply",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
              DataColumn(
                  label: Text(
                "Problem Date",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
              DataColumn(
                  label: Text(
                "User",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
              DataColumn(
                  label: Text(
                "Problem",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
              DataColumn(
                  label: Text(
                "Description",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
            ],
            rows:
                maintenanceProblems // Loops through dataColumnText, each iteration assigning the value to element
                    .map(
                      ((element) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(
                                element["employee"],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              )),
                              DataCell(Text(
                                element["date"],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              )),
                              DataCell(Text(
                                element["action"],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              )),
                              DataCell(Text(
                                element["Recommendations"],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              )),
                              DataCell(Text(
                                element["Repaly"],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              )),
                              DataCell(Text(
                                element["problemDate"],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              )),
                              DataCell(Text(
                                element["user"],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              )),
                              DataCell(Text(
                                element["problem"],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              )),
                              DataCell(Text(
                                element["description"],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              )),
                            ],
                          )),
                    )
                    .toList(),
          ));

    final body = ListView(children: <Widget>[
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: showData,
        ),
      ),
    ]);

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
                        type: STAFF_TYPE,
                        sectionid: widget.section,
                        Id: widget.id,
                        Academicyear: widget.year)));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    AssetImage('FlavorConfig.instance.values.imagePath!'),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_comment),
            title: Text('New Problem'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.low_priority),
            title: Text('Previous'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.appColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: () {
            logOut(STAFF_TYPE, widget.id);
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
