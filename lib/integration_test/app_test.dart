import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
//1
import 'package:flutter_application_1/Screens/Login.dart';
import 'package:flutter_application_1/Screens/SendComplaint.dart';
//2
import 'package:flutter/material.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;
  if (binding is LiveTestWidgetsFlutterBinding) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }
  group('end-to-end test', () {
    testWidgets('Login Testing', (WidgetTester tester) async {
      await tester.pumpWidget(Login());
      await tester.pumpAndSettle();
//1
      tester.printToConsole('Login screen opens');
//2
      await tester.pumpAndSettle();
//3
      await tester.enterText(
          find.byKey(const ValueKey('addPhone')), "06795437890");
      await tester.enterText(find.byKey(const ValueKey('addPassword')), "7890");
      await tester.tap(find.byKey(ValueKey("loginButton")));
    });
    //TODO: add test 2 here
     testWidgets('Send complaint', (WidgetTester tester) async {
          //find all widgets
      await tester.pumpWidget(SendComplaint());
      await tester.pumpAndSettle();
//1
      tester.printToConsole('Send complaint screen opens');
//2
      await tester.pumpAndSettle();
//3

       await tester.enterText(
          find.byKey(const ValueKey('addBinId')), "2");
      await tester.enterText(find.byKey(const ValueKey('addDistrict')), "Alnaseem");
      await tester.enterText(
          find.byKey(const ValueKey('addSummary')), "Bin is broken");
          await tester.enterText(
          find.byKey(const ValueKey('addDescription')), "i came to collect the bin at afternoon it was fully broken");
      await tester.tap(find.byKey(ValueKey("addComplaint")));
 
     
     
    });
  });
}
