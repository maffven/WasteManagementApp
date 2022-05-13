import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/second.dart';
import 'package:flutter_application_1/screens/first.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:firebase_database/firebase_database.dart';

BinLevel level = BinLevel();
var distance = 0.0;
final databaseReference = FirebaseDatabase.instance.reference();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp()
      .then((value) => print("connected " + value.options.asMap.toString()))
      .catchError((e) => print(e.toString()));

  runApp(Logo());
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogoDemo(),
    );
  }
}

class LogoDemo extends StatefulWidget {
  @override
  _LogoDemoState createState() => _LogoDemoState();
}

class _LogoDemoState extends State<LogoDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xffffDD83),
        title: Text("Hello"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => first()),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(top: 240.0, right: 10),
                child: Center(
                  child: Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: AssetImage(
                            "/Users/mac/Desktop/499/Untitled/WasteManagementApp/assets/images/ourLogo.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 207,
                    height: 170,
                  ),
                  
                ),
              ),
              
            )
          ],
        ),
      ),
    );
  }
}
