import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_application_1/Screens/CommonFunctions.dart';
import 'package:flutter_application_1/Screens/Logo.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/DriverStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/BinLevel.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp()
      .then((value) => print("connected " + value.options.asMap.toString()))
      .catchError((e) => print(e.toString()));

  runApp(MyAppDemo());
}

/// This Widget is the main application widget.
/*class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Training',
      home: DriverMenu(),
    );
  }

  
  
}*/
//addObj(DriverStatus,)

class MyAppDemo extends StatefulWidget {
  @override
  _MyAppDemoState createState() => _MyAppDemoState();
}

//Rawan work

class _MyAppDemoState extends State<MyAppDemo> {
  BinLevel level;
  var distance = 0.0;
  int binId = 0;
  bool loadData = false;

  @override
  void initState() {
    super.initState();

    readDistance();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Training',
      home: Logo(), //DriverMenu(),
    );
  }

//Create a firebase database reference
  final databaseReference = FirebaseDatabase.instance.reference();
//to read the distance from the firebase
  void readDistance() async {
    print("entered read distance");
    //this means the data is up to date
    databaseReference.onValue.listen((event) {
      final distanceFirebase =
          new Map<String, dynamic>.from(event.snapshot.value);
      print(distanceFirebase['Distance']); //json data
      distance = distanceFirebase['Distance'].toDouble();
      binId = distanceFirebase['BinId'];
      print(distance);

      print(binId); //get teh distance from the firebase
      //
      _getList();

      // DriverStatus d1 = new DriverStatus(
      //     driverID: 1,
      //     statusID: 1,
      //     completed: false,
      //     incomplete: false,
      //     performance:
      //     lateStatus: false);
      // //addObj(d1, tableDriverStatus);
      // DriverStatus d2 = new DriverStatus(
      //     driverID: 2,
      //     statusID: 2,
      //     completed: false,
      //     incomplete: false,
      //     lateStatus: false);
      // //addObj(d2, tableDriverStatus);
      // DriverStatus d3 = new DriverStatus(
      //     driverID: 3,
      //     statusID: 3,
      //     completed: false,
      //     incomplete: false,
      //     lateStatus: false);
      // //addObj(d3, tableDriverStatus);
      // DriverStatus d4 = new DriverStatus(
      //     driverID: 4,
      //     statusID: 4,
      //     completed: false,
      //     incomplete: false,
      //     lateStatus: false);
      // //addObj(d4, tableDriverStatus);
      // DriverStatus d5 = new DriverStatus(
      //     driverID: 5,
      //     statusID: 5,
      //     completed: false,
      //     incomplete: false,
      //     lateStatus: false);
      //addObj(d5, tableDriverStatus);
// addObj(level, tableBinLevel);
    });
  }

  Future deleteObj(int id, String tableName) async {
    print("$id rawan");
    await DatabaseHelper.instance.gneralDelete(id, tableName);
    print("Object is deleted");
  }

  Future addObj(dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalCreate(obj, tableName);
  }

  Future updateObj(int id, dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalUpdate(tableName, id, obj);
  }

  void _getList() async {
    //for every bin one binlevel
    CommonFunctions com = new CommonFunctions();
    List<BinLevel> binslevel = await com.getBinsLevel();
    for (var i = 0; i < binslevel.length; i++) {
      if (binslevel[i].binID == binId) {
        level = binslevel[i];
        loadData = true;
        if (loadData) {
          if (distance <= 15.0) {
            //full
            level = BinLevel(
                level: level.level,
                binID: binId,
                full: true,
                half_full: false,
                empty: false);
            await updateObj(level.level, level, tableBinLevel);
          } else if (distance > 15.0 && distance < 900.0) {
            //half-full
            level = BinLevel(
                level: level.level,
                binID: binId,
                full: false,
                half_full: true,
                empty: false);
            updateObj(level.level, level, tableBinLevel);
          } else {
            //empty
            level = BinLevel(
                level: level.level,
                binID: binId,
                full: false,
                half_full: false,
                empty: true);
            updateObj(level.level, level, tableBinLevel);
          }
        }

        break;
      } else {
        setState(() {
          loadData = false;
        });
      }
    }
    if (loadData == false) {
      setState(() {
        level =
            BinLevel(binID: binId, full: false, half_full: false, empty: true);
        addObj(level, tableBinLevel);
      });
    }
  }
}
