import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/constants.dart';

class PostBtn extends StatefulWidget {
  int n;

  PostBtn({
    Key key,
    this.n,
  }) : super(key: key);

  @override
  _PostBtnState createState() => _PostBtnState();
}

class _PostBtnState extends State<PostBtn> {
  onClick() {
    if (widget.n > 0)
      setState(() {
        widget.n = widget.n - 1;
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: widget.n == 0
            ? Container(
                height: 30,
                child: Image.asset(
                  "assets/azkar/correct.gif",
                  fit: BoxFit.cover,
                ),
              )
            : Text("عدد المرات: ${widget.n}"),
        onPressed: onClick,
      ),
    );
  }
}
