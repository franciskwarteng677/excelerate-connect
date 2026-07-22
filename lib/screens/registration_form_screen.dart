import 'package:flutter/material.dart';

import '../models/program.dart';
import '../widgets/submission_button.dart';

class RegistrationFormArguments {
  const RegistrationFormArguments({required this.program});

  final Program program;
}

class RegistrationFormScreen extends StatefulWidget {
  const RegistrationFormScreen({
    required this.program,
    this.submissionDelay = const Duration(milliseconds: 900),
    super.key,
  });

  static const routeName = '/programs/registration';

  final Program program;
  final Duration submissionDelay;

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  static const _educationLevels = <String>[
    'High school',
    'Diploma',
    'Undergraduate',
    'Postgraduate',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _educationFieldKey = GlobalKey<FormFieldState<String>>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _motivationController = TextEditingController();

  String? _educationLevel;
  bool _agreementAccepted = false;
  bool _isSubmitting = false;
  bool _showSuccess = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  String? _requiredName(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Enter your full name.';
    return null;
  }

  String? _emailError(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _motivationError(String? value) {
    final motivation = value?.trim() ?? '';
    if (motivation.isEmpty) return 'Tell us why you want to join.';
    if (motivation.length < 20) {
      return 'Enter at least 20 characters for your motivation.';
    }
    return null;
  }

  void _showValidationFailure() {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Please correct the highlighted registration fields.'),
        ),
      );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final formContext = _formKey.currentContext;
      if (formContext == null) return;
      Scrollable.ensureVisible(
        formContext,
        alignment: 0.05,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _showSuccess = false);
    if (!(_formKey.currentState?.validate() ?? false)) {
      _showValidationFailure();
      return;
    }

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(widget.submissionDelay);
    if (!mounted) return;

    _formKey.currentState?.reset();
    _educationFieldKey.currentState?.didChange(null);
    _fullNameController.clear();
    _emailController.clear();
    _motivationController.clear();
    setState(() {
      _educationLevel = null;
      _agreementAccepted = false;
      _isSubmitting = false;
      _showSuccess = true;
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Registration recorded temporarily in this local prototype. '
            'Nothing was sent to a server.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('registrationFormScreen'),
      appBar: AppBar(
        leading: IconButton(
          key: const ValueKey('registrationBackButton'),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Register for program'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 700 ? 32.0 : 16.0;
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              20,
              horizontalPadding,
              40,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Local registration prototype',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete the form to test the planned registration '
                      'experience for ${widget.program.title}.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    _ProgramContext(program: widget.program),
                    const SizedBox(height: 16),
                    const _LocalOnlyNotice(),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          autovalidateMode:
                              AutovalidateMode.onUserInteractionIfError,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Your details',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                key: const ValueKey(
                                  'registrationFullNameField',
                                ),
                                controller: _fullNameController,
                                enabled: !_isSubmitting,
                                validator: _requiredName,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.name],
                                decoration: const InputDecoration(
                                  labelText: 'Full name',
                                  hintText: 'Enter your full name',
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                key: const ValueKey('registrationEmailField'),
                                controller: _emailController,
                                enabled: !_isSubmitting,
                                validator: _emailError,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                autocorrect: false,
                                decoration: const InputDecoration(
                                  labelText: 'Email address',
                                  hintText: 'name@example.com',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: 18),
                              KeyedSubtree(
                                key: const ValueKey(
                                  'registrationEducationField',
                                ),
                                child: DropdownButtonFormField<String>(
                                  key: _educationFieldKey,
                                  isExpanded: true,
                                  initialValue: _educationLevel,
                                  items: [
                                    for (final level in _educationLevels)
                                      DropdownMenuItem(
                                        value: level,
                                        child: Text(level),
                                      ),
                                  ],
                                  onChanged: _isSubmitting
                                      ? null
                                      : (value) => setState(
                                          () => _educationLevel = value,
                                        ),
                                  validator: (value) => value == null
                                      ? 'Select your education level.'
                                      : null,
                                  decoration: const InputDecoration(
                                    labelText: 'Education level',
                                    prefixIcon: Icon(Icons.school_outlined),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                key: const ValueKey(
                                  'registrationMotivationField',
                                ),
                                controller: _motivationController,
                                enabled: !_isSubmitting,
                                validator: _motivationError,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                minLines: 4,
                                maxLines: 6,
                                decoration: const InputDecoration(
                                  labelText: 'Reason for joining',
                                  hintText:
                                      'Briefly explain what you hope to learn',
                                  alignLabelWithHint: true,
                                ),
                              ),
                              const SizedBox(height: 12),
                              FormField<bool>(
                                key: const ValueKey(
                                  'registrationAgreementField',
                                ),
                                initialValue: false,
                                validator: (value) => value == true
                                    ? null
                                    : 'Confirm that you understand this is a '
                                          'local prototype.',
                                builder: (field) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CheckboxListTile(
                                        key: const ValueKey(
                                          'registrationAgreementCheckbox',
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: _agreementAccepted,
                                        onChanged: _isSubmitting
                                            ? null
                                            : (value) {
                                                final accepted = value ?? false;
                                                setState(
                                                  () => _agreementAccepted =
                                                      accepted,
                                                );
                                                field.didChange(accepted);
                                              },
                                        title: const Text(
                                          'I understand that this is a local '
                                          'prototype and no real registration '
                                          'will be sent.',
                                        ),
                                      ),
                                      if (field.hasError)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 12,
                                            top: 2,
                                          ),
                                          child: Text(
                                            field.errorText!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.error,
                                                ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              SubmissionButton(
                                key: const ValueKey('registrationSubmitButton'),
                                progressKey: const ValueKey(
                                  'registrationSubmitProgress',
                                ),
                                label: 'Submit registration',
                                loadingLabel: 'Submitting registration…',
                                isSubmitting: _isSubmitting,
                                onPressed: _submit,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_showSuccess) ...[
                      const SizedBox(height: 20),
                      const _RegistrationSuccess(),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProgramContext extends StatelessWidget {
  const _ProgramContext({required this.program});

  final Program program;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colors.primaryContainer,
              foregroundColor: colors.primary,
              child: const Icon(Icons.auto_stories_outlined),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.category,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: colors.primary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    program.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocalOnlyNotice extends StatelessWidget {
  const _LocalOnlyNotice();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: colors.onSecondaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This form is a local prototype. It has no registration service, '
              'server, database, or persistent storage.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrationSuccess extends StatelessWidget {
  const _RegistrationSuccess();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      liveRegion: true,
      child: Card(
        key: const ValueKey('registrationSuccessPanel'),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: colors.secondary,
                size: 30,
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Prototype registration complete. The form has been cleared. '
                  'No registration was sent to a server, and no submitted data '
                  'was saved persistently.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
