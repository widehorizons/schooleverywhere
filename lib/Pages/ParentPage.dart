import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/Parent.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Modules/Parent.dart';
import '../Networking/Futures.dart';
import 'LoginPage.dart';
import 'ParentIndexPage.dart';

class ParentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ParentPageState();
  }
}

class _ParentPageState extends State<ParentPage> {
  List<Widget> children = [];
  List<Widget> listOfchildren = [];
  Parent? loggedParent;

  Future<void> getLoggedParent() async {
    loggedParent = await getUserData() as Parent;
    getChildrenOfParentePage();
  }

  Future<void> getChildrenOfParentePage() async {
    List<dynamic> y = loggedParent!.childrenId;
    Map Pagearr = new Map();
    for (int i = 0; i < y.length; i++) {
      Pagearr[loggedParent!.childrenName[i]] = loggedParent!.childrenImge[i];
      String imageUrl = loggedParent!.childrenImge[i].toString();
      listOfchildren.add(GestureDetector(
        onTap: () {
          String regno = loggedParent!.childrenId[i].toString();
          String section = loggedParent!.childrenSection[i].toString();
              goParentHomeS(section,regno);
            },
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * .10,
              backgroundImage: NetworkImage("https://" + imageUrl),
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .05),
                  child: Text(
                    loggedParent!.childrenName[i].toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.appColor),
                  )),
            )
          ],
        ),
      ));
      listOfchildren.add(Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * .03),
      ));
    }
    setState(() {
      children = listOfchildren;
    });
  }

  @override
  initState() {
    super.initState();
    getLoggedParent();
  }

  @override
  Widget build(BuildContext context) {
    final body = Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50, bottom: 40),
          ),
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
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('img/logo.png'),
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
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .1),
            child: Center(
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * .02),
                  children: children,
                ),
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: (){
            logOut(loggedParent!.type!,loggedParent!.id!);
            removeUserData();
            while(Navigator.canPop(context)){
              Navigator.pop(context);
            }
            Navigator.of(context).pushReplacement(
                new  MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child:Icon(FontAwesomeIcons.doorOpen,color: AppTheme.floatingButtonColor, size: 30,),
          backgroundColor: Colors.transparent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),)

      ),
    );
  }
  Future<void> goParentHomeS(String section,String regno) async {
    loggedParent!.regno = regno;
    loggedParent!.childeSectionSelected = section;
    await setUserData(loggedParent!);
print(regno);
   // print(loggedParent.academicYear);
  // bool getData = await goParentHome(loggedParent.regno, loggedParent.academicYear);
  // if(getData == true){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParentIndexPage(),
        ));
   // }
  }
}
