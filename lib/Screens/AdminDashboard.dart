//for admin
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_1/screens/DriverDashboard.dart';

class PieChartDashboard extends StatefulWidget {
  final Widget child;
  final Driver driver;
  PieChartDashboard({Key key, this.child, this.driver}) : super(key: key);
  _PieChartDashboard createState() => _PieChartDashboard(driver: driver);
}

class _PieChartDashboard extends State<PieChartDashboard> {
  List<District> districts = [];
  List<Bin> bins;
  List<BinLevel> binsLevel;
  List<BinLevel> binsLevelForDistrict;
  String value;
  List<charts.Series<PieChartData, String>> _seriesPieDataForDriver;
  List<charts.Series<PieChartData, String>> _seriesPieDataForDistrict;
  District district;
  final Driver driver;

  //constructor
  _PieChartDashboard({this.driver});

  //data fields
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists();
    _seriesPieDataForDriver = List<charts.Series<PieChartData, String>>();
    _seriesPieDataForDistrict = List<charts.Series<PieChartData, String>>();
  }

  // items for district list
//to generate data
  _fillBinsLevelForDistrict() {
    //data about specific district
    for (int i = 0; i < districts.length; i++) {
      if (value != null && value == districts[i].name) {
        print("val: $value");
        district = districts[i];
        break;
      }
    }
  }

  _generateDataForDistrict() {
    _fillBinsLevelForDistrict();
    print("district name: ${district.name}");

    //get bins level based on a specific district
    for (int i = 0; i < bins.length; i++) {
      print("inside bins loop");
      if (bins[i].districtId == district.districtID) {
        print("inside if $i");
        for (int j = 0; j < binsLevel.length; j++) {
          print("inside binsLevel $i");
          if (bins[i].binID == binsLevel[j].binID) {
            print("inside second if");
            binsLevelForDistrict.add(binsLevel[j]);
          }
        }
      }
    }
    double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
    for (int i = 0; i < binsLevel.length; i++) {
      if (binsLevel[i].full == true)
        numberOfFull++;
      else if (binsLevel[i].half_full == true)
        numberOfHalfFull++;
      else
        numberOfEmpty++;
    }

    var pieData = [
      new PieChartData(numberOfFull, 'Full', Color(0xfff05e5e)),
      new PieChartData(numberOfHalfFull, 'Half-full', Color(0xfff19840)),
      new PieChartData(numberOfEmpty, 'Empty', Color(0xffa6ed8e)),
    ];

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
  }

  _generateDataForDriver() {
    double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
    for (int i = 0; i < binsLevel.length; i++) {
      if (binsLevel[i].full == true)
        numberOfFull++;
      else if (binsLevel[i].half_full == true)
        numberOfHalfFull++;
      else
        numberOfEmpty++;
    }
    var pieData = [
      new PieChartData(numberOfFull, 'Full', Color(0xfff05e5e)),
      new PieChartData(numberOfHalfFull, 'Half-full', Color(0xfff19840)),
      new PieChartData(numberOfEmpty, 'Empty', Color(0xffa6ed8e)),
    ];

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
  }

  @override
  Widget build(BuildContext context) {
    print("bject inside build admin");
    _generateDataForDriver();
    return MaterialApp(
      home: DefaultTabController(
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
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 8.0, bottom: 40.0, right: 8.0, left: 8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text('${driver.firstName} ${driver.lastName}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Arial',
                                  fontSize: 25)),
                          margin: EdgeInsets.only(top: 70.0),
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: charts.PieChart(_seriesPieDataForDriver,
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
                              defaultRenderer: new charts.ArcRendererConfig(
                                  arcWidth: 90,
                                  arcRendererDecorators: [
                                    new charts.ArcLabelDecorator(
                                        labelPosition:
                                            charts.ArcLabelPosition.inside)
                                  ])),
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
                            child: DropdownButton(
                              hint: Text("Select district"),
                              iconSize: 36,
                              icon: Icon(
                                Icons.arrow_drop_down_outlined,
                                color: Color(0xff28CC9E),
                              ),
                              value: value,
                              items: districts.map((item) {
                                return DropdownMenuItem(
                                    value: item.name, child: Text(item.name));
                              }).toList(),
                              onChanged: (value) => setState(() {
                                this.value = value;
                              }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: charts.PieChart(_seriesPieDataForDistrict,
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
                              defaultRenderer: new charts.ArcRendererConfig(
                                  arcWidth: 80,
                                  arcRendererDecorators: [
                                    new charts.ArcLabelDecorator(
                                        labelPosition:
                                            charts.ArcLabelPosition.inside)
                                  ])),
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

  //to get district lists, bins list, and bins level list
  Future<void> getLists() async {
    List<District> district;
    List<dynamic> districtDB = await readAll(tableDistrict);
    district = districtDB.cast();
    print("in get distric method");
    print("district length ${districtDB.length}");
    setState(() {
      districts = district;
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
    });
    print(bins);
  }

  //read objects
  //int id, String tableName, dynamic classFields, dynamic className
  Future<dynamic> readObj(int id, String tableName) async {
    return await DatabaseHelper.instance.generalRead(tableName, id);
  }

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
  }
}
