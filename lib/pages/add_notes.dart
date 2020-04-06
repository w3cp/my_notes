import 'package:flutter/material.dart';

import 'package:my_notes/model/note.dart';

class AddNotes extends StatefulWidget {
  @override
  AddNotesState createState() => AddNotesState();
}

class AddNotesState extends State<AddNotes> {
  final note = Note();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /*void _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }*/

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Note args = ModalRoute.of(context).settings.arguments;
    _titleController.text = args.title;
    _bodyController.text = args.body;

    final titleFormField = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter note title';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Note title',
      ),
      controller: _titleController,
      autofocus: true,
    );

    final bodyFormField = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter note description';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Note body',
      ),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: _bodyController,
    );

    void saveNote() {
      if (_formKey.currentState.validate()) {
        note.id = args.id;
        note.title = _titleController.text;
        note.body = _bodyController.text;
        Navigator.pop(context, note);
      }
    }

    final saveButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          saveNote();
        },
        child: Text((args.title == '') ? 'Save' : 'Update'),
      ),
    );

    final form = Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            titleFormField,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: bodyFormField,
            ),
            saveButton,
          ],
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text((args.title == '') ? 'Add New Note' : 'Edit Note'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: saveNote,
            tooltip: 'Save note',
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          form,
        ],
      ),
    );
  }
}
