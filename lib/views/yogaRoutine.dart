import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YogaExerciseRoutinePage extends StatefulWidget {
  final List<String> titles;
  final List<int> intervals;
  final String name;

  const YogaExerciseRoutinePage(
      {Key? key,
      required this.name,
      required this.titles,
      required this.intervals})
      : super(key: key);

  @override
  _YogaExerciseRoutinePageState createState() =>
      _YogaExerciseRoutinePageState();
}

class _YogaExerciseRoutinePageState extends State<YogaExerciseRoutinePage>
    with SingleTickerProviderStateMixin {
  String? mainText;
  int? clockTime;
  int timeLimit = 0;
  bool firstTime = true;
  late Stopwatch _stopwatch;
  late Timer timerMain;
  bool redoButtonActive = false;

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void initState() {
    _stopwatch = Stopwatch();
    timerMain = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      setState(() {});
    });

    super.initState();
  }

  Future<void> segmentController(String text, int timeDuration) async {
    mainText = text;
    timeLimit = timeDuration;
    _stopwatch.start();

    await Future.delayed(Duration(milliseconds: timeDuration)).then((value) {
      _stopwatch.stop();
      _stopwatch.reset();
    });
  }

  Future<void> exerciseHandler(List<String> texts, List<int> durations) async {
    redoButtonActive = false;
    for (int i = 0; i < texts.length; i++) {
      await segmentController(texts[i], durations[i]);
    }

    mainText = "Done activity!";
    _stopwatch.reset();
    timeLimit = 0;
    redoButtonActive = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? temp = prefs.getInt("Exercise_timeToday");
    if (temp == null) {
      prefs.setInt("Exercise_timeToday", 0);
    } else
      prefs.setInt("Exercise_timeToday", temp++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mainText ?? widget.name,
                style: Theme.of(context).textTheme.headline1?.copyWith(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Relax and follow the instructions",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(fontSize: 20, color: Colors.white)),
            SizedBox(height: 10),
            Text(formatTime(timeLimit - _stopwatch.elapsedMilliseconds),
                style: TextStyle(fontSize: 48.0, color: Colors.white)),
            SizedBox(height: 10),
            Visibility(
              visible: _stopwatch.isRunning ? false : true,
              child: FloatingActionButton.extended(
                onPressed: () {
                  _stopwatch.isRunning
                      ? null
                      : exerciseHandler(widget.titles, widget.intervals);
                },
                backgroundColor:
                    _stopwatch.isRunning ? Colors.red : Colors.blue,
                icon: Icon(_stopwatch.isRunning
                    ? Icons.pause
                    : redoButtonActive
                        ? Icons.refresh
                        : Icons.play_arrow_outlined),
                label: Text(_stopwatch.isRunning
                    ? 'Stop'
                    : redoButtonActive
                        ? 'Restart'
                        : 'Start'),
              ),
            ),
            SizedBox(
              height: 22,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timerMain.cancel();
    super.dispose();
  }
}
