import 'package:flutter/material.dart';

import 'package:my_notes/pages/add_notes.dart';
import 'package:my_notes/pages/list_notes.dart';
import 'package:my_notes/pages/note_details.dart';

void main() => runApp(
      MaterialApp(
        title: 'My',
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => Notes(),
          '/add_note': (context) => AddNotes(),
          '/note_details': (context) => NoteDetails(),
        },
      ),
    );


