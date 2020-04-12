import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:my_notes/utils/uidata.dart';
import 'package:my_notes/model/note.dart';
import 'package:my_notes/db/db.dart';
import 'package:my_notes/utils/showSnackbar.dart';
import 'package:my_notes/utils/formatted_time.dart';

class NoteDetails extends StatefulWidget {
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  DBProvider _db = DBProvider.db;
  Note note = Note();
  bool _edited = false;

  FormattedTime formattedTime;

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
        //print('note updated');
        //print('Inside _updateNote: ${note.title}');
        //print('Inside _updateNote Date: ${note.createdAt}');
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
      //print(result);
      _updateNote();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_edited) {
      note = ModalRoute.of(context).settings.arguments;
      //print('get note from route');
    }
    //print('Inside build: ${note.title}');
    formattedTime = FormattedTime(time: note.createdAt);

    final appBar = AppBar(
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
    );

    final favoriteIconButton = IconButton(
      icon:
          Icon(note.favorite == true ? Icons.favorite : Icons.favorite_border),
      color: note.favorite == true
          ? Theme.of(context).accentColor
          : Theme.of(context).primaryColorLight,
      tooltip: note.favorite == true
          ? UIData.tooltipRemoveFromFavorite
          : UIData.tooltipAddToFavorite,
      onPressed: () {
        note.favorite = !note.favorite;
        _db.updateNote(note);
        setState(() {});
      },
    );

    final noteView = Container(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.all(0.0),
            title: Text(
              note.title,
              style: Theme.of(context).textTheme.headline,
            ),
            trailing: favoriteIconButton,
          ),
          Text(
            '${UIData.lastModified}: ${formattedTime.getFormattedTime()}',
            style: Theme.of(context).textTheme.caption,
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
    );

    final fabEdit = FloatingActionButton(
      onPressed: () {
        //print('Favorite in fab: ${note.favorite}');
        _editNote(context, note);
      },
      child: Icon(Icons.edit, size: 30.0),
      tooltip: UIData.tooltipEditNote,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: noteView,
      floatingActionButton: fabEdit,
    );
  }
}
