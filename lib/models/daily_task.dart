// ignore_for_file: public_member_api_docs, sort_constructors_first
class DailyTask {
  int id;
  String title;
  String description;
  String createdAt;
  String updatedAt;
  
  DailyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
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
