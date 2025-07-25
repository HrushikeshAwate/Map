import 'package:device_info_plus/device_info_plus.dart';

Future<String> getAndroidId() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  return androidInfo.id ?? 'unknown_device';
}
