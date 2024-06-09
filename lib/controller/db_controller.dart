import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance of DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  // Private constructor for DatabaseHelper
  DatabaseHelper._internal();

  // Getter for the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'alarms.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the 'alarms' table in the database if it doesn't exist
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE alarms(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        time TEXT
      )
    ''');
  }

  // Insert a new alarm into the 'alarms' table
  Future<int> insertAlarm(DateTime time) async {
    final db = await database;
    return await db.insert(
      'alarms',
      {'time': time.toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all alarms from the 'alarms' table
  Future<List<Map<String, dynamic>>> getAlarms() async {
    final db = await database;
    return await db.query('alarms');
  }

  // Delete an alarm from the 'alarms' table based on its ID
  Future<int> deleteAlarm(int id) async {
    final db = await database;
    return await db.delete('alarms', where: 'id = ?', whereArgs: [id]);
  }

  // Update the time of an existing alarm in the 'alarms' table
  Future<int> updateAlarm(int id, DateTime time) async {
    final db = await database;
    return await db.update(
      'alarms',
      {'time': time.toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
