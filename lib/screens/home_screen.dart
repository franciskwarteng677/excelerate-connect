import 'package:flutter/material.dart';

import '../models/program.dart';
import '../services/program_repository.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/async_state_card.dart';
import '../widgets/program_card.dart';
import '../widgets/section_header.dart';
import 'program_details_screen.dart';
import 'program_listing_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.programRepository, super.key});

  static const routeName = '/home';

  final ProgramRepository programRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Program>? _programs;
  Object? _programLoadError;
  bool _programsLoading = true;
  int _loadGeneration = 0;

  @override
  void initState() {
    super.initState();
    _loadPrograms();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.programRepository != widget.programRepository) {
      _loadPrograms();
    }
  }

  Future<void> _loadPrograms() async {
    final generation = ++_loadGeneration;
    setState(() {
      _programsLoading = true;
      _programLoadError = null;
    });

    try {
      final programs = await widget.programRepository.loadPrograms();
      if (!mounted || generation != _loadGeneration) return;
      setState(() {
        _programs = programs;
        _programsLoading = false;
      });
    } catch (error) {
      if (!mounted || generation != _loadGeneration) return;
      setState(() {
        _programs = null;
        _programLoadError = error;
        _programsLoading = false;
      });
    }
  }

  void _message(BuildContext context, String text) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _openPrograms(BuildContext context) {
    Navigator.of(context).pushNamed(ProgramListingScreen.routeName);
  }

  void _openDetails(BuildContext context, Program program) {
    Navigator.of(context).pushNamed(
      ProgramDetailsScreen.routeName,
      arguments: ProgramDetailsArguments(program: program),
    );
  }

  void _selectDestination(BuildContext context, int index) {
    switch (index) {
      case 0:
        return;
      case 1:
        _openPrograms(context);
        return;
      case 2:
        _message(context, 'Learning Progress is planned for a later stage.');
        return;
      case 3:
        _message(context, 'The learner Profile is planned for a later stage.');
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('homeScreen'),
      appBar: AppBar(
        toolbarHeight: 76,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Learner',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Discover what is planned for you',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.filledTonal(
              key: const ValueKey('notificationAction'),
              tooltip: 'Notifications',
              onPressed: () => _message(
                context,
                'Notifications are planned for a later stage.',
              ),
              icon: const Icon(Icons.notifications_none_rounded),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final side = constraints.maxWidth >= 700 ? 32.0 : 16.0;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(side, 20, side, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _WelcomeBanner(),
                    const SizedBox(height: 24),
                    _ProgramSearchAction(onTap: () => _openPrograms(context)),
                    const SizedBox(height: 28),
                    SectionHeader(
                      title: 'Featured Programs',
                      actionLabel: 'View all',
                      onAction: () => _openPrograms(context),
                    ),
                    const SizedBox(height: 12),
                    if (_programsLoading)
                      const AsyncLoadingState(
                        key: ValueKey('homeProgramsLoadingState'),
                        message: 'Loading featured programs…',
                        compact: true,
                      )
                    else if (_programLoadError != null)
                      AsyncErrorCard(
                        key: const ValueKey('homeProgramsErrorState'),
                        retryButtonKey: const ValueKey(
                          'homeProgramsRetryButton',
                        ),
                        title: 'Featured programs unavailable',
                        message:
                            'The local program file could not be loaded. '
                            'You can retry without leaving Home.',
                        onRetry: _loadPrograms,
                        compact: true,
                      )
                    else if (_programs!.isEmpty)
                      const AsyncEmptyCard(
                        key: ValueKey('homeProgramsEmptyState'),
                        title: 'No featured programs',
                        message:
                            'The local program file currently contains no '
                            'programs to feature.',
                      )
                    else
                      LayoutBuilder(
                        builder: (context, box) {
                          const gap = 16.0;
                          final width = box.maxWidth >= 720
                              ? (box.maxWidth - gap) / 2
                              : box.maxWidth;
                          return Wrap(
                            spacing: gap,
                            runSpacing: gap,
                            children: [
                              for (final program in _programs!.take(2))
                                SizedBox(
                                  width: width,
                                  child: ProgramCard(
                                    program: program,
                                    onViewDetails: () =>
                                        _openDetails(context, program),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    const SizedBox(height: 32),
                    const SectionHeader(title: 'Upcoming Events'),
                    const SizedBox(height: 12),
                    const _EventsCard(),
                    const SizedBox(height: 32),
                    const SectionHeader(title: 'Recent Announcement'),
                    const SizedBox(height: 12),
                    const _AnnouncementCard(),
                    const SizedBox(height: 32),
                    const SectionHeader(title: 'Quick Links'),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, box) {
                        const gap = 12.0;
                        final count = box.maxWidth >= 760
                            ? 3
                            : box.maxWidth >= 500
                            ? 2
                            : 1;
                        final width =
                            (box.maxWidth - gap * (count - 1)) / count;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            SizedBox(
                              width: width,
                              child: _QuickLink(
                                key: const ValueKey('quickPrograms'),
                                icon: Icons.view_list_outlined,
                                label: 'Programs',
                                detail: 'Browse learning opportunities',
                                onTap: () => _openPrograms(context),
                              ),
                            ),
                            SizedBox(
                              width: width,
                              child: _QuickLink(
                                icon: Icons.trending_up_rounded,
                                label: 'Progress',
                                detail: 'Review your learning journey',
                                onTap: () => _selectDestination(context, 2),
                              ),
                            ),
                            SizedBox(
                              width: width,
                              child: _QuickLink(
                                icon: Icons.person_outline_rounded,
                                label: 'Profile',
                                detail: 'Manage learner information',
                                onTap: () => _selectDestination(context, 3),
                              ),
                            ),
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
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) => _selectDestination(context, index),
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: colors.onPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore sample learning opportunities and upcoming activities in this local UI prototype.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: colors.onPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: colors.onPrimary.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.auto_stories_outlined,
              color: colors.onPrimary,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramSearchAction extends StatelessWidget {
  const _ProgramSearchAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: 'Search sample programs; opens Programs',
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: colors.outlineVariant),
          ),
          child: InkWell(
            key: const ValueKey('homeSearchField'),
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 58),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: colors.onSurfaceVariant),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Search sample programs',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: colors.onSurfaceVariant,
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

class _EventsCard extends StatelessWidget {
  const _EventsCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        children: [
          _EventTile(
            date: 'AUG\n12',
            title: 'Virtual Learning Session',
            detail: 'Sample event • 10:00 AM • Online',
          ),
          Divider(indent: 82, endIndent: 18),
          _EventTile(
            date: 'AUG\n18',
            title: 'Community Networking Hour',
            detail: 'Sample event • 2:00 PM • Online',
          ),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({
    required this.date,
    required this.title,
    required this.detail,
  });

  final String date;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      leading: Container(
        width: 48,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          date,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(title),
      subtitle: Text(detail),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: colors.secondaryContainer,
              foregroundColor: colors.onSecondaryContainer,
              child: const Icon(Icons.campaign_outlined),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to the local learner prototype',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Programs are loaded from bundled sample data. Events and '
                    'announcements remain static, and live services are not '
                    'connected.',
                    style: Theme.of(context).textTheme.bodyMedium,
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

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.icon,
    required this.label,
    required this.detail,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colors.primaryContainer,
                foregroundColor: colors.primary,
                child: Icon(icon),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.titleMedium),
                    Text(detail, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
