import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/constants.dart';

class HomeContainer extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback onPress;

  const HomeContainer({
    Key key,
    @required this.color,
    @required this.title,
    @required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: onPress,
          borderRadius: BorderRadius.circular(kBorderRadius),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
