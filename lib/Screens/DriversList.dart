import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/AdminDashboard.dart';
import 'package:flutter_application_1/Screens/AdminDriverStatus.dart';
import 'package:flutter_application_1/Screens/CommonFunctions.dart';
import 'package:flutter_application_1/Screens/DistrictListTab.dart';
import 'package:flutter_application_1/Screens/EditComplaints.dart';
import 'package:flutter_application_1/Screens/AdminDriverStatus.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Complaints.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() => runApp(MaterialApp(home: ViewDrivers()));

class ViewDrivers extends StatefulWidget {
  @override
  _ViewDrivers createState() => _ViewDrivers();
}

class _ViewDrivers extends State<ViewDrivers> {
  @override

  //Define variables
  final dbHelper = DatabaseHelper.instance;
  List<Driver> drivers = [];
  List<Driver> filteredList = [];
  List<District> district;
  List<Widget> boxWidgets = [];
  CommonFunctions com = new CommonFunctions();
  var status;
  bool doItJustOnce = false;

  void filterList(value) {
    setState(() {
      filteredList = drivers
          .where(
              (text) => text.firstName.toLowerCase().contains(value.toString()))
          .toList();
    });
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        backgroundColor: Color(0xffffDD83),
        title: Text("Drivers List"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 70,
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                        filterList(value);
                        print(value);
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search by name",
                        contentPadding: EdgeInsets.only(top: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.0),
                  topRight: Radius.circular(3.0),
                ),
              ),
              child: FutureBuilder<List<Driver>>(
                  future: com.getDrivers(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Driver>> snapshot) {
                    if (snapshot.hasData) {
                      if (!doItJustOnce) {
                        drivers = snapshot.data;
                        filteredList = drivers;
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
                          Driver drivers = filteredList[index];
                          return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              color: Colors.red,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(338, 30, 0, 0),
                                child: Text("delete"),
                              ),
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                dbHelper.gneralDelete(
                                    drivers.driverID, tableDriver);
                              });
                            },
                            child: InkWell(
                             
         onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AdminDriverStatus(
                driver: drivers); //PieChartDashboard(driver: drivers[i]);
          })),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                                side: BorderSide(
                                    color: Color(0xff28CC9E), width: 1),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text("${drivers.driverID}"),
                                  backgroundColor: Color(0xff28CC9E),
                                  foregroundColor: Colors.white,
                                ),
                                title: Text(
                                  drivers.firstName + " " + drivers.lastName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("${drivers.phone}"),
                                trailing: Text("status"),
                               /* onTap: () => Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return AdminDriverStatus(
                                      driver:
                                          drivers); //PieChartDashboard(driver: drivers[i]);
                                })),*/
                              ),
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

  Widget buildDriver(Driver driver) =>
      ListTile(title: Text("Name"), subtitle: Text(""));
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
