// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DBHelper {
//   static Database? _db;

//   static Future<Database> get db async {
//     if (_db != null) return _db!;
//     _db = await initDB();
//     return _db!;
//   }

//   static Future<Database> initDB() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'locations.db');

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE locations(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             latitude REAL,
//             longitude REAL,
//             timestamp TEXT
//           )
//         ''');
//       },
//     );
//   }

//   static Future<void> insertLocation(double lat, double lng, String time) async {
//     final dbClient = await db;
//     await dbClient.insert(
//       'locations',
//       {'latitude': lat, 'longitude': lng, 'timestamp': time},
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   static Future<List<Map<String, dynamic>>> getAllLocations() async {
//     final dbClient = await db;
//     return await dbClient.query('locations', orderBy: 'timestamp DESC');
//   }
// }
