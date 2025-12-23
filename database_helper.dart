import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'favorites.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imgUrl TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> addFavorite(String imgUrl) async {
    final db = await database;
    return await db.insert('favorites', {'imgUrl': imgUrl});
  }

  Future<int> removeFavorite(String imgUrl) async {
    final db = await database;
    return await db.delete('favorites', where: 'imgUrl = ?', whereArgs: [imgUrl]);
  }

  Future<List<String>> getFavorites() async {
    final db = await database;
    final result = await db.query('favorites');
    return result.map((row) => row['imgUrl'] as String).toList();
  }

  Future<bool> isFavorite(String imgUrl) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'imgUrl = ?',
      whereArgs: [imgUrl],
    );
    return result.isNotEmpty;
  }
}
