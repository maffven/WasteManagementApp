import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final String tableDriverStatus = 'Driver_Status';

class DriverStatusFields {
  static final List<String> values = [
    //add all fields
    id, driverID, completed, incomplete, lateStatus,binsNotCollected, binsCollected, performanceRate,
  ];
  //col names
  static final String id = "_Status";
  static final String driverID = "Driver_ID";
  static final String completed = "Completed";
  static final String incomplete = "Incomplete";
  static final String lateStatus = "Late";
  static final String performanceRate ="performanceRate";
  static final String binsNotCollected = "BinsNotCollected";
  static final String binsCollected = "BinsCollected";
}

class DriverStatus {
  final int driverID;
  final int statusID;
  final bool completed;
  final bool incomplete;
  final bool lateStatus;
  final String binsNotCollected;
  final String binsCollected;
final String performanceRate;
  const DriverStatus({
    @required this.driverID,
    @required this.statusID,
    @required this.completed,
    @required this.incomplete,
    @required this.lateStatus,
    @required this.binsNotCollected,
    @required this.binsCollected,
    @required this.performanceRate,
  });

  Map<String, dynamic> toJson() => {
        DriverStatusFields.id: statusID,
        DriverStatusFields.driverID: driverID,
        DriverStatusFields.completed: completed ? 1 : 0,
        DriverStatusFields.incomplete: incomplete ? 1 : 0,
        DriverStatusFields.lateStatus: lateStatus ? 1 : 0,
        DriverStatusFields.performanceRate: performanceRate,
        DriverStatusFields.binsNotCollected: binsNotCollected,
        DriverStatusFields.binsCollected: binsCollected
      };

  DriverStatus copy(
          {int id,
          int driverID,
          bool completed,
          String performanceRate,
          bool incomplete,
          String binsCollected,
          String binsNotCollected,
          bool lateStatus}) =>
      DriverStatus(
          statusID: id ?? this.statusID,
          driverID: driverID ?? this.driverID,
          completed: completed ?? this.completed,
          performanceRate: performanceRate ?? this.performanceRate,
          incomplete: incomplete ?? this.incomplete,
          binsCollected: binsCollected ?? this.binsCollected,
          binsNotCollected: binsNotCollected ?? this.binsNotCollected,
          lateStatus: lateStatus ?? this.lateStatus);

  static DriverStatus fromJson(Map<String, Object> json) => DriverStatus(
      statusID: json[DriverStatusFields.id] as int,
      driverID: json[DriverStatusFields.driverID] as int,
      completed: json[DriverStatusFields.completed] == 1,
      binsNotCollected: json[DriverStatusFields.binsNotCollected],
      binsCollected: json[DriverStatusFields.binsCollected],
      performanceRate: json[DriverStatusFields.performanceRate],
      incomplete: json[DriverStatusFields.incomplete] == 1,
      lateStatus: json[DriverStatusFields.lateStatus] == 1);

  Future<DriverStatus> read(int id, dynamic instance) async {
    final db = await instance.database;
    final maps = await db.query(
      DriverStatus,
      columns: DriverStatusFields.values,
      where: '${DriverStatusFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DriverStatus.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<dynamic>> readAll(dynamic instance) async {
    final db = await instance.database;
    final result = await db.query(tableDriverStatus);
    return result.map((json) => DriverStatus.fromJson(json)).toList();
  }

  Future<int> update(
      int id, dynamic instance, DriverStatus driverStatus) async {
    final db = await instance.database;
    //we have to convert from object to json
    return db.update(tableDriverStatus, driverStatus.toJson(),
        where: '${DriverStatusFields.id} = ?', whereArgs: [id]);
  }

  //delete a row
  Future<int> delete(int id, dynamic instance) async {
    final db = await instance.database;
    return db.delete(tableDriverStatus,
        where: '${DriverStatusFields.id} = ?', whereArgs: [id]);
  }
}
