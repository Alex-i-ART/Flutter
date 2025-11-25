import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  
  static final DBProvider db = DBProvider._();
  
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  
  Future<Database> _initDB() async {
    final dir = await getDatabasesPath();
    final path = join(dir, 'counter_history.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }
  
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE History(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        operation TEXT,
        previous_value INTEGER,
        new_value INTEGER,
        timestamp TEXT
      )
    ''');
  }
  
  // Добавляем запись в историю
  Future<void> addHistory(String operation, int previousValue, int newValue) async {
    final db = await database;
    await db.insert('History', {
      'operation': operation,
      'previous_value': previousValue,
      'new_value': newValue,
      'timestamp': DateTime.now().toString(),
    });
  }
  
  // Получаем всю историю
  Future<List<Map<String, dynamic>>> getAllHistory() async {
    final db = await database;
    return await db.query('History', orderBy: 'id DESC');
  }
  
  // Удаляем запись из истории
  Future<int> deleteHistory(int id) async {
    final db = await database;
    return await db.delete('History', where: 'id = ?', whereArgs: [id]);
  }
}