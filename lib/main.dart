import 'package:flutter/material.dart';
import 'package:tracker_app/views/RiveTest.dart';
import 'package:tracker_app/views/dashboard.dart';

void main() {
  runApp(MaterialApp(
    title: 'Team Null Void',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Color(0xFF2A2F3A),
    ),
    home: DashboardPage(),
  ));
}
