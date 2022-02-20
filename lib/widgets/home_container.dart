import 'package:flutter/material.dart';
import 'package:muslim_dialy_guide/constants.dart';

class HomeContainer extends StatelessWidget {
  final String image;
  final Color color;
  final String title;

  const HomeContainer(
      {Key key,
      @required this.image,
      @required this.color,
      @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.8,
            child: Container(
              height: 240,
              decoration: BoxDecoration(
                color: color,
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.7),
              borderRadius: BorderRadius.all(
                Radius.circular(kBorderRadius),
              ),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 10, left: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
