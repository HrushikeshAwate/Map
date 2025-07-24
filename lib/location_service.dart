import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map/database_helper.dart';
import 'firebase_db.dart';
import 'package:map/database_helper.dart';

class LocationService extends ChangeNotifier {
  final List<Map<String, dynamic>> _locationHistory = [];
  Timer? _locationTimer;
  Timer? _syncTimer;

  List<Map<String, dynamic>> get locationHistory => _locationHistory;

  LocationService() {
    _startLocationUpdates();
    _startFirebaseSync();
  }

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final position = await Geolocator.getCurrentPosition();
      final location = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'speed': position.speed,
        'timestamp': DateTime.now().toIso8601String().split('.')[0] 
      };

      _locationHistory.add(location);
      notifyListeners();

      await DatabaseHelper().insertLocation(location);
    });
  }

  void _startFirebaseSync() {
    _syncTimer = Timer.periodic(const Duration(minutes: 2), (_) async {
      await uploadAllLocationsToFirebase();
    });
  }

  void clearLocationHistory() async {
    _locationHistory.clear();
    notifyListeners();
    await DatabaseHelper().clearAllLocations();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _syncTimer?.cancel();
    super.dispose();
  }
}
