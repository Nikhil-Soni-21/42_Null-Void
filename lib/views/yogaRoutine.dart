import 'dart:async';

import 'package:flutter/material.dart';

List<String> breathingExercise1 = ["Breathe in", "Hold Breath", "Breathe Out"];
List<int> breathingExercise1Time = [6000, 8000, 9000];

class YogaExerciseRoutinePage extends StatefulWidget {
  const YogaExerciseRoutinePage({Key? key}) : super(key: key);

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
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
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
    print("Starting");

    await Future.delayed(Duration(milliseconds: timeDuration)).then((value) {
      _stopwatch.stop();
      _stopwatch.reset();
    });
  }

  Future<void> exerciseHandler(List<String> texts, List<int> durations) async {
    for (int i = 0; i < texts.length; i++) {
      await segmentController(texts[i], durations[i]);
    }

    mainText = "Done activity!";
    _stopwatch.reset();
    timeLimit = 0;
    redoButtonActive = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icon_yoga.png",
            width: 50,
            height: 50,
          ),
          SizedBox(height: 20),
          Text(mainText ?? "",
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
          !firstTime
              ? Container()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    exerciseHandler(breathingExercise1, breathingExercise1Time);
                    setState(() {
                      firstTime = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Text(
                      "Start Activity",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
          !redoButtonActive
              ? Container()
              : FloatingActionButton(
                  backgroundColor: Colors.purple,
                  onPressed: () {
                    setState(() {
                      _stopwatch.reset();
                      exerciseHandler(
                          breathingExercise1, breathingExercise1Time);
                    });
                  },
                  child: Icon(
                    Icons.replay_outlined,
                    size: 32,
                  ),
                ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    timerMain.cancel();
    super.dispose();
  }
}
