import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location/location.dart';
import 'package:map/local_db.dart';
import 'package:map/location_entry.dart';

Future<void> initializeNotificationService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: notificationServiceEntryPoint,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'location_channel',
      initialNotificationTitle: 'Location Tracker',
      initialNotificationContent: 'Fetching location...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(), 
  );

  await service.startService();
}

@pragma('vm:entry-point')
void notificationServiceEntryPoint(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final location = Location();

  print("🟢 Background service started");

  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      print("❌ Location service not enabled.");
      return;
    }
  }

  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      print("❌ Location permission not granted.");
      return;
    }
  }

  location.changeSettings(interval: 30000, distanceFilter: 0);

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
    print("✅ Foreground notification service started");

    Timer.periodic(const Duration(seconds: 30), (timer) async {
  try {
    final loc = await location.getLocation();
    final lat = loc.latitude?.toStringAsFixed(5) ?? 'N/A';
    final lng = loc.longitude?.toStringAsFixed(5) ?? 'N/A';
    final time = DateTime.now();

    print("📍 Background location: $lat, $lng");

    // Update the notification
    await service.setForegroundNotificationInfo(
      title: '📍 Lat: $lat, Lng: $lng',
      content: '🕒 ${time.toIso8601String()}',
    );

    // ✅ Insert into the database
    if (loc.latitude != null && loc.longitude != null) {
      await LocationDB.instance.insertLocation(LocationEntry(
        latitude: loc.latitude!,
        longitude: loc.longitude!,
        speed: loc.speed ?? 0.0,
        timestamp: time.toIso8601String(),
      ));
      print("✅ Saved location to DB");
    }
  } catch (e) {
    print("❌ Background fetch failed: $e");
  }
});
  }
}
