import 'package:flutter/cupertino.dart';
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
