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
        backgroundColor: Colors.orange,
        title: Text("Select Your Character"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(children: [
            Row(
              children: [_avatarMale(), _avatarFemale()],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28),
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selected = 1;
                        });
                      },
                      child: Row(
                        children: [
                          selected == 1 ? Icon(Icons.done) : Container(),
                          Text(
                            "Select John",
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 36, right: 18),
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selected = 2;
                        });
                      },
                      child: Row(
                        children: [
                          selected == 2 ? Icon(Icons.done) : Container(),
                          Text(
                            "Select Jane",
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange)),
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
                  style: TextStyle(fontSize: 36, color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 60.0, left: 60.0),
                  child: formTextField(
                      "", CharacterNameController, _validateCharacterName),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    saveData();
                  },
                  child: Text("Save"),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange)),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Widget _avatarMale() {
    return Flexible(
      child: SizedBox(
          height: 300,
          child: RiveAnimation.asset("assets/male_mood_happy.riv")),
    );
  }

  Widget _avatarFemale() {
    return Flexible(
      child: SizedBox(
          height: 300,
          child: RiveAnimation.asset("assets/female_happy_mood.riv")),
    );
  }

  String? _validateCharacterName(String? val) {
    if (val == null || val.length == 0) return "Name cannot be empty";

    return null;
  }

  Future<void> saveData() async {
    if (CharacterNameController.text == "" && selected == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select a name and avatar"),
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("avatarName", CharacterNameController.text);
    if (selected == 1) prefs.setString("avatarGender", "male");
    if (selected == 2) prefs.setString("avatarGender", "female");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Your avatar is ready!!"),
      ),
    );

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardPage()));
  }
}
