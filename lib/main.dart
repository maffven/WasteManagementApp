import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/Screens/Logo.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'Screens/DriverMenu.dart';
import 'model/BinLevel.dart';
import 'model/BinLocation.dart';
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

class MyAppDemo extends StatefulWidget {
  @override
  _MyAppDemoState createState() => _MyAppDemoState();
}

//Rawan work

class _MyAppDemoState extends State<MyAppDemo> {
  BinLevel level = BinLevel();
  var distance = 0.0;
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
  void readDistance() {
    print("entered read distance");
    //this means the data is up to date
    databaseReference.onValue.listen((event) {
      final distanceFirebase =
          new Map<String, dynamic>.from(event.snapshot.value);
      print(distanceFirebase['Distance']); //json data
      distance = distanceFirebase['Distance'].toDouble(); 
      print(distance);//get teh distance from the firebase
      if (distance <= 15.0) {
        //full

        level =
            BinLevel(binID: 144, full: true, half_full: false, empty: false);
      } else if (distance > 15.0 && distance < 900.0) {
        //half-full

        level =
            BinLevel(binID: 144, full: false, half_full: true, empty: false);
      } else {
        //empty

        level =
            BinLevel(binID: 144, full: false, half_full: false, empty: true);
        ;
      }
// addObj(level, tableBinLevel);
    updateObj(level.level, level, tableBinLevel);
    });
  }
 Future addObj(dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalCreate(obj, tableName);
    print("object inserted");
  }
  Future updateObj(int id, dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalUpdate(tableName, id, obj);
  }
}
