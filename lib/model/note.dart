import 'package:my_notes/utils/dbdata.dart';

class Note {
  int id;
  String title;
  String body;
  String createdAt;

  Note({
    this.id,
    this.title,
    this.body,
    this.createdAt,
  });

  factory Note.fromMap(Map<String, dynamic> data) => new Note(
        id: data[DBData.columnNoteId],
        title: data[DBData.columnNoteTitle],
        body: data[DBData.columnNoteBody],
        createdAt: data[DBData.columnNoteCreatedAt],
      );

  Map<String, dynamic> toMap() => {
        DBData.columnNoteId: id,
        DBData.columnNoteTitle: title,
        DBData.columnNoteBody: body,
        DBData.columnNoteCreatedAt: createdAt,
      };
}
