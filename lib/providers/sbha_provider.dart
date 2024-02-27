import 'package:flutter/foundation.dart';
import 'package:muslim_dialy_guide/models/zekr_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class SbhaProvider with ChangeNotifier {
  int totalCount = 0;
  final List<ZekrItem> sbhaItems = [
    ZekrItem(
      id: 0,
      title: 'سبحان الله',
      count: 0,
      qesm: '',
      createdAt: '',
      updatedAt: '',
      description: '',
      isActive: true,
    ),
    ZekrItem(
      id: 1,
      title: 'الحمد لله',
      count: 0,
      qesm: '',
      createdAt: '',
      updatedAt: '',
      description: '',
      isActive: true,
    ),
    ZekrItem(
      id: 2,
      title: 'لا إله إلا الله',
      count: 0,
      qesm: '',
      createdAt: '',
      updatedAt: '',
      description: '',
      isActive: true,
    ),
    ZekrItem(
      id: 3,
      title: 'الله اكبر',
      count: 0,
      qesm: '',
      createdAt: '',
      updatedAt: '',
      description: '',
      isActive: true,
    ),
    ZekrItem(
      id: 4,
      title: 'لاحول ولا قوة الا بالله',
      count: 0,
      qesm: '',
      createdAt: '',
      updatedAt: '',
      description: '',
      isActive: true,
    ),
    ZekrItem(
      id: 5,
      title:
          'اللهم صل على محمد وآل محمد كما صليت على ابراهيم وعلى ال ابراهيم وبارك على محمد وآل محمد كما باركت على إبراهيم وعلى آل إبراهيم',
      count: 0,
      qesm: '',
      createdAt: '',
      updatedAt: '',
      description: '',
      isActive: true,
    ),
    ZekrItem(
      id: 6,
      title:
          'لا اله الا الله وحده لا شريك له له الملك وله الحمد وهو على كل شيء قدير',
      count: 0,
      qesm: '',
      createdAt: '',
      updatedAt: '',
      description: '',
      isActive: true,
    ),
    ZekrItem(
      id: 7,
      title: 'لا اله الا انت سبحانك اني كنت من الظالمين',
      count: 0,
      qesm: '',
      createdAt: '',
      updatedAt: '',
      description: '',
      isActive: true,
    ),
    ZekrItem(
      id: 8,
      title: 'استغفر الله العظيم واتوب اليه',
      count: 0,
      qesm: '',
      createdAt: '',
      updatedAt: '',
      description: '',
      isActive: true,
    ),
  ];

  void incSebhaCount(int index) {
    sbhaItems[index].count++;
    getAllSebhaCounts();
    notifyListeners();
  }

  void resetSebhaCount(index) {
    sbhaItems[index].count = 0;
    getAllSebhaCounts();
    notifyListeners();
  }

  void resetAllSebhaCounts() {
    sbhaItems.forEach((element) {
      element.count = 0;
    });
    getAllSebhaCounts();
    notifyListeners();
  }

  void getAllSebhaCounts() {
    totalCount = 0;
    sbhaItems.forEach((element) {
      totalCount += element.count;
    });
    saveTotalCount(totalCount);
  }

  Future<void> saveTotalCount(int totalCount) async {
    // Saves and clears total count depending where it is called
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(totalSebhaCountKey, totalCount);
  }

  Future<void> getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    totalCount = prefs.getInt(totalSebhaCountKey) ?? 0;
    notifyListeners();
  }
}
