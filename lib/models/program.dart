/// Visual categories used by the prototype without relying on image assets.
enum ProgramVisual {
  mobileDevelopment,
  careerGrowth,
  dataLearning,
  projectLeadership,
}

/// Immutable information displayed by the local program prototype.
class Program {
  const Program({
    required this.id,
    required this.title,
    required this.category,
    required this.shortDescription,
    required this.fullDescription,
    required this.deadline,
    required this.duration,
    required this.deliveryFormat,
    required this.eligibilityRequirements,
    required this.visual,
  });

  final String id;
  final String title;
  final String category;
  final String shortDescription;
  final String fullDescription;
  final String deadline;
  final String duration;
  final String deliveryFormat;
  final List<String> eligibilityRequirements;
  final ProgramVisual visual;
}
