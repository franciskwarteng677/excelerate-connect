import 'dart:convert';

import 'package:excelerate_connect/models/program.dart';
import 'package:excelerate_connect/services/program_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Program.fromJson', () {
    test('parses a complete valid program', () {
      final program = Program.fromJson(_validProgramJson());

      expect(program.id, 'flutter-foundations');
      expect(program.title, 'Flutter Foundations');
      expect(program.category, 'Mobile Development');
      expect(program.shortDescription, contains('Flutter concepts'));
      expect(program.fullDescription, contains('guided practice'));
      expect(program.deadline, '30 August');
      expect(program.duration, '6 weeks');
      expect(program.deliveryFormat, 'Online');
      expect(program.eligibilityRequirements, hasLength(2));
      expect(program.visual, ProgramVisual.mobileDevelopment);
      expect(program.visual.identifier, 'mobileDevelopment');
    });

    test('rejects a missing or empty required string', () {
      final json = _validProgramJson()..['title'] = '   ';

      expect(
        () => Program.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message.toString(),
            'message',
            contains('title'),
          ),
        ),
      );
    });

    test('rejects an unknown visual identifier', () {
      final json = _validProgramJson()..['visual'] = 'remoteImage';

      expect(
        () => Program.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message.toString(),
            'message',
            allOf(contains('remoteImage'), contains('Unknown program visual')),
          ),
        ),
      );
    });

    test('rejects empty eligibility requirements', () {
      final json = _validProgramJson()
        ..['eligibilityRequirements'] = <String>[];

      expect(
        () => Program.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message.toString(),
            'message',
            contains('non-empty list'),
          ),
        ),
      );
    });

    test('rejects non-string eligibility entries', () {
      final json = _validProgramJson()
        ..['eligibilityRequirements'] = <Object>[
          'Interest in mobile development.',
          42,
        ];

      expect(
        () => Program.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message.toString(),
            'message',
            allOf(contains('index 1'), contains('non-empty string')),
          ),
        ),
      );
    });
  });

  group('AssetProgramRepository', () {
    test('loads the four declared programs from the bundled asset', () async {
      final repository = AssetProgramRepository(loadDelay: Duration.zero);

      final programs = await repository.loadPrograms();

      expect(
        programs.map((program) => program.id),
        orderedEquals([
          'flutter-foundations',
          'career-readiness-sprint',
          'data-insights-starter',
          'project-leadership-lab',
        ]),
      );
    });

    test('loads a typed immutable list from a JSON asset', () async {
      final bundle = _StringAssetBundle({
        AssetProgramRepository.defaultAssetPath: jsonEncode([
          _validProgramJson(),
        ]),
      });
      final repository = AssetProgramRepository(
        assetBundle: bundle,
        loadDelay: Duration.zero,
      );

      final programs = await repository.loadPrograms();

      expect(programs, hasLength(1));
      expect(programs.single.id, 'flutter-foundations');
      expect(
        () => programs.add(Program.fromJson(_validProgramJson())),
        throwsUnsupportedError,
      );
    });

    test('returns an empty typed list for an empty catalogue', () async {
      final repository = AssetProgramRepository(
        assetBundle: _StringAssetBundle({
          AssetProgramRepository.defaultAssetPath: '[]',
        }),
        loadDelay: Duration.zero,
      );

      expect(await repository.loadPrograms(), isEmpty);
    });

    test('wraps a malformed catalogue root in a clear domain error', () async {
      final repository = AssetProgramRepository(
        assetBundle: _StringAssetBundle({
          AssetProgramRepository.defaultAssetPath: jsonEncode({
            'programs': <Object>[],
          }),
        }),
        loadDelay: Duration.zero,
      );

      await expectLater(
        repository.loadPrograms(),
        throwsA(
          isA<ProgramRepositoryException>()
              .having(
                (error) => error.message,
                'message',
                contains('local program catalogue'),
              )
              .having((error) => error.cause, 'cause', isA<FormatException>()),
        ),
      );
    });
  });
}

Map<String, dynamic> _validProgramJson() => <String, dynamic>{
  'id': 'flutter-foundations',
  'title': 'Flutter Foundations',
  'category': 'Mobile Development',
  'shortDescription':
      'Explore core Flutter concepts while planning a mobile experience.',
  'fullDescription':
      'Learn Flutter widgets, layouts, navigation, and interface development '
      'through guided practice.',
  'deadline': '30 August',
  'duration': '6 weeks',
  'deliveryFormat': 'Online',
  'eligibilityRequirements': <String>[
    'Interest in mobile development.',
    'Access to a suitable computer.',
  ],
  'visual': 'mobileDevelopment',
};

class _StringAssetBundle extends CachingAssetBundle {
  _StringAssetBundle(this.assets);

  final Map<String, String> assets;

  @override
  Future<ByteData> load(String key) async {
    final value = assets[key];
    if (value == null) throw StateError('Missing test asset: $key');
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(value)));
  }
}
