import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/DistrictDashboard.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/District.dart';

void main() => runApp(MaterialApp(home: DistrictList()));

class DistrictList extends StatefulWidget {
  @override
  _DistrictList createState() => _DistrictList();
}

class _DistrictList extends State<DistrictList>
    with AutomaticKeepAliveClientMixin<DistrictList> {
  @override
  bool get wantKeepAlive => true;
  //Define variables
  List<District> district = [];
  List<Widget> boxWidgets = [];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<List<Widget>>(
          future: getWidgets(),
          builder: (context, snapshot) {
            final district = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                } else {
                  return buildDistricts(district);
                }
            }
          },
        ),
      );

  Widget buildDistricts(List<Widget> district) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            // to add search button you have to add padding
            padding: const EdgeInsets.all(12.0),
            child: Center(
                child: Wrap(spacing: 20, runSpacing: 20.0, children: district)),
          ),
        ));
  }

//Class methods
  //get Districts
  Future<List<District>> getDistricts() async {
    //Get district from DB
    List<District> districts;
    List<dynamic> districtDB = await readAll(tableDistrict);
    districts = districtDB.cast();
    print("in get distric method");
    print("district length ${districtDB.length}");
    return districts;
  }

  //get box widgets
  Future<List<Widget>> getWidgets() async {
    district = [];
    district = await getDistricts();
    print("in get widget dist length ${district.length}");
    boxWidgets = [];
    for (int i = 0; i < district.length; i++) {
      boxWidgets.add(SizedBox(
        width: 160.0,
        height: 160.0,
        child: InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return DistrictDashboard(
                district: district[i]); //PieChartDashboard(driver: drivers[i]);
          })),
          child: Card(
            borderOnForeground: true,
            color: Colors.white,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0xff28CC9E), width: 1),
                borderRadius: BorderRadius.circular(8.0)),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '${district[i].name}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            )),
          ),
        ),
      ));
    }
    return boxWidgets;
  }

//Database method
  Future addObj(dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalCreate(obj, tableName);
    print("object inserted");
  }

  //generalUpdate(String tablename, int id, dynamic obj)
  Future updateObj(int id, dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalUpdate(tableName, id, obj);
  }

  //read objects
  //int id, String tableName, dynamic classFields, dynamic className
  Future<dynamic> readObj(int id, String tableName) async {
    return await DatabaseHelper.instance.generalRead(tableName, id);
  }

  Future<List<dynamic>> readAll(String tableName) async {
    return await DatabaseHelper.instance.generalReadAll(tableName);
  }

  Future deleteObj(int id, String tableName) async {
    await DatabaseHelper.instance.gneralDelete(id, tableName);
    print("Object is deleted");
  }
}
