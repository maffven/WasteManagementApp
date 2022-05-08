import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/mapSc.dart';
import 'package:flutter_application_1/screens/first.dart';
import 'package:flutter_application_1/screens/Login.dart';

class second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: secondDemo(),
    );
  }
}

class secondDemo extends StatefulWidget {
  @override
  _secondDemo createState() => _secondDemo();
}

class _secondDemo extends State<secondDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xffffDD83),
        title: Text("Start"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Center(
                child: Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: AssetImage(
                          "/Users/mac/Desktop/flutter_application_1/assets/images/second.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 207,
                  height: 170,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 20, bottom: 30),
              child: Text(
                '\n Better manage the waste and \n be notified when bins are full',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ListTile(
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
            ),
            Container(
              height: 50,
              width: 250,
              margin: const EdgeInsets.only(top: 40.0),
              decoration: BoxDecoration(
                  color: Color(0xff28CC9E),
                  borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
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
