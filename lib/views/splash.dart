import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_app/views/dashboard.dart';
import 'package:tracker_app/views/input_user.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 1);

    if (firstTime != null && !firstTime) {// Not first time
      return new Timer(_duration, navigationPageHome);
    }
    else {
      return new Timer(_duration, navigationPageWel);
    }
  }

  void navigationPageHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashboardPage()));
  }

  void navigationPageWel() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => inputUser()));
  }
  
  @override
  Widget build(BuildContext context) {
    startTime();
    return Scaffold(
      body: Center(
        child: Image.asset("assets/app_logo.png"),
      )
    );
  }
}
