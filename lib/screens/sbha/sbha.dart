import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/widgets/app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class SbhaScreen extends StatefulWidget {
  static const String routeName = 'sbhaScreen';

  @override
  _SbhaScreenState createState() => _SbhaScreenState();
}

class _SbhaScreenState extends State<SbhaScreen> {
  int _counter = 0;
  bool isClick = true;
  _dismissDialog() {
    Navigator.pop(context);
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'تصفير العدد',
            ),
            content: Text(
              'هل أنت متأكد من تصفير العدد؟',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _dismissDialog();
                },
                child: Text('لا'),
              ),
              TextButton(
                onPressed: () {
                  _dismissDialog();
                  removeCounter();
                  setState(() {
                    _counter = 0;
                  });
                },
                child: Text('نعم'),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getCounter();
  }

  /*-----------------------------------------------------------------------------------------------*/
  /*---------------------------- get counter from shared preferences ------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt("counter") ?? 0);
    });
  }

  /*-----------------------------------------------------------------------------------------------*/
  /*---------------------------- Set counter to shared preferences ------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  Future<void> setCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("counter", _counter);
  }

  /*-----------------------------------------------------------------------------------------------*/
  /*---------------------------- delete counter from shared preferences ------------------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  removeCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("counter");
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GlobalAppBar(title: "السبحة"),
        body: InkWell(
          onTap: () {
            setState(() {
              _counter++;
            });
            setCounter();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Column(
              children: <Widget>[
                Center(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/azkar/sbha.png',
                          ),
                        ),
                      ),
                      child: Center(
                          child: Text(
                        '$_counter',
                        style: TextStyle(fontSize: 40.0),
                      )),
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          child: Text('تصفير العدد'),
                          style: ElevatedButton.styleFrom(
                            primary: redColor,
                          ),
                          onPressed: () {
                            _showMaterialDialog();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
