import 'package:flutter/material.dart';

import '../models/program.dart';
import '../widgets/primary_button.dart';
import '../widgets/program_artwork.dart';
import '../widgets/section_header.dart';

class ProgramDetailsArguments {
  const ProgramDetailsArguments({required this.program});

  final Program program;
}

class ProgramDetailsScreen extends StatelessWidget {
  const ProgramDetailsScreen({required this.program, super.key});

  static const routeName = '/programs/details';

  final Program program;

  void _message(BuildContext context, String text) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('programDetailsScreen'),
      appBar: AppBar(
        leading: IconButton(
          key: const ValueKey('programDetailsBackButton'),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Program details'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 700 ? 32.0 : 16.0;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              20,
              horizontalPadding,
              40,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProgramHero(program: program),
                    const SizedBox(height: 24),
                    _ProgramMetadata(program: program),
                    const SizedBox(height: 28),
                    const SectionHeader(title: 'About this sample program'),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          program.fullDescription,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const SectionHeader(title: 'Sample eligibility'),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            for (
                              var index = 0;
                              index < program.eligibilityRequirements.length;
                              index++
                            ) ...[
                              _EligibilityRequirement(
                                text: program.eligibilityRequirements[index],
                              ),
                              if (index <
                                  program.eligibilityRequirements.length - 1)
                                const Divider(height: 28),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _PrototypeNotice(),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, box) {
                        final applyButton = PrimaryButton(
                          key: const ValueKey('programApplyButton'),
                          label: 'Apply or register',
                          onPressed: () => _message(
                            context,
                            'Application and registration are not connected '
                            'in this prototype.',
                          ),
                        );
                        final feedbackButton = SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            key: const ValueKey('programFeedbackButton'),
                            onPressed: () => _message(
                              context,
                              'The Feedback Screen is planned for a later '
                              'stage. No feedback was submitted.',
                            ),
                            icon: const Icon(Icons.rate_review_outlined),
                            label: const Text('Give feedback (prototype)'),
                          ),
                        );

                        if (box.maxWidth < 620) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              applyButton,
                              const SizedBox(height: 12),
                              feedbackButton,
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: applyButton),
                            const SizedBox(width: 12),
                            Expanded(child: feedbackButton),
                          ],
                        );
                      },
                    ),
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

class _ProgramHero extends StatelessWidget {
  const _ProgramHero({required this.program});

  final Program program;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, box) {
            final artwork = ProgramArtwork(
              visual: program.visual,
              height: box.maxWidth >= 720 ? 210 : 170,
              iconSize: 64,
            );
            final summary = _ProgramSummary(program: program);

            if (box.maxWidth < 720) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [artwork, const SizedBox(height: 20), summary],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 300, child: artwork),
                const SizedBox(width: 28),
                Expanded(child: summary),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProgramSummary extends StatelessWidget {
  const _ProgramSummary({required this.program});

  final Program program;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Chip(label: Text(program.category)),
        const SizedBox(height: 10),
        Text(program.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 10),
        Text(
          program.shortDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 14),
        const Text(
          'Local sample content • Not a live offering',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _ProgramMetadata extends StatelessWidget {
  const _ProgramMetadata({required this.program});

  final Program program;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        const gap = 12.0;
        final columns = box.maxWidth >= 700 ? 3 : 1;
        final width = (box.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            SizedBox(
              width: width,
              child: _MetadataItem(
                icon: Icons.event_outlined,
                label: 'Sample deadline',
                value: program.deadline,
              ),
            ),
            SizedBox(
              width: width,
              child: _MetadataItem(
                icon: Icons.schedule_outlined,
                label: 'Duration',
                value: program.duration,
              ),
            ),
            SizedBox(
              width: width,
              child: _MetadataItem(
                icon: Icons.laptop_chromebook_outlined,
                label: 'Delivery format',
                value: program.deliveryFormat,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MetadataItem extends StatelessWidget {
  const _MetadataItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colors.primaryContainer,
              foregroundColor: colors.primary,
              child: Icon(icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 2),
                  Text(value, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EligibilityRequirement extends StatelessWidget {
  const _EligibilityRequirement({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_outline_rounded, color: colors.secondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}

class _PrototypeNotice extends StatelessWidget {
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
              'This prototype does not connect to an application, registration, '
              'feedback, or enrollment service.',
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
