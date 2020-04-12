import 'package:flutter/material.dart';

import 'package:my_notes/utils/uidata.dart';
import 'package:my_notes/pages/all_notes.dart';
import 'package:my_notes/pages/note_details.dart';
import 'package:my_notes/pages/add_edit_note.dart';

void main() => runApp(
      MaterialApp(
        title: UIData.appName,
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: UIData.backgroundColor,
          backgroundColor: UIData.backgroundColor,
          textTheme: TextTheme().copyWith(
            display1: UIData.quickFontTheme,
            display2: UIData.quickFontTheme,
            display3: UIData.quickFontTheme,
            display4: UIData.quickFontTheme,
            headline: UIData.quickFontTheme,
            title: UIData.quickFontTheme,
            subhead: UIData.quickFontTheme,
            body2: UIData.quickFontTheme,
            body1: UIData.quickFontTheme,
            caption: UIData.quickFontTheme,
            button: UIData.quickFontTheme,
            subtitle: UIData.quickFontTheme,
            overline: UIData.quickFontTheme,

          ),
        ),
        initialRoute: UIData.initialRoute,
        routes: <String, WidgetBuilder>{
          UIData.initialRoute: (BuildContext context) => AllNotes(),
          UIData.routeAddEditNote: (BuildContext context) => AddEditNote(),
          UIData.routeNoteDetails: (BuildContext context) => NoteDetails(),
        },
      ),
    );
