import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/providers/azkar_provider.dart';
import 'package:muslim_dialy_guide/screens/azkar_app/azkar_items_screen.dart';
import 'package:muslim_dialy_guide/screens/azkar_app/salah_azkar.dart';
import 'package:muslim_dialy_guide/screens/azkar_app/sleep_azkar.dart';
import 'package:muslim_dialy_guide/screens/sbha/sbha.dart';
import 'package:muslim_dialy_guide/widgets/animated_text_header.dart';
import 'package:muslim_dialy_guide/widgets/app_bar.dart';
import 'package:muslim_dialy_guide/widgets/azkar/sbha.dart';
import 'package:muslim_dialy_guide/widgets/or_widget.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'morning_night/home.dart';

class AzkarElmoslemMainPage extends StatefulWidget {
  static const String routeName = 'Azkarpage';

  const AzkarElmoslemMainPage({Key key}) : super(key: key);

  @override
  _AzkarElmoslemMainPageState createState() => _AzkarElmoslemMainPageState();
}

class _AzkarElmoslemMainPageState extends State<AzkarElmoslemMainPage> {
  bool isLoading = false;
  bool hasCrashed = false;

  @override
  void initState() {
    super.initState();
    getAzkarData();
  }

  Future<void> getAzkarData() async {
    try {
      setState(() {
        isLoading = true;
        hasCrashed = false;
      });
      final azkarData = Provider.of<AzkarProvider>(context, listen: false);
      await azkarData.getAzkar();
      setState(() {
        isLoading = false;
        hasCrashed = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        hasCrashed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final azkarData = Provider.of<AzkarProvider>(context);

    return Scaffold(
      appBar: GlobalAppBar(
        title: "أذكار المسلم",
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : hasCrashed
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_outlined,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        errorMsg,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextButton(
                        onPressed: getAzkarData,
                        child: Text(
                          'إعادة المحاولة',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : azkarData.azkar.isEmpty
                  ? Center(
                      child: Text('لا يوجد أذكار متاحة'),
                    )
                  : ListView.separated(
                      itemCount: azkarData.azkar.length,
                      itemBuilder: (context, i) {
                        final zekr = azkarData.azkar[i];
                        return ListTile(
                          title: Text(zekr.title),
                          subtitle: Text(zekr.description),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AzkarItemsScreen.routeName,
                              arguments: zekr,
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, i) {
                        return Divider();
                      },
                    ),
    );
  }
}
