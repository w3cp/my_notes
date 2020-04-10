class DBData {
  //database
  static const String databaseName = "Note.db";

  //table Note
  static const String tableNote = "Note";
  static const String columnNoteId = "id";
  static const String columnNoteTitle = "title";
  static const String columnNoteBody = "body";
  static const String columnNoteCreatedAt = "createdAt";
  static const String columnNoteFavorite = "favorite";
  static const String sqlNote = """
    CREATE TABLE $tableNote (
      $columnNoteId INTEGER PRIMARY KEY,
      $columnNoteTitle TEXT, 
      $columnNoteBody TEXT,
      $columnNoteCreatedAt TEXT,
      $columnNoteFavorite INTEGER
    )
  """;
}
