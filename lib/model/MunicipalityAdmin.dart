import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

final String tableMunicipalityAdmin = 'Municipality_Admin';
final Random random = new Random();

class MunicipalityAdminFields {
  static final List<String> values = [
    //add all fields
    id, firstName, lastName, password, email, phone
  ];

  //col names
  static final String id = "_Municipality_ID";
  static final String firstName = "First_name";
  static final String lastName = "Last_name";
  static final String password = "Password";
  static final String email = "Email";
  static final String phone = "Phone";
}

class MunicipalityAdmin {
  final int municpalityID;
  final String firstName;
  final String lastName;
  final String password;
  final String email;
  final int phone;

  const MunicipalityAdmin(
      {@required this.municpalityID,
      @required this.firstName,
      @required this.lastName,
      @required this.email,
      @required this.password,
      this.phone});

  //Convert MunicipalityAdmin object to json object
  Map<String, dynamic> toJson() => {
        MunicipalityAdminFields.email: email,
        MunicipalityAdminFields.id: municpalityID,
        MunicipalityAdminFields.firstName: firstName,
        MunicipalityAdminFields.lastName: lastName,
        MunicipalityAdminFields.password: password,
        MunicipalityAdminFields.phone: phone
      };

  MunicipalityAdmin copy(
          {
          //random.nextInt(8990) + 1000
          int id,
          String firstName,
          String lastName,
          String password,
          String email,
          int phone}) =>
      MunicipalityAdmin(
          municpalityID: id ?? this.municpalityID,
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          password: password ?? this.password,
          email: email ?? this.email,
          phone: phone ?? this.phone);

  //convert from json to MunicipalityAdmin
  static MunicipalityAdmin fromJson(Map<String, Object> json) =>
      MunicipalityAdmin(
          municpalityID: json[MunicipalityAdminFields.id] as int,
          firstName: json[MunicipalityAdminFields.firstName] as String,
          lastName: json[MunicipalityAdminFields.lastName] as String,
          password: json[MunicipalityAdminFields.password] as String,
          email: json[MunicipalityAdminFields.email] as String,
          phone: json[MunicipalityAdminFields.phone] as int);

  Future<MunicipalityAdmin> read(int id, dynamic instance) async {
    final db = await instance.database;
    final maps = await db.query(
      tableMunicipalityAdmin,
      columns: MunicipalityAdminFields.values,
      where: '${MunicipalityAdminFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MunicipalityAdmin.fromJson(maps.first);
    } else {
      throw Exception('ID $id not founs');
    }
  }

  Future<List<dynamic>> readAll(dynamic instance) async {
    final db = await instance.database;
    final result = await db.query(tableMunicipalityAdmin);
    return result.map((json) => MunicipalityAdmin.fromJson(json)).toList();
  }

  Future<int> update(
      int id, dynamic instance, MunicipalityAdmin municipalityAdmin) async {
    final db = await instance.database;
    //we have to convert from object to json
    return db.update(tableMunicipalityAdmin, municipalityAdmin.toJson(),
        where: '${MunicipalityAdminFields.id} = ?', whereArgs: [id]);
  }

  //delete a row
  Future<int> delete(int id, dynamic instance) async {
    final db = await instance.database;
    return db.delete(tableMunicipalityAdmin,
        where: '${MunicipalityAdminFields.id} = ?', whereArgs: [id]);
  }
}
