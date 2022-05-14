//for driver
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_application_1/Screens/AdminDriverDashboard.dart';
import 'package:flutter_application_1/Screens/BinsListAllDistricts.dart';
import 'package:flutter_application_1/Screens/CommonFunctions.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BarAndPieChartDashboard extends StatefulWidget {
  final Widget child;

  BarAndPieChartDashboard({Key key, this.child}) : super(key: key);

  _BarAndPieChartDashboard createState() => _BarAndPieChartDashboard();
}

class _BarAndPieChartDashboard extends State<BarAndPieChartDashboard> {
  //List to store bar chart data
  List<District> driverDistricts = [];
  List<DistrictInfo> districtInfo = [];
  var emptyBarData = [], fullBarData = [], halfFullBarData = [];
  Driver driver;
  int driverId;
  String value;
  List<charts.Series<BarChartData, String>> _seriesData;
  List<charts.Series<PieChartData, String>> _seriesPieDataForDistrict;
  List<BinInfo> binsInfo = [];
  List<Bin> barBinsInsideDistrict = [];
  List<Bin> pieBinsInsideSelectedDistrict = [];
  List<BinLevel> barBinsLevelForDistrict = [];
  List<BinLevel> pieBinsLevelForSelectedDistrict = [];
  List<Bin> bins;
  List<BinLevel> binsLevel;
  District selectedDistrict;
  double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
  bool loading = true;

//to generate data

  @override
  void initState() {
    _getLists();
    super.initState();
    _seriesData = List<charts.Series<BarChartData, String>>();
    _seriesPieDataForDistrict = List<charts.Series<PieChartData, String>>(1);
  }

  _generateDataForBarChart() {
    _fillDistrictInfo();
    _seriesData.add(
      charts.Series(
        domainFn: (BarChartData data, _) => data.distictName,
        measureFn: (BarChartData data, _) => data.numberOfBins,
        id: 'emptyBar',
        data: emptyBarData.cast(),
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (BarChartData data, _) =>
            charts.ColorUtil.fromDartColor(Color(0xffa6ed8e)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (BarChartData data, _) => data.distictName,
        measureFn: (BarChartData data, _) => data.numberOfBins,
        id: 'fullBar',
        data: fullBarData.cast(),
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (BarChartData data, _) =>
            charts.ColorUtil.fromDartColor(Color(0xfff05e5e)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (BarChartData data, _) => data.distictName,
        measureFn: (BarChartData data, _) => data.numberOfBins,
        id: 'halfFullBar',
        data: halfFullBarData.cast(),
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (BarChartData data, _) =>
            charts.ColorUtil.fromDartColor(Color(0xfff19840)),
      ),
    );
  }

  void _getLists() async {
    CommonFunctions com = new CommonFunctions();
    Driver driverObject = await com.retriveDriver();
    List<District> districts = await com.getAssignedDistricts(driverObject);
    List<Bin> binsList = await com.getBins();
    List<BinLevel> binsLevelList = await com.getBinsLevel();
    setState(() {
      driver = driverObject;
      driverDistricts = districts;
      bins = binsList;
      binsLevel = binsLevelList;
    });
    _generateDataForBarChart();
    value = driverDistricts[0].name;
    _generateDataForPieChart(value);
    //_fillBinsInfoList(); // value = driverDistricts[0].name

    loading = false;
  }

  Future<List<dynamic>> readAll(String tableName) async {
    return await DatabaseHelper.instance.generalReadAll(tableName);
  }

  void _fillDistrictInfo() {
    for (var i = 0; i < driverDistricts.length; i++) {
      barBinsLevelForDistrict = [];
      barBinsInsideDistrict = [];

      //execlude the bins for specific districts
      for (int j = 0; j < bins.length; j++) {
        if (bins[j].districtId == driverDistricts[i].districtID) {
          barBinsInsideDistrict.add(bins[j]);
        }
      }

      //execlude bins level for specific districts
      for (int k = 0; k < barBinsInsideDistrict.length; k++) {
        for (int l = 0; l < binsLevel.length; l++) {
          //       print("inside binsLevel $j");
          if (barBinsInsideDistrict[k].binID == binsLevel[l].binID) {
            //         print("inside second if");
            //check = true;
            barBinsLevelForDistrict.add(binsLevel[l]);
            //       }
          }
        }
      }
      //binsLevelForDistrict  and binIsideDistrict are done

      //classify bins based on full, half-full, empty
      for (int m = 0; m < barBinsLevelForDistrict.length; m++) {
        if (barBinsLevelForDistrict[m].full == true)
          numberOfFull++;
        else if (barBinsLevelForDistrict[m].half_full == true)
          numberOfHalfFull++;
        else if (barBinsLevelForDistrict[m].empty == true) {
          numberOfEmpty++;
        }
      }

      //Fill District info object
      DistrictInfo district = DistrictInfo(
          driverDistricts[i].districtID,
          driverDistricts[i].name,
          numberOfEmpty,
          numberOfFull,
          numberOfHalfFull);
      districtInfo.add(district);

      //recreate numberOfEmpty, numberOfFull, numberOfHalfFullattributes
      numberOfEmpty = 0;
      numberOfFull = 0;
      numberOfHalfFull = 0;

      //Fill bars with suitable information
      emptyBarData.add(
          BarChartData(district.districtName, "Empty", district.numberOfEmpty));
      fullBarData.add(
          BarChartData(district.districtName, "full", district.numberOfFull));
      halfFullBarData.add(BarChartData(
          district.districtName, "half-full", district.numberOfHalfFull));
    }
  }

  _fillSelectedDistrict(String val) {
    //data about specific district
    for (int i = 0; i < driverDistricts.length; i++) {
      if (val != null && val == driverDistricts[i].name) {
        selectedDistrict = driverDistricts[i];
        break;
      }
    }
  }

  //Generate data for pie chart
  _generateDataForPieChart(String val) {
    _fillBinsInfoListForPieChart(val);
    _fillSelectedDistrict(val);
    //print("district name: ${district.name}");
    //To show piechart based on specific district

    if (selectedDistrict != null) {
      pieBinsInsideSelectedDistrict = [];
      for (int i = 0; i < bins.length; i++) {
        if (bins[i].districtId == selectedDistrict.districtID) {
          pieBinsInsideSelectedDistrict.add(bins[i]);
        }
      }
    }

    bool check = false;
    pieBinsLevelForSelectedDistrict = [];
    for (int j = 0; j < binsLevel.length; j++) {
      for (int k = 0; k < pieBinsInsideSelectedDistrict.length; k++) {
        if (pieBinsInsideSelectedDistrict[k].binID == binsLevel[j].binID) {
          check = true;
          pieBinsLevelForSelectedDistrict.add(binsLevel[j]);
          //       }
        }
      }
    }

    // //print("binsLevelForDistrict length ${binsLevelForDistrict.length}");
    // double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
    // for (int i = 0; i < binsLevelForDistrict.length; i++) {
    //   if (binsLevelForDistrict[i].full == true) {
    //     numberOfFull++;
    //   } else if (binsLevelForDistrict[i].half_full == true) {
    //     numberOfHalfFull++;
    //   } else {
    //     numberOfEmpty++;
    //   }
    // }
    numberOfFull = 0;
    numberOfHalfFull = 0;
    numberOfEmpty = 0;
    for (int i = 0; i < pieBinsLevelForSelectedDistrict.length; i++) {
      if (pieBinsLevelForSelectedDistrict[i].full == true)
        numberOfFull++;
      else if (pieBinsLevelForSelectedDistrict[i].half_full == true)
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
          data: pieData,
          id: "bin state",
          labelAccessorFn: (PieChartData row, _) => '${row.percent}',
        ),
      );

      setState(() {});
    } else {
      _seriesPieDataForDistrict = [];
      setState(() {});
    }
  }

  _fillBinsInfoListForPieChart(String districtName) {
    //create BinInfoObjects
    binsInfo = [];
    for (var i = 0; i < pieBinsLevelForSelectedDistrict.length; i++) {
      binsInfo.add(
          new BinInfo(pieBinsLevelForSelectedDistrict[i].binID, districtName));
    }
  }

  _fillBinsInfoListForBarChart(String districtName) {
    //create BinInfoObjects
    binsInfo = [];
    for (var i = 0; i < barBinsLevelForDistrict.length; i++) {
      binsInfo.add(new BinInfo(barBinsLevelForDistrict[i].binID, districtName));
    }
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
              Tab(
                icon: Icon(FontAwesomeIcons.solidChartBar),
              ),
              Tab(icon: Icon(FontAwesomeIcons.chartPie)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              key: Key("DriverDashboard"),
              padding:
                  EdgeInsets.only(bottom: 85.0, top: 10, left: 20, right: 20),
              child: loading
                  ? Transform.scale(
                      scale: 0.2,
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: charts.BarChart(
                                _seriesData,
                                animate: true,
                                barGroupingType: charts.BarGroupingType.grouped,
                                animationDuration: Duration(seconds: 1),
                                selectionModels: [
                                  charts.SelectionModelConfig(changedListener:
                                      (charts.SelectionModel model) {
                                    if (model.hasDatumSelection) {
                                      if ((model
                                              .selectedSeries[0].displayName) ==
                                          "emptyBar") {
                                        List<BarChartData> emptyData =
                                            emptyBarData.cast();
                                        _fillBinsInfoListForBarChart(
                                            emptyData[0].distictName);
                                        for (var i = 0;
                                            i < binsInfo.length;
                                            i++) {
                                          print(
                                              "bin name: ${binsInfo[i].districtName}");
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BinsListAllDistricts(
                                                    binsStatus: "Empty",
                                                    binsInfo: binsInfo,
                                                  )),
                                        ).then((value) => setState(() {}));
                                      } else if ((model
                                              .selectedSeries[0].displayName) ==
                                          "fullBar") {
                                        List<BarChartData> fullData =
                                            fullBarData.cast();
                                        _fillBinsInfoListForBarChart(
                                            fullData[0].distictName);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BinsListAllDistricts(
                                                      binsStatus: "Full",
                                                      binsInfo: binsInfo)),
                                        ).then((value) => setState(() {}));
                                      } else {
                                        List<BarChartData> halfFullData =
                                            halfFullBarData.cast();
                                        _fillBinsInfoListForBarChart(
                                            halfFullData[0].distictName);
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
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
                              margin: EdgeInsets.only(top: 70.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color(0xff28CC9E),
                                  width: 1,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  iconSize: 36,
                                  icon: Icon(
                                    Icons.arrow_drop_down_outlined,
                                    color: Color(0xff28CC9E),
                                  ),
                                  value: value,
                                  items: driverDistricts.map((item) {
                                    try {
                                      return DropdownMenuItem(
                                          value: item.name,
                                          child: Text(item.name));
                                    } catch (error) {}
                                  }).toList(),
                                  onChanged: (value) => setState(() {
                                    this.value = value;
                                    _generateDataForPieChart(value);
                                  }),
                                ),
                              ),
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
                                          outsideJustification: charts
                                              .OutsideJustification.endDrawArea,
                                          horizontalFirst: false,
                                          desiredMaxRows: 1,
                                          cellPadding: new EdgeInsets.only(
                                              top: 30.0,
                                              right: 35.0,
                                              bottom: 0.0),
                                          entryTextStyle: charts.TextStyleSpec(
                                              color: charts
                                                  .MaterialPalette.black.darker,
                                              fontFamily: 'Arial',
                                              fontSize: 15),
                                        )
                                      ],
                                      selectionModels: [
                                        charts.SelectionModelConfig(
                                            changedListener:
                                                (charts.SelectionModel model) {
                                          if (model.hasDatumSelection) {
                                            print(
                                                "model.selectedSeries[0].colorFn ${model.selectedSeries[0].domainFn(model.selectedDatum[0].index).toString()}");
                                            if (model.selectedSeries[0]
                                                    .domainFn(model
                                                        .selectedDatum[0].index)
                                                    .toString() ==
                                                "Empty") {
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
                                                        .selectedDatum[0].index)
                                                    .toString() ==
                                                "Full") {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BinsListAllDistricts(
                                                            binsStatus: "Full",
                                                            binsInfo:
                                                                binsInfo)),
                                              ).then(
                                                  (value) => setState(() {}));
                                            } else {
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
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
}

//For bar chart data
class BarChartData {
  String distictName;
  double numberOfBins;
  String state; // full, half, empty

  BarChartData(this.distictName, this.state, this.numberOfBins);
}

class PieChartData {
  double percent;
  String state; // full, half, empty
  Color colorval;

  PieChartData(this.percent, this.state, this.colorval);
}

class DistrictInfo {
  String districtName;
  int districtID;
  double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
  DistrictInfo(this.districtID, this.districtName, this.numberOfEmpty,
      this.numberOfFull, this.numberOfHalfFull);
}
