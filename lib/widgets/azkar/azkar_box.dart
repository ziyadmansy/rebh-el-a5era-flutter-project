import 'package:flutter/material.dart';

import 'number_buttons.dart';

class AzkarPostDescription extends StatefulWidget {
  final String title;
  final String description;
  final int number;

  const AzkarPostDescription({
    Key key,
    @required this.title,
    @required this.number,
    this.description,
  }) : super(key: key);

  @override
  _AzkarPostDescriptionState createState() => _AzkarPostDescriptionState();
}

class _AzkarPostDescriptionState extends State<AzkarPostDescription> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  //Box is here
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 16,
                              ),
                        ),
                        Text(
                          widget.description ?? '',
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          widget.number == null
              ? Container()
              : PostBtn(
                  n: widget.number,
                ),
        ],
      ),
    );
  }
}
