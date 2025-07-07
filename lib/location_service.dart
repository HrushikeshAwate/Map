import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class LocationService extends ChangeNotifier {
  final Location _location = Location();
  LocationData? _currentLocation;
  final List<Map<String, dynamic>> _locationList = [];

  LocationService() {
    _init();
  }

  List<Map<String, dynamic>> get locationList => _locationList;
  LocationData? get currentLocation => _currentLocation;

  void _init() async {
    bool enabled = await _location.serviceEnabled();
    if (!enabled) enabled = await _location.requestService();
    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }

    if (enabled && permission == PermissionStatus.granted) {
      _location.onLocationChanged.listen((loc) {
        _currentLocation = loc;
        _locationList.add({
          'lat': loc.latitude,
          'lng': loc.longitude,
          'time': DateTime.now().toIso8601String(),
        });
        notifyListeners();
      });
    }
  }
}
