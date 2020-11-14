import 'package:flutter/material.dart';

class CountCards extends StatelessWidget {
  final String text;
  // ignore: non_constant_identifier_names
  final double width, height, border_radius;
  final int count;
  final Color color;
  final bool isLoading;

  const CountCards(
      {Key key,
      @required this.text,
      @required this.width,
      @required this.height,
      // ignore: non_constant_identifier_names
      @required this.border_radius,
      @required this.count,
      @required this.color,
      this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(border_radius)),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            isLoading
                ? Container(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                  )
                : Text(
                    count.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  )
          ],
        ),
      ),
    );
  }
}
