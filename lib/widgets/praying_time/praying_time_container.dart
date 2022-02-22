import 'package:flutter/material.dart';

import '../../constants.dart';

class PrayingTimeContainer extends StatelessWidget {
  final String icon;
  final String title;
  final String time;
  PrayingTimeContainer({this.icon, this.title, this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          '$icon',
          width: 40,
        ),
        SizedBox(
          width: 16,
        ),
        Padding(
          padding: EdgeInsets.only(left: 25),
          child: Text(
            '$title',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: Text(
            '$time',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        )
      ],
    );
  }
}
