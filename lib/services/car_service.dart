import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:car_booking_app/models/car.dart';

class CarService {
  static String get baseUrl {
    return Platform.isAndroid ? 'http://10.0.2.2:3000/api' : 'http://localhost:3000/api';
  }

  Future<List<Car>> getCars() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cars'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Car(
          id: json['id'],
          name: json['name'],
          seats: json['seats'],
          basePrice: json['base_price'],
          pricePerKm: json['price_per_km'],
          iconName: json['icon'],
        )).toList();
      }
      return _getFallbackCars();
    } catch (e) {
      return _getFallbackCars();
    }
  }

  List<Car> _getFallbackCars() {
    return const [
      Car(id: 'normal', name: 'Normal', seats: 4, basePrice: 15000, pricePerKm: 12000, iconName: 'car'),
      Car(id: 'economy', name: 'Economy', seats: 4, basePrice: 12000, pricePerKm: 10000, iconName: 'taxi'),
      Car(id: 'premium', name: 'Comfort', seats: 4, basePrice: 20000, pricePerKm: 15000, iconName: 'sedan'),
      Car(id: 'van_xl', name: 'Van XL', seats: 7, basePrice: 25000, pricePerKm: 18000, iconName: 'van'),
    ];
  }
}
