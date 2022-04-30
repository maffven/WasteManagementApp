import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/Screens/Login.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/Complaints.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/model/LoginField.dart';

void main() {
  runApp(ForgotPass()); //function written by flutter
}

class ForgotPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ForgotPasswordDemo(),
    );
  }
}

class ForgotPasswordDemo extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordDemo> {
  List<District> disList;
  List<Driver> dd;
  int driverId;
  int phone;
  int munId;
  String fname;
  String lname;
  String email;
  String workTime;
  String newPassField;
  bool matchCheck = false;
  String confPassField;
  final dbHelper = DatabaseHelper.instance;

  void showDialogSuccess() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Confirmation"),
          content: Text("passowrd updated successfully"),
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

  void showDialogError() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Warning"),
          content: Text("Passwords don't match"),
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

  void showDialogValPassword() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Warning"),
          content: Text("Enter a valid password"),
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

  //function written by flutter
  final TextEditingController newPass = new TextEditingController();
  final TextEditingController confPass = new TextEditingController();
  final TextEditingController phoneField = new TextEditingController();
  //from database
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop()),
          backgroundColor: Color(0xffffDD83),
          title: Text("Reset Password"),
        ),
        body: new Center(
          child: new Container(
            child: new Column(
              children: [
                new Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, top: 57, bottom: 24),
                  child: new Row(),
                ),
                new Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, top: 24, bottom: 55),
                  child: new Row(),
                ),
                Container(
                  height: 100,
                  width: 350,
                  child: new TextField(
                    key: Key("addPhone"),
                    controller: phoneField,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: Colors.greenAccent)),
                        labelText: 'Phone ',
                        suffixStyle: const TextStyle(color: Colors.green)),
                  ),
                ),
                Container(
                  height: 100,
                  width: 350,
                  child: new TextField(
                    key: Key("addNewPassword"),
                    controller: newPass,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: Colors.greenAccent)),
                        labelText: 'New Password',
                        suffixStyle: const TextStyle(color: Colors.green)),
                  ),
                ),
                Container(
                  height: 150,
                  width: 350,
                  child: new TextField(
                    key: Key("addConfirmedPasswrd"),
                    controller: confPass,
                    keyboardType: TextInputType.multiline,
                    minLines: 1, //Normal textInputField will be displayed
                    maxLines: 10, //
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: Colors.greenAccent)),
                        labelText: 'Confirm New Password',
                        suffixStyle: const TextStyle(color: Colors.green)),
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  margin: const EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(
                      color: Color(0xff28CC9E),
                      borderRadius: BorderRadius.circular(20)),
                  child: FlatButton(
                    key: Key("submit"),
                    onPressed: () async {
                
                      //frist, check if text fields are not empty
                      if (newPass.text == "" && confPass.text == "") {
                        showDialog();
                      } else {
                        //get text field's input from the user
                        newPassField = newPass.text;
                        phone = int.parse(phoneField.text);
                        confPassField = confPass.text;
                        //validate the password
                        if (LoginField.validatePassword(newPass.text) == null) {
                          //check if the two passwords match
                          if (LoginField.matchTwoPasswords(
                                  newPassField, confPassField) ==
                              true) {
                            matchCheck = true;
                            List<dynamic> drListd = await readAll(tableDriver);
                            dd = drListd.cast();
                            for (int i = 0; i < dd.length; i++) {
                              print("${dd[i].driverID}");
                              print("${dd[i].phone}");
                              print("${dd[i].password}");

                              if (phone == dd[i].phone) {
                                driverId = dd[i].driverID;
                                fname = dd[i].firstName;
                                lname = dd[i].lastName;
                                email = dd[i].email;
                                munId = dd[i].municpalityID;
                                workTime = dd[i].workTime;
                              }
                            }
                            print("$driverId");
                            //create a driver object with the new updated password

                            Driver updatedDriver = Driver(
                                driverID: driverId,
                                municpalityID: munId,
                                firstName: fname,
                                lastName: lname,
                                password: confPassField,
                                email: email,
                                phone: phone,
                                workTime: workTime);

                            //update password in the database
                            updateObj(driverId, updatedDriver, tableDriver);
                            showDialogSuccess();
                            print("updated successsfully");
                            //move back to the login screen
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          } else {
                            showDialogError();
                          }
                        } else {
                          showDialogValPassword();
                        }
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future addObj(dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalCreate(obj, tableName);
    print("object inserted");
  }

  Future addCol(dynamic obj, String tableName) async {
    await DatabaseHelper.instance.alterTable(tableName, obj);
    print("object inserted");
  }

  Future updateObj(int id, dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalUpdate(tableName, id, obj);
  }

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
    // print("mun object: ${munList[0].firatName}");
  }
}
