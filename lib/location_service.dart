import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class LocationService with ChangeNotifier {
  final Location _location = Location();
  LocationData? currentLocation;
  final List<Map<String, dynamic>> _locationHistory = [];
  Timer? _timer;

  List<Map<String, dynamic>> get locationHistory => _locationHistory;

  LocationService() {
    _init();
  }

  Future<void> _init() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Location settings (not listener-based now)
    _location.changeSettings(interval: 30000, distanceFilter: 0);

    // Fetch location every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (_) async {
      final data = await _location.getLocation();
      currentLocation = data;

      _locationHistory.add({
        'latitude': data.latitude,
        'longitude': data.longitude,
        'timestamp': DateTime.now().toIso8601String(),
      });

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
