import '../../../../core/error/failure.dart';
import '../entities/rental_unit.dart';
import '../repositories/unit_repository.dart';

class GetUnitsUseCase {
  final UnitRepository _repository;
  GetUnitsUseCase(this._repository);

  Future<({List<RentalUnit>? data, Failure? failure})> call() {
    return _repository.getUnits();
  }
}
