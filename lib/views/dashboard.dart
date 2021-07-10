import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedometer/pedometer.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:rive/rive.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tracker_app/repos/quotes_api.dart';
import 'package:tracker_app/repos/storage_api.dart';
import 'package:tracker_app/views/exercise.dart';
import 'package:tracker_app/views/stopwatchPage.dart';
import 'package:tracker_app/views/yoga.dart';
import 'package:tracker_app/views/yogaRoutine.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  late Future<Quote> quote;
  late final Stream<StepCount> _stepCountStream;
  Map<String, int> carouselData = Map();
  int steps = 0;
  double? totalScore;
  @override
  void initState() {
    quote = getQuote();
    _stepCountStream = Pedometer.stepCountStream;

    _stepCountStream.listen((StepCount event) {
      print("step = ${event.steps}");
      setState(() {
        steps = event.steps;
      });
    }).onError((error) {
      print(error);
    });

    getCarouselData().then((value) {
      carouselData = value;
      totalScore = await calculateScore(value);
      setState(() {});
    });
    super.initState();
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topBar(),
                Row(
                  children: [
                    _avatar(),
                    Flexible(
                      child: _moodMeter(),
                      flex: 0,
                    )
                  ],
                ),
                SizedBox(height: 32),
                _bottom(),
                SizedBox(
                  height: 32,
                ),
                CarouselSlider(
                  items: [
                    _motivationCard(),
                    _carouselExerciseProgress(),
                    _carouselWorkProgress(),
                    _carouselSideProjectsProgress(),
                    _carouselYogaProgress()
                  ],
                  options: CarouselOptions(
                      height: 180,
                      viewportFraction: 1,
                      enlargeCenterPage: false,
                      autoPlay: true,
                      enableInfiniteScroll: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(seconds: 1),
                      autoPlayCurve: Curves.fastOutSlowIn),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _motivationCard() {
    return FutureBuilder(
        future: quote,
        builder: (context, AsyncSnapshot<Quote> snapshot) {
          if (snapshot.data == null) {
            return Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Shimmer.fromColors(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.all(16),
                        width: double.maxFinite,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      Container(
                        margin: EdgeInsets.all(16),
                        width: 80,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12)),
                      )
                    ],
                  ),
                  baseColor: Colors.grey,
                  highlightColor: Colors.grey.shade100),
            );
          } else {
            return Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("\"${snapshot.data?.quote ?? ""}\"",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        )),
                    SizedBox(
                      height: 22,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "-- ${snapshot.data?.by ?? ""}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget _avatar() {
    return Flexible(
      child: SizedBox(
          height: 300, child: RiveAnimation.asset("assets/mood_sad.riv")),
    );
  }

  Widget _topBar() {
    var steps = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Chip(
          padding: EdgeInsets.symmetric(horizontal: 8),
          avatar: Image.asset("assets/icon_footsteps.png"),
          backgroundColor: Colors.black,
          label: steps == 0
              ? Text(
                  "Pedometer not available",
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  "$steps steps",
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }

  Widget _bottom() {
    var buttonStyle = ElevatedButton.styleFrom(
        primary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ));
    return Column(
      children: [
        Text("What do you want to do next?",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            )),
        SizedBox(height: 22),
        Wrap(
          direction: Axis.horizontal,
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StopwatchPage(
                                activityType: "Work",
                                colorTheme: Colors.yellow,
                              ))).then((value) {
                    setState(() {
                      getCarouselData().then((value) async {
                        carouselData = value;
                        totalScore = await calculateScore(value);
                        setState(() {});
                      });
                    });
                  });
                },
                style: buttonStyle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/icon_work.png",
                        width: 38,
                        height: 38,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Work",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => YogaExerciseRoutinePage()));
                },
                style: buttonStyle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/icon_exercise.png",
                        width: 38,
                        height: 38,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Exercise",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StopwatchPage(
                        activityType: "Side Project",
                        colorTheme: Colors.yellow,
                      ),
                    ),
                  ).then((value) {
                    setState(() {
                      getCarouselData().then((value) async {
                        carouselData = value;
                        totalScore = await calculateScore(value);
                        setState(() {});
                      });
                    });
                  });
                },
                style: buttonStyle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/icon_project.png",
                        width: 38,
                        height: 38,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Side Project",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => yoga()));
              },
              style: buttonStyle,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/icon_yoga.png",
                      width: 38,
                      height: 38,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Yoga",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _carouselWorkProgress() {
    double steps = 0;
    if (carouselData["Work_timeToday"] != null &&
        carouselData["Work_goal"] != null)
      steps = (carouselData["Work_timeToday"]! / carouselData["Work_goal"]!);

    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: steps,
                    strokeWidth: 6,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    valueColor: AlwaysStoppedAnimation(Colors.pink),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, top: 24),
                  child: Text(
                    "Work Progress",
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                )
              ],
            ),
            Text(
                "Time Spent: ${formatTime(carouselData["Work_timeToday"]) ?? "0"}",
                style: TextStyle(fontSize: 16.0, color: Colors.white)),
            Text(
                "Goal for today: ${formatTime(carouselData["Work_goal"]) ?? "0"}",
                style: TextStyle(fontSize: 16.0, color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget _carouselExerciseProgress() {
    var steps = 0.0;
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: steps,
                strokeWidth: 6,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                valueColor: AlwaysStoppedAnimation(Colors.orange),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22.0, top: 24),
              child: Text(
                "Exercise Progress",
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _carouselSideProjectsProgress() {
    double steps = 0;
    if (carouselData["Side Project_timeToday"] != null &&
        carouselData["Side Project_goal"] != null)
      steps = (carouselData["Side Project_timeToday"]! /
          carouselData["Side Project_goal"]!);
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: steps,
                    strokeWidth: 6,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    valueColor: AlwaysStoppedAnimation(Colors.blue.shade200),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45.0, top: 20),
                  child: Text(
                    "Side Project\n  Progress",
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                )
              ],
            ),
            Text(
                "Time Spent: ${formatTime(carouselData["Side Project_timeToday"]) ?? "0"}",
                style: TextStyle(fontSize: 16.0, color: Colors.white)),
            Text(
                "Goal for today: ${formatTime(carouselData["Side Project_goal"]) ?? "0"}",
                style: TextStyle(fontSize: 16.0, color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget _carouselYogaProgress() {
    var steps = 0.3;
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: steps,
                strokeWidth: 6,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, top: 24),
              child: Text(
                "Yoga Progress",
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _moodMeter() {
    var moodValue = totalScore ?? 0.6;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 200,
          child: LiquidLinearProgressIndicator(
            value: moodValue,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
            borderRadius: 32,
            backgroundColor: Colors.black,
            direction: Axis.vertical,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/happy_smiley.png",
                height: 24,
                width: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 64.0, bottom: 64.0),
                child: Image.asset(
                  "assets/normal_smiley.png",
                  height: 24,
                  width: 24,
                ),
              ),
              Image.asset(
                "assets/sad_smiley.png",
                height: 24,
                width: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String? formatTime(int? milliseconds) {
    if (milliseconds == null) return null;
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
}
