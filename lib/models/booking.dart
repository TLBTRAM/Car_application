import 'package:car_booking_app/models/car.dart';

enum PaymentStatus {
  pending,
  paidCard,
  paidMomo,
}

enum BookingStatus {
  pending,
  accepted,
  completed,
  cancelled,
}

class Booking {
  final String id;
  final DateTime createdAt;
  final String pickup;
  final String destination;
  final Car car;
  final double distanceKm; // Khoảng cách (km)
  final int totalPrice; // Tổng tiền (VNĐ)
  final PaymentStatus paymentStatus;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.createdAt,
    required this.pickup,
    required this.destination,
    required this.car,
    required this.distanceKm,
    required this.totalPrice,
    required this.paymentStatus,
    this.status = BookingStatus.pending,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      pickup: json['pickup'] ?? '',
      destination: json['destination'] ?? '',
      car: Car(
        id: json['car_id'] ?? 'normal',
        name: json['car_name'] ?? 'Normal',
        seats: 4, // Mặc định vì database ko lưu seats
        basePrice: 0,
        pricePerKm: 0,
        iconName: 'car',
      ),
      distanceKm: (json['distance'] ?? 0.0).toDouble(),
      totalPrice: json['total_price'] ?? 0,
      paymentStatus: _parsePaymentStatus(json['payment_status']),
      status: _parseBookingStatus(json['status']),
    );
  }

  static PaymentStatus _parsePaymentStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid_card': return PaymentStatus.paidCard;
      case 'paid_momo': return PaymentStatus.paidMomo;
      default: return PaymentStatus.pending;
    }
  }

  static BookingStatus _parseBookingStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted': return BookingStatus.accepted;
      case 'completed': return BookingStatus.completed;
      case 'cancelled': return BookingStatus.cancelled;
      default: return BookingStatus.pending;
    }
  }

  Booking copyWith({
    String? id,
    DateTime? createdAt,
    String? pickup,
    String? destination,
    Car? car,
    double? distanceKm,
    int? totalPrice,
    PaymentStatus? paymentStatus,
    BookingStatus? status,
  }) {
    return Booking(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      car: car ?? this.car,
      distanceKm: distanceKm ?? this.distanceKm,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      status: status ?? this.status,
    );
  }
}

