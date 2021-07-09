import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rive/rive.dart';

class StopwatchPage extends StatefulWidget {
  String activityType;
  Color colorTheme;
  StopwatchPage({
    Key? key,
    required this.activityType,
    required this.colorTheme,
  }) : super(key: key);

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void handleStartStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
    setState(() {}); // re-render the page
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_stopwatch.elapsedMilliseconds == 0)
          return true;
        else {
          var response = await showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                    title: Text("Exit?"),
                    content: Text("You will lose progress if you exit"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          return Navigator.of(context).pop(false);
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          return Navigator.of(context).pop(true);
                        },
                        child: Text("Exit"),
                      ),
                    ],
                  ));
          if (response)
            return true;
          else
            return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: RiveAnimation.asset("assets/clock.riv"),
                ),
                Hero(
                  tag: widget.activityType,
                  child: Text(widget.activityType,
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10),
                Text(formatTime(_stopwatch.elapsedMilliseconds),
                    style: TextStyle(fontSize: 48.0, color: Colors.white)),
                SizedBox(height: 10),
                ElevatedButton(
                    onPressed: handleStartStop,
                    child: Text(_stopwatch.isRunning
                        ? 'Pause ${widget.activityType}'
                        : 'Start ${widget.activityType}')),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _stopwatch.reset();
                    setState(() {});
                  },
                  child: Text(
                    "Reset",
                  ),
                ),
                SizedBox(height: 10),
                Text("You cannot leave this page while the timer is running",
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: widget.colorTheme),
                    onPressed: _stopwatch.elapsedMilliseconds == 0
                        ? null
                        : () {
                            storeData(context);
                          },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Text("Complete Activity",
                          style: TextStyle(color: Colors.black)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void storeData(BuildContext context) async {
    _stopwatch.stop();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          "Good Job! Activity Saved : Time Worked : ${formatTime(_stopwatch.elapsedMilliseconds)} "),
    ));

    //saving to storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? oldTime = prefs.getInt("${widget.activityType}_timeToday");
    if (oldTime != null)
      oldTime += _stopwatch.elapsedMilliseconds;
    else
      oldTime = _stopwatch.elapsedMilliseconds;
    prefs.setInt("${widget.activityType}_timeToday", oldTime);
    _stopwatch.reset();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
