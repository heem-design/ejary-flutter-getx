import '../models/rental_unit_model.dart';

abstract class UnitLocalDataSource {
  Future<List<RentalUnitModel>> fetchUnits();
  Future<List<RentalUnitModel>> toggleUnitRent(String unitId);
}

class UnitLocalDataSourceImpl implements UnitLocalDataSource {
  List<RentalUnitModel> _units = [
    const RentalUnitModel(
      id: 'U-101',
      titleAr: 'شقة عائلية حديثة',
      titleEn: 'Modern Family Apartment',
      cityAr: 'الرياض - حي النرجس',
      cityEn: 'Riyadh - Al Narjis',
      rooms: 3,
      monthlyRent: 3800,
      isRented: false,
    ),
    const RentalUnitModel(
      id: 'U-102',
      titleAr: 'استوديو بإطلالة مميزة',
      titleEn: 'Bright Studio Unit',
      cityAr: 'جدة - الشاطئ',
      cityEn: 'Jeddah - Al Shati',
      rooms: 1,
      monthlyRent: 2100,
      isRented: true,
    ),
    const RentalUnitModel(
      id: 'U-103',
      titleAr: 'دوبلكس بحديقة خاصة',
      titleEn: 'Duplex with Private Yard',
      cityAr: 'الخبر - العقربية',
      cityEn: 'Khobar - Al Aqrabiyah',
      rooms: 4,
      monthlyRent: 5400,
      isRented: false,
    ),
  ];

  @override
  Future<List<RentalUnitModel>> fetchUnits() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List<RentalUnitModel>.from(_units);
  }

  @override
  Future<List<RentalUnitModel>> toggleUnitRent(String unitId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _units = _units.map((u) {
      if (u.id == unitId) {
        return RentalUnitModel.fromEntity(u.copyWith(isRented: !u.isRented));
      }
      return u;
    }).toList();
    return List<RentalUnitModel>.from(_units);
  }
}