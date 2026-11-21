class RentalUnit {
  final String id;
  final String titleAr;
  final String titleEn;
  final String cityAr;
  final String cityEn;
  final int rooms;
  final double monthlyRent;
  final bool isRented;

  const RentalUnit({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.cityAr,
    required this.cityEn,
    required this.rooms,
    required this.monthlyRent,
    required this.isRented,
  });

  RentalUnit copyWith({
    String? id,
    String? titleAr,
    String? titleEn,
    String? cityAr,
    String? cityEn,
    int? rooms,
    double? monthlyRent,
    bool? isRented,
  }) {
    return RentalUnit(
      id: id ?? this.id,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      cityAr: cityAr ?? this.cityAr,
      cityEn: cityEn ?? this.cityEn,
      rooms: rooms ?? this.rooms,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      isRented: isRented ?? this.isRented,
    );
  }
}
