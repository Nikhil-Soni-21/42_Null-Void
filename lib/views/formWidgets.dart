import 'package:flutter/material.dart';

Widget formTextField(
    TextInputType type,
    String label, TextEditingController controller, Function validator,String? st) {
  return TextField(
    style: TextStyle(color: Colors.white),
    cursorColor: Colors.white,
    controller: controller,
    keyboardType: type,
    decoration: InputDecoration(
      labelStyle: TextStyle(fontSize: 22, color: Colors.white),
      labelText: label,
      suffixText: st,
      suffixStyle: TextStyle(color: Colors.white),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      enabledBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(12.0),
        borderSide: new BorderSide(color: Colors.white, width: 2),
      ),
      focusedBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(12.0),
        borderSide: new BorderSide(color: Colors.blue, width: 2),
      ),
    ),
  );
}