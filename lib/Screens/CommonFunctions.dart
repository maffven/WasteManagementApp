import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/Screens/AdminDriverDashboard.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonFunctions {
  //To get all drivers
  @visibleForTesting
  Future<List<Driver>> getDrivers() async {
    //Get drivers from DB
    List<Driver> driv;
    List<dynamic> driversDB = await readAll(tableDriver);
    driv = driversDB.cast();
    return driv;
  }

  //To get all districts
  Future<List<District>> getDistricts() async {
    //Get drivers from DB
    List<District> district;
    List<dynamic> districtsDB = await readAll(tableDistrict);
    district = districtsDB.cast();
    return district;
  }

  //To get all bins
  Future<List<Bin>> getBins() async {
    //Get drivers from DB
    List<Bin> bins;
    List<dynamic> binsDB = await readAll("bin_table");
    bins = binsDB.cast();
    return bins;
  }

  //To get all binsLevel
  Future<List<BinLevel>> getBinsLevel() async {
    //Get drivers from DB
    List<BinLevel> binsLevel;
    List<dynamic> binsLevelDB = await readAll(tableBinLevel);
    binsLevel = binsLevelDB.cast();
    return binsLevel;
  }

  Future<Driver> retriveDriver() async {
    //to retrieve the phone from the login interface
    List<Driver> drivers = await getDrivers();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int driverId = prefs.getInt('id');
    Driver driver;
    for (var i = 0; i < drivers.length; i++) {
      if (driverId == drivers[i].driverID) {
        driver = drivers[i];
        break;
      }
    }
    return driver;
  }

  //To get assigned districts for drivers
  Future<List<District>> getAssignedDistricts(Driver driver) async {
    //Get drivers from DB
    List<District> driverDistricts = [];
    List<District> districts = await getDistricts();
    for (int i = 0; i < districts.length; i++) {
      if (districts[i].driverID == driver.driverID) {
        driverDistricts.add(districts[i]);
      }
    }
    return driverDistricts;
  }

  //To fill bins info list with appropriate information then use it
  //to display the information as a list instead of chart
  List<BinInfo> fillPieBinsInfoList(
      String districtName, String status, List<BinLevel> binslevel) {
    List<BinInfo> binsInfo = [];
    for (var j = 0; j < binslevel.length; j++) {
      if (status == "Empty" && binslevel[j].empty) {
        print(" ${binslevel[j].empty} is empty");
        binsInfo.add(new BinInfo(binslevel[j].binID, districtName));
      } else if (status == "Full" && binslevel[j].full) {
        binsInfo.add(new BinInfo(binslevel[j].binID, districtName));
      } else if (status == "HalfFull" && binslevel[j].half_full) {
        binsInfo.add(new BinInfo(binslevel[j].binID, districtName));
      } else {
        print("nothing match");
        // }
      }
    }
    return binsInfo;
  }

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
    // print("mun object: ${munList[0].firatName}");
  }
}
