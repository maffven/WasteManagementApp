import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/DriverSatus.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:flutter_application_1/model/DriverStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDriverStatus extends StatefulWidget {
  final Driver driver;
  @override
  AdminDriverStatus({Key key, this.driver}) : super(key: key);
  AdminDriverStatusScreen createState() =>
      AdminDriverStatusScreen(driver: driver);
}

//  final String BinsStatus = null;
//  final Driver driver = null;

class AdminDriverStatusScreen extends State<AdminDriverStatus> {
  double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
  District selectedDistrict;
  bool alert;
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
    getLists().whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          backgroundColor: Colors.white,
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
                                        children: textList()
                                        //new Text("Districts:")

                                        ),
                                    IconButton(
                                      onPressed: () async {
                                        /* SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        await prefs.setBool("stats", true);*/
                                        List<dynamic> drListd =
                                            await readAll(tableDriverStatus);
                                        List<DriverStatus> driverStatusList =
                                            drListd.cast();
                                        bool completed;
                                        bool incomplete;
                                        int statusID;
                                        for (int i = 0;
                                            i < driverStatusList.length;
                                            i++) {
                                          if (driverStatusList[i].driverID ==
                                              driver.driverID) {
                                            statusID =
                                                driverStatusList[i].statusID;
                                            driverId =
                                                driverStatusList[i].driverID;
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
                                        decoration: new BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 162, 255, 229),
                                          border: Border.all(
                                              color: Color(0xff28CC9E),
                                              width: 0.0),
                                          borderRadius: new BorderRadius.all(
                                              Radius.elliptical(100, 50)),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 35.0),
                                        child: Text(
                                            ("${_generateDataForDriver("totalBins")}")),
                                        // _generateDataForDistrict(totalBin);
                                        //district=await readObj(DriverFields.id, district)
                                      ),
                                    ),
                                    new Container(
                                      height: 50,
                                      width: 100,
                                      margin: EdgeInsets.only(
                                          top: 20, left: 50, right: 0),
                                      decoration: new BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 162, 255, 229),
                                        border: Border.all(
                                            color: Color(0xff28CC9E),
                                            width: 0.0),
                                        borderRadius: new BorderRadius.all(
                                            Radius.elliptical(100, 50)),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 30.0),
                                      child: Text(
                                          "${_generateDataForDriver("performancePercent")}%"),
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
                                        decoration: new BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 162, 255, 229),
                                          border: Border.all(
                                              color: Color(0xff28CC9E),
                                              width: 0.0),
                                          borderRadius: new BorderRadius.all(
                                              Radius.elliptical(100, 50)),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 35.0),
                                        child: Text(
                                            ("${_generateDataForDriver("emptyBins")}")),
                                        //status = await readObj(DriverFields.id, DriverStatus)
                                      ),
                                    ),
                                    new Container(
                                      height: 50,
                                      width: 100,
                                      margin: EdgeInsets.only(
                                          top: 20, left: 50, right: 0),
                                      decoration: new BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 162, 255, 229),
                                        border: Border.all(
                                            color: Color(0xff28CC9E),
                                            width: 0.0),
                                        borderRadius: new BorderRadius.all(
                                            Radius.elliptical(100, 50)),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 35.0),
                                      child: Text(
                                          "${_generateDataForDriver("notCollected")}"),
                                      //status = await readObj(DriverFields.id, DriverStatus)
                                    ),
                                  ],
                                )),

                            //  !_status ? _getActionButtons() : new Container(),
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
    print("driver id: ${prefs.getInt('id')}");
    driverId = prefs.getInt('id');
    for (var i = 0; i < drivers.length; i++) {
      print("drivers[i].driverID ${drivers[i].driverID}");
      if (driverId == drivers[i].driverID) {
        driver = drivers[i];
        break;
      }
    }
  }

//to get district lists, bins list, and bins level list
  Future<void> getLists() async {
    //retrieve all deivers
    List<Driver> driv;
    List<dynamic> driversDB = await readAll(tableDriver);
    driv = driversDB.cast();
    print("in get drivers method");
    print("drivers length ${driversDB.length}");
    await _retriveDriver(driv);
    List<District> district;
    List<dynamic> districtDB = await readAll(tableDistrict);
    district = districtDB.cast();
    print("in get distric method");
    print("district length ${districtDB.length}");
    setState(() {
      for (int i = 0; i < district.length; i++) {
        if (district[i].driverID == driverId) {
          assignedDistricts.add(district[i]);
        }
      }
    });

    print(assignedDistricts);

    List<BinLevel> bin;
    List<dynamic> binStatus = await readAll(tableBinLevel);
    bin = binStatus.cast();
    print("in get binsLevel method");
    print("binsLevel length ${binStatus.length}");
    binsLevel = bin;

    print("here inside getBins");
    List<Bin> binsInfo;
    List<dynamic> binDB = await readAll("bin_table");
    binsInfo = binDB.cast();
    print("in get bins method");
    print("bins length ${binDB.length}");
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
          print("inside fill binsInsideDistricts $k");
          binsInsideDistricts.add(bins[j]);
        }
      }
    }
    print("binsInsideDistricts length: ${binsInsideDistricts.length}");

    double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
    // List of all bins leve that inside assigned district
    List<BinLevel> binsLevelForDistricts = [];
    for (int i = 0; i < binsLevel.length; i++) {
      for (int j = 0; j < binsInsideDistricts.length; j++) {
        if (binsInsideDistricts[j].binID == binsLevel[i].binID) {
          print("inside fill binsLevelForDistrict $j");
          binsLevelForDistricts.add(binsLevel[i]);
        }
      }
    }

    print("binsLevelForDistricts length: ${binsLevelForDistricts.length}");

    for (int i = 0; i < binsLevelForDistricts.length; i++) {
      if (binsLevelForDistricts[i].full == true)
        numberOfFull++;
      else if (binsLevelForDistricts[i].half_full == true)
        numberOfHalfFull++;
      else
        numberOfEmpty++;
    }

    print("numberOfEmpty: $numberOfEmpty");
    int totalBin = (binsInsideDistricts.length);
    double notCollected = (numberOfHalfFull + numberOfFull);
    double performance = ((totalBin - notCollected) / totalBin);
    double performancePercernt = performance * 100;

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
          return (99);
        }
        break;
    }
  }

  //read objects
  //int id, String tableName, dynamic classFields, dynamic className
  Future<dynamic> readObj(int id, String tableName) async {
    return await DatabaseHelper.instance.generalRead(tableName, id);
    //print("mun object: ${munObj.firatName}");
  }

  Future updateObj(int id, dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalUpdate(tableName, id, obj);
  }

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
    // print("mun object: ${munList[0].firatName}");
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0, top: 0.0, bottom: 0.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
}
