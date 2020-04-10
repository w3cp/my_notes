import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
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

    //print('Inside createNote: ${note.createdAt}');

    var result = await db.insert(
      DBData.tableNote,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return result;
  }

  Future<int> updateNote(Note note) async {
    final db = await database;

    return await db.update(
      DBData.tableNote,
      note.toMap(),
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

  Future<List<Note>> getAllNotes() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      DBData.tableNote,
      columns: [
        DBData.columnNoteId,
        DBData.columnNoteTitle,
        DBData.columnNoteBody,
        DBData.columnNoteCreatedAt,
        DBData.columnNoteFavorite,
      ],
    );

    // Convert the List<Map<String, dynamic> into a List<Note>.
    return List.generate(
      maps.length,
      (i) =>  Note.fromMap(maps[i]),
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
        DBData.columnNoteCreatedAt,
        DBData.columnNoteFavorite,
      ],
      where: '${DBData.columnNoteId} = ?',
      whereArgs: [id],
    );

    if (results.length > 0) {
      return Note.fromMap(results.first);
    }

    return null;
  }

  Future<String> get _localPath async {
    final directory = await getDatabasesPath();
    return directory;
  }

  closeDB() {
    if (_database != null) {
      _database.close();
    }
  }
}
