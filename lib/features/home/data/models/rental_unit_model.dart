import '../../domain/entities/rental_unit.dart';

class RentalUnitModel extends RentalUnit {
  const RentalUnitModel({
    required super.id,
    required super.titleAr,
    required super.titleEn,
    required super.cityAr,
    required super.cityEn,
    required super.rooms,
    required super.monthlyRent,
    required super.isRented,
  });

  factory RentalUnitModel.fromEntity(RentalUnit entity) {
    return RentalUnitModel(
      id: entity.id,
      titleAr: entity.titleAr,
      titleEn: entity.titleEn,
      cityAr: entity.cityAr,
      cityEn: entity.cityEn,
      rooms: entity.rooms,
      monthlyRent: entity.monthlyRent,
      isRented: entity.isRented,
    );
  }
}
