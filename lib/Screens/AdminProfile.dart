import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/model/MunicipalityAdmin.dart';
import '../model/MunicipalityAdmin.dart';
import '../db/DatabaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfile extends StatefulWidget {
  @override
  final Widget child;
  AdminProfile({Key key, this.child}) : super(key: key);
  AdminProfileState createState() => AdminProfileState();
}

class AdminProfileState extends State<AdminProfile> {
  @override
  bool _status = true;
  bool _enabled = false;
  bool loading = true;

  final FocusNode myFocusNode = FocusNode();

  //To take input from
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  List<MunicipalityAdmin> admins = [];
  bool checkInfo = false;
  MunicipalityAdmin admin;

  @override
  void initState() {
    // TODO: implement initState
    getAdmin();
    super.initState();
  }

  //MunicipalityAdmin mun;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 1,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Color(0xffffDD83),
              title: Text("Profile"),
              bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Info"),
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
                        height: 600.0,
                        child: ListView(
                            padding: const EdgeInsets.all(8),
                            children: <Widget>[
                              Container(
                                color: Color(0xffFFFFFF),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 25.0),
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          padding:
                                              EdgeInsets.only(bottom: 25.0),
                                          child: new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 25.0),
                                                  child: new Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          new Text(
                                                            'Info',
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      new Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
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
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 25.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          new Text(
                                                            'ID',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      Text(
                                                          "${admin.municpalityID}"),
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 25.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          new Text(
                                                            'Full name',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      Text(
                                                          "${admin.firstName} ${admin.lastName}"),
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 25.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          new Text(
                                                            'Email',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                        child: TextFormField(
                                                          controller:
                                                              emailController,
                                                          enabled: _enabled,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 25.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
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
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        flex: 2,
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
                                                      child: TextFormField(
                                                        controller:
                                                            phoneController,
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
                padding: const EdgeInsets.only(top: 50.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

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
                onPressed: () async {
                  String email = "";
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
                  int municipalityId = admin.municpalityID;
                  String firstName;
                  String lastName;
                  String password;
                  //Check email and phone if its correct create new object
                  if (_isPhone(phoneController.text) == true &&
                      _isEmail(emailController.text) == true) {
                    MunicipalityAdmin updatedadmin = new MunicipalityAdmin(
                        municpalityID: municipalityId,
                        firstName: firstName,
                        lastName: lastName,
                        password: password,
                        email: email,
                        phone: phonenumber);

                    updateObj(admin.municpalityID, updatedadmin,
                        tableMunicipalityAdmin);
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
    if (RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      return true;
    } else
      return false;
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

  Future<MunicipalityAdmin> _retriveAdmin(
      List<MunicipalityAdmin> adminList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Admin id: ${prefs.getInt('id')}");
    int munId = prefs.getInt('id');
    MunicipalityAdmin munAdmin;
    for (var i = 0; i < adminList.length; i++) {
      print("drivers[i].driverID ${adminList[i].municpalityID}");
      if (munId == adminList[i].municpalityID) {
        munAdmin = adminList[i];
        break;
      }
    }
    return munAdmin;
  }

  Widget _getEditIcon() {
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

  Future<dynamic> verifyLogin(String password, int phone) async {
    return await DatabaseHelper.instance.checkLogin(password, phone);
  }

  Future<List<dynamic>> readAll(String tableName) async {
    //We have to define list here as dynamci *******
    return await DatabaseHelper.instance.generalReadAll(tableName);
  }

  //Delete a row
  //gneralDelete(int id, String tablename)
  Future deleteObj(int id, String tableName) async {
    print("$id rawan");
    await DatabaseHelper.instance.gneralDelete(id, tableName);
    print("Object is deleted");
  }

  //Close database  Method
  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }

  Future<int> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }

  void getAdmin() async {
    //Get drivers from DB
    List<MunicipalityAdmin> mun;
    List<dynamic> munDB = await readAll(tableMunicipalityAdmin);
    mun = munDB.cast();
    MunicipalityAdmin munAdmin = await _retriveAdmin(mun);
    setState(() {
      admins = mun;
      admin = munAdmin;
      String ph = (admin.phone).toString();
      phoneController = TextEditingController(text: ph);
      emailController = TextEditingController(text: "${admin.email}");
      loading = false;
    });
  }
}
