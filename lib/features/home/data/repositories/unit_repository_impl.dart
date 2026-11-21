import '../../../../core/error/failure.dart';
import '../../domain/entities/rental_unit.dart';
import '../../domain/repositories/unit_repository.dart';
import '../datasources/unit_local_datasource.dart';

class UnitRepositoryImpl implements UnitRepository {
  final UnitLocalDataSource _localDataSource;
  UnitRepositoryImpl(this._localDataSource);

  @override
  Future<({List<RentalUnit>? data, Failure? failure})> getUnits() async {
    try {
      final list = await _localDataSource.fetchUnits();
      return (data: list, failure: null);
    } catch (_) {
      return (data: null, failure: const Failure('Failed to load units'));
    }
  }

  @override
  Future<({List<RentalUnit>? data, Failure? failure})> toggleUnitRent(
    String unitId,
  ) async {
    try {
      final list = await _localDataSource.toggleUnitRent(unitId);
      return (data: list, failure: null);
    } catch (_) {
      return (data: null, failure: const Failure('Failed to update unit'));
    }
  }
}
