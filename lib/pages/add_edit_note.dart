import 'package:flutter/material.dart';

import 'package:my_notes/utils/uidata.dart';
import 'package:my_notes/model/note.dart';
import 'package:my_notes/db/db.dart';

class AddEditNote extends StatefulWidget {
  @override
  AddEditNoteState createState() => AddEditNoteState();
}

class AddEditNoteState extends State<AddEditNote> {
  DBProvider _db = DBProvider.db;
  final note = Note();

  final _formKey = GlobalKey<FormState>();

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
    note.favorite = args.favorite;

    final titleFormField = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return UIData.formErrorEmtyTitle;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: UIData.formLebelTitle,
        hintText: UIData.formHintTitle,
      ),
      controller: _titleController,
      maxLines: 1,
      autofocus: true,
    );

    final bodyFormField = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return UIData.formErrorEmtyDescription;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: UIData.formLebelBody,
        hintText: UIData.formHintBody,
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
        note.createdAt = DateTime.now().toString();
        //print('Created date: ${note.createdAt}');

        if (args.title == '') {
          note.favorite = false;
          _db.createNote(note);
        } else {
          //print('Favorite in update: ${note.favorite}');
          _db.updateNote(note);
        }

        Navigator.pop(
            context,
            (args.title == '')
                ? UIData.snackbarNoteCreateSuccess
                : UIData.snackbarNoteUpdateSuccess);
      }
    }

    final saveButton = RaisedButton(
      padding: EdgeInsets.all(12.0),
      shape: StadiumBorder(),
      child: Text((args.title == '')
          ? UIData.raisedButtonSave
          : UIData.raisedButtonUpdate),
      color: Colors.teal,
      onPressed: () {
        saveNote();
      },
    );

    final form = Form(
      key: _formKey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: titleFormField,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: bodyFormField,
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: saveButton,
            ),
            SizedBox(
              height: 25.0,
            ),
          ],
        ),
      ),
    );

    final appBar = AppBar(
      title: Text((args.title == '')
          ? UIData.titleRouteAddNewNote
          : UIData.titleRouteEditNote),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.done),
          onPressed: saveNote,
          tooltip: args.title == ''
              ? UIData.tooltipSaveNote
              : UIData.tooltipUpdateNote,
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: SingleChildScrollView(
          child: form,
        ),
      ),
    );
  }
}
