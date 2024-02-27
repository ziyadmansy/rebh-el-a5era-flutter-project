import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/constants.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class HomeContainer extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  const HomeContainer({
    Key? key,
    required this.title,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: onPress,
          borderRadius: BorderRadius.circular(kBorderRadius),
          child: Container(
            decoration: BoxDecoration(
              gradient: theme.isDarkTheme
                  ? null
                  : LinearGradient(
                      colors: [
                        Colors.white,
                        Color(0xff6DD5FA),
                        Color(0xff2980B9),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
              borderRadius: BorderRadius.circular(kBorderRadius),
              color: !theme.isDarkTheme ? null : Colors.black26,
            ),
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
      ),
    );
  }
}
