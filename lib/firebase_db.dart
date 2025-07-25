import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database_helper.dart';
import 'package:map/device_info.dart';

Future<void> uploadAllLocationsToFirebase() async {
  final dbHelper = DatabaseHelper();
  final locations = await dbHelper.getAllLocations();

  final rtdb = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://maps-3759d-default-rtdb.asia-southeast1.firebasedatabase.app/',
  );

final rawId = await getAndroidId();
final androidId = rawId.replaceAll(RegExp(r'[.#$\[\]]'), '_');
final dbRef = rtdb.ref('locations').child(androidId);

  for (final location in locations) {
    await dbRef.push().set({
      'latitude': location['latitude'],
      'longitude': location['longitude'],
      'speed': location['speed'],
      'timestamp': location['timestamp'],
    });
  }
}
