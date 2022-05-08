import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/AdminDriverDashboard.dart';
import 'package:flutter_application_1/Screens/mapSc.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/Bin.dart';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Driver.dart';

class BinsListAllDistricts extends StatefulWidget {
  final List<BinInfo> binsInfo;
  final String binsStatus;
  @override
  BinsListAllDistricts({Key key, this.binsStatus, this.binsInfo})
      : super(key: key);
  _BinsListAllDistricts createState() =>
      _BinsListAllDistricts(binsStatus: binsStatus, binsInfo: binsInfo);
}

class _BinsListAllDistricts extends State<BinsListAllDistricts> {
  final List<BinInfo> binsInfo;
  final String binsStatus;
  Color color;
  _BinsListAllDistricts({this.binsStatus, this.binsInfo});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (binsStatus) {
      case "Empty":
        color = Colors.green;
        break;
      case "Full":
        color = Colors.red;
        break;
      case "Half-full":
        color = Colors.orange;
        break;
      default:
        print("doesn't match");
    }
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: color),
            onPressed: () => Navigator.pop(context)),
        backgroundColor: Color(0xffffDD83),
        title: Text("Bins List"),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: binsInfo.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(
                  Icons.circle,
                  color: color,
                ),
                title: Text(binsInfo[index].districtName),
                subtitle: Text("${binsInfo[index].binID}"),
                onTap: () {
                  MapUtils.openMap(21.4893852, 39.2462446);
                },
              );
            }),
      ),
    );
  }
}
