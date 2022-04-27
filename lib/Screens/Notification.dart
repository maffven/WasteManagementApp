import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/DatabaseHelper.dart';
import '../model/Bin.dart';
//import 'package:custom_list_flutter_app/Person.dart';

class Notifications extends StatefulWidget {
  @override
  final Widget child;
  Notifications({Key key, this.child}) : super(key: key);
  NotificationState createState() => NotificationState();
}

class notif {
  String name;
  String count;

  notif({this.name, this.count});
}

List<notif> persons = [
  notif(name: 'Alrawdah ', count: 'Full bin 1807422'),
  notif(name: 'AlNaseem ', count: 'Full bin 1807422'),
  notif(name: 'AlWaha ', count: 'Full bin 1807422')
];

class NotificationState extends State<Notifications> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAssignedDistricts().whenComplete(() => setState(() {}));
  }

  List<District> assignedDistricts = [];
  int driverId;
  Driver driver;
  bool _status = true;
  List<BinLevel> binLevel;
  List<Bin> bin;
  final FocusNode myFocusNode = FocusNode();

  Widget personDetailCard(Person) {
    for (int i = 0; i < binLevel.length; i++) {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Card(
          color: Color.fromARGB(255, 255, 244, 208),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // child: Container(
                  // width: 50.0,
                  // height: 50.0,
                  // ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.circle,
                      color: Color.fromARGB(255, 252, 10, 10),
                      size: 15,
                    ),
                    SizedBox(
                      width: 50,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      // Person.name,
                      "${bin[i].districtId} ${binLevel[i].binID}",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      //Person.count,
                      "${binLevel[i].full}",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffDD83),
        centerTitle: true,
        title: Text("Notifications"),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
          ),
        ],

        //title: Text("Notifications"),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            Column(
                children: persons.map((p) {
              return personDetailCard(p);
            }).toList()),
          ],
        ),
      ),
    ));
  }

  Future addObj(dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalCreate(obj, tableName);
    print("object inserted");
  }

  //generalUpdate(String tablename, int id, dynamic obj)
  Future updateObj(int id, dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalUpdate(tableName, id, obj);
  }

  //read objects
  //int id, String tableName, dynamic classFields, dynamic className
  Future<dynamic> readObj(int id, String tableName) async {
    return await DatabaseHelper.instance.generalRead(tableName, id);
    //print("mun object: ${munObj.firatName}");
  }

  Future<dynamic> verifyLogin(String password, int phone) async {
    return await DatabaseHelper.instance.checkLogin(password, phone);
    //print("mun object: ${munObj.firatName}");
  }

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
    // print("mun object: ${munList[0].firatName}");
  }

  //Delete a row
  //gneralDelete(int id, String tablename)
  Future deleteObj(int id, String tableName) async {
    print("$id rawan");
    await DatabaseHelper.instance.gneralDelete(id, tableName);
    print("Object is deleted");
  }

  //Close database  Method
  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }

  Future<void> getAssignedDistricts() async {
    List<Driver> driv;
    List<dynamic> driversDB = await readAll(tableDriver);
    driv = driversDB.cast();
    await _retriveDriver(driv);
    List<District> district;
    List<dynamic> districtDB = await readAll(tableDistrict);
    district = districtDB.cast();
    print("in get distric method");
    print("district length ${districtDB.length}");
    setState(() {
      for (int i = 0; i < district.length; i++) {
        if (district[i].driverID == driverId) {
          assignedDistricts.add(district[i]);
        }
      }
    });
  }

  Future<void> _retriveDriver(List<Driver> drivers) async {
    //to retrieve the phone from the login interface
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("driver id: ${prefs.getInt('id')}");
    driverId = prefs.getInt('id');
    for (var i = 0; i < drivers.length; i++) {
      print("drivers[i].driverID ${drivers[i].driverID}");
      if (driverId == drivers[i].driverID) {
        driver = drivers[i];
        break;
      }
    }
  }
}
