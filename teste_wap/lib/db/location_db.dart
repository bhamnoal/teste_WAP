import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocationDb {
  late Database database;
  LocationDb() {
    initializeDataBase();
  }
  Future<void> initializeDataBase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'location_database_.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE location(LatLong TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> saveToDatabase(String latlong) async {
    await database.rawInsert(
      'INSERT INTO location(LatLong) VALUES("$latlong")',
    );
  }

  Future<List<Map<String, dynamic>>> getSavedLocation() async {
    final List<Map<String, dynamic>> location =
        await database.query('location');
    return location;
  }
}
