import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/Screens/DriverDistrictList.dart';
import 'package:flutter_application_1/Screens/profileScreen.dart';
import 'package:flutter_application_1/screens/AdminProfile.dart';
import 'package:flutter_application_1/screens/DriverDashboard.dart';
import 'package:flutter_application_1/screens/SendComplaint.dart';
import 'package:flutter_application_1/screens/Login.dart';
import 'package:flutter_application_1/screens/Notification.dart';
import 'mapSc.dart';

class DriverMenu extends StatelessWidget {
  const DriverMenu({Key key}) : super(key: key);

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
            label: 'Notifications',
            icon: Icon(CupertinoIcons.bell),
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
            return BarAndPieChartDashboard();
            break;
          case 1:
            return MapScreen();
            break;
          case 2:
            return ViewNotification();
            break;
          case 3:
            return SendComplaint();
            break;
          case 4:
            return Profile();
            break;
          default:
            return Login();
        }
      },
    );
  }
}
