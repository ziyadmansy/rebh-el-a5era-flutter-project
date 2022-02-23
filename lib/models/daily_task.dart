class DailyTask {
  int id;
  String title;
  String description;
  String createdAt;
  String updatedAt;

  DailyTask({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory DailyTask.fromJson(Map<String, dynamic> json) {
    return DailyTask(
      id: json['id'],
      title: json['title'],
      description: json['text_field'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
