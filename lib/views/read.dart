import 'package:flutter/material.dart';

class reading extends StatefulWidget {
  const reading({Key? key}) : super(key: key);

  @override
  _readingState createState() => _readingState();
}

class _readingState extends State<reading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "READ",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
