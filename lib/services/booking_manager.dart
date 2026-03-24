import 'package:flutter/foundation.dart';

import 'package:car_booking_app/models/booking.dart';
import 'package:car_booking_app/models/car.dart';

import 'package:car_booking_app/services/car_service.dart';

class BookingManager extends ChangeNotifier {
  final CarService _carService;
  final List<Booking> _history = [];
  List<Car> _cars = [];

  String _pickup = '';
  String _destination = '';
  Car? _selectedCar;
  Booking? _currentBooking;

  BookingManager(this._carService) {
    _loadCars();
  }

  Future<void> _loadCars() async {
    _cars = await _carService.getCars();
    notifyListeners();
  }

  List<Car> get cars => _cars;

  List<Booking> get history => List.unmodifiable(_history);

  String get pickup => _pickup;
  String get destination => _destination;
  Car? get selectedCar => _selectedCar;
  Booking? get currentBooking => _currentBooking;

  bool get hasSearch => _pickup.trim().isNotEmpty && _destination.trim().isNotEmpty;

  bool get canConfirm =>
      hasSearch && _selectedCar != null;

  void startSearch({required String pickup, required String destination}) {
    _pickup = pickup.trim();
    _destination = destination.trim();
    _selectedCar = null;
    _currentBooking = null;
    notifyListeners();
  }

  void selectCar(Car car) {
    _selectedCar = car;
    _currentBooking = null;
    notifyListeners();
  }

  void confirmBooking({required double distanceKm}) {
    if (!canConfirm) return;
    final car = _selectedCar!;
    final totalPrice = car.basePrice + (car.pricePerKm * distanceKm).round();
    final now = DateTime.now();

    final booking = Booking(
      id: 'b_${now.microsecondsSinceEpoch}',
      createdAt: now,
      pickup: _pickup,
      destination: _destination,
      car: car,
      distanceKm: distanceKm,
      totalPrice: totalPrice,
      paymentStatus: PaymentStatus.pending,
    );

    _history.insert(0, booking);
    _currentBooking = booking;
    notifyListeners();
  }

  void payWithCard() {
    final current = _currentBooking;
    if (current == null) return;
    if (current.paymentStatus != PaymentStatus.pending) return;

    final updated = current.copyWith(paymentStatus: PaymentStatus.paidCard);
    _replaceBooking(updated);
    _currentBooking = updated;
    notifyListeners();
  }

  void payWithMomo() {
    final current = _currentBooking;
    if (current == null) return;
    if (current.paymentStatus != PaymentStatus.pending) return;

    final updated = current.copyWith(paymentStatus: PaymentStatus.paidMomo);
    _replaceBooking(updated);
    _currentBooking = updated;
    notifyListeners();
  }

  void _replaceBooking(Booking updated) {
    final index = _history.indexWhere((b) => b.id == updated.id);
    if (index == -1) return;
    _history[index] = updated;
  }

  void resetForNewBooking() {
    _pickup = '';
    _destination = '';
    _selectedCar = null;
    _currentBooking = null;
    notifyListeners();
  }
}

