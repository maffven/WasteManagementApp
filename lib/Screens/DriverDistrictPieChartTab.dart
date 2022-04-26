import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/AdminDriverDashboard.dart';
import 'package:flutter_application_1/Screens/DistrictListTab.dart';
import 'package:flutter_application_1/Screens/DriverListTab.dart';

//Define "root widget"
void main() => runApp(new DriverDistrictTabs()); //one-line function

class DriverDistrictTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //build function returns a "Widget"
    final tabController = new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Color(0xffffDD83),
          title: Text("Dashboard"),
          bottom: new TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 2.0,
              tabs: [
                new Tab(text: "Drivers"),
                new Tab(text: "Districts"),
              ]),
        ),
        body: new TabBarView(children: [
          new AdminDriverDashboard(),
          new DistrictList()
        ]), //Chnge will be here
      ),
    );
    return new MaterialApp(title: "Tabs example", home: tabController);
  }
}
