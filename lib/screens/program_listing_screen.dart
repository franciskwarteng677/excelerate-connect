import 'package:flutter/material.dart';

import '../data/sample_programs.dart';
import '../models/program.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/program_card.dart';
import 'program_details_screen.dart';

class ProgramListingScreen extends StatefulWidget {
  const ProgramListingScreen({super.key});

  static const routeName = '/programs';

  @override
  State<ProgramListingScreen> createState() => _ProgramListingScreenState();
}

class _ProgramListingScreenState extends State<ProgramListingScreen> {
  static const _allCategories = 'All';

  final _searchController = TextEditingController();
  late final List<String> _categories;
  String _query = '';
  String _selectedCategory = _allCategories;

  @override
  void initState() {
    super.initState();
    _categories = [
      _allCategories,
      ...samplePrograms.map((program) => program.category).toSet(),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Program> get _visiblePrograms {
    final query = _query.trim().toLowerCase();
    return samplePrograms
        .where((program) {
          final matchesCategory =
              _selectedCategory == _allCategories ||
              program.category == _selectedCategory;
          final searchableText = [
            program.title,
            program.category,
            program.shortDescription,
            program.fullDescription,
          ].join(' ').toLowerCase();
          return matchesCategory &&
              (query.isEmpty || searchableText.contains(query));
        })
        .toList(growable: false);
  }

  bool get _hasActiveFilters =>
      _query.isNotEmpty || _selectedCategory != _allCategories;

  void _setQuery(String value) => setState(() => _query = value);

  void _resetFilters() {
    FocusManager.instance.primaryFocus?.unfocus();
    _searchController.clear();
    setState(() {
      _query = '';
      _selectedCategory = _allCategories;
    });
  }

  void _openDetails(Program program) {
    Navigator.of(context).pushNamed(
      ProgramDetailsScreen.routeName,
      arguments: ProgramDetailsArguments(program: program),
    );
  }

  void _message(String text) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _selectDestination(int index) {
    switch (index) {
      case 0:
        final navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.pop();
        } else {
          navigator.pushReplacementNamed('/home');
        }
        return;
      case 1:
        return;
      case 2:
        _message('Learning Progress is planned for a later stage.');
        return;
      case 3:
        _message('The learner Profile is planned for a later stage.');
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final programs = _visiblePrograms;
    return Scaffold(
      key: const ValueKey('programListingScreen'),
      appBar: AppBar(title: const Text('Programs')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 700 ? 32.0 : 16.0;
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              20,
              horizontalPadding,
              32,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Discover sample programs',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Search and filter the local prototype catalogue. '
                      'These entries are not live offerings.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      key: const ValueKey('programSearchField'),
                      controller: _searchController,
                      onChanged: _setQuery,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        labelText: 'Search programs',
                        hintText: 'Title, category, or description',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                key: const ValueKey('programSearchClearButton'),
                                tooltip: 'Clear search',
                                onPressed: () {
                                  _searchController.clear();
                                  _setQuery('');
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Filter by category',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        TextButton.icon(
                          key: const ValueKey('programResetFiltersButton'),
                          onPressed: _hasActiveFilters ? _resetFilters : null,
                          icon: const Icon(Icons.restart_alt_rounded),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final category in _categories)
                          ChoiceChip(
                            key: ValueKey(
                              'programCategoryFilter-${_slug(category)}',
                            ),
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (_) {
                              setState(() => _selectedCategory = category);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        programs.length == 1
                            ? '1 sample program'
                            : '${programs.length} sample programs',
                        key: const ValueKey('programResultCount'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (programs.isEmpty)
                      _EmptyPrograms(onReset: _resetFilters)
                    else
                      LayoutBuilder(
                        builder: (context, box) {
                          const gap = 16.0;
                          final columns = box.maxWidth >= 1040
                              ? 3
                              : box.maxWidth >= 680
                              ? 2
                              : 1;
                          final cardWidth =
                              (box.maxWidth - gap * (columns - 1)) / columns;
                          return Wrap(
                            spacing: gap,
                            runSpacing: gap,
                            children: [
                              for (final program in programs)
                                SizedBox(
                                  width: cardWidth,
                                  child: ProgramCard(
                                    program: program,
                                    onViewDetails: () => _openDetails(program),
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
        selectedIndex: 1,
        onDestinationSelected: _selectDestination,
      ),
    );
  }
}

class _EmptyPrograms extends StatelessWidget {
  const _EmptyPrograms({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      key: const ValueKey('programEmptyState'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: colors.primaryContainer,
              foregroundColor: colors.primary,
              child: const Icon(Icons.search_off_rounded, size: 30),
            ),
            const SizedBox(height: 18),
            Text(
              'No programs found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try another search or reset the filters to view all sample programs.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              key: const ValueKey('programEmptyResetButton'),
              onPressed: onReset,
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Show all programs'),
            ),
          ],
        ),
      ),
    );
  }
}

String _slug(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp('[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}
