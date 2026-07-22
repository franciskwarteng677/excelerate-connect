import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:excelerate_connect/data/sample_programs.dart';
import 'package:excelerate_connect/screens/feedback_form_screen.dart';
import 'package:excelerate_connect/screens/home_screen.dart';
import 'package:excelerate_connect/screens/login_screen.dart';
import 'package:excelerate_connect/screens/program_details_screen.dart';
import 'package:excelerate_connect/screens/program_listing_screen.dart';
import 'package:excelerate_connect/screens/registration_form_screen.dart';
import 'package:excelerate_connect/theme/app_theme.dart';

import 'support/fake_program_repository.dart';

void main() {
  final viewportCases = <({String name, Size size, double textScale})>[
    (
      name: 'mobile with increased text',
      size: const Size(360, 800),
      textScale: 1.4,
    ),
    (name: 'tablet', size: const Size(768, 1024), textScale: 1),
    (name: 'desktop', size: const Size(1440, 900), textScale: 1),
  ];

  for (final viewportCase in viewportCases) {
    testWidgets(
      'audited screens avoid layout exceptions at ${viewportCase.name} width',
      (tester) async {
        tester.view
          ..devicePixelRatio = 1
          ..physicalSize = viewportCase.size;
        tester.platformDispatcher.textScaleFactorTestValue =
            viewportCase.textScale;
        addTearDown(() {
          tester.view
            ..resetDevicePixelRatio()
            ..resetPhysicalSize();
          tester.platformDispatcher.clearTextScaleFactorTestValue();
        });

        final repository = FakeProgramRepository.immediate(samplePrograms);
        final screens = <({Key key, Widget screen})>[
          (key: const ValueKey('loginScreen'), screen: const LoginScreen()),
          (
            key: const ValueKey('homeScreen'),
            screen: HomeScreen(programRepository: repository),
          ),
          (
            key: const ValueKey('programListingScreen'),
            screen: ProgramListingScreen(programRepository: repository),
          ),
          (
            key: const ValueKey('programDetailsScreen'),
            screen: ProgramDetailsScreen(program: samplePrograms.first),
          ),
          (
            key: const ValueKey('registrationFormScreen'),
            screen: RegistrationFormScreen(
              program: samplePrograms.first,
              submissionDelay: Duration.zero,
            ),
          ),
          (
            key: const ValueKey('feedbackFormScreen'),
            screen: FeedbackFormScreen(
              program: samplePrograms.first,
              submissionDelay: Duration.zero,
            ),
          ),
        ];

        for (final screenCase in screens) {
          await tester.pumpWidget(
            MaterialApp(theme: AppTheme.lightTheme, home: screenCase.screen),
          );
          await tester.pumpAndSettle();

          expect(find.byKey(screenCase.key), findsOneWidget);
          expect(
            tester.takeException(),
            isNull,
            reason:
                '${screenCase.key} overflowed or threw at '
                '${viewportCase.size} with text scale '
                '${viewportCase.textScale}.',
          );

          final scrollView = find.byType(SingleChildScrollView);
          if (scrollView.evaluate().isNotEmpty) {
            await tester.drag(
              scrollView.first,
              const Offset(0, -4000),
              warnIfMissed: false,
            );
            await tester.pumpAndSettle();
            expect(
              tester.takeException(),
              isNull,
              reason: '${screenCase.key} failed after scrolling.',
            );
          }
        }
      },
    );
  }

  testWidgets('Login tolerates an extremely short browser viewport', (
    tester,
  ) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(360, 48);
    addTearDown(() {
      tester.view
        ..resetDevicePixelRatio()
        ..resetPhysicalSize();
    });

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.lightTheme, home: const LoginScreen()),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('loginScreen')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
