import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Login.dart';
import 'package:flutter_application_1/Screens/SendComplaint.dart';
import 'package:flutter_application_1/screens/first.dart';
import 'DriverMenu.dart';

void main() {
  runApp(CompResult());
}

class CompResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CompResultDemo(),
    );
  }
}

class CompResultDemo extends StatefulWidget {
  @override
  _CompResultDemo createState() => _CompResultDemo();
}

class _CompResultDemo extends State<CompResultDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xffffDD83),
        title: Text("Send a complaint"),
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
                          "/Applications/XAMPP/xamppfiles/htdocs/Untitled/SeniorProject498/assets/images/confirm1.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 250,
                  height: 250,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 20, bottom: 30),
              child: Text(
                '\n Your complaint was sent \n           successfully',
                style: TextStyle(fontSize: 21),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DriverMenu()));
                },
                child: Text(
                  'Home',
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

  void _incrementCounter() {}
  void _decrementCounter() {}
}
