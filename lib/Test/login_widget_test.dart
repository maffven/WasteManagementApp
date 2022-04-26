import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/Screens/Login.dart';

void main() {
  testWidgets("login", (WidgetTester tester) async {
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
    await tester.tap(submitField);
    await tester.pump();

//check outputs
    expect(find.text("06795431420"), findsOneWidget);
  });
}
