import 'package:flutter/material.dart';

import 'screens/feedback_form_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/program_details_screen.dart';
import 'screens/program_listing_screen.dart';
import 'screens/registration_form_screen.dart';
import 'services/program_repository.dart';
import 'theme/app_theme.dart';

void main() => runApp(ExcelerateConnectApp());

class ExcelerateConnectApp extends StatelessWidget {
  ExcelerateConnectApp({ProgramRepository? programRepository, super.key})
    : programRepository = programRepository ?? AssetProgramRepository();

  final ProgramRepository programRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excelerate Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        HomeScreen.routeName: (_) =>
            HomeScreen(programRepository: programRepository),
        ProgramListingScreen.routeName: (_) =>
            ProgramListingScreen(programRepository: programRepository),
      },
      onGenerateRoute: _generateRoute,
    );
  }

  Route<void>? _generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case ProgramDetailsScreen.routeName:
        if (arguments is ProgramDetailsArguments) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => ProgramDetailsScreen(program: arguments.program),
          );
        }
        return _unavailableRoute(settings);
      case RegistrationFormScreen.routeName:
        if (arguments is RegistrationFormArguments) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => RegistrationFormScreen(program: arguments.program),
          );
        }
        return _unavailableRoute(settings);
      case FeedbackFormScreen.routeName:
        if (arguments is FeedbackFormArguments) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => FeedbackFormScreen(program: arguments.program),
          );
        }
        return _unavailableRoute(settings);
      default:
        return null;
    }
  }

  Route<void> _unavailableRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => const _ProgramUnavailableScreen(),
    );
  }
}

class _ProgramUnavailableScreen extends StatelessWidget {
  const _ProgramUnavailableScreen();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Program details')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: colors.primaryContainer,
                      foregroundColor: colors.primary,
                      child: const Icon(Icons.info_outline_rounded, size: 34),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Program unavailable',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Choose a local sample program from the Programs screen '
                      'to view its details.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            ProgramListingScreen.routeName,
                            (_) => false,
                          ),
                      icon: const Icon(Icons.view_list_outlined),
                      label: const Text('Browse programs'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
