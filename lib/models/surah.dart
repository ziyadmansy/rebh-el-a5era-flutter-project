// ignore_for_file: public_member_api_docs, sort_constructors_first
/*-----------------------------------------------------------------------------------------------*/
/*---------------------------------------  Surah Model  --------------------------------------*/
/*-----------------------------------------------------------------------------------------------*/
class Surah {
  String? place;
  String? type;
  int? count;
  String? title;
  String? titleAr;
  String? index;
  // int reversedPageIndex;
  int? pageIndex;
  String? juzIndex;

  Surah({
    this.place,
    this.type,
    this.count,
    this.title = '',
    this.titleAr = '',
    this.index,
    this.pageIndex,
    this.juzIndex,
  });

  /*-----------------------------------------------------------------------------------------------*/
  /*---------------------------------------  model from json  --------------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  factory Surah.fromJson(Map<String, dynamic> json) {
    return new Surah(
      place: json['place'],
      type: json['type'] as String?,
      count: json['count'] as int?,
      title: json['title'] as String?,
      titleAr: json['titleAr'] as String?,
      index: json['index'] as String?,
      // reversed pages
      // reversedPageIndex: 570 - int.parse(json['pages']),
      pageIndex: int.parse(json['pages']),
      juzIndex: json['juzIndex'] as String?,
    );
  }
}
