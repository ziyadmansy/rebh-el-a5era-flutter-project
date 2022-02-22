class ZekrItem {
  int id;
  String qesm;
  String title;
  String description;
  bool isActive;
  int count;
  String createdAt;
  String updatedAt;

  ZekrItem(
      {this.id,
      this.qesm,
      this.title,
      this.description,
      this.isActive,
      this.count,
      this.createdAt,
      this.updatedAt});

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
