import 'package:flutter/material.dart';

import '../models/program.dart';

class ProgramArtwork extends StatelessWidget {
  const ProgramArtwork({
    required this.visual,
    this.height = 112,
    this.iconSize = 44,
    super.key,
  });

  final ProgramVisual visual;
  final double height;
  final double iconSize;

  IconData get _icon => switch (visual) {
    ProgramVisual.mobileDevelopment => Icons.phone_android_outlined,
    ProgramVisual.careerGrowth => Icons.work_outline_rounded,
    ProgramVisual.dataLearning => Icons.insights_outlined,
    ProgramVisual.projectLeadership => Icons.groups_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(_icon, color: colors.primary, size: iconSize),
    );
  }
}
