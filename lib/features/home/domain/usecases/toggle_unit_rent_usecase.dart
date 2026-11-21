import '../../../../core/error/failure.dart';
import '../entities/rental_unit.dart';
import '../repositories/unit_repository.dart';

class ToggleUnitRentUseCase {
  final UnitRepository _repository;
  ToggleUnitRentUseCase(this._repository);

  Future<({List<RentalUnit>? data, Failure? failure})> call(String unitId) {
    return _repository.toggleUnitRent(unitId);
  }
}
