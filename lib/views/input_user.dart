import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_app/views/character_selection.dart';
import 'package:tracker_app/views/formWidgets.dart';

class inputUser extends StatefulWidget {
  const inputUser({Key? key}) : super(key: key);

  @override
  _inputUserState createState() => _inputUserState();
}

class _inputUserState extends State<inputUser> {
  double _workSliderValue = 1;
  double sideProjectSliderValue = 1;
  double stepTargetSliderValue = 1000;

  var _formKey = GlobalKey<FormState>();
  TextEditingController NameController = TextEditingController();
  TextEditingController AgeController = TextEditingController();
  TextEditingController HeightController = TextEditingController();
  TextEditingController WeightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Enter Basic Details',
                    style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: formTextField(TextInputType.name, "Name",
                            NameController, _validateUsername, null)),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        flex: 1,
                        child: formTextField(TextInputType.number, "Age",
                            AgeController, _validateAge, 'Years')),
                  ]),
                  SizedBox(
                    height: 30,
                  ),
                  Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: formTextField(TextInputType.number, "Height",
                            HeightController, _validateHeight, 'Cm')),
                    SizedBox(
                      width: 6,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        flex: 1,
                        child: formTextField(TextInputType.number, "Weight",
                            WeightController, _validateWeight, 'Kg')),
                  ]),
                  SizedBox(
                    height: 22,
                  ),
                  Divider(height: 2,color: Colors.white,),
                  SizedBox(
                    height: 22,
                  ),
                  Text(
                    'Set your daily goals',
                    style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
                  ),
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
                            label: _workSliderValue.toString() + " Hrs",
                            value: _workSliderValue,
                            min: 0,
                            max: 8,
                            divisions: 32,
                            onChanged: (double value) {
                              setState(() {
                                _workSliderValue = value;
                              });
                            }),
                      ),
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
                            label: sideProjectSliderValue.toString() + " Hrs",
                            value: sideProjectSliderValue,
                            min: 0,
                            max: 8,
                            divisions: 32,
                            onChanged: (double value) {
                              setState(() {
                                sideProjectSliderValue = value;
                              });
                            }),
                      ),
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
                            label: double.parse(
                                    stepTargetSliderValue.toStringAsFixed(0))
                                .toInt()
                                .toString(),
                            value: stepTargetSliderValue,
                            min: 1000,
                            max: 24000,
                            divisions: 23,
                            onChanged: (double value) {
                              setState(() {
                                stepTargetSliderValue = value;
                              });
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 34,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {
                            saveData();
                          },
                          icon: Icon(Icons.save_outlined),
                          label: Text("Save"))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
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

  Future<void> saveData() async {
    if (NameController.text == "" &&
        AgeController.text == "" &&
        HeightController.text == "" &&
        WeightController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please add all values. :("),
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userName", NameController.text);
    await prefs.setString("userAge", AgeController.text);
    await prefs.setString("userHeight", HeightController.text);
    await prefs.setString("userWeight", WeightController.text);

    await prefs.setInt("Work_goal", hoursToMilliseconds(_workSliderValue));
    await prefs.setInt(
        "Side Project_goal", hoursToMilliseconds(sideProjectSliderValue));
    await prefs.setDouble("Step_goal", stepTargetSliderValue);

    await prefs.setInt("Exercise_goal", 6);
    await prefs.setInt("Exercise_timeToday", 0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Values Saved Successfully"),
      ),
    );

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => characterSelection()));
  }

  int hoursToMilliseconds(double val) {
    int hours = int.parse(val.toString().split('.')[0]);
    int minutes = 0;
    if (int.parse(val.toString().split('.')[1]) != 0) {
      if (int.parse(val.toString().split('.')[1]) == 25) minutes = 15;
      if (int.parse(val.toString().split('.')[1]) == 25) minutes = 30;
      if (int.parse(val.toString().split('.')[1]) == 25) minutes = 45;
    }
    return Duration(hours: hours, minutes: minutes).inMilliseconds;
  }
}
