class Task {
  String title;
  bool isDone;
  DateTime dateCreated;
  DateTime? dateDone;

  Task({
    required this.title,
    this.isDone = false,
    DateTime? dateCreated,
    this.dateDone,
  }) : dateCreated = dateCreated ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'title': title,
    'isDone': isDone,
    'dateCreated': dateCreated.toIso8601String(),
    'dateDone': dateDone?.toIso8601String(),
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isDone: json['isDone'],
      dateCreated: DateTime.parse(json['dateCreated']),
      dateDone:
          json['dateDone'] != null ? DateTime.parse(json['dateDone']) : null,
    );
  }
}
