import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/AdminDriverStatus.dart';
import 'package:flutter_application_1/Screens/DriverDashboard.dart';
import 'package:flutter_application_1/Screens/Notification.dart';
import 'package:flutter_application_1/model/Driver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/Screens/mapSc.dart';
import 'package:flutter_application_1/Screens/Login.dart';
import 'package:flutter_application_1/Screens/SendComplaint.dart';
import 'package:flutter_application_1/Screens/profileScreen.dart';

void main() {
  testWidgets("login widget test", (WidgetTester tester) async {
    await tester.runAsync(() async {
      //find all widgets
      final userTypeField = find.byKey(ValueKey("checkType"));
      final phoneField = find.byKey(ValueKey("addPhone"));
      final passwordField = find.byKey(ValueKey("addPassword"));
      final submitField = find.byKey(ValueKey("loginButton"));
      //execute the actual test
      await tester.pumpWidget(Login());
      // await tester.enterText(userTypeField, true);
      await tester.enterText(phoneField, "06795431420");
      await tester.enterText(passwordField, "Rina12345!");
      await tester.press(userTypeField);
      await tester.tap(submitField);
      await tester.pump();

      //check outputs
      expect(find.text("06795431420"), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });
  });
  testWidgets("send complaint widget test", (WidgetTester tester) async {
    await tester.runAsync(() async {
      //find all widgets
      await tester.pumpWidget(SendComplaint());
      var binIdField = find.byKey(ValueKey("addBinId"));
      var districtieField = find.byKey(ValueKey("addDistrict"));
      var summaryField = find.byKey(ValueKey("addSummary"));
      var descriptionField = find.byKey(ValueKey("addDescription"));
      var submitField = find.byKey(ValueKey("addComplaint"));
      //execute the actual test
      await tester.enterText(binIdField, "144");
      await tester.enterText(districtieField, "Aljamea");
      await tester.enterText(summaryField, "Bin is broken");
      await tester.enterText(descriptionField,
          "i came to collect the bin at afternoon it was fully broken");
      await tester.tap(submitField);
      await tester.pump();
      //check output
      expect(find.text("144"), findsOneWidget);
      expect(find.text("Aljamea"), findsOneWidget);
      expect(find.text("Bin is broken"), findsOneWidget);
      expect(
          find.text(
              "i came to collect the bin at afternoon it was fully broken"),
          findsOneWidget);
    });
  });

  testWidgets("Driver Dashboard widget test", (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: BarAndPieChartDashboard())));

      //Ensure dashboard visualization
      var tab = find.byKey(ValueKey("DriverDashboard"));

      //check output
      expect(tab, findsOneWidget);
    });
  });
   testWidgets("Notification widget test", (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: ViewNotification())));

      var tab = find.byKey(ValueKey("Notification"));
      var tab1 = find.byKey(ValueKey("Performance"));
      //check output
      expect(tab, findsOneWidget);
      expect(tab1, findsOneWidget);
    });
  });
 testWidgets("Map widget test", (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: MapScreen())));

      var tab = find.byKey(ValueKey("Map"));
      
      //check output
      expect(tab, findsOneWidget);
    
    });
  });

  testWidgets("Profile widget test", (WidgetTester tester) async {
    await tester.runAsync(() async {
      //find all widgets
      Widget testWidget = new MediaQuery(
          data: new MediaQueryData(),
          child: new MaterialApp(home: new Profile()));
      await tester.pumpWidget(testWidget);
      Finder email = find.byKey(ValueKey("addEmail"));
      expect(email, findsOneWidget);
      Finder phone = find.byKey(ValueKey("addPhone"));
      expect(phone, findsOneWidget);
      Finder save = find.byKey(ValueKey("save"));
      expect(save, findsOneWidget);
      //execute the actual test
      await tester.enterText(email, "lina@gmail.com");
      await tester.enterText(phone, "05543620821");
      Future.delayed(Duration.zero, () {
        tester.tap(save);
      });
      await tester.pumpAndSettle();
      //check output
      expect(find.text("lina@gmail.com"), findsOneWidget);
      expect(find.text("05543620821"), findsOneWidget);
    });
  });
}
