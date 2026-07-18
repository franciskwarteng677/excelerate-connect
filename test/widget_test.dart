import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:excelerate_connect/main.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) {
    return tester.pumpWidget(const ExcelerateConnectApp());
  }

  Future<void> signIn(WidgetTester tester) async {
    await pumpApp(tester);
    await tester.enterText(
      find.byKey(const ValueKey('loginEmailField')),
      'learner@example.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('loginPasswordField')),
      'prototype-password',
    );
    await tester.tap(find.byKey(const ValueKey('loginSubmitButton')));
    await tester.pumpAndSettle();
  }

  testWidgets('starts on the learner login screen', (tester) async {
    await pumpApp(tester);

    expect(find.byKey(const ValueKey('loginScreen')), findsOneWidget);
    expect(find.text('Excelerate Connect'), findsOneWidget);
    expect(find.byKey(const ValueKey('loginEmailField')), findsOneWidget);
    expect(find.byKey(const ValueKey('loginPasswordField')), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });

  testWidgets('shows required errors for an empty login form', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const ValueKey('loginSubmitButton')));
    await tester.pumpAndSettle();

    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
    expect(
      find.text('Please correct the highlighted fields and try again.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('loginScreen')), findsOneWidget);
  });

  testWidgets('rejects a malformed email address', (tester) async {
    await pumpApp(tester);
    await tester.enterText(
      find.byKey(const ValueKey('loginEmailField')),
      'not-an-email',
    );
    await tester.enterText(
      find.byKey(const ValueKey('loginPasswordField')),
      'prototype-password',
    );

    await tester.tap(find.byKey(const ValueKey('loginSubmitButton')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(find.byKey(const ValueKey('loginScreen')), findsOneWidget);
  });

  testWidgets('password visibility can be toggled', (tester) async {
    await pumpApp(tester);
    final field = find.byKey(const ValueKey('loginPasswordField'));

    EditableText editableText() {
      return tester.widget<EditableText>(
        find.descendant(of: field, matching: find.byType(EditableText)),
      );
    }

    expect(editableText().obscureText, isTrue);
    await tester.tap(find.byKey(const ValueKey('loginPasswordVisibility')));
    await tester.pump();
    expect(editableText().obscureText, isFalse);
  });

  testWidgets('valid local input replaces Login with Home', (tester) async {
    await signIn(tester);

    expect(find.byKey(const ValueKey('homeScreen')), findsOneWidget);
    expect(find.byKey(const ValueKey('loginScreen')), findsNothing);
    expect(find.text('Featured Programs'), findsOneWidget);
    expect(find.text('Flutter Foundations'), findsOneWidget);
    expect(find.text('Career Readiness Sprint'), findsOneWidget);
    expect(find.text('Upcoming Events'), findsOneWidget);
    expect(find.text('Recent Announcement'), findsOneWidget);
    expect(find.text('Quick Links'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    expect(navigator.canPop(), isFalse);
  });

  testWidgets('Programs bottom destination opens Program Listing', (
    tester,
  ) async {
    await signIn(tester);

    await tester.tap(find.byKey(const ValueKey('bottomProgramsDestination')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('programListingScreen')), findsOneWidget);
    expect(find.byKey(const ValueKey('homeScreen')), findsNothing);
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Programs')),
      findsOneWidget,
    );
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      1,
    );
  });
}
