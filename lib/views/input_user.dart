import 'package:flutter/material.dart';
import 'package:tracker_app/views/formWidgets.dart';

class inputUser extends StatefulWidget {
  const inputUser({Key? key}) : super(key: key);

  @override
  _inputUserState createState() => _inputUserState();
}

class _inputUserState extends State<inputUser> {
  double _workSliderValue = 0;
  double sideProjectSliderValue = 0;
  double stepTargetSliderValue = 0;

  var _formKey = GlobalKey<FormState>();
  TextEditingController NameController = TextEditingController();
  TextEditingController AgeController = TextEditingController();
  TextEditingController HeightController = TextEditingController();
  TextEditingController WeightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Enter Your details"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: formTextField(
                          "Name", NameController, _validateUsername)),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      flex: 1,
                      child: formTextField("Age", AgeController, _validateAge)),
                ]),
                SizedBox(
                  height: 30,
                ),
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: formTextField(
                          "Height", HeightController, _validateHeight)),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    "Cm",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      flex: 1,
                      child: formTextField(
                          "Weight", WeightController, _validateWeight)),
                  Text(
                    "Kg",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ]),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Work Target: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Slider(
                          value: _workSliderValue,
                          min: 0,
                          max: 100,
                          divisions: 10,
                          onChanged: (double value) {
                            setState(() {
                              _workSliderValue = value;
                            });
                          }),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Side Project: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Slider(
                          value: sideProjectSliderValue,
                          min: 0,
                          max: 100,
                          divisions: 10,
                          onChanged: (double value) {
                            setState(() {
                              sideProjectSliderValue = value;
                            });
                          }),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Step Target: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Slider(
                          value: stepTargetSliderValue,
                          min: 0,
                          max: 100,
                          divisions: 10,
                          onChanged: (double value) {
                            setState(() {
                              stepTargetSliderValue = value;
                            });
                          }),
                    )
                  ],
                ),
                SizedBox(
                  height: 34,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text("Save"))
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  String? _validateUsername(String? val) {
    if (val == null || val.length == 0) return "Name cannot be empty";

    return null;
  }

  String? _validateAge(String? val) {
    if (val == null || val.length == 0) return "Age cannot be empty";
    return null;
  }

  String? _validateHeight(String? val) {
    if (val == null || val.length == 0) return "Height cannot be empty";
    return null;
  }

  String? _validateWeight(String? val) {
    if (val == null || val.length == 0) return "Weight cannot be empty";
    return null;
  }
}
