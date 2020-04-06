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

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String text) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  void _updateNoteList() {
    final Future<Database> dbFuture = _db.database;
    dbFuture.then((database) {
      Future<List<Note>> notesFuture = _db.notes();
      notesFuture.then((notes) {
        setState(() {
          this.notes = notes;
          this._length = notes.length;
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
        _updateNoteList();
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
      _updateNoteList();
      _showSnackBar('Note updated successfully');
    }
  }

  _deleteNote(BuildContext context, Note note) {
    _db.deleteNote(note.id);
    _updateNoteList();
    //_showSnackBar('Note deleted');

    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Note deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          _db.createNote(note);
          _updateNoteList();
        },
      ),
    ));
  }

  _viewNotes(BuildContext context, Note note) {
    Navigator.pushNamed(
      context,
      '/note_details',
      arguments: note,
    );
  }

  String _getSubtitle(String str, int endIndex) {
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
                  contentPadding:
                      const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  title: Text('${note.title}'),
                  subtitle: Text(_getSubtitle(note.body, 36)),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _updateNote(context, note);
                    },
                  ),
                  onTap: () {
                    _viewNotes(context, note);
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
      _updateNoteList();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('My Notes'),
      ),
      body: Container(
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
