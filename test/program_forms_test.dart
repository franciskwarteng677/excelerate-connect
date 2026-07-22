import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:excelerate_connect/models/program.dart';
import 'package:excelerate_connect/screens/feedback_form_screen.dart';
import 'package:excelerate_connect/screens/registration_form_screen.dart';
import 'package:excelerate_connect/theme/app_theme.dart';

const _program = Program(
  id: 'flutter-foundations',
  title: 'Flutter Foundations',
  category: 'Mobile Development',
  shortDescription: 'Explore core Flutter concepts.',
  fullDescription: 'A local sample program used by form widget tests.',
  deadline: '30 August',
  duration: '6 weeks',
  deliveryFormat: 'Online',
  eligibilityRequirements: ['Interest in mobile application development.'],
  visual: ProgramVisual.mobileDevelopment,
);

void main() {
  Future<void> pumpRegistration(
    WidgetTester tester, {
    Duration submissionDelay = Duration.zero,
  }) async {
    tester.view.physicalSize = const Size(900, 1400);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: RegistrationFormScreen(
          program: _program,
          submissionDelay: submissionDelay,
        ),
      ),
    );
  }

  Future<void> pumpFeedback(
    WidgetTester tester, {
    Duration submissionDelay = Duration.zero,
  }) async {
    tester.view.physicalSize = const Size(900, 1400);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: FeedbackFormScreen(
          program: _program,
          submissionDelay: submissionDelay,
        ),
      ),
    );
  }

  EditableText editableText(WidgetTester tester, String key) {
    return tester.widget<EditableText>(
      find.descendant(
        of: find.byKey(ValueKey(key)),
        matching: find.byType(EditableText),
      ),
    );
  }

  Future<void> selectDropdownOption(
    WidgetTester tester,
    String fieldKey,
    String option,
  ) async {
    final field = find.byKey(ValueKey(fieldKey));
    await tester.ensureVisible(field);
    await tester.tap(field);
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  Future<void> tapVisible(WidgetTester tester, String key) async {
    final target = find.byKey(ValueKey(key));
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pump();
  }

  Future<void> toggleRegistrationAgreement(WidgetTester tester) async {
    final tile = find.byKey(const ValueKey('registrationAgreementCheckbox'));
    await tester.ensureVisible(tile);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: tile, matching: find.byType(Checkbox)),
    );
    await tester.pump();
  }

  testWidgets('registration form validates required, format, and length', (
    tester,
  ) async {
    await pumpRegistration(tester);

    await tapVisible(tester, 'registrationSubmitButton');

    expect(find.text('Enter your full name.'), findsOneWidget);
    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Select your education level.'), findsOneWidget);
    expect(find.text('Tell us why you want to join.'), findsOneWidget);
    expect(
      find.text('Confirm that you understand this is a local prototype.'),
      findsOneWidget,
    );
    expect(
      find.text('Please correct the highlighted registration fields.'),
      findsOneWidget,
    );
    ScaffoldMessenger.of(
      tester.element(find.byType(Scaffold)),
    ).removeCurrentSnackBar();
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('registrationFullNameField')),
      'Francis Kwarteng',
    );
    await tester.pump();
    expect(find.text('Enter your full name.'), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('registrationEmailField')),
      'invalid-email',
    );
    await selectDropdownOption(
      tester,
      'registrationEducationField',
      'Undergraduate',
    );
    expect(find.text('Select your education level.'), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('registrationMotivationField')),
      'Too short',
    );
    await toggleRegistrationAgreement(tester);
    expect(
      find.text('Confirm that you understand this is a local prototype.'),
      findsNothing,
    );
    await tapVisible(tester, 'registrationSubmitButton');

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(
      find.text('Enter at least 20 characters for your motivation.'),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('registrationSuccessPanel')),
      findsNothing,
    );
  });

  testWidgets('registration submits locally, confirms success, and clears', (
    tester,
  ) async {
    await pumpRegistration(tester);

    await tester.enterText(
      find.byKey(const ValueKey('registrationFullNameField')),
      'Francis Kwarteng',
    );
    await tester.enterText(
      find.byKey(const ValueKey('registrationEmailField')),
      'francis@example.com',
    );
    await selectDropdownOption(
      tester,
      'registrationEducationField',
      'Undergraduate',
    );
    await tester.enterText(
      find.byKey(const ValueKey('registrationMotivationField')),
      'I want to strengthen my Flutter development skills.',
    );
    await toggleRegistrationAgreement(tester);
    await tapVisible(tester, 'registrationSubmitButton');
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('registrationSuccessPanel')),
      findsOneWidget,
    );
    expect(find.textContaining('No registration was sent'), findsOneWidget);
    expect(find.textContaining('Nothing was sent to a server'), findsOneWidget);
    expect(
      editableText(tester, 'registrationFullNameField').controller.text,
      isEmpty,
    );
    expect(
      editableText(tester, 'registrationEmailField').controller.text,
      isEmpty,
    );
    expect(
      editableText(tester, 'registrationMotivationField').controller.text,
      isEmpty,
    );
    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const ValueKey('registrationAgreementCheckbox')),
          )
          .value,
      isFalse,
    );
    final educationField = find.descendant(
      of: find.byKey(const ValueKey('registrationEducationField')),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    expect(tester.state<FormFieldState<String>>(educationField).value, isNull);
  });

  testWidgets('registration exposes and completes its in-flight state', (
    tester,
  ) async {
    await pumpRegistration(tester, submissionDelay: const Duration(seconds: 1));

    await tester.enterText(
      find.byKey(const ValueKey('registrationFullNameField')),
      'Francis Kwarteng',
    );
    await tester.enterText(
      find.byKey(const ValueKey('registrationEmailField')),
      'francis@example.com',
    );
    await selectDropdownOption(
      tester,
      'registrationEducationField',
      'Undergraduate',
    );
    await tester.enterText(
      find.byKey(const ValueKey('registrationMotivationField')),
      'I want to strengthen my Flutter development skills.',
    );
    await toggleRegistrationAgreement(tester);
    await tapVisible(tester, 'registrationSubmitButton');

    expect(
      find.byKey(const ValueKey('registrationSubmitProgress')),
      findsOneWidget,
    );
    final submitButton = find.descendant(
      of: find.byKey(const ValueKey('registrationSubmitButton')),
      matching: find.byType(FilledButton),
    );
    expect(tester.widget<FilledButton>(submitButton).onPressed, isNull);

    await tester.tap(submitButton);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('registrationSuccessPanel')),
      findsOneWidget,
    );
  });

  testWidgets('feedback form validates required, format, and length', (
    tester,
  ) async {
    await pumpFeedback(tester);

    await tapVisible(tester, 'feedbackSubmitButton');

    expect(find.text('Enter your full name.'), findsOneWidget);
    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Select an experience rating.'), findsOneWidget);
    expect(find.text('Enter your feedback comments.'), findsOneWidget);
    expect(
      find.text('Please correct the highlighted feedback fields.'),
      findsOneWidget,
    );
    ScaffoldMessenger.of(
      tester.element(find.byType(Scaffold)),
    ).removeCurrentSnackBar();
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('feedbackFullNameField')),
      'Francis Kwarteng',
    );
    await tester.pump();
    expect(find.text('Enter your full name.'), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('feedbackEmailField')),
      'invalid-email',
    );
    await selectDropdownOption(tester, 'feedbackRatingField', 'Good');
    expect(find.text('Select an experience rating.'), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('feedbackCommentsField')),
      'Too short',
    );
    await tapVisible(tester, 'feedbackSubmitButton');

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(
      find.text('Enter at least 20 characters for your comments.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('feedbackSuccessPanel')), findsNothing);
  });

  testWidgets('feedback submits locally, confirms success, and clears', (
    tester,
  ) async {
    await pumpFeedback(tester);

    await tester.enterText(
      find.byKey(const ValueKey('feedbackFullNameField')),
      'Francis Kwarteng',
    );
    await tester.enterText(
      find.byKey(const ValueKey('feedbackEmailField')),
      'francis@example.com',
    );
    await selectDropdownOption(tester, 'feedbackRatingField', 'Excellent');
    await tester.enterText(
      find.byKey(const ValueKey('feedbackCommentsField')),
      'The local prototype is clear and simple to navigate.',
    );
    await tapVisible(tester, 'feedbackSubmitButton');
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('feedbackSuccessPanel')), findsOneWidget);
    expect(find.textContaining('No feedback was sent'), findsOneWidget);
    expect(find.textContaining('Nothing was sent to a server'), findsOneWidget);
    expect(
      editableText(tester, 'feedbackFullNameField').controller.text,
      isEmpty,
    );
    expect(editableText(tester, 'feedbackEmailField').controller.text, isEmpty);
    expect(
      editableText(tester, 'feedbackCommentsField').controller.text,
      isEmpty,
    );
    final ratingField = find.descendant(
      of: find.byKey(const ValueKey('feedbackRatingField')),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    expect(tester.state<FormFieldState<String>>(ratingField).value, isNull);
  });

  testWidgets('feedback exposes and completes its in-flight state', (
    tester,
  ) async {
    await pumpFeedback(tester, submissionDelay: const Duration(seconds: 1));

    await tester.enterText(
      find.byKey(const ValueKey('feedbackFullNameField')),
      'Francis Kwarteng',
    );
    await tester.enterText(
      find.byKey(const ValueKey('feedbackEmailField')),
      'francis@example.com',
    );
    await selectDropdownOption(tester, 'feedbackRatingField', 'Excellent');
    await tester.enterText(
      find.byKey(const ValueKey('feedbackCommentsField')),
      'The local prototype is clear and simple to navigate.',
    );
    await tapVisible(tester, 'feedbackSubmitButton');

    expect(
      find.byKey(const ValueKey('feedbackSubmitProgress')),
      findsOneWidget,
    );
    final submitButton = find.descendant(
      of: find.byKey(const ValueKey('feedbackSubmitButton')),
      matching: find.byType(FilledButton),
    );
    expect(tester.widget<FilledButton>(submitButton).onPressed, isNull);

    await tester.tap(submitButton);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('feedbackSuccessPanel')), findsOneWidget);
  });
}
