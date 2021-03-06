import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/AdminDashboard.dart';
import 'package:flutter_application_1/Screens/AdminDriverDashboard.dart';
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

void main() => runApp(MaterialApp(home: AdminDistrictDashboard()));

class AdminDistrictDashboard extends StatefulWidget {
  final Driver driver;
  @override
  AdminDistrictDashboard({Key key, this.driver}) : super(key: key);
  _AdminDistrictDashboard createState() =>
      _AdminDistrictDashboard(driver: driver);
}

class _AdminDistrictDashboard extends State<AdminDistrictDashboard> {
//Define variables
  final _myState = new charts.UserManagedState<String>();
  final Driver driver;
  List<District> driverDistricts = [];
  List<Bin> bins;
  List<BinLevel> binsLevel;
  List<BinLevel> binsLevelForSelectedDistrict = [];
  List<Bin> binsInsideSelectedDistrict = [];
  List<BinInfo> binsInfo = [];
  String value;
  List<charts.Series<PieChartData, String>> _seriesPieDataForDistrict;
  District selectedDistrict;
  double numberOfFull = 0, numberOfHalfFull = 0, numberOfEmpty = 0;
  bool loading = true;
  CommonFunctions com = new CommonFunctions();
  _AdminDistrictDashboard({this.driver});

  @override
  void initState() {
    getLists();
    super.initState();
    _seriesPieDataForDistrict = List<charts.Series<PieChartData, String>>(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        child: Text("Assigned District for driver",
                            style: TextStyle(fontSize: 22),
                            textAlign: TextAlign.center),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30.0),
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
                            items: driverDistricts.map((item) {
                              return DropdownMenuItem(
                                  value: item.name, child: Text(item.name));
                            }).toList(),
                            onChanged: (value) => setState(() {
                              this.value = value;
                              _generateDataForDistrict(value);
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
                                      if (model.selectedSeries[0]
                                              .domainFn(
                                                  model.selectedDatum[0].index)
                                              .toString() ==
                                          "Empty") {
                                        binsInfo = [];
                                        binsInfo = com.fillPieBinsInfoList(
                                            value,
                                            "Empty",
                                            binsLevelForSelectedDistrict);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BinsListAllDistricts(
                                                    binsStatus: "Empty",
                                                    binsInfo: binsInfo,
                                                  )),
                                        ).then((value) => setState(() {}));
                                      } else if (model.selectedSeries[0]
                                              .domainFn(
                                                  model.selectedDatum[0].index)
                                              .toString() ==
                                          "Full") {
                                        binsInfo = [];
                                        binsInfo = com.fillPieBinsInfoList(
                                            value,
                                            "Full",
                                            binsLevelForSelectedDistrict);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BinsListAllDistricts(
                                                      binsStatus: "Full",
                                                      binsInfo: binsInfo)),
                                        ).then((value) => setState(() {}));
                                      } else {
                                        binsInfo = [];
                                        binsInfo = com.fillPieBinsInfoList(
                                            value,
                                            "HalfFull",
                                            binsLevelForSelectedDistrict);
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

  void _infoSelectionModelUpdated(charts.SelectionModel<String> model) {
    // If you want to allow the chart to continue to respond to select events
    // that update the selection, add an updatedListener that saves off the
    // selection model each time the selection model is updated, regardless of
    // if there are changes.
    //
    // This also allows you to listen to the selection model update events and
    // alter the selection.
    _myState.selectionModels[charts.SelectionModelType.info] =
        new charts.UserManagedSelectionModel(model: model);
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

  // _fillBinsInfoList() {
  //   //create BinInfoObjects
  //   binsInfo = [];
  //   for (var i = 0; i < binsLevelForSelectedDistrict.length; i++) {
  //     binsInfo.add(new BinInfo(binsLevelForSelectedDistrict[i].binID, value));
  //   }
  // }

  _generateDataForDistrict(String val) {
    _fillSelectedDistrict(val);
    print(
        "selected district name ${selectedDistrict.name} and id ${selectedDistrict.districtID}");
    if (selectedDistrict != null) {
      binsInsideSelectedDistrict = [];
      for (int i = 0; i < bins.length; i++) {
        if (bins[i].districtId == selectedDistrict.districtID) {
          binsInsideSelectedDistrict.add(bins[i]);
        }
      }
    }

    bool check = false;
    binsLevelForSelectedDistrict = [];
    for (int j = 0; j < binsLevel.length; j++) {
      print(
          "binsInsideSelectedDistrict.length: ${binsInsideSelectedDistrict.length}");
      for (int k = 0; k < binsInsideSelectedDistrict.length; k++) {
        if (binsInsideSelectedDistrict[k].binID == binsLevel[j].binID) {
          print(
              "${binsInsideSelectedDistrict[k].districtId} and ${binsLevel[j].binID}");
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

//to get district lists, bins list, and bins level list
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
    value = driverDistricts[0].name;
    _generateDataForDistrict(value);
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
