import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:location/location.dart';
import 'dart:async';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'location_channel',
      initialNotificationTitle: 'Initializing...',
      initialNotificationContent: 'Preparing background service...',
    ),
    iosConfiguration: IosConfiguration(),
  );

  await service.startService();
}

// THIS is where you put the foreground notification info!
@pragma("vm:entry-point")
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // This is required to show a valid notification or the app will crash!
  if (service is AndroidServiceInstance) {
    await service.setForegroundNotificationInfo(
      title: "Location Tracking",
      content: "Your location is being tracked in background",
    );
  }

  final location = Location();
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) serviceEnabled = await location.requestService();

  PermissionStatus permission = await location.hasPermission();
  if (permission == PermissionStatus.denied) {
    permission = await location.requestPermission();
  }

  location.changeSettings(interval: 5000); 

  location.onLocationChanged.listen((locationData) {

    print("Background Location: ${locationData.latitude}, ${locationData.longitude}");
  });
}
