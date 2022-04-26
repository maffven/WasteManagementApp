import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/Screens/DriverDistrictList.dart';
import 'package:flutter_application_1/Screens/Notification.dart';
import 'package:flutter_application_1/Screens/profileScreen.dart';
import 'package:flutter_application_1/screens/SendComplaint.dart';
import 'package:flutter_application_1/screens/Login.dart';
import 'package:flutter_application_1/screens/AdminProfile.dart';
import 'package:flutter_application_1/screens/DriversList.dart';
import 'AdminDashboard.dart';
import 'package:flutter_application_1/screens/ViewComplaints.dart';
import 'package:flutter_application_1/Screens/DriverDashboard.dart';
import 'package:flutter_application_1/Screens/DriverListTab.dart';
import 'mapSC.dart';

class AdminMenu extends StatelessWidget {
  const AdminMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Dashboards',
            icon: Icon(CupertinoIcons.chart_pie),
          ),
          BottomNavigationBarItem(
            label: 'Map',
            icon: Icon(CupertinoIcons.map),
          ),
          BottomNavigationBarItem(
            label: 'Drivers',
            icon: Icon(CupertinoIcons.square_list),
          ),
          BottomNavigationBarItem(
            label: 'Complaints',
            icon: Icon(CupertinoIcons.mail),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(CupertinoIcons.person_circle),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            //return BarAndPieChartDashboard();
            //return PieChartDashboard();
            return DriverDistrictList();
            break;
          case 1:
            return MapScreen();
            break;
          case 2:
            return ViewDrivers();
            break;
          case 3:
            return ViewComplaints();
            break;
          case 4:
            return AdminProfile();
            // return Notification();
            //return AdminProfile();
            // return DriverSatus();
            break;
          default:
            return Login();
        }
      },
    );
  }
}
