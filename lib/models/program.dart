/// Visual categories used by the prototype without relying on image assets.
enum ProgramVisual {
  mobileDevelopment,
  careerGrowth,
  dataLearning,
  projectLeadership,
}

/// Stable JSON identifier for a [ProgramVisual].
extension ProgramVisualIdentifier on ProgramVisual {
  String get identifier => switch (this) {
    ProgramVisual.mobileDevelopment => 'mobileDevelopment',
    ProgramVisual.careerGrowth => 'careerGrowth',
    ProgramVisual.dataLearning => 'dataLearning',
    ProgramVisual.projectLeadership => 'projectLeadership',
  };
}

/// Converts a safe local JSON identifier into a [ProgramVisual].
ProgramVisual programVisualFromIdentifier(String identifier) {
  return switch (identifier) {
    'mobileDevelopment' => ProgramVisual.mobileDevelopment,
    'careerGrowth' => ProgramVisual.careerGrowth,
    'dataLearning' => ProgramVisual.dataLearning,
    'projectLeadership' => ProgramVisual.projectLeadership,
    _ => throw FormatException(
      'Unknown program visual "$identifier". Expected one of: '
      'mobileDevelopment, careerGrowth, dataLearning, projectLeadership.',
    ),
  };
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

  /// Creates a program from one entry in the local JSON catalogue.
  ///
  /// Every text field must be a non-empty string. Eligibility must be a
  /// non-empty list containing only non-empty strings, and the visual
  /// identifier must map to one of the supported local presentation styles.
  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: _requiredString(json, 'id'),
      title: _requiredString(json, 'title'),
      category: _requiredString(json, 'category'),
      shortDescription: _requiredString(json, 'shortDescription'),
      fullDescription: _requiredString(json, 'fullDescription'),
      deadline: _requiredString(json, 'deadline'),
      duration: _requiredString(json, 'duration'),
      deliveryFormat: _requiredString(json, 'deliveryFormat'),
      eligibilityRequirements: _requiredEligibility(json),
      visual: programVisualFromIdentifier(_requiredString(json, 'visual')),
    );
  }

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

String _requiredString(Map<String, dynamic> json, String fieldName) {
  final value = json[fieldName];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException(
      'Program field "$fieldName" must be a non-empty string.',
    );
  }
  return value.trim();
}

List<String> _requiredEligibility(Map<String, dynamic> json) {
  const fieldName = 'eligibilityRequirements';
  final value = json[fieldName];
  if (value is! List || value.isEmpty) {
    throw const FormatException(
      'Program field "eligibilityRequirements" must be a non-empty list '
      'of non-empty strings.',
    );
  }

  final requirements = <String>[];
  for (var index = 0; index < value.length; index++) {
    final requirement = value[index];
    if (requirement is! String || requirement.trim().isEmpty) {
      throw FormatException(
        'Program field "$fieldName" contains an invalid value at index '
        '$index; every requirement must be a non-empty string.',
      );
    }
    requirements.add(requirement.trim());
  }
  return List<String>.unmodifiable(requirements);
}
