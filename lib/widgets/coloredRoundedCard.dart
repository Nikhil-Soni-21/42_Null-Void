import 'package:flutter/material.dart';

Widget coloredRoundedCard(Widget child, Color bgColor) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.all(4),
      child: Card(
        elevation: 10,
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: child,
      ),
    ),
  );
}
