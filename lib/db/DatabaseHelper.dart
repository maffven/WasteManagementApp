import 'dart:io';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/Complaints.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:flutter_application_1/model/DriverStatus.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/BinLocation.dart';
import 'package:flutter_application_1/model/MunicipalityAdmin.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "SmartWasteDB.db";
  static final _databaseVersion = 2;
  static final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static final boolType = 'BOOLEAN NOT NULL';
  static final number = 'INTEGER NOT NULL';
  static final textType = 'TEXT NOT NULL';
  static final doubleNum = 'REAL NOT NULL';

  DatabaseHelper() {}
  // make this a singleton class

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();
  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    //if DB exist
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  initDatabase() async {
    print("Hello inside init");
    String path = join(await getDatabasesPath(), _databaseName);
    print('db location : ' + path);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: createDB);
  }

  Future<void> deleteTable(Database db) async {
    await db.execute("DROP TABLE $tableBin");
    print("Bin deleted");
    await db.execute("DROP TABLE $tableBinLevel");
    print("BinLevel deleted");
    await db.execute("DROP TABLE $tableBinLocation");
    print("tableBinLocation deleted");
    await db.execute("DROP TABLE $tableComplaints");
    print("tableComplaints deleted");
    await db.execute("DROP TABLE $tableDistrict");
    print("tableComplaints deleted");
    await db.execute("DROP TABLE $tableDriver");
    print("tableDriver deleted");
    await db.execute("DROP TABLE $tableDriverStatus");
    print("tableDriverStatus deleted");
    await db.execute("DROP TABLE $MunicipalityAdminFields");
    print("MunicipalityAdminFields deleted");
  }

  Future createTable(Database db) async {
    //Bin table
    await db.execute('''
          CREATE TABLE $tableBin (
            ${BinFields.id} $idType,
            ${BinFields.capacity} $doubleNum ,
            ${BinFields.districtId} $number,
           FOREIGN KEY (${BinFields.districtId}) REFERENCES $tableDistrict(${DistrictFields.id})
          )
          ''');
    print('bin table created');

    //Bin level table
    await db.execute('''
          CREATE TABLE $BinLevel (
             ${BinLevelFields.id} $idType,
             ${BinLevelFields.half_full} $boolType,
             ${BinLevelFields.full} $boolType,
             ${BinLevelFields.empty} $boolType,
           FOREIGN KEY (${BinLevelFields.binID}) REFERENCES $tableBin(${BinFields.id})
          )
          ''');
    print('bin level table created');

    //Bin location table
    await db.execute('''
          CREATE TABLE $BinLocation (
             ${BinLocationFields.id} $idType,
             ${BinLocationFields.coordinateX} $doubleNum,
             ${BinLocationFields.coordinateY} $doubleNum,
           FOREIGN KEY (${BinLocationFields.binID}) REFERENCES $tableBin(${BinFields.id})
          )
          ''');
    print('bin location table created');

    //Rawan work
    //Municipality Admin table
    await db.execute('''
          CREATE TABLE $tableMunicipalityAdmin(
            ${MunicipalityAdminFields.id} $idType,
            ${MunicipalityAdminFields.firstName} $textType,
            ${MunicipalityAdminFields.lastName} $textType,
            ${MunicipalityAdminFields.password} $textType,
            ${MunicipalityAdminFields.email} $textType,
            ${MunicipalityAdminFields.phone} $number
          )
          ''');
    print('Municipality Admin table created');

    //Driver table
    await db.execute('''
          CREATE TABLE $tableDriver (
            ${DriverFields.id} $idType,
            ${DriverFields.municpalityID} $number,
            ${DriverFields.firstName} $textType,
            ${DriverFields.lastName} $textType,
            ${DriverFields.password} $textType,
            ${DriverFields.email} $textType,
            ${DriverFields.phone} $number,
            ${DriverFields.workTime} $textType,
            FOREIGN KEY (${DriverFields.municpalityID}) REFERENCES $tableMunicipalityAdmin(${MunicipalityAdminFields.id})
          )
          ''');
    print('Driver table created');

    //Driver Status table
    await db.execute('''
          CREATE TABLE $tableDriverStatus(
            ${DriverStatusFields.id} $idType,
            ${DriverStatusFields.driverID} $number,
            ${DriverStatusFields.completed} $boolType,
            ${DriverStatusFields.incomplete} $boolType,
            ${DriverStatusFields.lateStatus} $boolType,
            FOREIGN KEY (${DriverStatusFields.id}) REFERENCES $tableDriver(${DriverFields.id})
          )
          ''');
    print('Driver status table created');

    //Lina work
    //Complaints table
    await db.execute('''
          CREATE TABLE $tableComplaints (
            ${ComplaintsFields.id} $idType,
            ${ComplaintsFields.complaintMessage} $textType,
            ${ComplaintsFields.status} $textType,
            ${ComplaintsFields.subject} $textType,
            ${ComplaintsFields.date} $textType,
            ${ComplaintsFields.driverID} $number,
            ${ComplaintsFields.binID} $number,
            FOREIGN KEY (${ComplaintsFields.driverID}) REFERENCES $tableDriver(${DriverFields.id}),
            FOREIGN KEY (${ComplaintsFields.binID}) REFERENCES $tableBin($BinFields.id)
          )
          ''');
    print('Complaints table created');

    //District table
    await db.execute('''
          CREATE TABLE $tableDistrict (
            ${DistrictFields.id} $idType,
            ${DistrictFields.name} $textType,
            ${DistrictFields.numberOfBins} $number,
            ${DistrictFields.driverID} $number,
            FOREIGN KEY (${DistrictFields.driverID}) REFERENCES $tableDriver(${DriverFields.id})
          )
          ''');
    print('District table created');
  }

  // SQL code to create the database table
  Future createDB(Database db, int version) async {
    print("inside create method");
    //Municipality Admin table
    await db.execute('''
          CREATE TABLE $tableMunicipalityAdmin(
            ${MunicipalityAdminFields.id} $idType,
            ${MunicipalityAdminFields.firstName} $textType,
            ${MunicipalityAdminFields.lastName} $textType,
            ${MunicipalityAdminFields.password} $textType,
            ${MunicipalityAdminFields.email} $textType,
            ${MunicipalityAdminFields.phone} $number
          )
          ''');
    print('Municipality Admin table created');

    //Driver table
    await db.execute('''
          CREATE TABLE $tableDriver (
            ${DriverFields.id} $idType,
            ${DriverFields.municpalityID} $number,
            ${DriverFields.firstName} $textType,
            ${DriverFields.lastName} $textType,
            ${DriverFields.password} $textType,
            ${DriverFields.email} $textType,
            ${DriverFields.phone} $number,
            ${DriverFields.workTime} $textType,
            FOREIGN KEY (${DriverFields.municpalityID}) REFERENCES $tableMunicipalityAdmin(${MunicipalityAdminFields.id})
          )
          ''');
    print('Driver table created');

    //Driver Status table
    await db.execute('''
          CREATE TABLE $tableDriverStatus(
            ${DriverStatusFields.id} $idType,
            ${DriverStatusFields.driverID} $number,
            ${DriverStatusFields.completed} $boolType,
            ${DriverStatusFields.incomplete} $boolType,
            ${DriverStatusFields.lateStatus} $boolType,
            FOREIGN KEY (${DriverStatusFields.id}) REFERENCES $tableDriver(${DriverFields.id})
          )
          ''');
    print('Driver status table created');

    //District table
    await db.execute('''
          CREATE TABLE $tableDistrict (
            ${DistrictFields.id} $idType,
            ${DistrictFields.name} $textType,
            ${DistrictFields.numberOfBins} $number,
            ${DistrictFields.driverID} $number,
            FOREIGN KEY (${DistrictFields.driverID}) REFERENCES $tableDriver(${DriverFields.id})
          )
          ''');
    print('District table created');

    //Bin table
    await db.execute('''
          CREATE TABLE $tableBin (
            ${BinFields.id} $idType,
            ${BinFields.capacity} $doubleNum ,
            ${BinFields.districtId} $number,
           FOREIGN KEY (${BinFields.districtId}) REFERENCES $tableDistrict(${DistrictFields.id})
          )
          ''');
    print('bin table created');

    //Bin level table
    await db.execute('''
          CREATE TABLE $BinLevel (
             ${BinLevelFields.id} $idType,
             ${BinLevelFields.binID} $number,
             ${BinLevelFields.half_full} $boolType,
             ${BinLevelFields.full} $boolType,
             ${BinLevelFields.empty} $boolType,
           FOREIGN KEY (${BinLevelFields.binID}) REFERENCES $tableBin(${BinFields.id})
          )
          ''');
    print('bin level table created');

    //Bin location table
    await db.execute('''
          CREATE TABLE $BinLocation (
             ${BinLocationFields.id} $idType,
             ${BinLocationFields.binID} $number,
             ${BinLocationFields.coordinateX} $number,
             ${BinLocationFields.coordinateY} $number,
           FOREIGN KEY (${BinLocationFields.binID}) REFERENCES $tableBin(${BinFields.id})
          )
          ''');
    print('bin location table created');

    //Complaints table
    await db.execute('''
          CREATE TABLE $tableComplaints (
            ${ComplaintsFields.id} $idType,
            ${ComplaintsFields.complaintMessage} $textType,
            ${ComplaintsFields.status} $boolType,
            ${ComplaintsFields.subject} $textType,
            ${ComplaintsFields.date} $textType,
            ${ComplaintsFields.driverID} $number,
            ${ComplaintsFields.binID} $number,
            FOREIGN KEY (${ComplaintsFields.driverID}) REFERENCES $tableDriver(${DriverFields.id}),
            FOREIGN KEY (${ComplaintsFields.binID}) REFERENCES $tableBin(${BinFields.id})
          )
          ''');
    print('Complaints table created');
  }
Future <Driver> getLoginId (int phone) async{
  Driver dd = new Driver();
 Future<Driver> d = dd.readLogin(phone,instance);
 return d;
}
  // create a row
  Future<dynamic> generalCreate(
    dynamic table,
    String tableName,
  ) async {
    final db = await instance.database;
    //inset to database

    final id = await db.insert(tableName, table.toJson());
      print("object inserted");
    return table.copy(id: id);
  }

  Future<dynamic> alterTable(String TableName, String ColumneName) async {
    var dbClient = await await DatabaseHelper.instance.database;
    var count = await dbClient.execute("ALTER TABLE $TableName ADD "
        "COLUMN $ColumneName TEXT;");
    print(await dbClient.query(TableName));
    return count;
  }
 Future<dynamic> alterTable1(String TableName, String ColumneName) async {
    var dbClient = await await DatabaseHelper.instance.database;
    var count = await dbClient.execute("ALTER TABLE $TableName DELETE "
        "COLUMN $ColumneName;");
    print(await dbClient.query(TableName));
    return count;
  }

  Future<Driver> checkLogin(String password, int phone) async {
    //return await Driver().checkLogin(password, phone, instance);
/*final dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT * FROM $tableDriver WHERE password = '$password' and phone = '$phone'");

    if (res.length > 0) {
      return new Driver;
    }

    return null;
  */
  }
  // read a row

  Future<dynamic> generalRead(String tableName, int id) async {
    switch (tableName) {
//--------------------------------------------------------------
      case "Municipality_Admin":
        return await MunicipalityAdmin().read(id, instance);
        break;

      //--------------------------------------------------------------

      case "Driver":
        return await Driver().read(id, instance);
        break;

      //--------------------------------------------------------------
      case "DriverStatusFields":
        return await DriverStatus().read(id, instance);
        break;

//--------------------------------------------------------------
      case "bin":
        print("it is in DBHelper");

        return await Bin().read(id, instance);
        break;
//--------------------------------------------------------------
      case "BinLevel":
        return await BinLevel().read(id, instance);
        break;
//--------------------------------------------------------------
      case "BinLocation":
        return await BinLocation().read(id, instance);
        break;
//--------------------------------------------------------------
      case "complaints":
        return await Complaints().read(id, instance);
        break;
//--------------------------------------------------------------
      case "district":
        return await District().read(id, instance);
        break;
//--------------------------------------------------------------
      default:
        "cannot access data";
//--------------------------------------------------------------
    }
  }

//Read all rows
  Future<List<dynamic>> generalReadAll(String tableName) async {
    switch (tableName) {
//--------------------------------------------------------------
      case "Municipality_Admin":
        return await MunicipalityAdmin().readAll(instance);
        break;

      case "Driver":
        return await Driver().readAll(instance);
        break;

      //--------------------------------------------------------------
      case "Driver_Status":
        return await DriverStatus().readAll(instance);
        break;
//--------------------------------------------------------------
      case "bin_table":
        return await Bin().readAll(instance);
        break;
//--------------------------------------------------------------
      case "BinLevel":
        return await BinLevel().readAll(instance);
        break;
//--------------------------------------------------------------
      case "BinLocation":
        return await BinLocation().readAll(instance);
        break;
//--------------------------------------------------------------
      case "complaints":
        return await Complaints().readAll(instance);
        break;
//--------------------------------------------------------------
      case "district":
        return await District().readAll(instance);
        break;
//--------------------------------------------------------------
      default:
        "cannot access data";
//--------------------------------------------------------------
    }
  }

  //update row

  Future<int> generalUpdate(String tablename, int id, dynamic obj) async {
    switch (tablename) {
      case "Municipality_Admin":
        return await MunicipalityAdmin().update(id, instance, obj);
        break;
//--------------------------------------------------------------

      case "Driver":
        return await Driver().update(id, instance, obj);
        break;

      //--------------------------------------------------------------
      case "Driver_Status":
        return await DriverStatus().update(id, instance, obj);
        break;

      case "bin_table":
        return await Bin().update(id, instance, obj);
        break;
//--------------------------------------------------------------
      case "BinLevel":
        return await BinLevel().update(id, instance, obj);
        break;
//--------------------------------------------------------------
      case "BinLocation":
        return await BinLocation().update(id, instance, obj);
        break;
//--------------------------------------------------------------
      case "complaints":
        return await Complaints().update(id, instance, obj);
        break;
//--------------------------------------------------------------
      case "District":
        return await District().update(id, instance, obj);
        break;
//--------------------------------------------------------------
      default:
        "cannot access data";
    }
  }

  //delete a row
  Future<int> gneralDelete(int id, String tablename) async {
    switch (tablename) {
      case "Municipality_Admin":
        return await MunicipalityAdmin().delete(id, instance);
        break;

      case "Driver":
        return await Driver().delete(id, instance);
        break;

      //--------------------------------------------------------------
      case "Driver_Status":
        return await DriverStatus().delete(id, instance);
        break;

//--------------------------------------------------------------
      case "bin_table":
        return await Bin().delete(id, instance);
        break;
//--------------------------------------------------------------
      case "BinLevel":
        return await BinLevel().delete(id, instance);
        break;
//--------------------------------------------------------------
      case "BinLocation":
        return await BinLocation().delete(id, instance);
        break;
//------------------------------------------------------------
      case "complaints":
        return await Complaints().delete(id, instance);
        break;
//--------------------------------------------------------------
      case "district":
        return await District().delete(id, instance);
        break;
//--------------------------------------------------------------
      default:
        "cannot access data";
    }
  }
}

//close database
Future close() async {
  final db = await DatabaseHelper.instance.database;
  db.close();
}

/* Future<int> generalUpdate(String tablename) async {
    final db = await instance.database;
    //we have to convert from object to json
    return db.update(tablename, classInstance.toJson(),
        where: '${classfields.id} = ?', whereArgs: [classInstance.id]);
  }*

  //delete row
  Future<int> gneralDelete(
      int id, String tablename, dynamic classfields) async {
    final db = await instance.database;
    return db
        .delete(tablename, where: '${classfields.id} = ?', whereArgs: [id]);
  }

  //Close database  Method
  Future close() async {
    final db = await instance.database;
    db.close();
  }
  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  /*Future<int> insert(Bin bin) async {
    Database db = await instance.database;
    return await db.insert(table, {
      'binID': bin.binID,
      'capacity': bin.capacity,
      'district': bin.district
    });
  }*/

  //Rawan Work

  Future<int> generalInsert(String tableName, dynamic table) async {
    final db = await instance.database;
    return await db.insert(tableName, table.toJson());
  }




   /* Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }*/

  /*Future<List<Map<String, dynamic>>> generalQueryAllRows(
      String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }*/

  /*Future<int> generalQueryRowCount(String tableName) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }*/

 

  /* Future<int> insert(Complaints complaints) async {
    Database db = await instance.database;
    return await db.insert(table, {
      'complaintID': complaints.complaintID,
      'complaintMessage': complaints.complaintMessage,
      'status': complaints.status,
      'subject': complaints.subject,
      'date': complaints.date,
      'binID': complaints.binID,
      'driverID': complaints.driverID
    });
  }

  Future<int> insert(District district) async {
    Database db = await instance.database;
    return await db.insert(table, {
      'districtID': district.districtID,
      'name': district.name,
      'numberOfBins': district.numberOfBins,
      'driverID': district.driverID
    });
  }*/

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  /*Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }*/

  // Queries rows based on the argument received
  /*Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnCapacity LIKE '%$name%'");
  }*/

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  /*Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }*/

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  /*Future<int> update(Bin bin) async {
    Database db = await instance.database;
    int id = bin.toMap()['id'];
    return await db
        .update(table, bin.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }*/

  /*Future<int> update(Complaints complaints) async {
    Database db = await instance.database;
    int id = complaints.toMap()['id'];
    return await db.update(table, complaints.toMap(),
        where: '$columncomplaintId = ?', whereArgs: [id]);
  }

  Future<int> update(District district) async {
    Database db = await instance.database;
    int id = district.toMap()['id'];
    return await db.update(table, district.toMap(),
        where: '$columndistrictId = ?', whereArgs: [id]);
  }*/

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.*/
