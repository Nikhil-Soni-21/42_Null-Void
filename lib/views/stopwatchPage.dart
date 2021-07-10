import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class _StopwatchPageState extends State<StopwatchPage>
    with SingleTickerProviderStateMixin {
  late Stopwatch _stopwatch;
  late Timer _timer;
  late AnimationController _playController;
  late RiveAnimationController _riveAnimationController;
  late RiveAnimationController _checkController;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _playController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _riveAnimationController = SimpleAnimation("Animation 1", autoplay: false);
    _checkController = SimpleAnimation("show",autoplay: true);
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
      _playController.reverse();
      _riveAnimationController.isActive = false;
    } else {
      _stopwatch.start();
      _playController.forward();
      _riveAnimationController.isActive = true;
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
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text("Exit?",style: TextStyle(color: Colors.white),),
                    content: Text("You will lose progress if you exit",style: TextStyle(color: Colors.white),),
                    actions: [
                      TextButton(
                        onPressed: () {
                          return Navigator.of(context).pop(false);
                        },
                        child: Text("Cancel",style: TextStyle(color: Colors.white),),
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
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    controllers: [_riveAnimationController],
                    onInit: (_) {
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(widget.activityType,
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(formatTime(_stopwatch.elapsedMilliseconds),
                    style: TextStyle(fontSize: 48.0, color: Colors.white)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FloatingActionButton(
                      heroTag: "play",
                      onPressed: handleStartStop,
                      tooltip: _stopwatch.isRunning
                          ? 'Pause ${widget.activityType}'
                          : 'Start ${widget.activityType}',
                      child: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: _playController,
                      ),
                    ),
                    SizedBox(width: 22),
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        setState(() {
                          _stopwatch.reset();
                        });
                      },
                      child: Icon(
                        Icons.stop_rounded,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Text("You cannot leave this page while the timer is running",
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: widget.colorTheme,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: _stopwatch.elapsedMilliseconds == 0
                      ? null
                      : () {
                          storeData(context);
                        },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Complete Activity",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void storeData(BuildContext context) async {
    _stopwatch.stop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Good Job! Activity Saved : Time Worked : ${formatTime(_stopwatch.elapsedMilliseconds)} "),
      ),
    );

    _riveAnimationController.isActive = false;

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
    _playController.dispose();
    _riveAnimationController.dispose();
    _checkController.dispose();
    super.dispose();
  }
}
