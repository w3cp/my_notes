import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
//import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:my_notes/model/note.dart';

class DBProvider {
  static Database _database;

  DBProvider._();
  static final DBProvider db = DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  get _dbPath async {
    String documentsDirectory = await _localPath;
    return p.join(documentsDirectory, "Note.db");
  }

  Future<bool> dbExists() async {
    return File(await _dbPath).exists();
  }

  initDB() async {
    String path = await _dbPath;
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      print("DBProvider:: onCreate()");
      /*await db.execute("CREATE TABLE Task ("
          "id TEXT PRIMARY KEY,"
          "title TEXT,"
          "color INTEGER,"
          "code_point INTEGER"
          ")");
      await db.execute("CREATE TABLE Todo ("
          "id TEXT PRIMARY KEY,"
          "title TEXT,"
          "parent TEXT,"
          "completed INTEGER NOT NULL DEFAULT 0"
          ")");*/
      await db.execute("CREATE TABLE Note ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "body TEXT"
          ")");
    });
  }

  Future<int> createNote(Note note) async {
    final db = await database;
    var result = await db.insert(
      "Note",
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List> getNotes() async {
    final db = await database;
    var result = await db
        .query("Note", columns: ["id", "title", "body"]);

    return result.toList();
  }

  Future<List<Note>> notes() async {
    // Get a reference to the database
    final db = await database;

    // Query the table for all The Notes.
    final List<Map<String, dynamic>> maps = await db.query('Note');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        body: maps[i]['body'],
      );
    });
  }

  Future<Note> getNote(int id) async {
    final db = await database;
    List<Map> results = await db.query("Note",
        columns: ["id", "title", "body"],
        where: 'id = ?',
        whereArgs: [id]);

    if (results.length > 0) {
      return new Note.fromJson(results.first);
    }

    return null;
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update("Note", note.toJson(),
        where: "id = ?", whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete("Note", where: 'id = ?', whereArgs: [id]);
  }

  /*insertBulkTask(List<Task> tasks) async {
    final db = await database;
    tasks.forEach((it) async {
      var res = await db.insert("Task", it.toJson());
      print("Task ${it.id} = $res");
    });
  }

  insertBulkTodo(List<Todo> todos) async {
    final db = await database;
    todos.forEach((it) async {
      var res = await db.insert("Todo", it.toJson());
      print("Todo ${it.id} = $res");
    });
  }

  Future<List<Task>> getAllTask() async {
    final db = await database;
    var result = await db.query('Task');
    return result.map((it) => Task.fromJson(it)).toList();
  }

  Future<List<Todo>> getAllTodo() async {
    final db = await database;
    var result = await db.query('Todo');
    return result.map((it) => Todo.fromJson(it)).toList();
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return db
        .update('Todo', todo.toJson(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> removeTodo(Todo todo) async {
    final db = await database;
    return db.delete('Todo', where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> insertTodo(Todo todo) async {
    final db = await database;
    return db.insert('Todo', todo.toJson());
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert('Task', task.toJson());
  }

  Future<void> removeTask(Task task) async {
    final db = await database;
    return db.transaction<void>((txn) async {
      await txn.delete('Todo', where: 'parent = ?', whereArgs: [task.id]);
      await txn.delete('Task', where: 'id = ?', whereArgs: [task.id]);
    });
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return db
        .update('Task', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }*/

  Future<String> get _localPath async {
    //final directory = await getApplicationDocumentsDirectory();
    //return directory.path;
    final directory = await getDatabasesPath();
    return directory;
  }

  closeDB() {
    if (_database != null) {
      _database.close();
    }
  }
}
