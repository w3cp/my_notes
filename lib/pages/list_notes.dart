import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:my_notes/model/note.dart';
import 'package:my_notes/db/db.dart';

class Notes extends StatefulWidget {
  @override
  NotesState createState() => NotesState();
}

class NotesState extends State<Notes> {
  DBProvider _db = DBProvider.db;
  List<Note> notes;
  int _length = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String text) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  void updateNoteList() {
    final Future<Database> dbFuture = _db.database;
    dbFuture.then((database) {
      Future<List<Note>> notesFuture = _db.notes();
      notesFuture.then((note) {
        setState(() {
          this.notes = note;
          this._length = note.length;
        });
      });
    });
  }

  _createNote(BuildContext context) async {
    try {
      final editedNote = await Navigator.pushNamed(
        context,
        '/add_note',
        arguments: Note(
          id: (_length == 0) ? 0 : notes[_length - 1].id + 1,
          title: '',
          body: '',
        ),
      );
      if (editedNote != null) {
        _db.createNote(editedNote);
        updateNoteList();
        _showSnackBar('Note created successfully');
      }
    } catch (e) {
      print('Failed to create note: $e');
    }
  }

  _updateNote(BuildContext context, Note currentNote) async {
    final editedNote = await Navigator.pushNamed(
      context,
      '/add_note',
      arguments: currentNote,
    );
    if (editedNote != null) {
      _db.updateNote(editedNote);
      updateNoteList();
      _showSnackBar('Note updated successfully');
    }
  }

  _deleteNote(BuildContext context, Note note) {
    _db.deleteNote(note.id);
    updateNoteList();
    //_showSnackBar('Note deleted');

    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Note deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          _db.createNote(note);
          updateNoteList();
        },
      ),
    ));
  }

  String getSubtitle(String str, int endIndex) {
    if (str.length <= endIndex) {
      return str;
    }
    return str.substring(0, endIndex) + '...';
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: _length * 2,
      itemBuilder: (context, index) {
        final i = _length - (index ~/ 2) - 1; // last to first
        final note = notes[i];
        return (index % 2 == 1)
            ? Divider(height: 0.0)
            : Dismissible(
                key: Key(note.id.toString()),
                onDismissed: (direction) {
                  _deleteNote(context, note);
                },
                background: Container(
                  color: Colors.red,
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    trailing: Icon(Icons.delete),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  title: Text('${note.title}'),
                  subtitle: Text(getSubtitle(note.body, 36)),
                  trailing: Icon(Icons.edit),
                  onTap: () {
                    _updateNote(context, note);
                  },
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (notes == null) {
      notes = List<Note>();
      updateNoteList();
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('My Notes'),
      ),
      body: Container(
        //padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: _buildList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //print(_length);
          _createNote(context);
        },
        child: Icon(Icons.add, size: 30.0),
        tooltip: 'Add New Note',
      ),
    );
  }
}
