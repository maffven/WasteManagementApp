import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final String tableDriver = 'Driver';

class DriverFields {
  static final List<String> values = [
    //add all fields
    id, municpalityID, firstName, lastName, password, email, phone, workTime
  ];

  //col names
  static final String id = "_Driver_ID";
  static final String municpalityID = "_Municipality_ID";
  static final String firstName = "First_name";
  static final String lastName = "Last_name";
  static final String password = "Password";
  static final String email = "Email";
  static final String phone = "Phone";
  static final String workTime = "Work_time";
}

class Driver {
  final int driverID;
  final int municpalityID;
  final String firstName;
  final String lastName;
  final String password;
  final String email;
  final int phone;
  final String workTime;

  const Driver({
    @required this.driverID,
    @required this.municpalityID,
    @required this.firstName,
    @required this.lastName,
    @required this.password,
    @required this.email,
    @required this.phone,
    @required this.workTime,
  });
  

  Map<String, dynamic> toJson() => {
        DriverFields.id: driverID,
        DriverFields.municpalityID: municpalityID,
        DriverFields.firstName: firstName,
        DriverFields.lastName: lastName,
        DriverFields.password: password,
        DriverFields.email: email,
        DriverFields.phone: phone,
        DriverFields.workTime: workTime,
      };

  Driver copy(
          {int id,
          int municpalityID,
          String firatName,
          String lastName,
          String password,
          String email,
          int phone,
          String workTime}) =>
      Driver(
          driverID: id ?? this.driverID,
          municpalityID: municpalityID ?? this.municpalityID,
          firstName: firatName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          password: password ?? this.password,
          email: email ?? this.email,
          phone: phone ?? this.phone,
          workTime: workTime ?? this.workTime);

  static Driver fromJson(Map<String, Object> json) => Driver(
      driverID: json[DriverFields.id] as int,
      municpalityID: json[DriverFields.municpalityID] as int,
      firstName: json[DriverFields.firstName] as String,
      lastName: json[DriverFields.lastName] as String,
      password: json[DriverFields.password] as String,
      email: json[DriverFields.email] as String,
      phone: json[DriverFields.phone] as int,
      workTime: json[DriverFields.workTime] as String);

  Future<Driver> read(int id, dynamic instance) async {
    final db = await instance.database;
    final maps = await db.query(
      Driver,
      columns: DriverFields.values,
      where: '${DriverFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Driver.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }
  Future<Driver> readLogin(int phone, dynamic instance) async {
    final db = await instance.database;
    final maps = await db.query(
      Driver,
      columns: DriverFields.values,
      where: '${DriverFields.phone} = ?',
      whereArgs: [phone],
    );

    if (maps.isNotEmpty) {
      return Driver.fromJson(maps.first);
    } else {
      throw Exception('phone $phone not found');
    }
  }
  Future<List<dynamic>> readAll(dynamic instance) async {
    final db = await instance.database;
    final result = await db.query(tableDriver);
    return result.map((json) => Driver.fromJson(json)).toList();
  }

  Future<int> update(int id, dynamic instance, Driver driver) async {
    final db = await instance.database;
    //we have to convert from object to json
    return db.update(tableDriver, driver.toJson(),
        where: '${DriverFields.id} = ?', whereArgs: [id]);
  }

  //delete a row
  Future<int> delete(int id, dynamic instance) async {
    final db = await instance.database;
    return db
        .delete(tableDriver, where: '${DriverFields.id} = ?', whereArgs: [id]);
  }

  Future<Driver> checkLogin(String password, int phone, dynamic instance) async{
  final dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT * FROM $tableDriver WHERE password = '$password' and phone = '$phone'");

    if (res.length > 0) {
      return res;
    }

    return null;
  }
}
