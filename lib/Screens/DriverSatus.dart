import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/CommonFunctions.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverSatus extends StatefulWidget {
  @override
  final Driver driver;
  DriverSatus({Key key, this.driver}) : super(key: key);
  DriverStatusScreen createState() => DriverStatusScreen();
}

//  final String BinsStatus = null;
//  final Driver driver = null;

class DriverStatusScreen extends State<DriverSatus> {
  double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
  bool alert;
  String value;
  List<BinLevel> binsLevel;
  List<Bin> bins;
  Driver driver;
  List<District> driverDistricts = [];
  bool loading = true;
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  //initeState
  @override
  void initState() {
    // TODO: implement initState
    _getLists();
    super.initState();
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
                child: loading
                    ? Transform.scale(
                        scale: 0.2,
                        child: CircularProgressIndicator(),
                      )
                    : new Column(
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
                                          left: 25.0, right: 25.0, top: 25.0),
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
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              new Text(
                                                'Performance',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 2.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                ("${_generateDataForDriver("totalBins")}"),
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              new Text(
                                                "${_generateDataForDriver("performancePercent")}%",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      )),
                                  /*Padding(
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
                                              /* decoration: new BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 162, 255, 229),
                                                border: Border.all(
                                                    color: Color(0xff28CC9E),
                                                    width: 0.0),
                                                borderRadius: new BorderRadius
                                                        .all(
                                                    Radius.elliptical(100, 50)),
                                              ),*/
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 35.0),
                                              child: Text(
                                                  ("${_generateDataForDriver("totalBins")}"),
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                          new Container(
                                            height: 50,
                                            width: 100,
                                            margin: EdgeInsets.only(
                                                top: 20, left: 50, right: 0),
                                            decoration: new BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 162, 255, 229),
                                              border: Border.all(
                                                  color: Color(0xff28CC9E),
                                                  width: 0.0),
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  Radius.elliptical(100, 50)),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 30.0),
                                            child: Text(
                                                "${_generateDataForDriver("performancePercent")}%",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      )),*/
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              new Text(
                                                'Bins not collected',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                          new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                  ("${_generateDataForDriver("emptyBins")}"),
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              new Text(
                                                "${_generateDataForDriver("notCollected")}",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      )),
                                  /*Padding(
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
                                                borderRadius: new BorderRadius
                                                        .all(
                                                    Radius.elliptical(100, 50)),
                                              ),*/
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 35.0),
                                              child: Text(
                                                  ("${_generateDataForDriver("emptyBins")}"),
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                          new Container(
                                            height: 50,
                                            width: 100,
                                            margin: EdgeInsets.only(
                                                top: 20, left: 50, right: 0),
                                            /*  decoration: new BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 162, 255, 229),
                                              border: Border.all(
                                                  color: Color(0xff28CC9E),
                                                  width: 0.0),
                                              borderRadius: new BorderRadius
                                                      .all(
                                                  Radius.elliptical(100, 50)),
                                            ),*/
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 35.0),
                                            child: Text(
                                                "${_generateDataForDriver("notCollected")}",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      )),*/
                                ],
                              ),
                            ),
                          ]),
                padding: EdgeInsets.only(bottom: 25.0),
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
    for (var i = 0; i < driverDistricts.length; i++) {
      textList.add(
          Text("${driverDistricts[i].name}, ", style: TextStyle(fontSize: 20)));
    }
    return textList;
  }

//to get district lists, bins list, and bins level list
  void _getLists() async {
    //retrieve all deivers
    CommonFunctions com = new CommonFunctions();
    Driver loginedDriver = await com.retriveDriver();
    List<District> assignedDistricts =
        await com.getAssignedDistricts(loginedDriver);
    List<BinLevel> binLevel = await com.getBinsLevel();
    List<Bin> bin = await com.getBins();
    setState(() {
      driver = loginedDriver;
      driverDistricts = assignedDistricts;
      bins = bin;
      binsLevel = binLevel;
      loading = false;
    });
  }

  double _generateDataForDriver(String val) {
    //All bins inside assigned districts for driver
    List<Bin> binsInsideDistricts = [];
    for (int j = 0; j < bins.length; j++) {
      for (int k = 0; k < driverDistricts.length; k++) {
        if (bins[j].districtId == driverDistricts[k].districtID) {
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
          return (0);
        }
        break;
    }
  }

  //read objects
  //int id, String tableName, dynamic classFields, dynamic className
  Future<dynamic> readObj(int id, String tableName) async {
    return await DatabaseHelper.instance.generalRead(tableName, id);
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
