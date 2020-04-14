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
            headline4: UIData.quickFontTheme,
            headline3: UIData.quickFontTheme,
            headline2: UIData.quickFontTheme,
            headline1: UIData.quickFontTheme,
            headline5: UIData.quickFontTheme,
            headline6: UIData.quickFontTheme,
            subtitle1: UIData.quickFontTheme,
            bodyText1: UIData.quickFontTheme,
            bodyText2: UIData.quickFontTheme,
            caption: TextStyle().copyWith(
              fontFamily: UIData.quickFont,
              color: Colors.grey,
            ),
            button: UIData.quickFontTheme,
            subtitle2: UIData.quickFontTheme,
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
