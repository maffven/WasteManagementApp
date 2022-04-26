import 'package:flutter_application_1/model/LoginField.dart';

//import 'package:test/test.dart';
import 'package:flutter_application_1/Screens/Login.dart';
import 'package:flutter_application_1/model/LoginField.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
//TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
  }

  //-------------------------------------------------------------
  test('Valid password check', () {
    try{
    var result = LoginField.validatePassword('Rania45');
    expect(result, 'Enter a valid password');
    }catch(error){
      print(error.toString());
    }
  });
  //-------------------------------------------------------------
  test('match two passwords', () {
    try{
    var result = LoginField.matchTwoPasswords('1233', '1233');
    expect(result, true);
    }catch(error){
      print(error.toString());
    }
  });
  //-------------------------------------------------------------
  test('phone in database check', () async {
    try {
      bool result = await LoginField.checkPhone(06795437890);
      expect(result, true);
    } catch (error, stackTrace) {
      return Future.error(error, stackTrace);
    }
  });
  //-------------------------------------------------------------
  test('password in database check', () async {
    try {
      bool result = await LoginField.checkPassword("7890");
      expect(result, true);
    } catch (error, stackTrace) {
      return Future.error(error, stackTrace);
    }
  });
  //-------------------------------------------------------------
}
