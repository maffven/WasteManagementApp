import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/CommonFunctions.dart';
import 'package:flutter_application_1/Screens/AdminDriverStatus.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/DriverStatus.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Complaints.dart';
import 'package:flutter_application_1/Screens/mapSc.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class ViewNotification extends StatefulWidget {
  @override
  _ViewNotification createState() => _ViewNotification();
}

class _ViewNotification extends State<ViewNotification>
    with AutomaticKeepAliveClientMixin<ViewNotification> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAssignedDistricts().whenComplete(() => setState(() {}));
  }

  //define all needed variables
  var loggedInId;
  var driverStatus;
  String performance;
  String uncollectedBins;
  List<District> assignedDistricts = [];
  int driverId;
  List<BinLevel> theLevels = [];
  Driver driver;
  List<Bin> binDistrict = [];
  List<BinLevel> binsLevelForDistrict = [];
  List<Bin> bins;
  List<BinLevel> binsLevel;
  District selectedDistrict;
  double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
  bool fullBin;
  bool assignedDist;
  List<District> driverDistricts = [];

  //methods

  Future<void> getAssignedDistricts() async {
    List<Driver> driv;
    List<dynamic> driversDB = await readAll(tableDriver);
    driv = driversDB.cast();
    await _retriveDriver(driv);
    List<District> district;
    List<dynamic> districtDB = await readAll(tableDistrict);
    district = districtDB.cast();
    print("in get distric method");
    print("district length ${districtDB.length}");
    setState(() {
      for (int i = 0; i < district.length; i++) {
        if (district[i].driverID == driverId) {
          assignedDistricts.add(district[i]);
        }
      }
    });
  }

  Future<void> _retriveDriver(List<Driver> drivers) async {
    //to retrieve the phone from the login interface
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("driver id: ${prefs.getInt('id')}");
    driverId = prefs.getInt('id');
    for (var i = 0; i < drivers.length; i++) {
      print("drivers[i].driverID ${drivers[i].driverID}");
      if (driverId == drivers[i].driverID) {
        driver = drivers[i];
        break;
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
  //Define variables
  List<Complaints> complaints;
  List<BinLevel> binLevels = [];
  List<District> disBin = [];
  List<Driver> theDrivers = [];
  List<Widget> boxWidgets = [];
  List<Bin> binDist = [];
  List<District> districts;
  Color color;
  String level;
  String performanceRate;
  var lateStatus;
  String distName;

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
                  return buildNotifications(comps);
                }
            }
          },
        ),
      );

  Widget buildNotifications(List<Widget> BinLevel) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Color(0xffffDD83),
              title: Text("View Notifications"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                // to add search button you have to add padding
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child:
                      Wrap(spacing: 20, runSpacing: 20.0, children: BinLevel),
                ),
              ),
            )));
  }

//Class methods
  //get Districts
  Future<List<District>> getDistricts() async {
    //Get district from DB
    List<District> districts;
    List<dynamic> districtDB = await readAll(tableDistrict);
    districts = districtDB.cast();
    print("in get distric method");
    print("district length ${districtDB.length}");
    return districts;
  }

  //get all bin levels from database
  Future<List<BinLevel>> getBinLevels() async {
    //Get bin levels from DB
    List<BinLevel> binLevel = [];

    List<dynamic> compDB = await readAll(tableBinLevel);
    binLevel = compDB.cast();

    for (int i = 0; i < binLevel.length; i++) {
      if (binLevel[i].empty == true) {
        level = "Empty";
      } else if (binLevel[i].half_full == true) {
        color = Color(0xfff19840);
        level = "Half-Full";
      } else {
        color = Color(0xfff05e5e);
        level = "Full";
      }

      //----------------------------------------------
      print("Bin levels length ${compDB.length}");
    }

    return binLevel;
  }

  void _fillDistrictInfo() async {
    //only display full bins of assigned district to a specific driver
    CommonFunctions com = new CommonFunctions();
    Driver driverObject = await com.retriveDriver();
    List<District> districts = await com.getAssignedDistricts(driverObject);
    List<Bin> binsList = await com.getBins();
    List<BinLevel> binsLevelList = await com.getBinsLevel();

    driver = driverObject;
    driverDistricts = districts;
    bins = binsList;
    binsLevel = binsLevelList;

    for (var i = 0; i < driverDistricts.length; i++) {
      binDistrict = [];

      //execlude the bins for specific districts
      for (int j = 0; j < bins.length; j++) {
        if (bins[j].districtId == driverDistricts[i].districtID) {
          binDistrict.add(bins[j]);
        }
      }

      //execlude bins level for specific districts
      for (int k = 0; k < binDistrict.length; k++) {
        for (int l = 0; l < binsLevel.length; l++) {
          //       print("inside binsLevel $j");
          if (binDistrict[k].binID == binsLevel[l].binID) {
            //         print("inside second if");
            //check = true;
            binsLevelForDistrict.add(binsLevel[l]);
            //       }
          }
        }
      }
      //binsLevelForDistrict  and binIsideDistrict are done

      //classify bins based on full, half-full, empty
      for (int m = 0; m < binsLevelForDistrict.length; m++) {
        if (binsLevelForDistrict[m].full == true)
          numberOfFull++;
        else if (binsLevelForDistrict[m].half_full == true)
          numberOfHalfFull++;
        else if (binsLevelForDistrict[m].empty == true) {
          numberOfEmpty++;
        }
      }
    }
  }

  Future<List<DriverStatus>> getDriversStatus() async {
    //Get complaints from DB
    List<DriverStatus> driver = [];

    List<dynamic> compDB = await readAll(tableDriverStatus);
    driver = compDB.cast();

    return driver;
  }

  //get box widgets
  Future<List<Widget>> getWidgets() async {
    theLevels = [];
    bool check=false;
    theLevels = await getBinLevels();
    boxWidgets = [];
    List<DriverStatus> theDriversStatus = [];
    theDriversStatus = await getDriversStatus();
       print(theDriversStatus.length);
    //retrieve the loggedin id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedInId = prefs.getInt('id');
    print("the id " + "${loggedInId}");
    /*get the driver status and check if its equivalent to the loggedIn Id
    and store the drier status*/
    for (int i = 0; i < theDriversStatus.length; i++) {
      if (theDriversStatus[i].driverID == loggedInId) {
        print("hi "+ theDriversStatus[i].binsNotCollected);
        lateStatus = theDriversStatus[i].lateStatus;
        performanceRate = theDriversStatus[i].performanceRate;
        uncollectedBins = theDriversStatus[i].binsNotCollected;
        break;
      }
      
    }


    _fillDistrictInfo(); //to display full bins from assigned districts
//check if the driver has an alert from the admin of late status som show the alert
    for (int i = 0; i < theLevels.length; i++) {
      if (level == "Full" && lateStatus == true) {
        boxWidgets.add(SizedBox(
          width: 370.0,
          height: 100.0,
          child: Card(
              key: Key("Performance"),
            borderOnForeground: true,
            color: Colors.white,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0xff28CC9E), width: 1),
                borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                  ),
                  Text("\t \t"),
                  Icon(
                    Icons.add_alert_rounded,
                    color: Colors.red,
                  ),
                  Text(
                    " Your performance is below average " +performanceRate + "\n You have " + uncollectedBins +" uncollected bin \n  Please collect bins before 8PM" ,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0),
                  ),
                  
                 
                  
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            )),
          ),
        ));
      }
      if (level == "Full" && numberOfFull > 0) {
        //don't show the empty and half-full ones and of assigned districts (only full ones)
        boxWidgets.add(SizedBox(
            width: 370.0,
            height: 70.0,
            child: InkWell(
               onTap: () {
            MapUtils.openMap(
                21.4893852, 39.2462446); //to open google map app/direct
          },
              child: Card( 
                  key: Key("Notification"),
                borderOnForeground: true,
                color: Colors.white,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xff28CC9E), width: 1),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "\t",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                      Text("\t \t"),
                      Icon(
                        Icons.circle_sharp,
                        color: color,
                      ),
                      Text(
                        "\t" + level + " Bin ID " + '${theLevels[i].binID}',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                    ],
                  ),
                )),
              ),
            )));
      }

      return boxWidgets;
    }
  }

//Database method
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
    //print("mun object: ${munObj.firatName}");
  }

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
    // print("mun object: ${munList[0].firatName}");
  }

  Future deleteObj(int id, String tableName) async {
    print("$id rawan");
    await DatabaseHelper.instance.gneralDelete(id, tableName);
    print("Object is deleted");
  }
}
