import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wallpaper_app/dataModel.dart';


class Sqldatabaseclass {
  Database? _database;
  final String tableName = "favtable";
  final String databaseName = "my_favorite.db";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $tableName('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'imgurl TEXT, '
              'state INTEGER)', // 0 = false, 1 = true
        );
      },
    );
  }

  // Insert a new item
  Future<void> insertItem(DataModel model) async {
    final db = await database;
    await db.insert(
      tableName,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all items
  Future<List<DataModel>> retrieveItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (position) {
      return DataModel.fromMap(maps[position]);
    });
  }

  // Update isFavorite status
  Future<void> updateFavoriteStatus(String imgurl, bool isFavorite) async {
    final db = await database;
    await db.update(
      tableName,
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'imgurl = ?',
      whereArgs: [imgurl],
    );
  }

  // Delete an item
  Future<void> deleteItem(String imgurl) async {
    final db = await database;
    await db.delete(
        tableName,
        where: 'imgurl = ?',
        whereArgs: [imgurl],
        );
    }
}