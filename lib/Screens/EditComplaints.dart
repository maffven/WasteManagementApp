import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/Screens/ViewComplaints.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/Complaints.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/Screens/complaintResult.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class EditComplaints extends StatefulWidget {
  final Widget child;
  final Complaints complaint;
  EditComplaints({Key key, this.child, this.complaint}) : super(key: key);

  _EditComplaints createState() => _EditComplaints(complaint: complaint);
}

class _EditComplaints extends State<EditComplaints> {
  List<District> disList;
  //final Complaints complaint;
  List<Complaints> complaints = [];
  List<Driver> dd;
  final Complaints complaint;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
void showDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Confirmation"),
          content: Text("Status updated successfully"),
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
  bool status = false;
  _EditComplaints({this.complaint});

  final dbHelper = DatabaseHelper.instance;
  //from database
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop()),
          backgroundColor: Color(0xffffDD83),
          title: Text("Edit Complaint"),
        ),
        body: 
        
        new Center(
          child: new Container(
            child: new Column(
              children: [
                new Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, top: 57, bottom: 24),
                  child: new Row(
                    children: <Widget>[
                      Text("Bin Id: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0)),
                      Text("${complaint.binID}",
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.0)),
                    ],
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, top: 24, bottom: 55),
                  child: new Row(
                    children: <Widget>[
                      Text("Driver Id: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0)),
                      Text("${complaint.driverID} ",
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.0)),
                    ],
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, top: 24, bottom: 55),
                  child: new Row(
                    children: <Widget>[
                      Text("Subject: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0)),
                      Text("${complaint.subject} ",
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.0)),
                    ],
                  ),
                ),
               new Padding(
                  padding: const EdgeInsets.only(
                      left: 1.0, right: 235.0, top: 0, bottom: 0),child:    
                Text("Description: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0)),),
                new Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 24, bottom: 10),
                  child: 
                      Text("${complaint.complaintMessage} ",
                          maxLines: 10,
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.0)),
                   
                ),

                new Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, top: 24, bottom: 30),
                  child: new Row(
                    children: <Widget>[
                      Text("Date: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0)),
                      Text(DateFormat('yyyy-MM-dd').format(complaint.date) ,
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.0)),
                              Text('  Time: ', style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0)),
                              Text(DateFormat('HH:mm').format(complaint.date)),
                    ],
                  ),
                ),

                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ), //SizedBox
                    Text(
                      ' Solved ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0),
                    ), //Text
                    Checkbox(
                      checkColor: Colors.white,
                      focusColor: Color(0xff28CC9E),
                      value: status,
                      onChanged: (bool value) {
                        setState(() {
                          status = value;
                          print(status);
                        });
                      },
                    ),
                  ], //<Widget>[]
                ), //Row
                Container(
                  height: 50,
                  width: 250,
                  margin: const EdgeInsets.only(top: 80.0, bottom: 50.0),
                  decoration: BoxDecoration(
                      color: Color(0xff28CC9E),
                      borderRadius: BorderRadius.circular(20)),
                  child: FlatButton(
                    onPressed: () async {
                      if (status== true) {//if the solved checkbox is checked (true)
                        Complaints c = Complaints(
                          complaintID: complaint.complaintID,
                          binID: complaint.binID,
                          complaintMessage: complaint.complaintMessage,
                          status: true,
                          subject: complaint.subject,
                          date: complaint.date,
                          driverID: complaint.driverID,
                          districtName: complaint.districtName,
                        );

                          List<dynamic> drListd = await readAll(tableComplaints);
                      complaints = drListd.cast();
                      for (int i = 0; i < complaints.length; i++) {
                        print(complaints[i].status);
                        print(complaints[i].subject);
           
                      }
                      //to update teh states from false (Not solved) to true (solved)
                        updateObj(complaint.complaintID, c, tableComplaints);
                        showDialog();
                      }else{
                        print('true');
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
    //print("object inserted");
  }

  Future addCol(dynamic obj, String tableName) async {
    await DatabaseHelper.instance.alterTable(tableName, obj);
    print("column inserted");
  }

  Future delCol(dynamic obj, String tableName) async {
    await DatabaseHelper.instance.alterTable1(tableName, obj);
    print("column deleted");
  }

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
    // print("mun object: ${munList[0].firatName}");
  }

  Future<dynamic> readObj(int id, String tableName) async {
    return await DatabaseHelper.instance.generalRead(tableName, id);
    //print("mun object: ${munObj.firatName}");
  }

  Future updateObj(int id, dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalUpdate(tableName, id, obj);
  }
  Future deleteObj(int id, String tableName) async {
    await DatabaseHelper.instance.gneralDelete(id, tableName);
    print("Object is deleted");
  }
}
