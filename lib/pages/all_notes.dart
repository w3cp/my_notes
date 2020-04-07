import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:my_notes/utils/uidata.dart';
import 'package:my_notes/model/note.dart';
import 'package:my_notes/db/db.dart';

class AllNotes extends StatefulWidget {
  @override
  AllNotesState createState() => AllNotesState();
}

class AllNotesState extends State<AllNotes> {
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
      Future<List<Note>> notesFuture = _db.getAllNotes();

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
        UIData.routeAddEditNote,
        arguments: Note(
          // to create a new note pass the latest note id + 1
          id: (_length == 0) ? 0 : notes[_length - 1].id + 1,
          title: '',
          body: '',
        ),
      );
      if (editedNote != null) {
        _db.createNote(editedNote);
        _updateNoteList();
        _showSnackBar(UIData.snackbarNoteCreateSuccess);
      }
    } catch (e) {
      print('Failed to create note: $e');
    }
  }

  _updateNote(BuildContext context, Note currentNote) async {
    final editedNote = await Navigator.pushNamed(
      context,
      UIData.routeAddEditNote,
      arguments: currentNote,
    );
    if (editedNote != null) {
      _db.updateNote(editedNote);
      _updateNoteList();
      _showSnackBar(UIData.snackbarNoteUpdateSuccess);
    }
  }

  _deleteNote(BuildContext context, Note note) {
    _db.deleteNote(note.id);
    _updateNoteList();

    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(UIData.snackbarNoteDeleteSuccess),
      action: SnackBarAction(
        label: UIData.lebelUndo,
        onPressed: () {
          _db.createNote(note);
          _updateNoteList();
        },
      ),
    ));
  }

  _viewNote(BuildContext context, Note note) async {
    final action = await Navigator.pushNamed(
      context,
      UIData.routeNoteDetails,
      arguments: note,
    );
    if (action != null) {
      if (action == UIData.actionDelete) {
        _deleteNote(context, note);
      } else if (action == UIData.actionEdit) {
        _updateNote(context, note);
      }
    }
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
                    _viewNote(context, note);
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
        title: Text(UIData.appName),
      ),
      body: Container(
        child: _buildList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNote(context);
        },
        child: Icon(Icons.add, size: 30.0),
        tooltip: UIData.tooltipAddNewNote,
      ),
    );
  }
}