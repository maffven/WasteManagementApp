import 'dart:io';
import 'package:flutter_application_1/db/DatabaseHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_application_1/model/BinLevel.dart';
import 'package:flutter_application_1/model/BinLocation.dart';
import 'package:flutter_application_1/model/tabs_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/model/Bin.dart';

const double GMAP_DEFAULT_LATITUDE = 21.584873;
const double GMAP_DEFAULT_LONGITUDE = 39.205959;
const double GMAP_DEFAULT_ZOOM = 12;
var distance = 0.0;
String color = "";
String titlee = "";
double colorBin = 0.0;
List<BinLevel> binlevel = [];
List<Bin> b = [];
//the markers (pins) on the map
List<Marker> markerss = [];
BinLevel level = BinLevel();
BinLocation location = BinLocation(); //location of bin
const CameraPosition INITIAL_CAMERA_POSITION = CameraPosition(
  target: LatLng(
    GMAP_DEFAULT_LATITUDE,
    GMAP_DEFAULT_LONGITUDE,
  ),
  zoom: GMAP_DEFAULT_ZOOM,
);

List<Marker> displayMarker(double colorBin) {
  print(colorBin);
  print(color);
  List<Marker> marker = [
    Marker(
        infoWindow: InfoWindow(title: titlee),
        markerId: MarkerId(color),
        position: LatLng(21.4893852, 39.2462446),
        icon: BitmapDescriptor.defaultMarkerWithHue(colorBin),
        onTap: () {
          MapUtils.openMap(
              21.4893852, 39.2462446); //to open google map app/direct
        })
  ];

  return marker;
}

Future deleteObj(int id, String tableName) async {
  print("$id rawan");
  await DatabaseHelper.instance.gneralDelete(id, tableName);
  print("Object is deleted");
}

Future<List<dynamic>> readAll(String tableName) async {
  //We have to define list here as dynamci *******
  return await DatabaseHelper.instance.generalReadAll(tableName);
}

//Create a firebase database reference
final databaseReference = FirebaseDatabase.instance.reference();
//to read the distance from the firebase
void readDistance() {
 
  //this means the data is up to date
  databaseReference.onValue.listen((event) {
    final distanceFirebase =
        new Map<String, dynamic>.from(event.snapshot.value);
    print(distanceFirebase['Distance']); //json data
    distance = distanceFirebase['Distance'].toDouble();
    print(distance); //get the distance from the firebase
    if (distance <= 15.0) {
      //full
      print('manar');
      color = 'Red';
      titlee = "Full";
      level = BinLevel(binID: 144, full: true, half_full: false, empty: false);
      colorBin = BitmapDescriptor.hueRed;
      displayMarker(colorBin);
    } else if (distance > 15.0 && distance < 900.0) {
      //half-full
      color = 'Orange';
      print('rawan');
      titlee = "Half - Empty";
      colorBin = BitmapDescriptor.hueOrange;
      level = BinLevel(binID: 144, full: false, half_full: true, empty: false);
      displayMarker(colorBin);
    } else {
      //empty
      color = 'Green';
      print('lina');
      titlee = "Empty";
      level = BinLevel(binID: 144, full: false, half_full: false, empty: true);
      colorBin = BitmapDescriptor.hueGreen;
      displayMarker(colorBin);
    }
    //coordinateX must be double not iNTEGER
    print("before adding bin level");

    //list of markers on the map
    markerss = [
      Marker(
          infoWindow: InfoWindow(title: titlee),
          markerId: MarkerId(color),
          position: LatLng(21.4893852, 39.2462446),
          icon: BitmapDescriptor.defaultMarkerWithHue(colorBin),
          onTap: () {
            MapUtils.openMap(
                21.4893852, 39.2462446); //to open google map app/direct
          }),

           Marker(
          infoWindow: InfoWindow(title: titlee),
          markerId: MarkerId('Green'),
          position: LatLng(21.4897, 39.2502),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: () {
            MapUtils.openMap(
                21.4897,39.2502); //to open google map app/direct
          }),
          /* Marker(
          infoWindow: InfoWindow(title: titlee),
          markerId: MarkerId('Orange'),
          position: LatLng(, ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () {
            MapUtils.openMap(
                21.4893852, 39.2462446); //to open google map app/direct
          })*/
       
    ];
  });
}

Future addObj(dynamic obj, String tableName) async {
  await DatabaseHelper.instance.generalCreate(obj, tableName);
  print("object inserted");
}

class map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp()
      .then((value) => print("connected " + value.options.asMap.toString()))
      .catchError((e) => print(e.toString()));
  runApp(MaterialApp(home: map())); //function written by flutter
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    readDistance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffDD83),
        title: Text("Map"),
      ),
      body: GoogleMap(key: Key("Map"),
        markers: Set<Marker>.of(markerss),
        initialCameraPosition: INITIAL_CAMERA_POSITION,
      ),
    );
  }
}

class MapUtils {
  MapUtils._();
//these method and class are created to open the google map application
//once the user clicks on any pin/marker
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
