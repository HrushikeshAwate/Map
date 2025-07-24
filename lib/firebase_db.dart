import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database_helper.dart';

Future<void> uploadAllLocationsToFirebase() async {
  final dbHelper = DatabaseHelper();
  final locations = await dbHelper.getAllLocations();

  final rtdb = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://maps-3759d-default-rtdb.asia-southeast1.firebasedatabase.app/',
  );

  final dbRef = rtdb.ref('locations');

  for (var loc in locations) {
    await dbRef.push().set({
      'id': loc['id'],
      'latitude': loc['latitude'],
      'longitude': loc['longitude'],
      'speed': loc['speed'],
      'timestamp': loc['timestamp'],
    });
  }
}
