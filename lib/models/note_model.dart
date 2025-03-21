class NoteModel {
  final String id;
  final String title;
  final String body;
  final String owner;
  final bool archived;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.body,
    required this.owner,
    required this.archived,
    required this.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      owner: json['owner'],
      archived: json['archived'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
