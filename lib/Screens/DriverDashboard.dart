//for driver

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_application_1/Screens/AdminDriverDashboard.dart';
import 'package:flutter_application_1/Screens/BinsListAllDistricts.dart';
import 'package:flutter_application_1/Screens/DriverSatus.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BarAndPieChartDashboard extends StatefulWidget {
  final Widget child;

  BarAndPieChartDashboard({Key key, this.child}) : super(key: key);

  _BarAndPieChartDashboard createState() => _BarAndPieChartDashboard();
}

class _BarAndPieChartDashboard extends State<BarAndPieChartDashboard> {
  //List to store bar chart data
  List<District> driverDistricts = [];
  //List<Driver> drivers = [];
  List<DistrictInfo> districtInfo = [];
  var emptyBarData = [], fullBarData = [], halfFullBarData = [];
  Driver driver;
  int driverId;
  String value;
  List<charts.Series<BarChartData, String>> _seriesData;
  List<charts.Series<PieChartData, String>> _seriesPieDataForDistrict;
  List<BinInfo> binsInfo = [];
  List<Bin> barBinsInsideDistrict = [];
  List<BinLevel> pieBinsLevelForSelectedDistrict = [];
  List<Bin> pieBinsInsideSelectedDistrict = [];
  List<BinLevel> barBinsLevelForDistrict = [];
  List<Bin> bins;
  List<BinLevel> binsLevel;
  District selectedDistrict;
  double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;

  // items for district list
  //final items = [];

//to generate data
  _generateDataForBarChart() {
    _fillDistrictInfo();
    // emptyBarData = [];
    // fullBarData = [];
    // halfFullBarData = [];
    print("number of empty ${districtInfo[0].numberOfEmpty}");
    // for (var i = 0; i < districtInfo.length; i++) {
    //   print("districtInfo[i].districtName: ${districtInfo[i].districtName}");
    //   emptyBarData.add(BarChartData(districtInfo[i].districtName, "Empty", 15));
    //   fullBarData.add(BarChartData(
    //       districtInfo[i].districtName, "full", districtInfo[i].numberOfFull));
    //   halfFullBarData.add(BarChartData(districtInfo[i].districtName,
    //       "half-full", districtInfo[i].numberOfHalfFull));
    // }

    // var barData1 = [
    //   //number of bins
    //   new BarChartData("Alnaseem", "Empty", 30),
    //   new BarChartData("Alrawda", "Empty", 40),
    //   new BarChartData("Alwaha", "Empty", 50),
    // ];
    // var barData2 = [
    //   new BarChartData("Alnaseem", 'full', 40),
    //   new BarChartData("Alrawda", 'full', 10),
    //   new BarChartData("Alwaha", 'full', 10),
    // ];
    // var barData3 = [
    //   new BarChartData("Alnaseem", 'half-full', 50),
    //   new BarChartData("Alrawda", 'half-full', 30),
    //   new BarChartData("Alwaha", 'half-full', 10),
    // ];

    // var pieData = [
    //   new PieChartData(50.0, 'Full', Color(0xfff05e5e)),
    //   new PieChartData(30.0, 'Half-full', Color(0xfff19840)),
    //   new PieChartData(20.0, 'Empty', Color(0xffa6ed8e)),
    // ];

    //First district

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

    // _seriesData.add(
    //   charts.Series(
    //     domainFn: (BarChartData data, _) => data.distictName,
    //     measureFn: (BarChartData data, _) => data.numberOfBins,
    //     id: 'Anaseem',
    //     data: barData1,
    //     fillPatternFn: (_, __) => charts.FillPatternType.solid,
    //     fillColorFn: (BarChartData data, _) =>
    //         charts.ColorUtil.fromDartColor(Color(0xffa6ed8e)),
    //   ),
    // );
    //second district
    // _seriesData.add(
    //   charts.Series(
    //     domainFn: (BarChartData data, _) => data.distictName,
    //     measureFn: (BarChartData data, _) => data.numberOfBins,
    //     id: 'Alrawda',
    //     data: barData2,
    //     fillPatternFn: (_, __) => charts.FillPatternType.solid,
    //     fillColorFn: (BarChartData data, _) =>
    //         charts.ColorUtil.fromDartColor(Color(0xfff05e5e)),
    //   ),
    // );

    //Third district
    // _seriesData.add(
    //   charts.Series(
    //     domainFn: (BarChartData data, _) => data.distictName,
    //     measureFn: (BarChartData data, _) => data.numberOfBins,
    //     id: 'Alwaha',
    //     data: barData3,
    //     fillPatternFn: (_, __) => charts.FillPatternType.solid,
    //     fillColorFn: (BarChartData data, _) =>
    //         charts.ColorUtil.fromDartColor(Color(0xfff19840)),
    //   ),
    // );

    // _seriesPieData.add(
    //   charts.Series(
    //     domainFn: (PieChartData data, _) => data.state,
    //     measureFn: (PieChartData data, _) => data.percent,
    //     colorFn: (PieChartData data, _) =>
    //         charts.ColorUtil.fromDartColor(data.colorval),
    //     id: 'Bins state',
    //     data: pieData,
    //     labelAccessorFn: (PieChartData row, _) => '${row.percent}',
    //   ),
    // );
  } //generateData

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesData = List<charts.Series<BarChartData, String>>();
    _seriesPieDataForDistrict = List<charts.Series<PieChartData, String>>(1);
    _getLists().whenComplete(() => setState(() {
          value = driverDistricts[0].name;
          _generateDataForBarChart();
        }));
  }

  Future<void> _getLists() async {
    //retrieve all deivers
    List<Driver> driv;
    List<dynamic> driversDB = await readAll(tableDriver);
    driv = driversDB.cast();
    print("in get drivers method");
    print("drivers length ${driversDB.length}");
    await _retriveDriver(driv);
    driverDistricts = [];
    //get district based on driver district
    List<District> district;
    List<dynamic> districtDB = await readAll(tableDistrict);
    district = districtDB.cast();
    print("in get distric method");
    print("district length ${district.length}");
    setState(() {
      for (int i = 0; i < district.length; i++) {
        if (district[i].driverID == driver.driverID) {
          driverDistricts.add(district[i]);
        }
      }
      print("driver district length ${driverDistricts.length}");
    });

    print(driverDistricts);
    //get all bins' level
    List<BinLevel> bin;
    binsLevel = [];
    List<dynamic> binStatus = await readAll(tableBinLevel);
    bin = binStatus.cast();
    print("in get binsLevel method");
    print("binsLevel length ${binStatus.length}");
    // for (var i = 0; i < bin.length; i++) {
    //   print("binslevel id: ${bin[i].binID} ");
    // }

    setState(() {
      binsLevel = bin;
    });

    //get all bins
    print("here inside getBins");
    List<Bin> binsInfo;
    bins = [];
    List<dynamic> binDB = await readAll("bin_table");
    binsInfo = binDB.cast();
    print("in get bins method");
    print("bins length ${binDB.length}");
    setState(() {
      bins = binsInfo;
    });
    print(bins);
  }

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
    // print("mun object: ${munList[0].firatName}");
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

  void _fillDistrictInfo() {
    for (var i = 0; i < driverDistricts.length; i++) {
      barBinsLevelForDistrict = [];
      barBinsInsideDistrict = [];
      for (int j = 0; j < bins.length; j++) {
        print("${driverDistricts[i].districtID} and ${bins[j].districtId}");

        if (bins[j].districtId == driverDistricts[i].districtID) {
          print("bin id: ${bins[j].binID}");
          barBinsInsideDistrict.add(bins[j]);
          print(
              "driverDistricts[i].name ${driverDistricts[i].name} and id: ${driverDistricts[i].districtID}");
        }
      }
      print(
          "binsInsideSelectedDistrict.length: ${barBinsInsideDistrict.length}");
      for (int k = 0; k < barBinsInsideDistrict.length; k++) {
        for (int l = 0; l < binsLevel.length; l++) {
          //       print("inside binsLevel $j");
          print("${barBinsInsideDistrict[k].binID} and ${binsLevel[l].binID}");
          if (barBinsInsideDistrict[k].binID == binsLevel[l].binID) {
            //         print("inside second if");
            print(
                "${barBinsInsideDistrict[k].binID} and ${binsLevel[l].binID}");
            //check = true;
            barBinsLevelForDistrict.add(binsLevel[l]);
            //       }
          }
        }
      }
      //binsLevelForDistrict  and binIsideDistrict are done

      print("bin level: ${barBinsLevelForDistrict.length}");
      for (int m = 0; m < barBinsLevelForDistrict.length; m++) {
        if (barBinsLevelForDistrict[m].full == true)
          numberOfFull++;
        else if (barBinsLevelForDistrict[m].half_full == true)
          numberOfHalfFull++;
        else if (barBinsLevelForDistrict[m].empty == true) {
          numberOfEmpty++;
          print("inside empty");
        }
      }
      DistrictInfo district = DistrictInfo(
          driverDistricts[i].districtID,
          driverDistricts[i].name,
          numberOfEmpty,
          numberOfFull,
          numberOfHalfFull);
      numberOfEmpty = 0;
      numberOfFull = 0;
      numberOfHalfFull = 0;
      emptyBarData.add(
          BarChartData(district.districtName, "Empty", district.numberOfEmpty));
      fullBarData.add(
          BarChartData(district.districtName, "full", district.numberOfFull));
      halfFullBarData.add(BarChartData(
          district.districtName, "half-full", district.numberOfHalfFull));

      districtInfo.add(district);
    }
  }

  _fillSelectedDistrict(String val) {
    //data about specific district
    print("inside fill selected district");
    for (int i = 0; i < driverDistricts.length; i++) {
      if (val != null && val == driverDistricts[i].name) {
        print("val: $val");
        selectedDistrict = driverDistricts[i];
        print(
            "${selectedDistrict.name} and id: ${selectedDistrict.districtID}");
        break;
      }
    }
  }

  //Generate data for pie chart
  _generateDataForPieChart(String val) {
    _fillSelectedDistrict(val);
    print(
        "selected district name ${selectedDistrict.name} and id ${selectedDistrict.districtID}");
    //print("district name: ${district.name}");
    //To show piechart based on specific district
    // bool check = false;

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
      print(
          "binsInsideSelectedDistrict.length: ${pieBinsInsideSelectedDistrict.length}");
      for (int k = 0; k < pieBinsInsideSelectedDistrict.length; k++) {
        //       print("inside binsLevel $j");
        if (pieBinsInsideSelectedDistrict[k].binID == binsLevel[j].binID) {
          //         print("inside second if");
          print(
              "${pieBinsInsideSelectedDistrict[k].districtId} and ${binsLevel[j].binID}");
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
      print("yes there");
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

      print(
          "There is data on series ${_seriesPieDataForDistrict.elementAt(0)}");

      setState(() {});
    } else {
      _seriesPieDataForDistrict = [];
      setState(() {});
      print("empty");
    }
  }

  _fillBinsInfoList() {
    //create BinInfoObjects
    binsInfo = [];
    for (var i = 0; i < pieBinsLevelForSelectedDistrict.length; i++) {
      binsInfo
          .add(new BinInfo(pieBinsLevelForSelectedDistrict[i].binID, value));
    }
  }

  @override
  Widget build(BuildContext context) {
    _generateDataForPieChart(value);
    _fillBinsInfoList();
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          /*appBar: AppBar(
            backgroundColor: Color(0xffffDD83),
            title: Text("Dashboard"),
          ),*/
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
                padding:
                    EdgeInsets.only(bottom: 85.0, top: 10, left: 20, right: 20),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: charts.BarChart(
                            _seriesData,
                            animate: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            //behaviors: [new charts.SeriesLegend()],
                            animationDuration: Duration(seconds: 1),
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
                                  } else if ((model.selectedSeries[0].measureFn(
                                          model.selectedDatum[0].index)) ==
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
                child: Container(
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
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              iconSize: 36,
                              icon: Icon(
                                Icons.arrow_drop_down_outlined,
                                color: Color(0xff28CC9E),
                              ),
                              value: value,
                              items: driverDistricts.map((item) {
                                return DropdownMenuItem(
                                    value: item.name, child: Text(item.name));
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
                                          top: 30.0, right: 35.0, bottom: 0.0),
                                      entryTextStyle: charts.TextStyleSpec(
                                          color: charts
                                              .MaterialPalette.black.darker,
                                          fontFamily: 'Arial',
                                          fontSize: 15),
                                    )
                                  ],
                                  selectionModels: [
                                    charts.SelectionModelConfig(changedListener:
                                        (charts.SelectionModel model) {
                                      if (model.hasDatumSelection) {
                                        if ((model.selectedSeries[0].measureFn(
                                                model
                                                    .selectedDatum[0].index)) ==
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
                                      arcWidth: 90,
                                      arcRendererDecorators: [
                                        new charts.ArcLabelDecorator(
                                            labelPosition:
                                                charts.ArcLabelPosition.inside)
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
