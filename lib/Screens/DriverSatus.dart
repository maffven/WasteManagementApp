import 'package:flutter/material.dart';
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
  MapScreenState createState() => MapScreenState();
}

//  final String BinsStatus = null;
//  final Driver driver = null;
List<District> Assigneddistricts = [];
Driver driver;
List<District> districts = [];
List<Bin> bins;
List<BinLevel> binsLevel;
List<BinLevel> binsLevelForSelectedDistrict = [];
String value;
bool alert;
District selectedDistrict;
double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;

class MapScreenState extends State<DriverSatus> {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _generateDataForDriver(value);
    return MaterialApp(
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xffffDD83),
            title: Text("Status"),
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
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text("Districts:" +
                                            (_generateDataForDriver(
                                                    "assignedDistricts"))
                                                .toString())
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        await prefs.setBool("stats", true);
                                      },
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
                                        child: Text((_generateDataForDriver(
                                                "totalBins"))
                                            .toString()),
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
                                          vertical: 10.0, horizontal: 35.0),
                                      child: Text((_generateDataForDriver(
                                                  "performancePercent"))
                                              .toString() +
                                          "%"),
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
                                        child: Text((_generateDataForDriver(
                                                "emptyBins"))
                                            .toString()),
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
                                      child: Text((_generateDataForDriver(
                                              "notCollected"))
                                          .toString()),
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

//to get district lists, bins list, and bins level list
  Future<void> getLists() async {
    List<District> district;
    List<dynamic> districtDB = await readAll(tableDistrict);
    district = districtDB.cast();
    print("in get distric method");
    print("district length ${districtDB.length}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int driverId = prefs.getInt('driverID');
    setState(() {
      for (int i = 0; i < district.length; i++) {
        if (district[i].driverID == driverId) {
          districts.add(district[i]);
        }
      }
    });

    print(districts);

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
        for (int k = 0; k < Assigneddistricts.length; k++) {
          if (bins[j].districtId == Assigneddistricts[k].districtID) {
            print("inside fill binsInsideDistricts $k");
            binsInsideDistricts.add(bins[j]);
          }
        }
      }
    });
    print(bins);
  }

  int _generateDataForDriver(String val) {
    //All bins inside assigned districts for driver
    List<Bin> binsInsideDistricts = [];
    for (int j = 0; j < bins.length; j++) {
      for (int k = 0; k < Assigneddistricts.length; k++) {
        if (bins[j].districtId == Assigneddistricts[k].districtID) {
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
    int notCollected = (numberOfHalfFull + numberOfFull) as int;
    int performance = ((totalBin - notCollected) / totalBin) as int;
    int performancePercernt = performance * 100;

    switch (val) {
      case ("totalBins"):
        {
          return totalBin;
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
          return numberOfEmpty as int;
        }
        break;
      case ("assignedDistricts"):
        {
          return Assigneddistricts.length;
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

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
