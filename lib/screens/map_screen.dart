import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:map/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final Location _location = Location();
  final Completer<GoogleMapController> _controller = Completer();

  LatLng _currentPosition = const LatLng(0.0, 0.0);
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied || permission == PermissionStatus.deniedForever) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) return;
    }

    _permissionGranted = true;

    final loc = await _location.getLocation();
    setState(() {
      _currentPosition = LatLng(loc.latitude!, loc.longitude!);
    });

    _location.onLocationChanged.listen((LocationData currentLocation) {
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });

        _mapController.animateCamera(
          CameraUpdate.newLatLng(_currentPosition),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _permissionGranted
          ? GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 16,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _mapController = controller;
              },
            )
          : const Center(
              child: Text("Fetching Location"),
            ),
    );
  }
}
