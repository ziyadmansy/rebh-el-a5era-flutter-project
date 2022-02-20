import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_dialy_guide/constants.dart';
import 'package:muslim_dialy_guide/provides/theme_provider.dart';
import 'package:provider/provider.dart';

class GlobalAppBar extends PreferredSize {
  final String title;

  const GlobalAppBar({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.lilyScriptOne(
          fontWeight: FontWeight.w300,
          color: Theme.of(context).textTheme.titleLarge.color,
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      actions: [
        _themeIcon(theme, context),
      ],
    );
  }

  _themeIcon(theme, context) {
    return IconButton(
      icon: Icon(
        (theme.theme)
            ? Icons.brightness_7_outlined
            : Icons.brightness_4_outlined,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        theme.switchTheme();
      },
    );
  }

  @override
  Size get preferredSize {
    return Size(double.infinity, kToolbarHeight);
  }
}
