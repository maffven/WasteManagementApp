import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/DriverMenu.dart';
import 'package:flutter_application_1/Screens/ForgotPass.dart';
import 'package:flutter_application_1/model/Complaints.dart';
import 'package:flutter_application_1/model/BinLocation.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/Screens/AdminMenu.dart';
import 'package:flutter_application_1/model/MunicipalityAdmin.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/DriverStatus.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/model/LoginField.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp()
      .then((value) => print("connected " + value.options.asMap.toString()))
      .catchError((e) => print(e.toString()));

  runApp(Login()); //function written by flutter
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  @override
  void initState() {
    super.initState();
  }

//list of needed variables
  bool userType = false; //if a driver of admin
  List<BinLocation> locList = [];
  List<Bin> bins = [];
  List<Bin> binsByCapacity = [];
  MunicipalityAdmin munObj = MunicipalityAdmin();
  List<MunicipalityAdmin> munList;
  List<Bin> bb;
  List<Driver> dd;
  List<District> disList;
  List<Complaints> complaints;
  int phone;
  bool passCheck = false;
  bool phoneCheck = false;
  String password;
  int loggedInId;

  //Take input from user or textview
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //display warning when fields are empty
  void showDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Warning"),
          content: Text("please enter all the fields"),
          actions: [
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

//show warning when text fields (password & username) don't match the database
  void showDialogError() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Warning"),
          content: Text("Password or phone are incorrect"),
          actions: [
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xffffDD83),
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 150, bottom: 0),
              child: Text(
                'Hello!',
                style: TextStyle(color: Colors.black, fontSize: 45),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0, bottom: 60),
              child: Text(
                'Login to your account',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                  key: ValueKey("addPhone"),
                  controller: phoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone number',
                  )),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                key: Key("addPassword"),
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText:
                        'For new users, please enter last 6 digits\n of your registered mobile'),
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ), //SizedBox
                Text(
                  'Are You An Admin? ',
                  style: TextStyle(fontSize: 15.0),
                ), //Text
                Checkbox(
                  key: Key("checkType"),
                  checkColor: Colors.white,
                  focusColor: Color(0xff28CC9E),
                  value: userType,
                  onChanged: (bool value) {
                    setState(() {
                      userType = value;
                    });
                  },
                ),
              ], //<Widget>[]
            ), //Row
            FlatButton(
              key: Key("forgotPassword"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ForgotPass()));
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                    fontSize: 15, decoration: TextDecoration.underline),
              ),
            ),

            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Color(0xff28CC9E),
                  borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                key: Key("loginButton"),
                onPressed: () async {
                  List<dynamic> muniList = await readAll(tableDriverStatus);
                  List<DriverStatus> drSt = muniList.cast();
                  for (int i = 0; i < drSt.length; i++) {
                    print(drSt[i].lateStatus);
                    print(drSt[i].driverID);
                  }
                  //  deleteObj(19, tableComplaints);
                  List<BinLevel> binLevel = [];
                  List<dynamic> compDB = await readAll(tableBinLevel);
                  binLevel = compDB.cast();
                  print(binLevel.length);
                  for (int i = 0; i < binLevel.length; i++) {
                    print('the id : ' + '${binLevel[i].full}');
                    print('the bin id : ' + '${binLevel[i].binID}');
                    print('the id : ' + '${binLevel[i].level}');
                  }
                  
                  //frist, check if text fields are not empty
                  if (phoneController.text == "" &&
                      passwordController.text == "") {
                    showDialog();
                  } else {
                    //get text field's input from the user
                    phone = int.parse(phoneController.text);
                    password = passwordController.text;
                    //first check if its an admin or a driver
                    if (userType != true) {
                      //driver
                      print("driver");
                      //check login info from the database driver's list
                      List<dynamic> drListd = await readAll(tableDriver);
                      dd = drListd.cast();
                      for (int i = 0; i < dd.length; i++) {
                        if (dd[i].phone == phone) {
                          loggedInId = dd[i].driverID;
                        }

                        bool checkPhone = await LoginField.checkPhone(phone, userType);

                        bool checkPassword =
                            await LoginField.checkPassword(password, userType);
                        if (checkPhone != false) {
                          phoneCheck = true;
                        }
                        if (checkPassword != false) {
                          passCheck = true;
                        }
                      }

/*.........................CHECK ALL CONDITIONS.......................
1. phone and password both aren't correct 
2. phone is correct but password isn't
3. phone isn't correct but password is
4. both are correct so store the loggedIn Id and navigate to the menu
.....................................................................*/

                      if (phoneCheck != true && passCheck != true) {
                        showDialogError();
                      }
                      if (phoneCheck == true && passCheck != true) {
                        showDialogError();
                      }
                      if (phoneCheck != true && passCheck == true) {
                        showDialogError();
                      }
                      if (phoneCheck == true && passCheck == true) {
                        //store the loggedin Id and phone
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setInt('id', loggedInId);
                        await prefs.setInt('phone', phone);
                        print(prefs.getInt('phone'));
                        // print(loggedInId);
                        //naviagte to the driver's menu screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DriverMenu()));
                      }
                    } else {
                      print("admin");
                      //admin

                      List<dynamic> muniList =
                          await readAll(tableMunicipalityAdmin);
                      munList = muniList.cast();
                      for (int i = 0; i < munList.length; i++) {
                        if (munList[i].phone == phone) {
                          phoneCheck = true;
                          loggedInId = munList[i].municpalityID;
                        }
                        bool checkPhone = await LoginField.checkPhone(phone, userType);

                        bool checkPassword =
                            await LoginField.checkPassword(password, userType);
                        if (checkPhone != false) {
                          phoneCheck = true;
                        }
                        if (checkPassword != false) {
                          passCheck = true;
                        }
                      }

/*.........................CHECK ALL CONDITIONS.......................
1. phone and password both aren't correct 
2. phone is correct but password isn't
3. phone isn't correct but password is
4. both are correct so store the loggedIn Id and navigate to the menu
.....................................................................*/

                      if (phoneCheck != true && passCheck != true) {
                        showDialogError();
                      }
                      if (phoneCheck == true && passCheck != true) {
                        showDialogError();
                      }
                      if (phoneCheck != true && passCheck == true) {
                        showDialogError();
                      }
                      if (phoneCheck == true && passCheck == true) {
                        //store the loggedin id and phone
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setInt('id', loggedInId);
                        await prefs.setInt('phone', phone);
                        print(prefs.getInt('phone'));
                        // print(loggedInId);
                        //naviagte to the admin's menu screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminMenu()));
                      }
                    }
                  }
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

  //required method from the database
  Future<Driver> getLoginId(int phone) async {
    return await DatabaseHelper.instance.getLoginId(phone);
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
  }

  Future<dynamic> verifyLogin(String password, int phone) async {
    return await DatabaseHelper.instance.checkLogin(password, phone);
  }

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
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
}
