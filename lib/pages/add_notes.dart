import 'package:flutter/material.dart';

import 'package:my_notes/model/note.dart';

class AddNotes extends StatefulWidget {
  @override
  AddNotesState createState() => AddNotesState();
}

class AddNotesState extends State<AddNotes> {
  final note = Note();

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /*void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }*/

  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Note args = ModalRoute.of(context).settings.arguments;
    titleController.text = args.title;
    bodyController.text = args.body;

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
      controller: titleController,
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
      controller: bodyController,
    );

    final saveButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            note.id = args.id;
            note.title = titleController.text;
            note.body = bodyController.text;
            Navigator.pop(context, note);
            //_showSnackBar('Processing data');
          }
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
      key: scaffoldKey,
      appBar: AppBar(
        title: Text((args.title == '') ? 'Add New Note' : 'Edit Note'),
      ),
      body: ListView(
        children: <Widget>[
          form,
        ],
      ),
    );
  }
}