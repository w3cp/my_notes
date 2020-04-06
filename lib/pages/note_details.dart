import 'package:flutter/material.dart';

import 'package:my_notes/model/note.dart';

class NoteDetails extends StatefulWidget {
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  @override
  Widget build(BuildContext context) {
    final Note _noteArgs = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Note Details'),
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              _noteArgs.title,
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(height: 24.0),
            Text(
              _noteArgs.body,
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
