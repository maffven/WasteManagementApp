import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/AdminDashboard.dart';
import 'package:flutter_application_1/Screens/DistrictListTab.dart';
import 'package:flutter_application_1/Screens/EditComplaints.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:flutter_application_1/model/Complaints.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
void main() => runApp(MaterialApp(home: ViewComplaints()));

class ViewComplaints extends StatefulWidget {
  @override
  _ViewComplaints createState() => _ViewComplaints();
}

class _ViewComplaints extends State<ViewComplaints>

    with AutomaticKeepAliveClientMixin<ViewComplaints> {
 
  @override
  bool get wantKeepAlive => true;
  //Define variables
  List<Complaints> complaints=[];
  List<District> district;
  List<Widget> boxWidgets = [];
  var status;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<List<Widget>>(
          future: getWidgets(),
          builder: (context, snapshot) {
            final comps = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                } else {
                  return buildComplaints(comps);
                }
            }
          },
        ),
      );

  Widget buildComplaints(List<Widget> complaints) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
             appBar: AppBar(
        backgroundColor: Color(0xffffDD83),
        title: Text("View Complaints"),
      ),
            body: SingleChildScrollView(
              child: Padding(
                // to add search button you have to add padding
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Wrap(spacing: 20, runSpacing: 20.0, children: complaints),
                ),
              ),
            )));
  }

   


  //get all complaints from database
  Future<List<Complaints>> getComplaints() async {
    //Get complaints from DB
    List<Complaints> comp;
   
    List<dynamic> compDB = await readAll(tableComplaints);
    comp = compDB.cast();
    for (int i=0;i<comp.length;i++){
     if(comp[i].status==false){
       //check the status of the complaint
       status="In Progress";
     }else{
       status="Completed";
     }
   }
    print("complaints length ${compDB.length}");
    return comp;
  }


  //get box widgets
  Future<List<Widget>> getWidgets() async {
     complaints=[];
    complaints = await getComplaints();
    for (int i = 0; i < complaints.length; i++) {
      boxWidgets.add(SizedBox(
          width: 370.0,
          height: 140.0,
          child: InkWell(//move to the specific complaint's detail screen
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return EditComplaints(complaint: complaints[i]);
            })),
            child: Card(
              borderOnForeground: true,
              color: Colors.white,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xff28CC9E), width: 1),
                  borderRadius: BorderRadius.circular(20.0)),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      '${complaints[i].subject}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 21.0),
                    ),
                    Text('\nDate: ' +  DateFormat('yyyy-MM-dd').format(complaints[i].date) + " \nTime: " +  DateFormat('HH:mm').format(complaints[i].date) +'\n'+'Status: ' + status,
              
                      style: TextStyle(
                          color: Colors.black,
                        
                          fontSize: 15.0),),
                    SizedBox(
                      height: 5.0,
                    ),
                  
                  ],
                ),
              )),
            ),
          )));
    }
    return boxWidgets;
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
