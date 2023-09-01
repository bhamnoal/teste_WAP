import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  late Database database;

  final List<Map<String, dynamic>> _savedTasks = [];

  DatabaseManager(String dbName) {
    initializeDataBase(dbName);
  }
  Future<void> initializeDataBase(String dbName) async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'task_database_$dbName.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tasks(label TEXT, required INTEGER, clicktime TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> saveToDatabase(String label, bool required) async {
    final time = DateTime.now();
    await database.rawInsert(
      'INSERT INTO tasks(label, required, clicktime) VALUES("$label", ${required ? 1 : 0}, "${time.toIso8601String()}")',
    );
  }

  Future<List<Map<String, dynamic>>> getSavedTasks() async {
    final List<Map<String, dynamic>> tasks = await database.query('tasks');
    return tasks;
  }
}
