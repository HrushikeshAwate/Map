import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'firebase_db.dart';
import 'database_helper.dart'; // Add this import

class LocationService with ChangeNotifier {
  final Location _location = Location();
  LocationData? currentLocation;
  final List<Map<String, dynamic>> _locationHistory = [];
  Timer? _locationTimer;
  Timer? _firebaseTimer;

  List<Map<String, dynamic>> get locationHistory => _locationHistory;

  LocationService() {
    _init();
  }

  Future<void> _init() async {
    // Load saved data from DB on startup
    await _location.enableBackgroundMode(enable: true);

    final savedData = await DatabaseHelper().getAllLocations();
    _locationHistory.addAll(savedData);
    notifyListeners();

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

    _location.changeSettings(interval: 30000, distanceFilter: 0);

    _locationTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      final data = await _location.getLocation();
      currentLocation = data;

      final entry = {
        'latitude': data.latitude,
        'longitude': data.longitude,
        'speed': data.speed ?? 0.0,
        'timestamp': DateTime.now().toLocal().toString().split('.').first,
      };

      _locationHistory.add(entry);
      await DatabaseHelper().insertLocation(entry); // Save to DB

      notifyListeners();
    });
    _startFirebaseSync();
  }
   void _startFirebaseSync() {
    _firebaseTimer = Timer.periodic(const Duration(minutes: 2), (_) async {
      await uploadAllLocationsToFirebase();
    });
  }
  void clearLocationHistory() async {
    _locationHistory.clear();
    await DatabaseHelper().clearAllLocations(); // Clear DB too
    notifyListeners();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _firebaseTimer?.cancel();
    super.dispose();
  }
}
