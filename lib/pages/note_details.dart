import 'package:flutter/material.dart';

import 'package:my_notes/model/note.dart';

class NoteDetails extends StatefulWidget {
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  Note _note = Note();

  @override
  Widget build(BuildContext context) {
    _note = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Note Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, 'delete');
            },
            tooltip: 'Delete Note',
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pop(context, 'edit');
            },
            tooltip: 'Edit Note',
          ),
        ],
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              _note.title,
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(height: 24.0),
            Text(
              _note.body,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
