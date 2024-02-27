// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:muslim_dialy_guide/models/zekr_item.dart';

class ZekrCategory {
  int id;
  String title;
  List<ZekrItem> ad3ya;
  String description;
  String createdAt;
  String updatedAt;
  ZekrCategory({
    required this.id,
    required this.title,
    required this.ad3ya,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ZekrCategory.fromJson(Map<String, dynamic> json) {
    return ZekrCategory(
      id: json['id'],
      title: json['title'],
      ad3ya: (json['ad3ya'] as List<dynamic>).map<ZekrItem>(
        (doaa) => ZekrItem.fromJson(doaa),
      ).toList(),
      description: json['text_field'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
