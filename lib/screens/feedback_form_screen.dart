import 'package:flutter/material.dart';

import '../models/program.dart';
import '../widgets/submission_button.dart';

class FeedbackFormArguments {
  const FeedbackFormArguments({required this.program});

  final Program program;
}

class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({
    required this.program,
    this.submissionDelay = const Duration(milliseconds: 900),
    super.key,
  });

  static const routeName = '/programs/feedback';

  final Program program;
  final Duration submissionDelay;

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  static const _experienceRatings = <String>[
    'Excellent',
    'Good',
    'Fair',
    'Needs improvement',
  ];

  final _formKey = GlobalKey<FormState>();
  final _ratingFieldKey = GlobalKey<FormFieldState<String>>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _commentsController = TextEditingController();

  String? _rating;
  bool _isSubmitting = false;
  bool _showSuccess = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _commentsController.dispose();
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

  String? _commentsError(String? value) {
    final comments = value?.trim() ?? '';
    if (comments.isEmpty) return 'Enter your feedback comments.';
    if (comments.length < 20) {
      return 'Enter at least 20 characters for your comments.';
    }
    return null;
  }

  void _showValidationFailure() {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Please correct the highlighted feedback fields.'),
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
    _ratingFieldKey.currentState?.didChange(null);
    _fullNameController.clear();
    _emailController.clear();
    _commentsController.clear();
    setState(() {
      _rating = null;
      _isSubmitting = false;
      _showSuccess = true;
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Feedback recorded temporarily in this local prototype. '
            'Nothing was sent to a server.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('feedbackFormScreen'),
      appBar: AppBar(
        leading: IconButton(
          key: const ValueKey('feedbackBackButton'),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Give feedback'),
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
                      'Share your experience',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Use this local form to test the planned feedback '
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
                                'Your feedback',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                key: const ValueKey('feedbackFullNameField'),
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
                                key: const ValueKey('feedbackEmailField'),
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
                                key: const ValueKey('feedbackRatingField'),
                                child: DropdownButtonFormField<String>(
                                  key: _ratingFieldKey,
                                  isExpanded: true,
                                  initialValue: _rating,
                                  items: [
                                    for (final rating in _experienceRatings)
                                      DropdownMenuItem(
                                        value: rating,
                                        child: Text(rating),
                                      ),
                                  ],
                                  onChanged: _isSubmitting
                                      ? null
                                      : (value) =>
                                            setState(() => _rating = value),
                                  validator: (value) => value == null
                                      ? 'Select an experience rating.'
                                      : null,
                                  decoration: const InputDecoration(
                                    labelText: 'Experience rating',
                                    prefixIcon: Icon(
                                      Icons.star_outline_rounded,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                key: const ValueKey('feedbackCommentsField'),
                                controller: _commentsController,
                                enabled: !_isSubmitting,
                                validator: _commentsError,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                minLines: 4,
                                maxLines: 7,
                                decoration: const InputDecoration(
                                  labelText: 'Comments',
                                  hintText:
                                      'Describe your experience and suggestions',
                                  alignLabelWithHint: true,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SubmissionButton(
                                key: const ValueKey('feedbackSubmitButton'),
                                progressKey: const ValueKey(
                                  'feedbackSubmitProgress',
                                ),
                                label: 'Submit feedback',
                                loadingLabel: 'Submitting feedback…',
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
                      const _FeedbackSuccess(),
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
              child: const Icon(Icons.rate_review_outlined),
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
              'This feedback form is a local prototype. It has no feedback '
              'service, server, database, or persistent storage.',
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

class _FeedbackSuccess extends StatelessWidget {
  const _FeedbackSuccess();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      liveRegion: true,
      child: Card(
        key: const ValueKey('feedbackSuccessPanel'),
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
                  'Prototype feedback complete. The form has been cleared. '
                  'No feedback was sent to a server, and no submitted data was '
                  'saved persistently.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
