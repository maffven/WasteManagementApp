//import 'dart:html';
//import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final String tableDistrict = 'district';

class DistrictFields {
  static final List<String> values = [
    //add all fields
    id, name, numberOfBins, driverID
  ];
  static final String id = '_districtID';
  static final String name = 'name';
  static final String numberOfBins = 'numberOfBins';
  static final String driverID = '_driverID';
}

class District {
  final int districtID;
  final String name;
  final int numberOfBins;
  final int driverID;

  const District({
    @required this.districtID,
    @required this.name,
    @required this.numberOfBins,
    @required this.driverID,
  });

  Map<String, dynamic> toJson() => {
        DistrictFields.id: districtID,
        DistrictFields.name: name,
        DistrictFields.numberOfBins: numberOfBins,
        DistrictFields.driverID: driverID,
      };

  District copy({int id, String name, int numberOfBins, int driverID}) =>
      District(
          driverID: driverID ?? this.driverID,
          districtID: id ?? this.districtID,
          name: name ?? this.name,
          numberOfBins: numberOfBins ?? this.numberOfBins);

  static District fromJson(Map<String, Object> json) => District(
      districtID: json[DistrictFields.id] as int,
      driverID: json[DistrictFields.driverID] as int,
      name: json[DistrictFields.name] as String,
      numberOfBins: json[DistrictFields.numberOfBins] as int);

  Future<District> read(int id, dynamic instance) async {
    final db = await instance.database;
    final maps = await db.query(
      District,
      columns: DistrictFields.values,
      where: '${DistrictFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return District.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<dynamic>> readAll(dynamic instance) async {
    final db = await instance.database;
    final result = await db.query(tableDistrict);
    return result.map((json) => District.fromJson(json)).toList();
  }

  Future<int> update(int id, dynamic instance, District district) async {
    final db = await instance.database;
    //we have to convert from object to json
    return db.update(tableDistrict, district.toJson(),
        where: '${DistrictFields.id} = ?', whereArgs: [id]);
  }

  //delete a row
  Future<int> delete(int id, dynamic instance) async {
    final db = await instance.database;
    return db.delete(tableDistrict,
        where: '${DistrictFields.id} = ?', whereArgs: [id]);
  }
}
