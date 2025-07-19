import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'locations.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE locations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            latitude REAL,
            longitude REAL,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertLocation(Map<String, dynamic> location) async {
    final db = await database;
    await db.insert('locations', location);
  }

  Future<List<Map<String, dynamic>>> getAllLocations() async {
    final db = await database;
    return await db.query('locations');
  }

  Future<void> clearAllLocations() async {
    final db = await database;
    await db.delete('locations');
  }
}
