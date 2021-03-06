import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/AdminDashboard.dart';
import 'package:flutter_application_1/Screens/AdminDistrictDashboard.dart';
import 'package:flutter_application_1/Screens/BinsListAllDistricts.dart';
import 'package:flutter_application_1/Screens/CommonFunctions.dart';
import 'package:flutter_application_1/Screens/DistrictListTab.dart';
import 'package:flutter_application_1/Screens/DriverDashboard.dart';
import 'package:flutter_application_1/Screens/DriverListTab.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(MaterialApp(home: AdminDriverDashboard()));

class AdminDriverDashboard extends StatefulWidget {
  final Driver driver;
  @override
  AdminDriverDashboard({Key key, this.driver}) : super(key: key);
  _AdminDriverDashboard createState() => _AdminDriverDashboard(driver: driver);
}

class _AdminDriverDashboard extends State<AdminDriverDashboard> {
//Define variables

  final Driver driver;
  double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
  List<Bin> binsInsideDistricts = [];
  List<BinLevel> binsLevelForDistricts = [];
  List<Bin> bins;
  List<BinLevel> binsLevel = [];
  List<District> driverDistricts = [];
  List<BinInfo> binsInfo = [];
  List<charts.Series<PieChartData, String>> _seriesPieDataForDriver;
  _AdminDriverDashboard({this.driver});
  bool loading = true;

  @override
  void initState() {
    getLists();
    super.initState();
    _seriesPieDataForDriver = List<charts.Series<PieChartData, String>>();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xffffDD83),
              title: Text("Dashboard"),
              bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Driver"),
                  Tab(
                    text: "District",
                  ),
                ],
              ),
            ),
            body: TabBarView(children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 8.0, bottom: 40.0, right: 8.0, left: 8.0),
                child: loading
                    ? Transform.scale(
                        scale: 0.2,
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                    '${driver.firstName} ${driver.lastName}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Arial',
                                        fontSize: 25)),
                                margin: EdgeInsets.only(top: 70.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 1),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Expanded(
                                child: _seriesPieDataForDriver != null &&
                                        _seriesPieDataForDriver.isNotEmpty
                                    ? charts.PieChart(_seriesPieDataForDriver,
                                        animate: true,
                                        animationDuration: Duration(seconds: 1),
                                        behaviors: [
                                          new charts.DatumLegend(
                                            outsideJustification: charts
                                                .OutsideJustification
                                                .endDrawArea,
                                            horizontalFirst: false,
                                            desiredMaxRows: 1,
                                            cellPadding: new EdgeInsets.only(
                                                top: 30.0,
                                                right: 35.0,
                                                bottom: 0.0),
                                            entryTextStyle:
                                                charts.TextStyleSpec(
                                                    color: charts
                                                        .MaterialPalette
                                                        .black
                                                        .darker,
                                                    fontFamily: 'Arial',
                                                    fontSize: 15),
                                          )
                                        ],
                                        selectionModels: [
                                          charts.SelectionModelConfig(
                                              changedListener:
                                                  (charts.SelectionModel
                                                      model) {
                                            if (model.hasDatumSelection) {
                                              if (model.selectedSeries[0]
                                                      .domainFn(model
                                                          .selectedDatum[0]
                                                          .index)
                                                      .toString() ==
                                                  "Empty") {
                                                _fillBinsInfoList("Empty");
                                                print("it is here");
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BinsListAllDistricts(
                                                            binsStatus: "Empty",
                                                            binsInfo: binsInfo,
                                                          )),
                                                ).then(
                                                    (value) => setState(() {}));
                                              } else if (model.selectedSeries[0]
                                                      .domainFn(model
                                                          .selectedDatum[0]
                                                          .index)
                                                      .toString() ==
                                                  "Full") {
                                                _fillBinsInfoList("Full");
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BinsListAllDistricts(
                                                              binsStatus:
                                                                  "Full",
                                                              binsInfo:
                                                                  binsInfo)),
                                                ).then(
                                                    (value) => setState(() {}));
                                              } else {
                                                _fillBinsInfoList("HalfFull");
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BinsListAllDistricts(
                                                              binsStatus:
                                                                  "Half-full",
                                                              binsInfo:
                                                                  binsInfo)),
                                                ).then(
                                                    (value) => setState(() {}));
                                              }
                                              print("clicked");
                                              print("$numberOfEmpty this is");
                                            }
                                          })
                                        ],
                                        defaultRenderer:
                                            new charts.ArcRendererConfig(
                                                arcWidth: 90,
                                                arcRendererDecorators: [
                                              new charts.ArcLabelDecorator(
                                                  labelPosition: charts
                                                      .ArcLabelPosition.inside)
                                            ]))
                                    : SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              new AdminDistrictDashboard(driver: driver)
            ])));
  }

//Class methods
  _fillBinsInfoList(String status) {
    //create BinInfoObjects
    binsInfo = [];
    for (var i = 0; i < binsLevelForDistricts.length; i++) {
      for (var k = 0; k < binsInsideDistricts.length; k++) {
        for (var j = 0; j < driverDistricts.length; j++) {
          if (binsLevelForDistricts[i].binID == binsInsideDistricts[k].binID) {
            if (binsInsideDistricts[k].districtId ==
                driverDistricts[j].districtID) {
              if (status == "Empty" && binsLevelForDistricts[i].empty) {
                binsInfo.add(new BinInfo(
                    binsLevelForDistricts[i].binID, driverDistricts[j].name));
              } else if (status == "Full" && binsLevelForDistricts[i].full) {
                binsInfo.add(new BinInfo(
                    binsLevelForDistricts[i].binID, driverDistricts[j].name));
              } else if (status == "HalfFull" &&
                  binsLevelForDistricts[i].half_full) {
                binsInfo.add(new BinInfo(
                    binsLevelForDistricts[i].binID, driverDistricts[j].name));
              } else {
                print("nothing match");
              }
            }
          }
        }
      }
    }
  }

  _generateDataForDriver() {
//All bins inside assigned districts for driver
    binsInsideDistricts = [];
    for (int j = 0; j < bins.length; j++) {
      for (int k = 0; k < driverDistricts.length; k++) {
        if (bins[j].districtId == driverDistricts[k].districtID) {
          print("inside fill binsInsideDistricts $k");
          binsInsideDistricts.add(bins[j]);
        }
      }
    }
    print("binsInsideDistricts length: ${binsInsideDistricts.length}");
    // List of all bins leve that inside assigned district
    binsLevelForDistricts = [];
    for (int i = 0; i < binsLevel.length; i++) {
      for (int j = 0; j < binsInsideDistricts.length; j++) {
        if (binsInsideDistricts[j].binID == binsLevel[i].binID) {
          print("inside fill binsLevelForDistrict $j");
          binsLevelForDistricts.add(binsLevel[i]);
        }
      }
    }

    bool check = false;
    if (binsLevelForDistricts.length != 0) check = true;

    print("binsLevelForDistricts length: ${binsLevelForDistricts.length}");
    numberOfFull = 0;
    numberOfHalfFull = 0;
    numberOfEmpty = 0;
    for (int i = 0; i < binsLevelForDistricts.length; i++) {
      if (binsLevelForDistricts[i].full == true)
        numberOfFull++;
      else if (binsLevelForDistricts[i].half_full == true)
        numberOfHalfFull++;
      else
        numberOfEmpty++;
    }
    print("numberOfEmpty: $numberOfEmpty");

    var pieData = [
      new PieChartData(numberOfFull, 'Full', Color(0xfff05e5e)),
      new PieChartData(numberOfHalfFull, 'Half-full', Color(0xfff19840)),
      new PieChartData(numberOfEmpty, 'Empty', Color(0xffa6ed8e)),
    ];

    if (check) {
      _seriesPieDataForDriver = [];

      _seriesPieDataForDriver.add(
        charts.Series(
          domainFn: (PieChartData data, _) => data.state,
          measureFn: (PieChartData data, _) => data.percent,
          colorFn: (PieChartData data, _) =>
              charts.ColorUtil.fromDartColor(data.colorval),
          id: 'Bins state',
          data: pieData,
          labelAccessorFn: (PieChartData row, _) => '${row.percent}',
        ),
      );
    } else {
      _seriesPieDataForDriver = [];
    }
  } //generateData

  void getLists() async {
    CommonFunctions com = new CommonFunctions();
    List<District> districts = await com.getAssignedDistricts(driver);
    List<Bin> binsList = await com.getBins();
    List<BinLevel> binsLevelList = await com.getBinsLevel();
    setState(() {
      driverDistricts = districts;
      bins = binsList;
      binsLevel = binsLevelList;
    });
    _generateDataForDriver();
    loading = false;
  }

  //read objects
  //int id, String tableName, dynamic classFields, dynamic className
  Future<dynamic> readObj(int id, String tableName) async {
    return await DatabaseHelper.instance.generalRead(tableName, id);
  }

  Future<List<dynamic>> readAll(String tableName) async {
    return await DatabaseHelper.instance.generalReadAll(tableName);
  }
}

class BinInfo {
  String districtName;
  int binID;

  BinInfo(this.binID, this.districtName);
}
