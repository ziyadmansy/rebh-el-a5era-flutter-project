import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_dialy_guide/constants.dart';
import 'package:muslim_dialy_guide/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class GlobalAppBar extends PreferredSize {
  final String title;
  List<Widget> actions = [];

  GlobalAppBar({
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.lilyScriptOne(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleLarge.color,
        ),
      ),
      centerTitle: true,
      actions: [
        if (actions != null) ...actions,
        _themeIcon(theme, context),
      ],
    );
  }

  _themeIcon(theme, context) {
    return IconButton(
      icon: Icon(
        (theme.theme)
            ? Icons.nightlight_round_rounded
            : Icons.light_mode_rounded,
        color: Theme.of(context).iconTheme.color,
        semanticLabel: 'وضع التطبيق',
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
