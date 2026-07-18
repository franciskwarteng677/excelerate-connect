import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/program_details_screen.dart';
import 'screens/program_listing_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const ExcelerateConnectApp());

class ExcelerateConnectApp extends StatelessWidget {
  const ExcelerateConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excelerate Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        ProgramListingScreen.routeName: (_) => const ProgramListingScreen(),
      },
      onGenerateRoute: _generateRoute,
    );
  }

  Route<void>? _generateRoute(RouteSettings settings) {
    if (settings.name != ProgramDetailsScreen.routeName) return null;

    final arguments = settings.arguments;
    if (arguments is! ProgramDetailsArguments) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const _ProgramUnavailableScreen(),
      );
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => ProgramDetailsScreen(program: arguments.program),
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
