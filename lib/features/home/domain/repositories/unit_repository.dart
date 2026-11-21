import '../../../../core/error/failure.dart';
import '../entities/rental_unit.dart';

abstract class UnitRepository {
  Future<({List<RentalUnit>? data, Failure? failure})> getUnits();
  Future<({List<RentalUnit>? data, Failure? failure})> toggleUnitRent(
    String unitId,
  );
}
