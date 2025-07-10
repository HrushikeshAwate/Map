import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:location/location.dart';

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
    iosConfiguration: IosConfiguration(), // iOS no-op
  );

  await service.startService();
}

@pragma('vm:entry-point')
void notificationServiceEntryPoint(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized(); // IMPORTANT: Register plugins in isolate
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
        final time = DateTime.now().toIso8601String();

        print("📍 Background location: $lat, $lng");

        await service.setForegroundNotificationInfo(
          title: '📍 Lat: $lat, Lng: $lng',
          content: '🕒 $time',
        );
      } catch (e) {
        print("❌ Background fetch failed: $e");
      }
    });
  }
}
