import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/DriverSatus.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:flutter_application_1/model/DriverStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class AdminDriverStatus extends StatefulWidget {
  final Driver driver;

  @override
  AdminDriverStatus({Key key, this.driver}) : super(key: key);
  AdminDriverStatusScreen createState() =>
      AdminDriverStatusScreen(driver: driver);
}

class AdminDriverStatusScreen extends State<AdminDriverStatus> {
  double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
  District selectedDistrict;
  bool alert;
  double performancePercernt = 0.0;
  String value;
  List<BinLevel> binsLevelForSelectedDistrict = [];
  List<BinLevel> binsLevel;
  List<Bin> bins;
  int driverId;
  Driver driver;
  List<District> assignedDistricts = [];
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  AdminDriverStatusScreen({this.driver});
  //initeState
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("the id ");
    print(driver.driverID);
    getLists().whenComplete(() => setState(() {}));
  }

  void showDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Success"),
          content: Text("Driver is alerted"),
          actions: [
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool completed;
    bool incomplete;
    int statusID;
    return MaterialApp(
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)),
            backgroundColor: Color(0xffffDD83),
            title: Text("Alert Driver"),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 10.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: textList()),
                                    //Create the alert button
                                    IconButton(
                                      onPressed: () async {
                                        List<dynamic> drListd =
                                            await readAll(tableDriverStatus);
                                        List<DriverStatus> driverStatusList =
                                            drListd.cast();
                                        for (int i = 0;
                                            i < driverStatusList.length;
                                            i++) {
                                          if (driverStatusList[i].driverID ==
                                              driver.driverID) {
                                            statusID =
                                                driverStatusList[i].statusID;
                                            driverId = driver.driverID;
                                            incomplete =
                                                driverStatusList[i].incomplete;
                                            completed =
                                                driverStatusList[i].completed;
                                          }
                                        }
                                        DriverStatus alert = new DriverStatus(
                                            driverID: driver.driverID,
                                            statusID: statusID,
                                            completed: completed,
                                            incomplete: incomplete,
                                            lateStatus: true);
                                        updateObj(
                                            statusID, alert, tableDriverStatus);
                                        showDialog();
                                        List<dynamic> muniList =
                                            await readAll(tableDriverStatus);
                                        List<DriverStatus> drSt =
                                            muniList.cast();
                                        for (int i = 0; i < drSt.length; i++) {
                                          print(drSt[i].lateStatus);
                                          print(drSt[i].driverID);
                                        }
                                      },
                                      alignment: Alignment.center,
                                      padding: new EdgeInsets.all(0.0),
                                      icon: Icon(Icons.add_alert_rounded),
                                    ),
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[],
                                    )
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 55.0,
                                    right: 15.0,
                                    top: 25.0,
                                    bottom: 0.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Number of bins',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        new Text(
                                          'Performance',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 2.0, top: 2.0),
                                child: new Row(
                                  //mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Align(
                                      child: Container(
                                        height: 50,
                                        width: 100,
                                        margin: EdgeInsets.only(
                                            top: 20, left: 40, right: 25),
                                        /*decoration: new BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 162, 255, 229),
                                          border: Border.all(
                                              color: Color(0xff28CC9E),
                                              width: 0.0),
                                          borderRadius: new BorderRadius.all(
                                              Radius.elliptical(100, 50)),
                                        ),*/
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 35.0),
                                        child: Text(
                                            ("${_generateDataForDriver("totalBins")}"),
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    new Container(
                                      height: 50,
                                      width: 100,
                                      margin: EdgeInsets.only(
                                          top: 20, left: 50, right: 0),
                                      /*decoration: new BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 162, 255, 229),
                                        border: Border.all(
                                            color: Color(0xff28CC9E),
                                            width: 0.0),
                                        borderRadius: new BorderRadius.all(
                                            Radius.elliptical(100, 50)),
                                      ),*/
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 30.0),
                                      child: Text(
                                          "${_generateDataForDriver("performancePercent")}%",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 55.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Bins collected',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        new Text(
                                          'Bins not collected',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Align(
                                      child: Container(
                                        height: 50,
                                        width: 100,
                                        margin: EdgeInsets.only(
                                            top: 20, left: 40, right: 25),
                                        /* decoration: new BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 162, 255, 229),
                                          border: Border.all(
                                              color: Color(0xff28CC9E),
                                              width: 0.0),
                                          borderRadius: new BorderRadius.all(
                                              Radius.elliptical(100, 50)),
                                        ),*/
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 35.0),
                                        child: Text(
                                            ("${_generateDataForDriver("emptyBins")}"),
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    new Container(
                                      height: 50,
                                      width: 100,
                                      margin: EdgeInsets.only(
                                          top: 20, left: 50, right: 0),
                                      /*decoration: new BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 162, 255, 229),
                                        border: Border.all(
                                            color: Color(0xff28CC9E),
                                            width: 0.0),
                                        borderRadius: new BorderRadius.all(
                                            Radius.elliptical(100, 50)),
                                      ),*/
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 35.0),
                                      child: Text(
                                          "${_generateDataForDriver("notCollected")}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> textList() {
    List<Widget> textList = [
      Text(
        "Districts: ",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      )
    ];
    for (var i = 0; i < assignedDistricts.length; i++) {
      textList.add(Text("${assignedDistricts[i].name}, ",
          style: TextStyle(fontSize: 20)));
    }
    return textList;
  }

  Future<void> _retriveDriver(List<Driver> drivers) async {
    //to retrieve the phone from the login interface
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print("driver id: ${prefs.getInt('id')}");
    driverId = prefs.getInt('id');
    for (var i = 0; i < drivers.length; i++) {
      // print("drivers[i].driverID ${drivers[i].driverID}");
      if (driverId == drivers[i].driverID) {
        driver = drivers[i];
        break;
      }
    }
  }

//to get district lists, bins list, and bins level list
  Future<void> getLists() async {
    List<District> district;
    List<dynamic> districtDB = await readAll(tableDistrict);
    district = districtDB.cast();
    setState(() {
      for (int i = 0; i < district.length; i++) {
        if (district[i].driverID == driver.driverID) {
          assignedDistricts.add(district[i]);
        }
      }
    });

    print(assignedDistricts);

    List<BinLevel> bin;
    List<dynamic> binStatus = await readAll(tableBinLevel);
    bin = binStatus.cast();
    binsLevel = bin;

    List<Bin> binsInfo;
    List<dynamic> binDB = await readAll("bin_table");
    binsInfo = binDB.cast();
    setState(() {
      bins = binsInfo;
      List<Bin> binsInsideDistricts = [];
      for (int j = 0; j < bins.length; j++) {
        for (int k = 0; k < assignedDistricts.length; k++) {
          if (bins[j].districtId == assignedDistricts[k].districtID) {
            print("inside fill binsInsideDistricts $k");
            binsInsideDistricts.add(bins[j]);
          }
        }
      }
    });
    print(bins);
  }

  double _generateDataForDriver(String val) {
    //All bins inside assigned districts for driver
    List<Bin> binsInsideDistricts = [];
    for (int j = 0; j < bins.length; j++) {
      for (int k = 0; k < assignedDistricts.length; k++) {
        if (bins[j].districtId == assignedDistricts[k].districtID) {
          binsInsideDistricts.add(bins[j]);
        }
      }
    }

    double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
    // List of all bins leve that inside assigned district
    List<BinLevel> binsLevelForDistricts = [];
    for (int i = 0; i < binsLevel.length; i++) {
      for (int j = 0; j < binsInsideDistricts.length; j++) {
        if (binsInsideDistricts[j].binID == binsLevel[i].binID) {
          binsLevelForDistricts.add(binsLevel[i]);
        }
      }
    }

    for (int i = 0; i < binsLevelForDistricts.length; i++) {
      if (binsLevelForDistricts[i].full == true)
        numberOfFull++;
      else if (binsLevelForDistricts[i].half_full == true)
        numberOfHalfFull++;
      else
        numberOfEmpty++;
    }

    int totalBin = (binsInsideDistricts.length);
    double notCollected = (numberOfHalfFull + numberOfFull);
    double performance = ((totalBin - notCollected) / totalBin);
    double performancePercernt1 = performance * 100;
    String roundedPercent = performancePercernt1.toStringAsFixed(0);
    double performancePercernt = double.parse(roundedPercent);

    switch (val) {
      case ("totalBins"):
        {
          return totalBin.toDouble();
        }
        break;

      case ("notCollected"):
        {
          return notCollected;
        }
        break;
      case ("performancePercent"):
        {
          return performancePercernt;
        }
        break;
      case ("emptyBins"):
        {
          return numberOfEmpty;
        }
        break;
      default:
        {
          return (00);
        }
        break;
    }
  }

  //read objects
  //int id, String tableName, dynamic classFields, dynamic className
  Future<dynamic> readObj(int id, String tableName) async {
    return await DatabaseHelper.instance.generalRead(tableName, id);
  }

  Future updateObj(int id, dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalUpdate(tableName, id, obj);
  }

  Future<List<dynamic>> readAll(String tableName) async {
    return await DatabaseHelper.instance.generalReadAll(tableName);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}
