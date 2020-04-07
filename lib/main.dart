import 'package:flutter/material.dart';

import 'package:my_notes/utils/uidata.dart';

import 'package:my_notes/pages/all_notes.dart';
import 'package:my_notes/pages/note_details.dart';
import 'package:my_notes/pages/add_edit_note.dart';

void main() => runApp(
      MaterialApp(
        title: UIData.appName,
        theme: ThemeData.dark(),
        initialRoute: UIData.initialRoute,
        routes: <String, WidgetBuilder>{
          UIData.initialRoute: (BuildContext context) => AllNotes(),
          UIData.routeAddEditNote: (BuildContext context) => AddEditNote(),
          UIData.routeNoteDetails: (BuildContext context) => NoteDetails(),
        },
      ),
    );
