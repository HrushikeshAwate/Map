import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'location_entry.dart';

class LocationDB {
  static final LocationDB _instance = LocationDB._internal();
  static Database? _database;

  factory LocationDB() {
    return _instance;
  }

  LocationDB._internal();

  static LocationDB get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'locations.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE locations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitude REAL,
        longitude REAL,
        timestamp TEXT
      )
    ''');
  }

  Future<void> insertLocation(LocationEntry entry) async {
    final db = await database;
    await db.insert(
      'locations',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LocationEntry>> getAllLocations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('locations');
    return List.generate(maps.length, (i) {
      return LocationEntry.fromMap(maps[i]);
    });
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('locations');
  }

  // Future<void> printAllLocations() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.query('locations');
  //   // for (final row in maps) {
  //   //   // print("📍 Lat: ${row['latitude']}, Lng: ${row['longitude']}, Time: ${row['timestamp']}");
  //   // }
  //   print("📍 Total locations: ${maps.length}");
}
