import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/CommonFunctions.dart';
import 'package:flutter_application_1/Screens/DriverSatus.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:flutter_application_1/db/DatabaseHelper.dart';

void main() {
  runApp(
    MaterialApp(
      home: Profile(),
    ),
  );
}

class Profile extends StatefulWidget {
  @override
  final Widget child;
  Profile({Key key, this.child}) : super(key: key);
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  Driver driver;
  bool _status = true;
  bool loading = true;
  bool _enabled = false;

  final FocusNode myFocusNode = FocusNode();

  //To take input from
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    _getLoginedDriver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              child: loading
                  ? Transform.scale(
                      scale: 0.2,
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: Expanded(
                          child: Container(
                      height: 1000.0,
                      child:
                          ListView(padding: const EdgeInsets.all(8), children: <
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        //Edit Icon
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 25.0),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                left: 25.0,
                                                right: 25.0,
                                                top: 25.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                left: 25.0,
                                                right: 15.0,
                                                top: 2.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Text("${driver.driverID}")
                                              ],
                                            )),
                                        //Name padding
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 25.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                left: 25.0,
                                                right: 25.0,
                                                top: 2.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Text(
                                                    "${driver.firstName} ${driver.lastName}"),
                                              ],
                                            )),
                                        //Email padding
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 25.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                              left: 25.0,
                                              right: 25.0,
                                              top: 2.0),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: 100,
                                                child: TextField(
                                                  key: Key("addEmail"),
                                                  controller: emailController,
                                                  enabled: _enabled,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        //Phone padding
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 25.0),
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
                                              left: 25.0,
                                              right: 25.0,
                                              top: 2.0),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: 100,
                                                child: TextField(
                                                  key: Key("addPhone"),
                                                  controller: phoneController,
                                                  enabled: _enabled,
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
              padding: const EdgeInsets.only(top: 15.0),
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
                key: Key("save"),
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                //here u have to check phone and email if it is wrong show dialog else make the update
                onPressed: () async {
                  String email = '';
                  String phone = "";
                  int phonenumber;
                  if (_isEmail(emailController.text) == true) {
                    email = emailController.text;
                  } else {
                    showDialog("please enter a valid email");
                    setState(() {
                      emailController.text = driver.email;
                    });
                  }
                  if (_isPhone(phoneController.text) == true) {
                    phone = phoneController.text;
                    phonenumber = int.parse(phone);
                  } else {
                    showDialog("please enter a valid phone number");

                    setState(() {
                      phoneController.text = (driver.phone).toString();
                    });
                  }
                  int driverId = driver.driverID;
                  int municipalityId = driver.municpalityID;
                  String firstName = driver.firstName;
                  String lastName = driver.lastName;
                  String password = driver.password;
                  String workTime = driver.workTime;
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

                    setState(() {
                      String ph = updateddriver.phone.toString();
                      phoneController.text = ph;
                      emailController.text = updateddriver.email;
                    });
                  } else {
                    showDialog("email/phone");
                  }

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
    if (RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      return true;
    } else
      return false;
  }

  void showDialog(String text) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Warning"),
          content: Text(text),
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

  _isPhone(String phone) {
    if (phone.length == 0) {
      return false;
    } else if (phone.length == 11 || phone.length == 10 || phone.length == 9) {
      return true;
    } else {
      return false;
    }
  }

  //generalUpdate(String tablename, int id, dynamic obj)
  Future updateObj(int id, dynamic obj, String tableName) async {
    await DatabaseHelper.instance.generalUpdate(tableName, id, obj);
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
          _enabled = true;
        });
      },
    );
  }

  Future<List<dynamic>> readAll(String tableName) async {
    return await DatabaseHelper.instance.generalReadAll(tableName);
  }

  Future <void> _getLoginedDriver() async {
    CommonFunctions com = new CommonFunctions();
    Driver loginedDriver = await com.retriveDriver();
    setState(() {
      driver = loginedDriver;
      String ph = driver.phone.toString();
      phoneController = TextEditingController(text: ph);
      emailController = TextEditingController(text: "${driver.email}");
      loading = false;
    });
  }
}
