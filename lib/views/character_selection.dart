import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_app/views/dashboard.dart';

import 'formWidgets.dart';

class characterSelection extends StatefulWidget {
  const characterSelection({Key? key}) : super(key: key);

  @override
  _characterSelectionState createState() => _characterSelectionState();
}

class _characterSelectionState extends State<characterSelection> {
  TextEditingController CharacterNameController = TextEditingController();
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Select Your Character"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(
            children: [_avatarMale(), _avatarFemale()],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28),
                  child: FilterChip(
                    backgroundColor: Colors.black,
                    selectedColor: Colors.blue,
                    label: Text(
                      'Select John',
                      style: TextStyle(color: Colors.white),
                    ),
                    selected: (selected == 1),
                    onSelected: (bool value) {
                      setState(() {
                        selected = 1;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 36, right: 18),
                  child: FilterChip(
                    label: Text(
                      'Select Jane',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black,
                    selectedColor: Colors.blue,
                    selected: (selected == 2),
                    onSelected: (bool value) {
                      setState(() {
                        selected = 2;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 36,
          ),
          Column(
            children: [
              Text(
                "Name your character: ",
                style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 60.0, left: 60.0),
                child: formTextField(TextInputType.name, "",
                    CharacterNameController, _validateCharacterName, null),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                saveData();
              },
              label: Text("Save"),
              icon: Icon(Icons.save),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _avatarMale() {
    return Flexible(
      child: SizedBox(
          height: 300, child: RiveAnimation.asset("assets/male_happy.riv")),
    );
  }

  Widget _avatarFemale() {
    return Flexible(
      child: SizedBox(
          height: 300, child: RiveAnimation.asset("assets/female_happy.riv")),
    );
  }

  String? _validateCharacterName(String? val) {
    if (val == null || val.length == 0) return "Name cannot be empty";

    return null;
  }

  Future<void> saveData() async {
    if (CharacterNameController.text == "" || selected == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select a name and avatar"),
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("avatarName", CharacterNameController.text);
    if (selected == 1) await prefs.setString("avatarGender", "male");
    if (selected == 2) await prefs.setString("avatarGender", "female");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Your avatar is ready!!"),
      ),
    );

    await prefs.setBool("first_time", false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardPage()));
  }
}
