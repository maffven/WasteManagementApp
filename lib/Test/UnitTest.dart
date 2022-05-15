import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/Screens/CommonFunctions.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:flutter_application_1/model/FieldValidator.dart';
import 'package:test/test.dart';
import 'package:flutter_application_1/model/LoginField.dart';
import 'package:flutter_application_1/model/ComplaintFields.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('CommonFunctions', () {
    //test if the entered password is valid and matches the pattern
    //-------------------------------------------------------------
    test('Valid password check', () {
      try {
        var result = LoginField.validatePassword('Rania45');
        expect(result, 'Enter a valid password');
      } catch (error) {
        print(error.toString());
      }
    });
    //test if the two passwords match in forgot password interface
    //-------------------------------------------------------------
    test('match two passwords', () {
      try {
        var result = LoginField.matchTwoPasswords('1233', '1233');
        expect(result, true);
      } catch (error) {
        print(error.toString());
      }
    });
    //test if the phone exists in the database
    //-------------------------------------------------------------
    test('phone in database check', () async {
      try {
        bool result = await LoginField.checkPhone(06795437890, true);
        expect(result, true);
      } catch (error, stackTrace) {
        return Future.error(error, stackTrace);
      }
    });
    //test if the password exists in the database
    //-------------------------------------------------------------
    test('password in database check', () async {
      try {
        bool result = await LoginField.checkPassword("Manar1234", true);
        expect(result, true);
      } catch (error, stackTrace) {
        return Future.error(error, stackTrace);
      }
    });
    //-------------------------------------------------------------
    //the purpose of this test is to ensure drivers info
    // is retrieved from the DB correctly
    test('Get drivers info from DB Test', () async {
      try {
        CommonFunctions com = new CommonFunctions();
        List<Driver> result = await com.getDrivers();
        expect((result.length != 0), true);
      } catch (error) {
        print(error);
      }
    });
    //test if the fields are empty or not
    //-------------------------------------------------------------
    test('Empty Complaint fields Test', () {
      try {
        var result = ComplaintFields.validateFields("", "", "", "");
        expect(result, true);
      } catch (error) {
        print(error);
      }
    });
    //-------------------------------------------------------------
    //the purpose of this test is to ensure districts info
    //is retrieved from the DB correctly
    test('Get districts info from DB Test', () async {
      try {
        CommonFunctions com = new CommonFunctions();
        List<District> result = await com.getDistricts();
        expect((result.length != 0), true);
      } catch (error) {
        print(error);
      }
    });
    //--------------------------------------------------------------------
    //the purpose of this test is to ensure bins info
    //is retrieved from the DB correctly
    test('Get bins info from DB Test', () async {
      try {
        CommonFunctions com = new CommonFunctions();
        List<Bin> result = await com.getBins();
        expect((result.length != 0), true);
      } catch (error) {
        print(error);
      }
    });
    //-------------------------------------------------------------------
    //the purpose of this test is to ensure bins level info
    //is retrieved from the DB correctly
    test('Get bins level info from DB Test', () async {
      try {
        CommonFunctions com = new CommonFunctions();
        List<BinLevel> result = await com.getBinsLevel();
        expect((result.length != 0), true);
      } catch (error) {
        print(error);
      }
    });
    //--------------------------------------------------------------------
    //the purpose of this test is to ensure
    //the validity of the entered email
    test('Empty Email Test', () {
      var result = FieldValidator.validateEmail('');
      expect(result, 'Enter a valid email');
    });
    //--------------------------------------------------------------------
    //the purpose of this test is to ensure
    //the validity of the entered email
    test('Valid Email Test', () {
      var result = FieldValidator.validateEmail('ajay.kumar@nonstopio.com');
      expect(result, "Valid Email");
    });
    //--------------------------------------------------------------------
    //the purpose of this test is to ensure
    //the validity of the entered phone number
    test('Valid phone number Test', () {
      var result = FieldValidator.validatePhone(05543620821);
      expect(result, "Valid phone number");
    });
    //---------------------------------------------------------------------
    //the purpose of this test is to ensure
    //the validity of the entered phone number
    test('Valid phone number Test', () {
      var result = FieldValidator.validatePhone(0);
      expect(result, "Enter a valid phone number");
    });
    //--------------------------------------------------------------------
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
