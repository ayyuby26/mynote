class MyNote {
  final String id;
  String title, content;

  MyNote(
    this.id,
    this.title,
    this.content,
  );

  MyNote.fromJson(Map<String, dynamic> i)
      : id = i['id'],
        title = i['title'],
        content = i['content'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
      };
}
