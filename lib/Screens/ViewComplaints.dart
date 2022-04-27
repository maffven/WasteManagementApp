import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/AdminDashboard.dart';
import 'package:flutter_application_1/Screens/DistrictListTab.dart';
import 'package:flutter_application_1/Screens/EditComplaints.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Complaints.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() => runApp(MaterialApp(home: ViewComplaints()));

class ViewComplaints extends StatefulWidget {
  @override
  _ViewComplaints createState() => _ViewComplaints();
}

class _ViewComplaints extends State<ViewComplaints> {
  @override

  //Define variables
  final dbHelper = DatabaseHelper.instance;
  List<Complaints> complaints = [];
  List<Complaints> filteredList = [];
  List<Widget> boxWidgets = [];
  var status;
  bool doItJustOnce = false;

  void filterList(value) {
    setState(() {
      filteredList = complaints
          .where(
              (text) => text.subject.toLowerCase().contains(value.toString()))
          .toList();
    });
  }

//get all complaints from database
  Future<List<Complaints>> getComplaints() async {
    //Get complaints from DB
    List<Complaints> comp;
    List<dynamic> compDB = await readAll(tableComplaints);
    comp = compDB.cast();
    for (int i = 0; i < comp.length; i++) {
      if (comp[i].status == false) {
        //check the status of the complaint
        status = "In Progress";
      } else {
        status = "Completed";
      }
    }
    print("complaints length ${compDB.length}");
    return comp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        backgroundColor: Color(0xffffDD83),
        title: Text("View Complaints"),
      ),
      body: 
    
      Column(
        children: <Widget>[
          Expanded(
            
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.0),
                  topRight: Radius.circular(3.0),
                ),
              ),
              child: FutureBuilder<List<Complaints>>(
                  future: getComplaints(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Complaints>> snapshot) {
                    if (snapshot.hasData) {
                      if (!doItJustOnce) {
                        complaints = snapshot.data;
                        filteredList = complaints;
                        doItJustOnce = !doItJustOnce;
                      }
                      
                      return ListView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        reverse: false,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Complaints complaint = filteredList[index];
                          if(complaint.status==true){
                            status="Completed";
                          }else{
                            status="In Progress";
                          }
                          return Dismissible(
                            key: UniqueKey(),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                                side: BorderSide(
                                    color: Color(0xff28CC9E), width: 1),
                              ),
                              child: ListTile(
                                leading: IconButton(
                                  icon: Icon(Icons.edit_outlined),
                                  color: Color(0xff28CC9E),
                                ),
                                title: Text(
                                  complaint.subject,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('Date: ' +
                                    DateFormat('yyyy-MM-dd')
                                        .format(complaint.date) +
                                    " \nTime: " +
                                    DateFormat('HH:mm').format(complaint.date)),
                                trailing: Text(status),
                                onTap: () => Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return EditComplaints(complaint: complaint);
                                })),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
          ),
        ],
      ),
    );
  }

  //read objects
  //int id, String tableName, dynamic classFields, dynamic className
  Future<dynamic> readObj(int id, String tableName) async {
    return await DatabaseHelper.instance.generalRead(tableName, id);
  }

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
  }
}
