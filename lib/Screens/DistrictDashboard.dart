import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/AdminDriverDashboard.dart';
import 'package:flutter_application_1/Screens/BinsListAllDistricts.dart';
import 'package:flutter_application_1/Screens/CommonFunctions.dart';
import 'package:flutter_application_1/Screens/DriverDashboard.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(MaterialApp(home: DistrictDashboard()));

class DistrictDashboard extends StatefulWidget {
  final District district;
  @override
  DistrictDashboard({Key key, this.district}) : super(key: key);
  _DistrictDashboard createState() => _DistrictDashboard(district: district);
}

class _DistrictDashboard extends State<DistrictDashboard> {
//Define variables
  final _myState = new charts.UserManagedState<String>();
  final District district;
  Driver driver;
  List<Bin> bins;
  List<BinLevel> binsLevel;
  List<BinLevel> binsLevelForSelectedDistrict = [];
  List<Bin> binsInsideSelectedDistrict = [];
  List<BinInfo> binsInfo = [];
  List<charts.Series<PieChartData, String>> _seriesPieDataForDistrict;
  double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
  bool loading = true;
  _DistrictDashboard({this.district});

  @override
  void initState() {
    // TODO: implement initState
    getLists();
    super.initState();
    _seriesPieDataForDistrict = List<charts.Series<PieChartData, String>>(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffDD83),
        title: Text("District"),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 8.0, bottom: 40.0, right: 8.0, left: 8.0),
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
                        margin: EdgeInsets.only(top: 70.0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xff28CC9E),
                            width: 1,
                          ),
                        ),
                        child: Text(
                            "District is ${district.name}\nDriver is ${driver.firstName} ${driver.lastName}",
                            style: TextStyle(fontSize: 22),
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: _seriesPieDataForDistrict != null &&
                                _seriesPieDataForDistrict.isNotEmpty
                            ? charts.PieChart(_seriesPieDataForDistrict,
                                animate: true,
                                animationDuration: Duration(seconds: 1),
                                behaviors: [
                                  new charts.DatumLegend(
                                    outsideJustification:
                                        charts.OutsideJustification.endDrawArea,
                                    horizontalFirst: false,
                                    desiredMaxRows: 1,
                                    cellPadding: new EdgeInsets.only(
                                        top: 30.0, right: 35.0, bottom: 0.0),
                                    entryTextStyle: charts.TextStyleSpec(
                                        color:
                                            charts.MaterialPalette.black.darker,
                                        fontFamily: 'Arial',
                                        fontSize: 15),
                                  )
                                ],
                                selectionModels: [
                                  charts.SelectionModelConfig(changedListener:
                                      (charts.SelectionModel model) {
                                    if (model.hasDatumSelection) {
                                      if ((model.selectedSeries[0].measureFn(
                                              model.selectedDatum[0].index)) ==
                                          numberOfEmpty) {
                                        print("it is here");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BinsListAllDistricts(
                                                    binsStatus: "Empty",
                                                    binsInfo: binsInfo,
                                                  )),
                                        ).then((value) => setState(() {}));
                                      } else if ((model.selectedSeries[0]
                                              .measureFn(model
                                                  .selectedDatum[0].index)) ==
                                          numberOfFull) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BinsListAllDistricts(
                                                      binsStatus: "Full",
                                                      binsInfo: binsInfo)),
                                        ).then((value) => setState(() {}));
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BinsListAllDistricts(
                                                      binsStatus: "Half-full",
                                                      binsInfo: binsInfo)),
                                        ).then((value) => setState(() {}));
                                      }
                                    }
                                  })
                                ],
                                defaultRenderer: new charts.ArcRendererConfig(
                                    arcWidth: 80,
                                    arcRendererDecorators: [
                                      new charts.ArcLabelDecorator(
                                          labelPosition:
                                              charts.ArcLabelPosition.inside)
                                    ]))
                            : SizedBox(),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

//Class methods

  _fillBinsInfoList() {
    //create BinInfoObjects
    binsInfo = [];
    for (var i = 0; i < binsLevelForSelectedDistrict.length; i++) {
      binsInfo.add(
          new BinInfo(binsLevelForSelectedDistrict[i].binID, district.name));
    }
  }

  _generateDataForDistrict() {
    if (district != null) {
      binsInsideSelectedDistrict = [];
      for (int i = 0; i < bins.length; i++) {
        if (bins[i].districtId == district.districtID) {
          binsInsideSelectedDistrict.add(bins[i]);
        }
      }
    }

    bool check = false;
    binsLevelForSelectedDistrict = [];
    for (int j = 0; j < binsLevel.length; j++) {
      for (int k = 0; k < binsInsideSelectedDistrict.length; k++) {
        if (binsInsideSelectedDistrict[k].binID == binsLevel[j].binID) {
          check = true;
          binsLevelForSelectedDistrict.add(binsLevel[j]);
          //       }
        }
      }
    }
    numberOfFull = 0;
    numberOfHalfFull = 0;
    numberOfEmpty = 0;
    for (int i = 0; i < binsLevelForSelectedDistrict.length; i++) {
      if (binsLevelForSelectedDistrict[i].full == true)
        numberOfFull++;
      else if (binsLevelForSelectedDistrict[i].half_full == true)
        numberOfHalfFull++;
      else
        numberOfEmpty++;
    }

    var pieData = [
      new PieChartData(numberOfFull, 'Full', Color(0xfff05e5e)),
      new PieChartData(numberOfHalfFull, 'Half-full', Color(0xfff19840)),
      new PieChartData(numberOfEmpty, 'Empty', Color(0xffa6ed8e)),
    ];
    if (check) {
      _seriesPieDataForDistrict = [];

      _seriesPieDataForDistrict.add(
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

      setState(() {});
    } else {
      _seriesPieDataForDistrict = [];
      setState(() {});
    }
  }

//to get district lists, bins list, and bins level list
  void getLists() async {
    CommonFunctions com = new CommonFunctions();
    List<Bin> binsList = await com.getBins();
    List<BinLevel> binsLevelList = await com.getBinsLevel();
    List<Driver> drivers = await com.getDrivers();
    setState(() {
      for (int i = 0; i < drivers.length; i++) {
        if (drivers[i].driverID == district.driverID) {
          driver = drivers[i];
        }
      }
      bins = binsList;
      binsLevel = binsLevelList;
    });
    _generateDataForDistrict();
    _fillBinsInfoList();
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
