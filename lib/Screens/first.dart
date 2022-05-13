import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Login.dart';
import 'package:flutter_application_1/Screens/second.dart';
import 'package:flutter_application_1/screens/first.dart';

void main() {
  runApp(first());
}

class first extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstDemo(),
    );
  }
}

class FirstDemo extends StatefulWidget {
  @override
  _FirstDemo createState() => _FirstDemo();
}

class _FirstDemo extends State<FirstDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    appBar: AppBar(
        backgroundColor: Color(0xffffDD83),
        title: Text("Start" ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 180.0),
              child: Center(
                child: Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: AssetImage(
                          "/Users/mac/Desktop/499/Untitled/WasteManagementApp/assets/images/third.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 210,
                  height: 170,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 5),
              child: Text(
                '\n Track your bins effectively \n   for a better enviroment',
                style: TextStyle(fontSize: 24, fontWeight:FontWeight.bold),
              ), 
             
            ),
    Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0, bottom: 0),
              child: Text(
                '\n To manage the waste and \nbe notified when bins are full',
                style: TextStyle(fontSize: 17),
              ), 
             
            ),
          /*  ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FirstDemo()));
                    },
                    elevation: 4.0,
                    fillColor: Color(0xff28CC9E),
                    padding: EdgeInsets.all(5.0),
                    shape: CircleBorder(),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => second()));
                    },
                    elevation: 2.0,
                    fillColor: Color(0xff28CC9E),
                    padding: EdgeInsets.all(5.0),
                    shape: CircleBorder(),
                  )
                ],
              ),
            ),*/
            Container(
              height: 40,
              width: 250,
              margin: const EdgeInsets.only(top: 40.0),
              decoration: BoxDecoration(
                  color: Color(0xff28CC9E),
                  borderRadius: BorderRadius.circular(10)),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
