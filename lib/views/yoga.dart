import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class yoga extends StatefulWidget {
  const yoga({Key? key}) : super(key: key);

  @override
  _yogaState createState() => _yogaState();
}

class _yogaState extends State<yoga> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Yoga",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/icon_yoga.png"),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40.0, top: 2),
                        child:
                        Text(
                          "Meditation",
                          style: TextStyle(
                              fontSize: 24.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
