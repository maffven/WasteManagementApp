import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/DriverSatus.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter_application_1/model/District.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/model/DriverStatus.dart';

class Profile extends StatefulWidget {
  @override
  final Widget child;
  Profile({Key key, this.child}) : super(key: key);
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  Driver driver;
  int driverId;
  bool _status = true;
  bool _Enabled = false;
  List<Driver> drivers = [];

  final FocusNode myFocusNode = FocusNode();

  //To take input from
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  List<Driver> dd;
  bool checkInfo = false;
  //Driver driver;
  // DriverStatus status;
  //District district;
  //List<District> districts;
  //List<DriverStatus> status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDrivers().whenComplete(() {
      setState(() {
        _retriveDriver(drivers);
      });
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: FutureBuilder<List<Driver>>(
  //       future: getDrivers(),
  //       builder: (context, snapshot) {
  //         final drivers = snapshot.data;
  //         switch (snapshot.connectionState) {
  //           case ConnectionState.waiting:
  //             return Center(child: CircularProgressIndicator());
  //           default:
  //             if (snapshot.hasError) {
  //               return Center(child: Text("${snapshot.error}"));
  //             } else {
  //               return buildProfile(drivers);
  //             }R
  //         }
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // drivers = await getDrivers();

    phoneController = TextEditingController(text: "${driver.phone}");
    emailController = TextEditingController(text: "${driver.email}");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Color(0xffffDD83),
            title: Text("Profile"),
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "Info"),
                Tab(
                  text: "Status",
                ),
              ],
            )),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(
                  child: Expanded(
                      child: Container(
                height: 1000.0,
                child: ListView(padding: const EdgeInsets.all(8), children: <
                    Widget>[
                  //Icon container
                  Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: new Stack(
                              fit: StackFit.loose,
                              children: <Widget>[
                                new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Container(
                                        width: 140.0,
                                        height: 140.0,
                                        child: new Icon(
                                          Icons.person_rounded,
                                          size: 150.0,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          new Container(
                            color: Color(0xffFFFFFF),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  //Edit Icon
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Personal Information',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              _status
                                                  ? _getEditIcon()
                                                  : new Container(),
                                            ],
                                          )
                                        ],
                                      )),

                                  //ID padding
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'ID',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  //Id information
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 15.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Text("${driver.driverID}")
                                          // Text("${drivers[0].driverID}"),
                                          //new Flexible(
                                          //  child: new TextField(controller: IDController),
                                          //    decoration: const InputDecoration(
                                          //     hintText: "Enter Your ID",
                                          //mun = await readObj(mun.municpalityID, "municipality_admin");
                                          // driver= await readObj(driver.driverID, Driver)
                                          //   ),
                                          //   enabled: !_status,
                                          //    autofocus: !_status,
                                          //  ),
                                          // ),
                                        ],
                                      )),
                                  //Name padding
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Full name',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  //Name information
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Text(
                                              "${driver.firstName} ${driver.lastName}"),
                                          // new Flexible(
                                          //   child: new Text(
                                          //       "${drivers[0].firstName} ${drivers[0].lastName}"),

                                          //   //controller: nameController,
                                          //   //child: new TextField(
                                          //   //  decoration: const InputDecoration(
                                          //   //      hintText:
                                          //   //          "Enter your full name"),
                                          //   // "${drivers[i].firstName} ${drivers[i].lastName}"
                                          //   //  mun = await readObj(mun, "municipality_admin");
                                          //   // driver= await readObj(driver.firstName, Driver)
                                          //   // enabled: !_status,
                                          //   // ),
                                          // ),
                                        ],
                                      )),
                                  //Email padding
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Email',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  //Email information
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 100,
                                          child: TextFormField(
                                            controller: emailController,
                                            validator: (value) {
                                              if (!RegExp(r'\S+@\S+\.\S+')
                                                  .hasMatch(value)) {
                                                return "Please enter a valid email address";
                                              }
                                              return null;
                                            },
                                            enabled: _Enabled,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //Phone padding
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                'Phone number',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                        ],
                                      )),
                                  //phone information
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 100,
                                          child: TextFormField(
                                            controller: phoneController,
                                            validator: (value) {
                                              if (value.length != 10)
                                                return 'Mobile Number must be of 10 digit';
                                              else
                                                return null;
                                            },
                                            enabled: _Enabled,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  !_status
                                      ? _getActionButtons()
                                      : new Container(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              ))),
            ),
            new DriverSatus(),
          ],
        ),
      ),
    );
  }

  // Save and Cancel button
  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0, top: 0.0, bottom: 0.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                //here u have to check phone and email if it is wrong show dialog else make the update
                onPressed: () async {
                  String email = '';
                  String phone = "";
                  var phonenumber;
                  if (_isEmail(emailController.text) == true) {
                    email = emailController.text;
                  } else {
                    void showDialog() {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text("Warning"),
                            content: Text("please enter a valid email"),
                            actions: [
                              CupertinoDialogAction(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    }
                  }
                  if (_isPhone(phoneController.text) == true) {
                    phone = phoneController.text;
                    phonenumber = int.parse(phone);
                  } else {
                    void showDialog() {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text("Warning"),
                            content: Text("please enter a valid phone number"),
                            actions: [
                              CupertinoDialogAction(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    }
                  }
                  int driverId = driver.driverID;
                  int municipalityId;
                  String firstName;
                  String lastName;
                  String password;
                  String workTime;
                  //Check email and phone if its correct create new object
                  if (_isPhone(phoneController.text) == true &&
                      _isEmail(emailController.text) == true) {
                    Driver updateddriver = new Driver(
                        driverID: driverId,
                        municpalityID: municipalityId,
                        firstName: firstName,
                        lastName: lastName,
                        password: password,
                        email: email,
                        phone: phonenumber,
                        workTime: workTime);

                    updateObj(driver.driverID, updateddriver, tableDriver);
                  } else {}

                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  _isEmail(String email) {
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      return false;
    } else
      return true;
  }

  _isPhone(String phone) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (phone.length == 0) {
      return false;
    } else if (!regExp.hasMatch(phone)) {
      return false;
    } else
      return true;
  }

  Widget _getEditIcon() {
    //Edit icon style
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
          _Enabled = true;
        });
      },
    );
  }

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
    // print("mun object: ${munList[0].firatName}");
  }

  //Method to get drivers from DB
  Future<List<Driver>> getDrivers() async {
    //Get drivers from DB
    List<Driver> driv;
    List<dynamic> driversDB = await readAll(tableDriver);
    driv = driversDB.cast();
    // print("in get drivers method");
    // print("drivers length ${driversDB.length}");
    drivers = driv;
  }

  //generalUpdate(String tablename, int id, dynamic obj)
  Future updateObj(int id, dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalUpdate(tableName, id, obj);
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
}
