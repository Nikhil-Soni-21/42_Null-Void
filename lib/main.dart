import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracker_app/views/splash.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Team Null Void',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Color(0xFF2A2F3A),
    ),
    home: Splash(),
  ));
  
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Color(0xFF2A2F3A)));
}
