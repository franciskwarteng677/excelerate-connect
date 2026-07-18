import 'package:flutter/material.dart';

import '../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  static const _programs = [
    _ProgramPreview(
      title: 'Flutter Foundations',
      category: 'Mobile Development',
      deadline: 'Sample deadline: 30 August',
      icon: Icons.phone_android_outlined,
    ),
    _ProgramPreview(
      title: 'Career Readiness Sprint',
      category: 'Professional Skills',
      deadline: 'Sample deadline: 15 September',
      icon: Icons.work_outline,
    ),
  ];

  void _message(BuildContext context, String text) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _selectDestination(BuildContext context, int index) {
    const messages = {
      1: 'Program Listing will be completed in the next stage.',
      2: 'Learning Progress is planned for a later stage.',
      3: 'The learner Profile is planned for a later stage.',
    };
    if (messages[index] case final message?) _message(context, message);
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
                    TextField(
                      key: const ValueKey('homeSearchField'),
                      readOnly: true,
                      onTap: () => _message(
                        context,
                        'Program and event search is planned for a later stage.',
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search programs and events',
                        prefixIcon: Icon(Icons.search_rounded),
                        suffixIcon: Icon(Icons.tune_rounded),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SectionHeader(
                      title: 'Featured Programs',
                      actionLabel: 'View all',
                      onAction: () => _selectDestination(context, 1),
                    ),
                    const SizedBox(height: 12),
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
                            for (final program in _programs)
                              SizedBox(
                                width: width,
                                child: _ProgramCard(
                                  program: program,
                                  onDetails: () => _message(
                                    context,
                                    'Program details are planned for a later stage.',
                                  ),
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
                                onTap: () => _selectDestination(context, 1),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) => _selectDestination(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            key: ValueKey('bottomProgramsDestination'),
            icon: Icon(Icons.view_list_outlined),
            label: 'Programs',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
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

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.program, required this.onDetails});

  final _ProgramPreview program;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 112,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(program.icon, color: colors.primary, size: 44),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(label: Text(program.category)),
            ),
            const SizedBox(height: 8),
            Text(program.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(program.deadline),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onDetails,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('View details'),
            ),
          ],
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
      trailing: const Icon(Icons.chevron_right_rounded),
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
                    'Welcome to the Stage 1 prototype',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'This is sample content for the planned learner dashboard. Live announcements are not connected yet.',
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

class _ProgramPreview {
  const _ProgramPreview({
    required this.title,
    required this.category,
    required this.deadline,
    required this.icon,
  });

  final String title;
  final String category;
  final String deadline;
  final IconData icon;
}
