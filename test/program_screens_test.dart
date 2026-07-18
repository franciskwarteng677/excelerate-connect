import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:excelerate_connect/main.dart';

void main() {
  Future<void> signIn(WidgetTester tester) async {
    await tester.pumpWidget(const ExcelerateConnectApp());
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

  Future<void> openPrograms(WidgetTester tester) async {
    await signIn(tester);
    await tester.tap(find.byKey(const ValueKey('bottomProgramsDestination')));
    await tester.pumpAndSettle();
  }

  EditableText searchInput(WidgetTester tester) {
    return tester.widget<EditableText>(
      find.descendant(
        of: find.byKey(const ValueKey('programSearchField')),
        matching: find.byType(EditableText),
      ),
    );
  }

  testWidgets('Program Listing renders the local sample programs', (
    tester,
  ) async {
    await openPrograms(tester);

    expect(find.byKey(const ValueKey('programListingScreen')), findsOneWidget);
    expect(find.byKey(const ValueKey('programResultCount')), findsOneWidget);
    expect(find.text('4 sample programs'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('programCard-flutter-foundations')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('programCard-career-readiness-sprint')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('programCard-data-insights-starter')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('programCard-project-leadership-lab')),
      findsOneWidget,
    );
  });

  testWidgets('search filters programs by local text case-insensitively', (
    tester,
  ) async {
    await openPrograms(tester);

    await tester.enterText(
      find.byKey(const ValueKey('programSearchField')),
      'CAREER',
    );
    await tester.pump();

    expect(find.text('1 sample program'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('programCard-career-readiness-sprint')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('programCard-flutter-foundations')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('programCard-data-insights-starter')),
      findsNothing,
    );

    await tester.enterText(
      find.byKey(const ValueKey('programSearchField')),
      'analytics',
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('programCard-data-insights-starter')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('programCard-career-readiness-sprint')),
      findsNothing,
    );

    await tester.enterText(
      find.byKey(const ValueKey('programSearchField')),
      'guided practice',
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('programCard-flutter-foundations')),
      findsOneWidget,
    );
    expect(find.text('1 sample program'), findsOneWidget);
  });

  testWidgets('empty search can be reset to restore every program', (
    tester,
  ) async {
    await openPrograms(tester);

    await tester.enterText(
      find.byKey(const ValueKey('programSearchField')),
      'no matching sample',
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('programEmptyState')), findsOneWidget);
    expect(find.text('No programs found'), findsOneWidget);

    final reset = find.byKey(const ValueKey('programEmptyResetButton'));
    await tester.ensureVisible(reset);
    await tester.pumpAndSettle();
    await tester.tap(reset);
    await tester.pumpAndSettle();

    expect(searchInput(tester).controller.text, isEmpty);
    expect(find.byKey(const ValueKey('programEmptyState')), findsNothing);
    expect(find.text('4 sample programs'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('programCard-flutter-foundations')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('programCard-project-leadership-lab')),
      findsOneWidget,
    );
  });

  testWidgets('category controls filter and reset the catalogue', (
    tester,
  ) async {
    await openPrograms(tester);

    final mobileFilter = find.byKey(
      const ValueKey('programCategoryFilter-mobile-development'),
    );
    await tester.tap(mobileFilter);
    await tester.pump();

    expect(find.text('1 sample program'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('programCard-flutter-foundations')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('programCard-career-readiness-sprint')),
      findsNothing,
    );

    await tester.enterText(
      find.byKey(const ValueKey('programSearchField')),
      'flutter',
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('programResetFiltersButton')));
    await tester.pump();

    expect(searchInput(tester).controller.text, isEmpty);
    expect(find.text('4 sample programs'), findsOneWidget);
    expect(
      tester
          .widget<ChoiceChip>(
            find.byKey(const ValueKey('programCategoryFilter-all')),
          )
          .selected,
      isTrue,
    );
    expect(
      find.byKey(const ValueKey('programCard-career-readiness-sprint')),
      findsOneWidget,
    );
  });

  testWidgets('selecting a card opens its selected Program Details', (
    tester,
  ) async {
    await openPrograms(tester);
    await tester.enterText(
      find.byKey(const ValueKey('programSearchField')),
      'data insights',
    );
    await tester.pump();

    final card = find.byKey(
      const ValueKey('programCard-data-insights-starter'),
    );
    await tester.ensureVisible(card);
    await tester.pumpAndSettle();
    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('programDetailsScreen')), findsOneWidget);
    expect(find.text('Data Insights Starter'), findsOneWidget);
    expect(find.text('Data and Analytics'), findsOneWidget);
    expect(find.text('28 September'), findsOneWidget);
    expect(find.text('5 weeks'), findsOneWidget);
    expect(find.text('Self-paced online'), findsOneWidget);
    expect(find.text('About this sample program'), findsOneWidget);
    expect(find.text('Sample eligibility'), findsOneWidget);
    expect(find.textContaining('This sample program outlines'), findsOneWidget);
    expect(
      find.text('Curiosity about using data to answer practical questions.'),
      findsOneWidget,
    );
  });

  testWidgets('Details back returns to the filtered Program Listing', (
    tester,
  ) async {
    await openPrograms(tester);
    await tester.enterText(
      find.byKey(const ValueKey('programSearchField')),
      'career',
    );
    await tester.pump();

    final detailsButton = find.byKey(
      const ValueKey('programViewDetails-career-readiness-sprint'),
    );
    await tester.ensureVisible(detailsButton);
    await tester.pumpAndSettle();
    await tester.tap(detailsButton);
    await tester.pumpAndSettle();
    expect(find.text('Career Readiness Sprint'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('programDetailsBackButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('programListingScreen')), findsOneWidget);
    expect(find.byKey(const ValueKey('programDetailsScreen')), findsNothing);
    expect(find.text('1 sample program'), findsOneWidget);
    expect(searchInput(tester).controller.text, 'career');
    expect(
      find.byKey(const ValueKey('programCard-career-readiness-sprint')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('programCard-flutter-foundations')),
      findsNothing,
    );
  });

  testWidgets('program actions report their prototype limitations', (
    tester,
  ) async {
    await openPrograms(tester);

    final detailsButton = find.byKey(
      const ValueKey('programViewDetails-flutter-foundations'),
    );
    await tester.ensureVisible(detailsButton);
    await tester.pumpAndSettle();
    await tester.tap(detailsButton);
    await tester.pumpAndSettle();

    final applyButton = find.byKey(const ValueKey('programApplyButton'));
    await tester.ensureVisible(applyButton);
    await tester.pumpAndSettle();
    await tester.tap(applyButton);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Application and registration are not connected in this prototype.',
      ),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    final feedbackButton = find.byKey(const ValueKey('programFeedbackButton'));
    await tester.ensureVisible(feedbackButton);
    await tester.pumpAndSettle();
    await tester.tap(feedbackButton);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'The Feedback Screen is planned for a later stage. '
        'No feedback was submitted.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Home search opens Programs and bottom Home returns Home', (
    tester,
  ) async {
    await signIn(tester);

    await tester.tap(find.byKey(const ValueKey('homeSearchField')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('programListingScreen')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottomHomeDestination')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('homeScreen')), findsOneWidget);
    expect(find.byKey(const ValueKey('loginScreen')), findsNothing);
  });

  testWidgets('Home View all and Quick Programs open Program Listing', (
    tester,
  ) async {
    await signIn(tester);

    await tester.tap(find.text('View all'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('programListingScreen')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottomHomeDestination')));
    await tester.pumpAndSettle();

    final quickPrograms = find.byKey(const ValueKey('quickPrograms'));
    await tester.ensureVisible(quickPrograms);
    await tester.pumpAndSettle();
    await tester.tap(quickPrograms);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('programListingScreen')), findsOneWidget);
  });

  testWidgets('Home featured program opens Details and Back returns Home', (
    tester,
  ) async {
    await signIn(tester);

    final featuredCard = find.byKey(
      const ValueKey('programCard-flutter-foundations'),
    );
    await tester.ensureVisible(featuredCard);
    await tester.pumpAndSettle();
    await tester.tap(featuredCard);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('programDetailsScreen')), findsOneWidget);
    expect(find.text('Flutter Foundations'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('programDetailsBackButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('homeScreen')), findsOneWidget);
    expect(find.byKey(const ValueKey('programDetailsScreen')), findsNothing);
  });
}
