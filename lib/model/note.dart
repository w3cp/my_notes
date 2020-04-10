import 'package:my_notes/utils/dbdata.dart';

class Note {
  int id;
  String title;
  String body;
  String createdAt;
  bool favorite;

  Note({
    this.id,
    this.title,
    this.body,
    this.createdAt,
    this.favorite,
  });

  factory Note.fromMap(Map<String, dynamic> data) => Note(
        id: data[DBData.columnNoteId],
        title: data[DBData.columnNoteTitle],
        body: data[DBData.columnNoteBody],
        createdAt: data[DBData.columnNoteCreatedAt],
        favorite: data[DBData.columnNoteFavorite] == 1,
      );

  Map<String, dynamic> toMap() => {
        DBData.columnNoteId: id,
        DBData.columnNoteTitle: title,
        DBData.columnNoteBody: body,
        DBData.columnNoteCreatedAt: createdAt,
        DBData.columnNoteFavorite: favorite == true ? 1 : 0,
      };
}
