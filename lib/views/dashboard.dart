import 'package:flutter/material.dart';
import 'package:tracker_app/widgets/coloredRoundedCard.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _motivationCard(),
                SizedBox(height: 16),
                Flexible(flex: 2, child: _avatar()),
                SizedBox(height: 16),
                Flexible(
                  child: _bottom(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _motivationCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("\" Nathu katta nikal bahut bakchodi ho rahi hai \"",
              style: TextStyle(fontSize: 20)),
          Text("-Mahatma Gandhi", style: TextStyle(fontSize: 16))
        ],
      ),
    );
  }

  // Widget _statusCard() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text("Status: ",
  //             style: TextStyle(
  //                 fontSize: 22,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white)),
  //         Text("Jinda hu bsdk",
  //             style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white)),
  //         Wrap(
  //           direction: Axis.horizontal,
  //           children: [
  //             Text("Physical Health: ",
  //                 style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white)),
  //             Text(" nahi degi ",
  //                 style: TextStyle(fontSize: 18, color: Colors.white)),
  //           ],
  //         ),
  //         Wrap(
  //           direction: Axis.horizontal,
  //           children: [
  //             Text("Mental Health: ",
  //                 style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white)),
  //             Text("konsi? ",
  //                 style: TextStyle(fontSize: 18, color: Colors.white))
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _avatar() {
    return Placeholder();
  }

  Widget _bottom() {
    return Column(
      children: [
        Text(
          "What do you want to do next?",
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Wrap(
          direction: Axis.horizontal,
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(primary: Colors.green.shade700),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Work"),
                )),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(primary: Colors.green.shade700),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Exercise"),
                )),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(primary: Colors.green.shade700),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Side Project"),
                )),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(primary: Colors.green.shade700),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Read"),
                )),
          ],
        ),
      ],
    );
  }
}
