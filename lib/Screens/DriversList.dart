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
void main() => runApp(MaterialApp(home: ViewDrivers()));

class ViewDrivers extends StatefulWidget {
  @override
  _ViewDrivers createState() => _ViewDrivers();
}

class _ViewDrivers extends State<ViewDrivers>

    with AutomaticKeepAliveClientMixin<ViewDrivers> {
 
  @override
  bool get wantKeepAlive => true;
  //Define variables
  List<Driver> drivers=[];
  List<District> district;
  List<Widget> boxWidgets = [];
  var status;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<List<Widget>>(
          future: getWidgets(),
          builder: (context, snapshot) {
            final comps = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                } else {
                  return buildDrivers(comps);
                }
            }
          },
        ),
      );

  Widget buildDrivers(List<Widget> drivers) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
             appBar: AppBar(
        backgroundColor: Color(0xffffDD83),
        title: Text("View Drivers"),
        
      ),
            body: SingleChildScrollView(
              child: Padding(
                // to add search button you have to add padding
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Wrap(spacing: 20, runSpacing: 20.0, children: drivers),
                ),
              ),
            )));
  }

   


  //get all complaints from database
  Future<List<Driver>> getdrivers() async {
    //Get complaints from DB
    List<Driver> dri;
   
    List<dynamic> compDB = await readAll(tableDriver);
    dri = compDB.cast();
    for (int i=0;i<dri.length;i++){
   
   }
    print("drivers length ${compDB.length}");
    return dri;
  }


  //get box widgets
  Future<List<Widget>> getWidgets() async {
     drivers=[];
    drivers = await getdrivers();
    for (int i = 0; i < drivers.length; i++) {
      boxWidgets.add(SizedBox(
          width: 370.0,
          height: 100.0,
          child: InkWell(//move to the specific complaint's detail screen
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              
            })),
            child: Card(
              borderOnForeground: true,
              color: Colors.white,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xff28CC9E), width: 1),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 7.0,
                    ),
                    Text(
                      '${drivers[i].firstName}' + '\t'+   '${drivers[i].lastName}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 19.0),
                    ),
                   Text(
                      '',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 21.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  
                  ],
                ),
              )),
            ),
          )));
    }
    return boxWidgets;
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
