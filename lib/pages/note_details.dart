import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:my_notes/utils/uidata.dart';
import 'package:my_notes/model/note.dart';
import 'package:my_notes/db/db.dart';
import 'package:my_notes/utils/showSnackbar.dart';

class NoteDetails extends StatefulWidget {
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  DBProvider _db = DBProvider.db;
  Note note = Note();
  bool _edited = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _updateNote() {
    final Future<Database> dbFuture = _db.database;

    dbFuture.then((database) {
      Future<Note> noteFuture = _db.getNote(note.id);

      noteFuture.then((note) {
        setState(() {
          this.note = note;
          this._edited = true;
          ShowSnackbar.snackBar(_scaffoldKey, UIData.snackbarNoteUpdateSuccess);
        });
        print('note updated');
        print('Inside _updateNote: ${note.title}');
      });
    });
  }

  _editNote(BuildContext context, Note currentNote) async {
    final result = await Navigator.pushNamed(
      context,
      UIData.routeAddEditNote,
      arguments: currentNote,
    );
    if (result != null) {
      print(result);
      _updateNote();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_edited) {
      note = ModalRoute.of(context).settings.arguments;
      print('get note from route');
    }
    print('Inside build: ${note.title}');

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(UIData.titleRouteNoteDetails),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, UIData.actionDelete);
            },
            tooltip: UIData.tooltipDeleteNote,
          ),
        ],
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              note.title,
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(height: 24.0),
            Text(
              note.body,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _editNote(context, note);
        },
        child: Icon(Icons.edit, size: 30.0),
        tooltip: UIData.tooltipEditNote,
      ),
    );
  }
}
