import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:my_notes/utils/uidata.dart';
import 'package:my_notes/model/note.dart';
import 'package:my_notes/db/db.dart';
import 'package:my_notes/utils/showSnackbar.dart';

class AllNotes extends StatefulWidget {
  @override
  AllNotesState createState() => AllNotesState();
}

class AllNotesState extends State<AllNotes> {
  DBProvider _db = DBProvider.db;
  List<Note> notes;
  List<Note> filteredNotes;

  String _appBarTitle = UIData.appName;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _filterController = TextEditingController();
  int _previousSearchTextLength = 0;
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarWidget = Text(UIData.appName);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _filterController.dispose();
    super.dispose();
  }

  void _searchNote(String searchText) {
    //print('Inside _searchNote searchText: $searchText');
    if (searchText.isEmpty) {
      setState(() {
        _previousSearchTextLength = 0;
        filteredNotes = notes;
      });
    } else {
      //print(_previousSearchTextLength);
      //print(searchText.length);
      if (_previousSearchTextLength > searchText.length) {
        filteredNotes = notes;
      }
      _previousSearchTextLength = searchText.length;

      setState(() {
        List<Note> tempNotes = List<Note>();

        for (int i = 0; i < filteredNotes.length; i++) {
          String noteContent = filteredNotes[i].title + filteredNotes[i].body;
          if (noteContent.toLowerCase().contains(searchText.toLowerCase())) {
            tempNotes.add(filteredNotes[i]);
          }
        }

        //print('Notes before search: $filteredNotes');
        filteredNotes = tempNotes;
        //print('Notes after search: $filteredNotes');
      });
    }
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = Icon(Icons.close);
        _appBarWidget = TextField(
          controller: _filterController,
          onChanged: _searchNote,
          autofocus: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: UIData.formHintSearchNote,
          ),
        );
      } else {
        _searchIcon = Icon(Icons.search);
        _appBarTitle = UIData.appName;
        _appBarWidget = Text(_appBarTitle);
        filteredNotes = notes;
        _previousSearchTextLength = 0;
        _filterController.clear();
      }
    });
  }

  Widget appBar() => AppBar(
        title: _appBarWidget,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            tooltip: UIData.tooltipSearchNote,
            onPressed: _searchPressed,
          ),
        ],
      );

  void _updateNoteListFromDatabase() {
    final Future<Database> dbFuture = _db.database;

    dbFuture.then((database) {
      Future<List<Note>> notesFuture = _db.getAllNotes();

      notesFuture.then((notes) {
        setState(() {
          this.notes = notes;
          this.filteredNotes = notes;
          _appBarTitle = UIData.appName;
          //print('notes $notes');
          //print('filteredNotes $filteredNotes');
        });
      });
    });
  }

  void _updateNoteListByAll() {
    setState(() {
      filteredNotes = notes;
      _appBarTitle = UIData.appName;
      _appBarWidget = Text(_appBarTitle);
      Navigator.pop(context);
    });
  }

  void _updateNoteListByFavorite() {
    List<Note> tempNotes = List<Note>();

    for (int i = 0; i < filteredNotes.length; i++) {
      if (filteredNotes[i].favorite == true) {
        tempNotes.add(filteredNotes[i]);
      }
    }

    setState(() {
      filteredNotes = tempNotes;
      _appBarTitle = UIData.drawerFavoriteNotes;
      _appBarWidget = Text(_appBarTitle);
      Navigator.pop(context);
    });
  }

  _createNote(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      UIData.routeAddEditNote,
      arguments: Note(
        // to create a new note pass the latest note id + 1
        id: (notes.length == 0) ? 0 : notes[notes.length - 1].id + 1,
        title: '',
        body: '',
      ),
    );
    if (result != null) {
      _updateNoteListFromDatabase();
      ShowSnackbar.snackBar(_scaffoldKey, result);
    }
  }

  _editNote(BuildContext context, Note currentNote) async {
    final result = await Navigator.pushNamed(
      context,
      UIData.routeAddEditNote,
      arguments: currentNote,
    );
    if (result != null) {
      _updateNoteListFromDatabase();
      ShowSnackbar.snackBar(_scaffoldKey, result);
    }
  }

  _deleteNote(BuildContext context, Note note) {
    _db.deleteNote(note.id);
    _updateNoteListFromDatabase();

    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(UIData.snackbarNoteDeleteSuccess),
      action: SnackBarAction(
        label: UIData.lebelUndo,
        onPressed: () {
          _db.createNote(note);
          _updateNoteListFromDatabase();
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
    if (action == null) {
      _updateNoteListFromDatabase();
    } else {
      if (action == UIData.actionDelete) {
        _deleteNote(context, note);
      } else if (action == UIData.actionEdit) {
        _editNote(context, note);
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
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        final i = filteredNotes.length - index - 1; // last to first
        final note = filteredNotes[i];
        return Dismissible(
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
            contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            title: Text('${note.title}'),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(_getSubtitle(note.body, 36)),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  note.favorite == true ? Icons.favorite : null,
                  color: Theme.of(context).accentColor,
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: UIData.tooltipEditNote,
                  onPressed: () {
                    _editNote(context, note);
                  },
                ),
              ],
            ),
            onTap: () {
              _viewNote(context, note);
            },
          ),
        );
      },
    );
  }

  Widget drawer() => Drawer(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  UIData.appName,
                  style: TextStyle(fontSize: 25.0),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              ListTile(
                title: Text(UIData.drawerAllNotes),
                leading: Icon(Icons.list),
                onTap: _updateNoteListByAll,
              ),
              ListTile(
                title: Text(UIData.drawerFavoriteNotes),
                leading: Icon(Icons.favorite),
                onTap: _updateNoteListByFavorite,
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (notes == null) {
      notes = List<Note>();
      filteredNotes = List<Note>();
      _updateNoteListFromDatabase();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(),
      drawer: drawer(),
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
