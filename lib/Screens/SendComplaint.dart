import 'package:flutter/material.dart';
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
import 'package:flutter_application_1/model/ComplaintFields.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  runApp(MaterialApp(home: SendComplaint()));
}

class SendComplaint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SendComplaintDemo(),
    );
  }
}

class SendComplaintDemo extends StatefulWidget {
  @override
  _SendComplaintState createState() => _SendComplaintState();
}

class _SendComplaintState extends State<SendComplaintDemo> {
  @override
  void initState() {
    super.initState();
    // readD();
  }

  List<District> disList;
  List<Complaints> complaints = [];
  List<Driver> dd;
  //districts
  var itemsDis = [
    "Alnaseem",
    "AlJamea",
    "Alfaisaliyah",
    "Alwaha",
    "Alsulaimania"
  ];
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

  //bins id
  var itemsBin = ["144", "2", "3", "4"];
  //database reference
  final dbHelper = DatabaseHelper.instance;
//get inputs from the user text fields
//---------------------------------------------------------------------
  final TextEditingController binId = new TextEditingController();
  final TextEditingController district = new TextEditingController();
  final TextEditingController summary = new TextEditingController();
  final TextEditingController description = new TextEditingController();
//---------------------------------------------------------------------
  var selectedBinId;
  var selectedDist;
  //from database
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffDD83),
        title: Text("Send Complaint"),
      ),
      body: new Center(
        child: new Container(
          child: new Column(
            children: [
              new Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24.0, top: 57, bottom: 24),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new TextField(
                      controller: binId,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide:
                                  new BorderSide(color: Colors.greenAccent)),
                          labelText: 'Bin Id',
                          suffixStyle: const TextStyle(color: Colors.green)),
                    )),
                    new PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        binId.text = value;
                        selectedBinId = value;
                        print(selectedBinId);
                      },
                      itemBuilder: (BuildContext context) {
                        return itemsBin
                            .map<PopupMenuItem<String>>((String value) {
                          return new PopupMenuItem(
                              child: new Text(value), value: value);
                        }).toList();
                      },
                    ),
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24.0, top: 24, bottom: 55),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new TextField(
                      controller: district,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide:
                                  new BorderSide(color: Colors.greenAccent)),
                          labelText: 'District',
                          suffixStyle: const TextStyle(color: Colors.green)),
                    )),
                    new PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        district.text = value;
                        selectedDist = value;
                        print(selectedDist);
                      },
                      itemBuilder: (BuildContext context) {
                        return itemsDis
                            .map<PopupMenuItem<String>>((String value) {
                          return new PopupMenuItem(
                              child: new Text(value), value: value);
                        }).toList();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                  height: 100,
                  width: 350,
                  child: new Theme(
                    data: new ThemeData(
                      primaryColor: Colors.greenAccent,
                      primaryColorDark: Colors.green,
                    ),
                    child: new TextField(
                      controller: summary,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide:
                                  new BorderSide(color: Colors.greenAccent)),
                          labelText: 'Summary',
                          suffixStyle: const TextStyle(color: Colors.green)),
                    ),
                  )),
              Container(
                  height: 150,
                  width: 350,
                  child: new Theme(
                    data: new ThemeData(
                      primaryColor: Colors.greenAccent,
                      primaryColorDark: Colors.green,
                    ),
                    child: SizedBox(
                      height: 150,
                      child: new TextField(
                        controller: description,
                        keyboardType: TextInputType.multiline,
                        minLines: 1, //Normal textInputField will be displayed
                        maxLines: 20, //
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 60),
                            border: new OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.greenAccent)),
                            labelText: ' Description',
                            suffixStyle: const TextStyle(color: Colors.green)),
                      ),
                    ),
                  )),
              Container(
                height: 50,
                width: 250,
                margin: const EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                    color: Color(0xff28CC9E),
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () async {
                    print(ComplaintFields.validateFields(selectedBinId,
                        district.text, summary.text, description.text));
                    if (ComplaintFields.validateFields(selectedBinId,
                            district.text, summary.text, description.text) ==
                        false) {
                      print("hi");
                      showDialog();
                    } else {
                      DateTime now = new DateTime.now();
                      print(now);
//format the date
                      var newFormat = DateFormat("yyyy-MM-dd");
                      String updatedDt = newFormat.format(now);

                      DateTime date =
                          new DateTime(now.year, now.month, now.day);
//added the district name column to the complaint table
//addCol("DistrictName", tableComplaints);
//delCol("DistrictName", tableComplaints);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      print(prefs.getInt('id'));
                      // print(date);
                      print(district.text);
                      Complaints c = Complaints(
                          binID: int.parse(selectedBinId),
                          complaintMessage: description.text,
                          subject: summary.text,
                          status: false,
                          driverID: prefs.getInt('id'),
                          districtName: district.text,
                          date: now);
                      //  addObj(c, tableComplaints);
                      /* for (int i = 16; i <= 18; i++) {
                        deleteObj(i, tableComplaints);
                      }*/
                      //  deleteObj(14, tableComplaints);
                      /*  Complaints cc = await readObj(1, tableComplaints);
                      print(cc.complaintID);*/

                      /* List<dynamic> compList = await readAll(tableComplaints);
                      complaints = compList.cast();
                      for (int i = 0; i < complaints.length; i++) {
                        print("${complaints[i].binID}");
                        print("${complaints[i].complaintID}");
                        print("${complaints[i].districtName}");
                        print("${complaints[i].subject}");
                        print("${complaints[i].status}");
                      }*/

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompResult()));
                      /* BinLevel bin = BinLevel(
                          binID: 123,
                          half_full: true,
                          full: false,
                          empty: false,
                          level: 1);
                      addObj(bin, tableBinLevel);*/
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
    );
  }

//required methods from the database
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

  Future deleteObj(int id, String tableName) async {
    print("$id");
    await DatabaseHelper.instance.gneralDelete(id, tableName);
    print("Object is deleted");
  }

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
  }

  Future<dynamic> readObj(int id, String tableName) async {
    return await DatabaseHelper.instance.generalRead(tableName, id);
  }
}
