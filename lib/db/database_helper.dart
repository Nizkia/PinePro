import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pinepro.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 3, // bump version to add role column
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    // 🔹 Users table with role
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    // Entrepreneurs
    await db.execute('''
      CREATE TABLE entrepreneurs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      name TEXT NOT NULL,
      businessType TEXT NOT NULL,
      location TEXT NOT NULL,
      phone TEXT NOT NULL,
      telegram TEXT,
      website TEXT,
      imageUrl TEXT,
      description TEXT
      );
    ''');

    // Announcements
    await db.execute('''
      CREATE TABLE announcements (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      entrepreneurId INTEGER NOT NULL,
      title TEXT NOT NULL,
      message TEXT NOT NULL,
      date TEXT NOT NULL
      );
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // add role column to users table if upgrading from old version
      await db.execute('ALTER TABLE users ADD COLUMN role TEXT NOT NULL DEFAULT "user"');
    }
  }
}
