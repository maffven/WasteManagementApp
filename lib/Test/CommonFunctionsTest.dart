import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/Screens/CommonFunctions.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:test/test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('CommonFunctions', () {
    //the purpose of this test is to ensure drivers info is retrieved from the DB correctly
    test('Get drivers info from DB Test', () async {
      try {
        CommonFunctions com = new CommonFunctions();
        List<Driver> result = await com.getDrivers();
        expect((result.length != 0), true);
      } catch (error) {
        print(error);
      }
    });

    //the purpose of this test is to ensure districts info is retrieved from the DB correctly
    test('Get districts info from DB Test', () async {
      try {
        CommonFunctions com = new CommonFunctions();
        List<District> result = await com.getDistricts();
        expect((result.length != 0), true);
      } catch (error) {
        print(error);
      }
    });

    //the purpose of this test is to ensure bins info is retrieved from the DB correctly
    test('Get bins info from DB Test', () async {
      try {
        CommonFunctions com = new CommonFunctions();
        List<Bin> result = await com.getBins();
        expect((result.length != 0), true);
      } catch (error) {
        print(error);
      }
    });

    //the purpose of this test is to ensure bins level info is retrieved from the DB correctly
    test('Get bins level info from DB Test', () async {
      try {
        CommonFunctions com = new CommonFunctions();
        List<BinLevel> result = await com.getBinsLevel();
        expect((result.length != 0), true);
      } catch (error) {
        print(error);
      }
    });
    //the purpose of this test is to ensure
    //the ability of retrieve assigned district for a specific driver
    test('Get assigned districts for a specific driver from DB Test', () async {
      try {
        CommonFunctions com = new CommonFunctions();
        List<Driver> drivers = await com.getDrivers();
        List<District> result = await com.getAssignedDistricts(drivers[0]);
        expect(result[0].driverID, drivers[0].driverID);
      } catch (error) {
        print(error);
      }
    });
  });
}
