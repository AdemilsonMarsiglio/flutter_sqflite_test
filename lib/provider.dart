import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_floor/client.dart';

class DBProvider {

  final _versionDb = 1;
  final _nameDb = "TestDB3.db";

  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    return _database = await initDB();
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "/$_nameDb";

    return await openDatabase(
      path, 
      version: _versionDb, 
      onOpen: (db) {
        print("Abriu conexao com BD");
      }, 
      onCreate: (Database db, int version) async {
        await db.execute(Client.createTable());
      }
    );
  }

  insert(String tableName, Map<String, dynamic> json) async {
    final db = await database;
    var res = await db.insert(tableName, json);
    return res;
  }

  rawInsert(String sqlInsert) async {
    final db = await database;
    var res = await db.rawInsert(sqlInsert);
    return res;
  }

  getByWhere(String tableName, String whereClause, List arguments) async {
    final db = await database;
    var res =await  db.query(tableName, where: whereClause, whereArgs: arguments);
    return res.isNotEmpty ? res.first : Null;
  }


  Future getAll(String tableName) async {
    final db = await database;
    var res = await db.query(tableName);
    return res.isNotEmpty ? res : [];
  }

  Future execQuery(String query) async {
    final db = await database;
    var res = await db.rawQuery(query);
    return res;
  }

  updateByWhere(String tableName, Map<String, dynamic> json, String whereClause, List arguments) async {
    final db = await database;
    var res = await db.update(tableName, json, where: whereClause, whereArgs: arguments);
    return res;
  }

  deleteWhere(String tableName, String whereClause, List arguments) async {
    final db = await database;
    db.delete(tableName, where: whereClause, whereArgs: arguments);
  }

  deleteAll(String tableName) async {
    final db = await database;
    await db.rawDelete("DELETE FROM $tableName");
  }
}