import '../models/program.dart';

/// Local sample content for the Stage 2 UI prototype.
///
/// These entries do not represent live programs, availability, or deadlines.
const samplePrograms = <Program>[
  Program(
    id: 'flutter-foundations',
    title: 'Flutter Foundations',
    category: 'Mobile Development',
    shortDescription:
        'Explore core Flutter concepts while planning a simple mobile experience.',
    fullDescription:
        'This sample learning opportunity introduces Flutter widgets, layouts, '
        'navigation, and basic interface development through guided practice. '
        'Its content is included only to demonstrate the Stage 2 program '
        'discovery experience.',
    deadline: '30 August',
    duration: '6 weeks',
    deliveryFormat: 'Online',
    eligibilityRequirements: [
      'Interest in learning mobile application development.',
      'Access to a computer that can run the Flutter development tools.',
      'Availability to complete guided sample learning activities.',
    ],
    visual: ProgramVisual.mobileDevelopment,
  ),
  Program(
    id: 'career-readiness-sprint',
    title: 'Career Readiness Sprint',
    category: 'Professional Skills',
    shortDescription:
        'Practice communication, personal branding, and interview preparation.',
    fullDescription:
        'This sample sprint presents a structured introduction to career '
        'planning, professional communication, personal branding, and interview '
        'preparation. It is static prototype content and is not connected to a '
        'live enrollment process.',
    deadline: '15 September',
    duration: '4 weeks',
    deliveryFormat: 'Online workshops',
    eligibilityRequirements: [
      'Interest in strengthening career-readiness skills.',
      'Availability to participate in sample workshop activities.',
      'Willingness to reflect on professional development goals.',
    ],
    visual: ProgramVisual.careerGrowth,
  ),
  Program(
    id: 'data-insights-starter',
    title: 'Data Insights Starter',
    category: 'Data and Analytics',
    shortDescription:
        'Build confidence with data questions, summaries, and visual insights.',
    fullDescription:
        'This sample program outlines an introductory journey through data '
        'literacy, simple analysis, and clear visual communication. It exists '
        'only as local demonstration data for search, filtering, and program '
        'details.',
    deadline: '28 September',
    duration: '5 weeks',
    deliveryFormat: 'Self-paced online',
    eligibilityRequirements: [
      'Curiosity about using data to answer practical questions.',
      'Basic confidence using a computer and spreadsheet-style tools.',
      'No prior analytics experience is required for this sample scenario.',
    ],
    visual: ProgramVisual.dataLearning,
  ),
  Program(
    id: 'project-leadership-lab',
    title: 'Project Leadership Lab',
    category: 'Leadership',
    shortDescription:
        'Explore planning, collaboration, and responsible team leadership.',
    fullDescription:
        'This sample lab introduces practical project planning, team '
        'communication, and reflective leadership activities. The listing is '
        'prototype content and does not indicate a currently available program.',
    deadline: '10 October',
    duration: '6 weeks',
    deliveryFormat: 'Blended online sessions',
    eligibilityRequirements: [
      'Interest in project coordination or team leadership.',
      'Availability for collaborative sample exercises.',
      'Commitment to respectful and inclusive teamwork.',
    ],
    visual: ProgramVisual.projectLeadership,
  ),
];
