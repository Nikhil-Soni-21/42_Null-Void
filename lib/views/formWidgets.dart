import 'dart:io';
import 'package:flutter/material.dart';

Widget formTextField(
    String label, TextEditingController controller, Function validator) {
  return TextField(
    cursorColor: Colors.white,
    controller: controller,
    decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 22, color: Colors.white),
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
          border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(12.0),
          borderSide: new BorderSide(color: Colors.orange),
        )),
    obscureText:
    label == "Password" || label == "Confirm Password" ? true : false,
  );
}