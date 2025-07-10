// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

// class LocalDatabase {
//   static Database? _db;

//   static Future<Database> get database async {
//     if (_db != null) return _db!;
//     _db = await _initDb();
//     return _db!;
//   }

//   static Future<Database> _initDb() async {
//     final dir = await getApplicationDocumentsDirectory();
//     final path = join(dir.path, 'locations.db');

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE locations (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             latitude REAL,
//             longitude REAL,
//             timestamp TEXT
//           )
//         ''');
//       },
//     );
//   }

//   static Future<void> insertLocation({
//     required double latitude,
//     required double longitude,
//     required String timestamp,
//   }) async {
//     final db = await database;
//     await db.insert('locations', {
//       'latitude': latitude,
//       'longitude': longitude,
//       'timestamp': timestamp,
//     });
//   }

//   static Future<List<Map<String, dynamic>>> getAllLocations() async {
//     final db = await database;
//     return await db.query('locations', orderBy: 'timestamp DESC');
//   }
// }
