import 'package:flutter_application_1/model/Driver.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/MunicipalityAdmin.dart';

class LoginField {
  static Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
  }

//validate login info
  static Future<bool> checkPhone(int phone) async {
    Future<bool> phoneCheck;
    List<Driver> dd = [];
    List<dynamic> drListd = await readAll(tableDriver);
    dd = drListd.cast();

//check login info from the database driver's list
    try {
      for (int i = 0; i < dd.length; i++) {
        print("jj " + '${dd[i].phone}');
        if (dd[i].phone != phone) {
          phoneCheck = Future<bool>.value(false);
        } else {
          phoneCheck = Future<bool>.value(true);
          break;
        }
      }
    } catch (error, stackTrace) {
      return Future.error(error, stackTrace);
    }
    return phoneCheck;
  }

  static Future<bool> checkPassword(String password) async {
    Future<bool> passwordCheck;

    List<Driver> dd = [];

    List<dynamic> drListd = await readAll(tableDriver);
    dd = drListd.cast();
    try {
      for (int i = 0; i < dd.length; i++) {
        if (dd[i].password != password) {
          passwordCheck = Future<bool>.value(false);
        } else {
          passwordCheck = Future<bool>.value(true);
          break;
        }
      }
    } catch (error, stackTrace) {
      return Future.error(error, stackTrace);
    }

    return passwordCheck;
  }

  static String validatePassword(String pass) {
/*
  (?=.*[A-Z])       // should contain at least one upper case
  (?=.*[a-z])       // should contain at least one lower case
  (?=.*?[0-9])      // should contain at least one digit
  (?=.*?[!@#\$&*~]) // should contain at least one Special character
  .{8,}             // Must be at least 8 characters in length  
  */

    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    try {
      if (!regex.hasMatch(pass)) {
        return 'Enter a valid password';
      } else {
        return null;
      }
    } catch (error) {
      print(error.toString());
    }
  }

  static bool matchTwoPasswords(String password, String confiPassword) {
    try {
      if (password == confiPassword) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
    }
  }
}
