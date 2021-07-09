import 'package:flutter/material.dart';
import 'package:tracker_app/views/dashboard.dart';

void main() {
  runApp(MaterialApp(
    title: 'Team Null Void',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
    ),
    home: DashboardPage(),
  ));
}
