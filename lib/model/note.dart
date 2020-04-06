class Note {
  int id;
  String title;
  String body;

  Note({
    this.id,
    this.title,
    this.body,
  });

  factory Note.fromJson(Map<String, dynamic> data) => new Note(
        id: data["id"],
        title: data["title"],
        body: data["body"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
      };
  @override
  String toString() {
    return 'Note{id: $id, title: $title, body: $body}';
  }
}
