import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:daily_todo/models/models.dart';

class DBHelper {
  static DBHelper _dbHelper;
  static Database _database;

  String todoTable = "todo_table";
  String colId = 'id';
  String colTodo = 'todo';
  String colDate = 'date';

  DBHelper._createInstance();

  factory DBHelper() {
    if (_dbHelper == null) _dbHelper = DBHelper._createInstance();
    return _dbHelper;
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();

    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todos.db';

    final notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $todoTable(" +
        "$colId INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "$colTodo TEXT, $colDate TEXT)");
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    final db = await this.database;
    final result = await db.query(todoTable, orderBy: '$colId ASC');

    return result;
  }

  Future<int> insertTodo(Todo todo) async {
    final db = await this.database;
    final result = await db.insert(todoTable, todo.toMap());
    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await this.database;
    final result = await db.update(
      todoTable,
      todo.toMap(),
      where: '$colId = ?',
      whereArgs: [todo.id],
    );
    return result;
  }

  Future<int> deleteTodo(Todo todo) async {
    final db = await this.database;
    final result = await db.delete(
      todoTable,
      where: '$colId: ?',
      whereArgs: [todo.id],
    );

    return result;
  }

  Future<int> getCount() async {
    final db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) FROM $todoTable");
    final result = Sqflite.firstIntValue(x);
    return result;
  }
}
