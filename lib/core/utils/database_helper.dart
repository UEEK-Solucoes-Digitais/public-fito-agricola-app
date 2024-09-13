import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'offline_data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE data (id INTEGER PRIMARY KEY, route TEXT, fragment_index INTEGER, json TEXT)",
        );
      },
    );
  }

  Future<void> insertData(String route, String jsonData) async {
    final db = await database;
    final fragments = _splitData(jsonData);
    await db.delete('data', where: 'route = ?', whereArgs: [route]);

    await db.transaction((txn) async {
      // await txn.delete('data', where: 'route = ?', whereArgs: [route]);
      for (int i = 0; i < fragments.length; i++) {
        await txn.insert('data',
            {'route': route, 'fragment_index': i, 'json': fragments[i]});
      }
    });
  }

  Future<void> insertBulkData(Map<String, String> data) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var entry in data.entries) {
        final fragments = _splitData(entry.value);
        await txn.delete('data', where: 'route = ?', whereArgs: [entry.key]);
        for (int i = 0; i < fragments.length; i++) {
          await txn.insert('data',
              {'route': entry.key, 'fragment_index': i, 'json': fragments[i]});
        }
      }
    });
  }

  Future<String?> getDataByRoute(String route) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('data',
        where: 'route = ?', whereArgs: [route], orderBy: 'fragment_index');

    if (maps.isEmpty) return null;

    final fragments = maps.map((map) => map['json'] as String).toList();
    return _joinData(fragments);
  }

  // get all routes list (dont return data, just the route names)
  Future<List<String>> getAllRoutes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('data',
        columns: ['route'], distinct: true, orderBy: 'route');

    return maps.map((map) => map['route'] as String).toList();
  }

  List<String> _splitData(String data, {int chunkSize = 1000}) {
    final List<String> chunks = [];
    for (var i = 0; i < data.length; i += chunkSize) {
      chunks.add(data.substring(
          i, i + chunkSize > data.length ? data.length : i + chunkSize));
    }
    return chunks;
  }

  String _joinData(List<String> chunks) {
    return chunks.join();
  }

  // remover todos os registros
  Future<void> removeAllData() async {
    final db = await database;
    await db.delete('data');
  }

  // remove bulk data
  Future<void> removeBulkData(List<String> routes) async {
    final db = await database;

    // Crie um número adequado de placeholders para a lista de rotas
    String placeholders = List.filled(routes.length, '?').join(',');

    // executar em segundo plano
    // Exclua usando esses placeholders
    await db.delete(
      'data',
      where: 'route IN ($placeholders)',
      whereArgs: routes,
    );
  }
}
