# Excelerate Connect

Excelerate Connect is a planned Flutter mobile application intended to help Excelerate learners discover programs and events, view program information and announcements, track learning progress, manage their profiles, and submit feedback. Future administrator capabilities are planned to support the management of programs, learner participation, announcements, and feedback.

> **Project status:** Week 2 development in progress. Stage 1 implements the application foundation plus Login and Home UI prototypes; the remaining application features are still planned and have not yet been implemented.

## Problem Being Addressed

Learners need a clear, convenient way to find Excelerate learning opportunities, keep up with relevant events and announcements, follow their participation and progress, and provide feedback. Administrators also need an organized way to manage program information and learner participation. Excelerate Connect is planned as a centralized mobile experience that will address these needs in later development stages.

## Target Users

- **Learners:** Excelerate participants who want to discover programs, review details and announcements, monitor their learning progress, maintain a profile, and submit feedback.
- **Administrators:** Authorized users who will manage programs, announcements, learner participation, and feedback in later development stages.

## Planned Features

- Login and learner profile
- Home dashboard
- Program listing
- Program details
- Events and announcements
- Feedback form
- Learning progress tracking
- Notifications
- Administrator program and participation management

## Planned Navigation Flow

```text
Login → Home → Program Listing → Program Details → Feedback Form
Home → Events and Announcements
Home → Profile
Program Details → Program Listing
Profile → Home
```

This flow is a Week 1 planning artifact and may be refined during design and implementation.

## Technology Stack

- **Flutter:** Planned cross-platform application framework
- **Dart:** Planned application programming language
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
│   ├── screens/
│   │   ├── home_screen.dart
│   │   └── login_screen.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── widgets/
│   │   ├── primary_button.dart
│   │   └── section_header.dart
│   └── main.dart         # Application entry point and named routes
├── test/                 # Flutter-generated test files
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

From the project root, confirm that Chrome is detected and start the current Stage 1 UI prototype:

```bash
flutter devices
flutter run -d chrome
```

The current build starts on the Login UI prototype and navigates to the Home UI prototype after valid local form input. It does not provide real authentication, live data, or backend integration.

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
- [ ] Week 2 four-screen prototype completed
- [ ] Program Listing and Program Details implemented
- [ ] Remaining planned Excelerate Connect screens implemented
- [ ] Additional functionality integrated
- [ ] Testing and final refinement completed

## Author

**Francis Kwarteng**

This project is being developed as part of the **Mobile App Development with Flutter Virtual Internship**.
