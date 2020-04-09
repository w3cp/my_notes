import 'package:my_notes/utils/dbdata.dart';

class Note {
  int id;
  String title;
  String body;

  Note({
    this.id,
    this.title,
    this.body,
  });

  factory Note.fromMap(Map<String, dynamic> data) => new Note(
        id: data[DBData.columnNoteId],
        title: data[DBData.columnNoteTitle],
        body: data[DBData.columnNoteBody],
      );

  Map<String, dynamic> toMap() => {
        DBData.columnNoteId: id,
        DBData.columnNoteTitle: title,
        DBData.columnNoteBody: body,
      };
}
