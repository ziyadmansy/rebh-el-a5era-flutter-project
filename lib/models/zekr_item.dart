// ignore_for_file: public_member_api_docs, sort_constructors_first
class ZekrItem {
  int id;
  String qesm;
  String title;
  String description;
  bool isActive;
  int count;
  String createdAt;
  String updatedAt;

  ZekrItem({
    required this.id,
    required this.qesm,
    required this.title,
    required this.description,
    required this.isActive,
    required this.count,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ZekrItem.fromJson(Map<String, dynamic> json) {
    return ZekrItem(
      id: json['id'],
      qesm: json['qesm'],
      title: json['title'],
      description: json['text_field'],
      isActive: json['is_active'],
      count: json['counter'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
