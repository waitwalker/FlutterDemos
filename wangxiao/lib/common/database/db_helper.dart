import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'database_base.dart';

class DBHelper {
  Future<Database> _db;

  Future<Database> get db async {
    if (_db == null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentDir = await getApplicationDocumentsDirectory();
    String path = join(documentDir.path, "aixue.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Employee(id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, mobileno TEXT,emailId TEXT )");
  }

  Future<List<DBObject>> getData(String query) async {
    var dbClient = await db;
    List<Map> list_map = await dbClient.rawQuery(query);
    List<DBObject> listObje = new List();
    for (int i = 0; i < list_map.length; i++) {
      DBObject object = DBObject();
      object.loadObject(list_map[i]);
      listObje.add(object);
    }
    return listObje;
  }
}
