import 'package:flutter/material.dart';
import 'package:tracker_app/views/character_selection.dart';
import 'package:tracker_app/views/dashboard.dart';
import 'package:tracker_app/views/input_user.dart';
import 'package:tracker_app/views/yogaRoutine.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Team Null Void',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Color(0xFF2A2F3A),
    ),
    home: characterSelection(),
  ));
}
