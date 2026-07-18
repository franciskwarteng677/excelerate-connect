import 'package:flutter/material.dart';

import '../models/program.dart';
import 'program_artwork.dart';

class ProgramCard extends StatelessWidget {
  const ProgramCard({
    required this.program,
    required this.onViewDetails,
    super.key,
  });

  final Program program;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        key: ValueKey('programCard-${program.id}'),
        onTap: onViewDetails,
        canRequestFocus: false,
        excludeFromSemantics: true,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProgramArtwork(visual: program.visual),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(label: Text(program.category)),
              ),
              const SizedBox(height: 8),
              Text(
                program.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                program.shortDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.event_outlined, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Sample deadline: ${program.deadline}')),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                key: ValueKey('programViewDetails-${program.id}'),
                onPressed: onViewDetails,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('View details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
