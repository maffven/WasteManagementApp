import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/ForgotPass.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/Screens/Login.dart';
import 'package:flutter_application_1/Screens/SendComplaint.dart';

void main() {
  testWidgets("login widget test", (WidgetTester tester) async { await tester.runAsync(() async {
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
    await tester.pumpWidget(ForgotPass());
    /*var binIdField = find.byKey(ValueKey("addBinId"));
    var districtieField = find.byKey(ValueKey("addDistrict"));
    var summaryField = find.byKey(ValueKey("addSummary"));
    var descriptionField = find.byKey(ValueKey("addDescription"));
    var submitField = find.byKey(ValueKey("addComplaint"));*/
    var textField = find.byType(TextField);
    /*//execute the actual test
    await tester.enterText(binIdField, "144");
    await tester.enterText(districtieField, "Aljamea");
    await tester.enterText(summaryField, "Bin is broken");
    await tester.enterText(descriptionField,
        "i came to collect the bin at afternoon it was fully broken");
    await tester.tap(submitField);
    await tester.pump();*/
    
    //check outputs
    expect(find.byType(TextField), findsNWidgets(1));
    //expect(find.text("Bin is broken"), findsOneWidget);
     });
  });
}
