# Excelerate Connect

Excelerate Connect is a planned Flutter mobile application intended to help Excelerate learners discover programs and events, view program information and announcements, track learning progress, manage their profiles, and submit feedback. Future administrator capabilities are planned to support the management of programs, learner participation, announcements, and feedback.

> **Project status:** Week 2 development in progress. Stage 1 implements the application foundation plus Login and Home UI prototypes. Stage 2 adds Program Listing and Program Details UI prototypes using local sample data. The remaining application features are still planned and have not yet been implemented.

## Problem Being Addressed

Learners need a clear, convenient way to find Excelerate learning opportunities, keep up with relevant events and announcements, follow their participation and progress, and provide feedback. Administrators also need an organized way to manage program information and learner participation. Excelerate Connect is planned as a centralized mobile experience that will address these needs in later development stages.

## Target Users

- **Learners:** Excelerate participants who want to discover programs, review details and announcements, monitor their learning progress, maintain a profile, and submit feedback.
- **Administrators:** Authorized users who will manage programs, announcements, learner participation, and feedback in later development stages.

## Feature Status

The current four-screen UI prototype includes:

- A Login Screen with local form validation and no real authentication
- A Home Screen with static sample programs, events, and announcement content
- A Program Listing Screen with local search, category filters, reset controls, and an empty state
- A Program Details Screen that displays the selected local sample program
- Honest prototype messages for registration and feedback actions that are not connected

The following capabilities remain planned:

- Real login, account creation, password recovery, and learner profile management
- Live program, event, and announcement data
- Feedback form and submission
- Learning progress tracking
- Notifications
- Administrator program and participation management

## Week 2 Working UI Prototype

Week 2 establishes a responsive four-screen Flutter prototype for the learner program-discovery journey. The implemented interface includes:

- **Login Screen:** Local email and password validation, password visibility control, and replacement navigation to Home
- **Home Screen:** Greeting, welcome content, static featured programs, sample events, a static announcement, quick links, and bottom navigation
- **Program Listing Screen:** In-memory search, category filters, reset and empty states, and responsive local program cards
- **Program Details Screen:** Selected-program descriptions, metadata, eligibility information, and transparent prototype action messages

The working navigation connects Login → Home → Program Listing → Program Details. Learners can also reach Programs from Home search, the Programs quick link, the View all action, the bottom navigation, and featured-program actions. Search matches local titles, categories, and descriptions, while category filters can refine or restore the sample catalogue.

See the [complete Week 2 deliverable](docs/WEEK2_DELIVERABLE.md) for the implementation summary, validation record, screenshot sequence, and current scope.

### Week 2 Screenshot Gallery

| Login | Home |
| --- | --- |
| ![Week 2 Login Screen](docs/screenshots/week2/01-login-screen.png) | ![Week 2 Home Screen](docs/screenshots/week2/02-home-screen-top.png) |
| Program Listing | Program Details |
| ![Week 2 Program Listing Screen](docs/screenshots/week2/05-program-listing-search-filters.png) | ![Week 2 Program Details Screen](docs/screenshots/week2/08-program-details-top.png) |

### Current Prototype Limitations

The interface does not provide real authentication, registration, password recovery, enrollment, application submission, feedback submission, live program data, APIs, databases, or backend services. Program, event, and announcement content is local sample material. Progress, Profile, notification, feedback, and administrator workflows remain planned, and no unprovided logo or official brand claim is used.

## Navigation Flow

The implemented Week 2 prototype navigation is:

    Login (local validation only) → Home → Program Listing → Program Details
    Home featured program → Program Details
    Program Details → previous screen using Back

Home connects to Program Listing through its Programs bottom-navigation item, Programs quick link, search placeholder, and View all action. Selecting a sample program card or its View details action opens that program's details.

The broader Week 1 planned flow remains:

```text
Login → Home → Program Listing → Program Details → Feedback Form
Home → Events and Announcements
Home → Profile
Program Details → Program Listing
Profile → Home
```

The Feedback Form, Events and Announcements destination, Profile, and related return paths remain planning artifacts and may be refined during later development.

## Technology Stack

- **Flutter:** Cross-platform application framework used by the prototype
- **Dart:** Application programming language used by the prototype
- **Git:** Version-control tool
- **GitHub:** Planned repository hosting and collaboration platform

No database or backend has been selected. Backend technology will be evaluated and selected in a later phase if the application requires it.

## Current Repository Structure

```text
excelerate_connect/
├── android/              # Flutter-generated Android platform files
├── docs/
│   ├── wireframes/       # Week 1 low-fidelity SVG wireframes
│   ├── APP_PROPOSAL.md   # Week 1 application proposal
│   └── WIREFRAMES.md     # Wireframe descriptions and navigation flow
├── lib/
│   ├── data/
│   │   └── sample_programs.dart
│   ├── models/
│   │   └── program.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── login_screen.dart
│   │   ├── program_details_screen.dart
│   │   └── program_listing_screen.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── widgets/
│   │   ├── app_bottom_navigation_bar.dart
│   │   ├── primary_button.dart
│   │   ├── program_artwork.dart
│   │   ├── program_card.dart
│   │   └── section_header.dart
│   └── main.dart         # Application entry point and named routes
├── test/                 # Login, Home, Program Listing, and Details widget tests
├── web/                  # Flutter-generated web platform files
├── analysis_options.yaml # Dart static-analysis configuration
├── pubspec.yaml          # Project metadata and dependencies
└── README.md             # Project overview and setup guide
```

Generated folders such as `build/` and `.dart_tool/` may also appear locally after Flutter commands are run.

## Installation and Setup

### Prerequisites

- Flutter SDK installed and available on the command line
- Dart SDK (included with Flutter)
- Git
- Google Chrome for web testing
- A code editor such as Visual Studio Code or Android Studio

### Steps

1. Clone the repository when a remote repository is available, or open the existing project folder.
2. Move into the project directory:

   ```bash
   cd excelerate_connect
   ```

3. Confirm the Flutter installation:

   ```bash
   flutter doctor
   ```

4. Restore the dependencies already declared by the Flutter project:

   ```bash
   flutter pub get
   ```

## Run the Flutter Project in Chrome

From the project root, confirm that Chrome is detected and start the current Week 2 UI prototype:

```bash
flutter devices
flutter run -d chrome
```

The current build starts on the Login UI prototype. Any reasonably formatted email and any nonempty password navigate locally to Home. From Home, use Programs or a featured-program action to test Program Listing, local search and category filtering, and Program Details.

The prototype does not provide real authentication, live data, application submission, feedback submission, or backend integration.

## Local Sample Data and Prototype Limitations

Stage 2 uses four static sample program records declared in [sample_programs.dart](lib/data/sample_programs.dart). They exist only to demonstrate responsive cards, local search, category filtering, selected-program navigation, and details presentation. Their names, descriptions, eligibility examples, durations, delivery formats, and deadlines must not be interpreted as live or currently available Excelerate offerings.

All program search and filtering runs in memory. No API, database, authentication provider, application system, feedback service, analytics service, or backend is connected. The Apply or register and Give feedback actions display explanatory prototype messages and do not submit or store information.

## Wireframes

The completed Week 1 low-fidelity planning wireframes are documented in the [wireframe guide](docs/WIREFRAMES.md):

- [Login](docs/wireframes/01-login.svg)
- [Home dashboard](docs/wireframes/02-home.svg)
- [Program listing](docs/wireframes/03-program-listing.svg)
- [Program details](docs/wireframes/04-program-details.svg)
- [Feedback form](docs/wireframes/05-feedback-form.svg)
- [Profile](docs/wireframes/06-profile.svg)

The [navigation flow diagram](docs/wireframes/navigation-flow.svg) records the proposed relationships among the planned screens. These low-fidelity artifacts use grayscale placeholders and are planning documentation, not implemented application screens or final visual designs.

## Development Roadmap

- **Week 1:** Environment setup, application proposal, wireframes, and GitHub preparation
- **Week 2:** Staged UI prototype development—foundation, Login, Home, Program Listing, and Program Details
- **Week 3:** Planned additional functionality and integration
- **Week 4:** Planned testing, refinement, and final submission

The roadmap is a plan and may be adjusted as requirements are refined.

## Current Progress Checklist

- [x] Flutter and Dart environment configured
- [x] Initial Flutter project created
- [x] Default sample app successfully run in Chrome
- [x] Application requirements studied
- [x] Week 1 application proposal prepared
- [x] Low-fidelity wireframes completed and added
- [x] Stage 1 application foundation and global theme implemented
- [x] Stage 1 Login UI prototype with local validation implemented
- [x] Stage 1 Home UI prototype with static sample content implemented
- [x] Stage 2 Program Listing UI with local search and filters implemented
- [x] Stage 2 Program Details UI with selected local data implemented
- [x] Week 2 four-screen UI prototype completed
- [x] Stage 2 widget tests added for program discovery and navigation
- [ ] Remaining planned Excelerate Connect screens implemented
- [ ] Additional functionality integrated
- [ ] Testing and final refinement completed

## Author

**Francis Kwarteng**

This project is being developed as part of the **Mobile App Development with Flutter Virtual Internship**.
