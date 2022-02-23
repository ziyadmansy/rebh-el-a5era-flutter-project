import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/widgets/app_bar.dart';

import '../../models/zekr_cat.dart';
import '../../widgets/azkar/azkar_box.dart';

class AzkarItemsScreen extends StatefulWidget {
  static const String routeName = '/azkarItems';
  const AzkarItemsScreen({Key key}) : super(key: key);

  @override
  _AzkarItemsScreenState createState() => _AzkarItemsScreenState();
}

class _AzkarItemsScreenState extends State<AzkarItemsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ZekrCategory zekr = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: GlobalAppBar(
        title: zekr.title,
      ),
      body: zekr.ad3ya.isEmpty
          ? Center(
              child: Text('لا يوجد أذكار متاحة'),
            )
          : ListView.separated(
              itemCount: zekr.ad3ya.length,
              itemBuilder: (context, i) {
                final doaa = zekr.ad3ya[i];
                return AzkarPostDescription(
                  title: doaa.title,
                  description: doaa.description,
                  number: doaa.count,
                );
              },
              separatorBuilder: (context, i) {
                return Divider();
              },
            ),
    );
  }
}
