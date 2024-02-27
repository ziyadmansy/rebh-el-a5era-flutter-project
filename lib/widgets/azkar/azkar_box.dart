import 'package:flutter/material.dart';

import 'number_buttons.dart';

class AzkarPostDescription extends StatefulWidget {
  final String title;
  final String? description;
  final int number;

  const AzkarPostDescription({
    Key? key,
    required this.title,
    required this.number,
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
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  //Box is here
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.description ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
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
