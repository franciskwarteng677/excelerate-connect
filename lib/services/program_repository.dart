import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/program.dart';

/// Contract used by program screens and test fakes.
abstract interface class ProgramRepository {
  Future<List<Program>> loadPrograms();
}

/// Loads the local program catalogue from a bundled JSON asset.
class AssetProgramRepository implements ProgramRepository {
  AssetProgramRepository({
    AssetBundle? assetBundle,
    this.assetPath = defaultAssetPath,
    this.loadDelay = const Duration(seconds: 1),
  }) : _assetBundle = assetBundle ?? rootBundle;

  static const defaultAssetPath = 'assets/data/programs.json';

  final AssetBundle _assetBundle;
  final String assetPath;
  final Duration loadDelay;

  @override
  Future<List<Program>> loadPrograms() async {
    try {
      if (loadDelay > Duration.zero) {
        await Future<void>.delayed(loadDelay);
      }

      final source = await _assetBundle.loadString(assetPath);
      final decoded = jsonDecode(source);
      if (decoded is! List) {
        throw const FormatException(
          'The program catalogue root must be a JSON array.',
        );
      }

      final programs = <Program>[];
      final programIds = <String>{};
      for (var index = 0; index < decoded.length; index++) {
        final entry = decoded[index];
        if (entry is! Map<String, dynamic>) {
          throw FormatException(
            'Program entry at index $index must be a JSON object.',
          );
        }

        try {
          final program = Program.fromJson(entry);
          if (!programIds.add(program.id)) {
            throw FormatException(
              'Duplicate program id "${program.id}" at index $index.',
            );
          }
          programs.add(program);
        } on FormatException catch (error) {
          throw FormatException(
            'Invalid program entry at index $index: $error',
          );
        }
      }

      return List<Program>.unmodifiable(programs);
    } catch (error, stackTrace) {
      if (error is ProgramRepositoryException) rethrow;
      throw ProgramRepositoryException(
        'Unable to load the local program catalogue from "$assetPath".',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Clear domain error exposed when the asset cannot be read or parsed.
class ProgramRepositoryException implements Exception {
  const ProgramRepositoryException(
    this.message, {
    required this.cause,
    required this.stackTrace,
  });

  final String message;
  final Object cause;
  final StackTrace stackTrace;

  @override
  String toString() => '$message Cause: $cause';
}
