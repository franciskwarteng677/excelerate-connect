import 'package:excelerate_connect/models/program.dart';
import 'package:excelerate_connect/services/program_repository.dart';

class FakeProgramRepository implements ProgramRepository {
  FakeProgramRepository(this.onLoad);

  FakeProgramRepository.immediate(List<Program> programs)
    : this(() async => programs);

  final Future<List<Program>> Function() onLoad;

  int loadCount = 0;

  @override
  Future<List<Program>> loadPrograms() {
    loadCount++;
    return onLoad();
  }
}
