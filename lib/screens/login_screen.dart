import 'package:flutter/material.dart';

import '../widgets/primary_button.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  bool _validateWhileTyping = false;

  String? _emailError(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _passwordError(String? value) {
    return value == null || value.isEmpty ? 'Enter your password.' : null;
  }

  void _message(String text) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _login() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => _validateWhileTyping = true);
      _message('Please correct the highlighted fields and try again.');
      return;
    }
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      key: const ValueKey('loginScreen'),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 700;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: wide ? 32 : 20,
                vertical: 32,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight >= 64
                      ? constraints.maxHeight - 64
                      : 0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Card(
                      elevation: wide ? 3 : 0,
                      child: Padding(
                        padding: EdgeInsets.all(wide ? 40 : 24),
                        child: AutofillGroup(
                          child: Form(
                            key: _formKey,
                            autovalidateMode: _validateWhileTyping
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Align(
                                  child: Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: colors.primaryContainer,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      Icons.school_outlined,
                                      color: colors.primary,
                                      size: 38,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Excelerate Connect',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineLarge,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Sign in to explore the learner experience.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 32),
                                TextFormField(
                                  key: const ValueKey('loginEmailField'),
                                  validator: _emailError,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.email],
                                  autocorrect: false,
                                  decoration: const InputDecoration(
                                    labelText: 'Email address',
                                    hintText: 'learner@example.com',
                                    prefixIcon: Icon(Icons.mail_outline),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                TextFormField(
                                  key: const ValueKey('loginPasswordField'),
                                  validator: _passwordError,
                                  obscureText: _hidePassword,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
                                  onFieldSubmitted: (_) => _login(),
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      key: const ValueKey(
                                        'loginPasswordVisibility',
                                      ),
                                      tooltip: _hidePassword
                                          ? 'Show password'
                                          : 'Hide password',
                                      onPressed: () => setState(
                                        () => _hidePassword = !_hidePassword,
                                      ),
                                      icon: Icon(
                                        _hidePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => _message(
                                      'Password recovery is planned for a later stage.',
                                    ),
                                    child: const Text('Forgot password?'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                PrimaryButton(
                                  key: const ValueKey('loginSubmitButton'),
                                  label: 'Login',
                                  onPressed: _login,
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    const Text('New learner?'),
                                    TextButton(
                                      onPressed: () => _message(
                                        'Account creation is planned for a later stage.',
                                      ),
                                      child: const Text('Create account'),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Local UI prototype • No real authentication',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
