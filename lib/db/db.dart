import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
//import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:my_notes/utils/dbdata.dart';

import 'package:my_notes/model/note.dart';

class DBProvider {
  static Database _database;

  DBProvider._();
  static final DBProvider db = DBProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  get _dbPath async {
    String documentsDirectory = await _localPath;
    return p.join(documentsDirectory, DBData.databaseName);
  }

  Future<bool> dbExists() async {
    return File(await _dbPath).exists();
  }

  initDB() async {
    String path = await _dbPath;
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        print("DBProvider:: onCreate()");
        await db.execute(DBData.sqlNote);
      },
    );
  }

  Future<int> createNote(Note note) async {
    final db = await database;
    var result = await db.insert(
      DBData.tableNote,
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List> getNotes() async {
    final db = await database;
    var result = await db.query(
      DBData.tableNote,
      columns: [
        DBData.columnNoteId,
        DBData.columnNoteTitle,
        DBData.columnNoteBody,
      ],
    );

    return result.toList();
  }

  Future<List<Note>> getAllNotes() async {
    // Get a reference to the database
    final db = await database;

    // Query the table for all The Notes.
    final List<Map<String, dynamic>> maps = await db.query(DBData.tableNote);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(
      maps.length,
      (i) {
        return Note(
          id: maps[i][DBData.columnNoteId],
          title: maps[i][DBData.columnNoteTitle],
          body: maps[i][DBData.columnNoteBody],
        );
      },
    );
  }

  Future<Note> getNote(int id) async {
    final db = await database;
    List<Map> results = await db.query(
      DBData.tableNote,
      columns: [
        DBData.columnNoteId,
        DBData.columnNoteTitle,
        DBData.columnNoteBody,
      ],
      where: '${DBData.columnNoteId} = ?',
      whereArgs: [id],
    );

    if (results.length > 0) {
      return new Note.fromJson(results.first);
    }

    return null;
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      DBData.tableNote,
      note.toJson(),
      where: "${DBData.columnNoteId} = ?",
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      DBData.tableNote,
      where: '${DBData.columnNoteId} = ?',
      whereArgs: [id],
    );
  }

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
