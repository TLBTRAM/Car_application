class Car {
  final String id;
  final String name;
  final int seats;
  final int basePrice; // Giá mở cửa (VNĐ)
  final int pricePerKm; // Giá mỗi km (VNĐ)
  final String iconName;

  const Car({
    required this.id,
    required this.name,
    required this.seats,
    required this.basePrice,
    required this.pricePerKm,
    required this.iconName,
  });
}

