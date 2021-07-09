import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class StopWatchPage extends StatefulWidget {
  String activityType;
  Color colorTheme;

  StopWatchPage({
    Key? key,
    required this.activityType,
    required this.colorTheme,
  }) : super(key: key);

  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage>
    with SingleTickerProviderStateMixin {
  late Stopwatch _stopwatch;
  late Timer _timer;
  late AnimationController _playPauseController;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _playPauseController =
        AnimationController(vsync: this, duration: Duration(microseconds: 300));
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
    setState(() {
      if (_stopwatch.isRunning) {
        _playPauseController.reverse();
        _stopwatch.stop();
      } else {
        _playPauseController.forward();
        _stopwatch.start();
      }
    });
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
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 180,
                  width: 180,
                  child: RiveAnimation.asset(
                    "assets/clock.riv",
                  ),
                ),
                SizedBox(height: 10),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      onPressed: handleStartStop,
                      tooltip: _stopwatch.isRunning
                          ? 'Pause ${widget.activityType}'
                          : 'Start ${widget.activityType}',
                      elevation: 0,
                      child: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: _playPauseController,
                      ),
                    ),
                    SizedBox(width: 10),
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _stopwatch.reset();
                        });
                      },
                      backgroundColor: Colors.red,
                      child: Icon(Icons.stop_rounded),
                    ),
                  ],
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
                          //TODO
                        },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Text("Complete Activity",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _playPauseController.dispose();
    super.dispose();
  }
}
