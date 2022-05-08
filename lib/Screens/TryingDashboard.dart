import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/DriverMenu.dart';

void main() => runApp(MaterialApp(home: AdminDistrictDashboard()));

class AdminDistrictDashboard extends StatefulWidget {
  @override
  AdminDistrictDashboard({Key key}) : super(key: key);
  _AdminDistrictDashboard createState() => _AdminDistrictDashboard();
}

class _AdminDistrictDashboard extends State<AdminDistrictDashboard> {
//Define variables
  final _myState = new charts.UserManagedState<String>();
  String value = "Hala";
  List<String> districts = ["Rawan", "Hala"];
  List<charts.Series<PieChartData, String>> _seriesPieDataForDistrict;
  _AdminDistrictDashboard();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesPieDataForDistrict = List<charts.Series<PieChartData, String>>(1);
  }

  @override
  Widget build(BuildContext context) {
    _generateDataForDistrict(value);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 8.0, bottom: 40.0, right: 8.0, left: 8.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 70.0),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
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
                        return DropdownMenuItem(value: item, child: Text(item));
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
                                  color: charts.MaterialPalette.black.darker,
                                  fontFamily: 'Arial',
                                  fontSize: 15),
                            )
                          ],
                          selectionModels: [
                            charts.SelectionModelConfig(
                                changedListener: (charts.SelectionModel model) {
                              if (model.hasDatumSelection) {
                                if ((model.selectedSeries[0].measureFn(
                                        model.selectedDatum[0].index)) ==
                                    20.0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DriverMenu()),
                                  );
                                }
                                new charts.SelectionModelConfig(
                                    type: charts.SelectionModelType.info,
                                    updatedListener:
                                        _infoSelectionModelUpdated);
                              }
                              print("clicked");
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

  _generateDataForDistrict(String val) {
    var pieData = [
      new PieChartData(20, 'Full', Color(0xfff05e5e)),
      new PieChartData(60, 'Half-full', Color(0xfff19840)),
      new PieChartData(20, 'Empty', Color(0xffa6ed8e)),
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
}

class PieChartData {
  double percent;
  String state; // full, half, empty
  Color colorval;

  PieChartData(this.percent, this.state, this.colorval);
}
