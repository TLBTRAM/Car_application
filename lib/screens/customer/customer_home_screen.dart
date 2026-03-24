import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_booking_app/services/booking_manager.dart';
import 'package:car_booking_app/services/app_localization.dart';
import 'package:car_booking_app/widgets/account_bottom_sheet.dart';
import 'package:car_booking_app/services/car_service.dart';
import 'package:car_booking_app/services/booking_service.dart';
import 'package:car_booking_app/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class RideOption {
  final String id;
  final String name;
  final String price;
  final String time;
  final String seats;
  final bool isPopular;
  final IconData icon;

  RideOption({
    required this.id,
    required this.name,
    required this.price,
    required this.time,
    required this.seats,
    this.isPopular = false,
    required this.icon,
  });
}

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  final _pickupFocus = FocusNode();
  final _destinationFocus = FocusNode();

  bool _isSearching = false;
  bool _isBooking = false;
  int _selectedRideIndex = 0;
  double _tripDistanceKm = 5.0; // Mock distance since map is removed
  int _tripDurationMin = 15; // Mock duration

  final List<Map<String, String>> _mockSuggestions = [
    {'name': 'Chợ Bến Thành', 'address': 'Quận 1, TP. Hồ Chí Minh'},
    {'name': 'Landmark 81', 'address': 'Bình Thạnh, TP. Hồ Chí Minh'},
    {'name': 'Sân bay Tân Sơn Nhất', 'address': 'Tân Bình, TP. Hồ Chí Minh'},
    {'name': 'Nhà thờ Đức Bà', 'address': 'Quận 1, TP. Hồ Chí Minh'},
    {'name': 'Phố đi bộ Nguyễn Huệ', 'address': 'Quận 1, TP. Hồ Chí Minh'},
  ];

  @override
  void initState() {
    super.initState();
    _destinationFocus.addListener(() {
      if (_destinationFocus.hasFocus) setState(() => _isSearching = true);
    });
    _pickupFocus.addListener(() {
      if (_pickupFocus.hasFocus) setState(() => _isSearching = true);
    });
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _pickupFocus.dispose();
    _destinationFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<AppLocalization>();
    final bookingManager = context.watch<BookingManager>();
    final authProvider = context.watch<AuthProvider>();
    final cars = bookingManager.cars;
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

    final List<RideOption> rideOptions = cars.map((car) {
      final totalPrice = car.basePrice + (car.pricePerKm * _tripDistanceKm).toInt();
      return RideOption(
        id: car.id,
        name: localization.translate(car.id),
        price: currencyFormat.format(totalPrice),
        time: '${_tripDurationMin} ${localization.translate('min')}',
        seats: car.seats.toString(),
        isPopular: car.id == 'normal',
        icon: _getIconForCar(car.id),
      );
    }).toList();

    bool hasAddresses = _pickupController.text.isNotEmpty && _destinationController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Hi, ${authProvider.user?.name ?? 'Customer'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const AccountBottomSheet(),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localization.translate('grab_ride'),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildSearchCard(localization),
                const SizedBox(height: 30),
                if (hasAddresses && !_isSearching) ...[
                  Text(
                    localization.translate('select_car'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: rideOptions.length,
                      itemBuilder: (context, index) => _buildRideOption(rideOptions[index], index),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_isSearching) _buildSearchOverlay(localization),
          if (hasAddresses && !_isSearching)
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomActionSection(localization, rideOptions),
            ),
          if (_isBooking)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(AppLocalization localization) {
    return GestureDetector(
      onTap: () => setState(() => _isSearching = true),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.circle, size: 12, color: Colors.blue),
                const SizedBox(width: 15),
                Text(_pickupController.text.isEmpty ? localization.translate('pickup') : _pickupController.text),
              ],
            ),
            const Divider(height: 30),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.red),
                const SizedBox(width: 15),
                Text(_destinationController.text.isEmpty ? localization.translate('where_heading') : _destinationController.text),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCar(String id) {
    switch (id) {
      case 'economy': return Icons.local_taxi;
      case 'premium': return Icons.airport_shuttle;
      case 'van_xl': return Icons.bus_alert;
      default: return Icons.directions_car;
    }
  }

  Widget _buildSearchOverlay(AppLocalization localization) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() => _isSearching = false);
                  FocusScope.of(context).unfocus();
                },
              ),
              const Expanded(child: Center(child: Text("Tìm chuyến đi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 10),
          _buildInputFields(localization),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: _mockSuggestions.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _mockSuggestions[index];
                return ListTile(
                  leading: const Icon(Icons.history, color: Colors.grey),
                  title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(item['address']!, style: const TextStyle(fontSize: 12)),
                  onTap: () => _onSuggestionSelected(item['name']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields(AppLocalization localization) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          TextField(
            controller: _pickupController,
            focusNode: _pickupFocus,
            decoration: InputDecoration(hintText: localization.translate('pickup'), border: InputBorder.none),
          ),
          const Divider(),
          TextField(
            controller: _destinationController,
            focusNode: _destinationFocus,
            decoration: InputDecoration(hintText: localization.translate('where_heading'), border: InputBorder.none),
            onSubmitted: (value) => _onSuggestionSelected(value),
          ),
        ],
      ),
    );
  }

  void _onSuggestionSelected(String address) {
    setState(() {
      if (_pickupFocus.hasFocus) {
        _pickupController.text = address;
      } else {
        _destinationController.text = address;
      }
      _isSearching = false;
    });
    FocusScope.of(context).unfocus();
  }

  Widget _buildRideOption(RideOption option, int index) {
    bool isSelected = _selectedRideIndex == index;
    final localization = context.read<AppLocalization>();
    return GestureDetector(
      onTap: () => setState(() => _selectedRideIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.blue.shade300 : Colors.grey.shade100, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(option.icon, size: 30, color: Colors.blue.shade800),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('${option.price} • ${option.time}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, color: isSelected ? Colors.blue.shade800 : Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionSection(AppLocalization localization, List<RideOption> rideOptions) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade100))),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: _handleConfirmRide,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          child: Text("${localization.translate('select_ride')} ${rideOptions[_selectedRideIndex].name}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Future<void> _handleConfirmRide() async {
    final bookingService = context.read<BookingService>();
    final bookingManager = context.read<BookingManager>();
    final selectedCar = bookingManager.cars[_selectedRideIndex];
    final authProvider = context.read<AuthProvider>();

    setState(() => _isBooking = true);

    final success = await bookingService.createBooking({
      'customer_id': authProvider.user?.id,
      'pickup': _pickupController.text,
      'destination': _destinationController.text,
      'car_id': selectedCar.id,
      'car_name': selectedCar.name,
      'total_price': selectedCar.basePrice + (selectedCar.pricePerKm * _tripDistanceKm).toInt(),
      'distance': _tripDistanceKm,
    });

    setState(() => _isBooking = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đặt xe thành công!"), backgroundColor: Colors.green));
      Navigator.pushNamed(context, '/history');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lỗi kết nối Backend"), backgroundColor: Colors.red));
    }
  }
}
