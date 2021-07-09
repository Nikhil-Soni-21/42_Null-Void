import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tracker_app/repos/quotes_api.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Quote> quote;

  @override
  void initState() {
    quote = getQuote();
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
                _avatar(),
                SizedBox(height: 32),
                _bottom(),
                SizedBox(height: 32,),
                CarouselSlider(
                  items: [
                    _motivationCard()
                  ],
                  options: CarouselOptions(
                    height: 180,
                    viewportFraction: 1,
                    enlargeCenterPage: false,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn
                  ),
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
            return SizedBox(
              width: 200,
              height: 100,
              child: Shimmer.fromColors(
                  child: Container(),
                  baseColor: Colors.amber,
                  highlightColor: Colors.black),
            );
          } else {
            return Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "\"${snapshot.data?.quote}\"" ?? "",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        )),
                    SizedBox(height: 22,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "-- ${snapshot.data?.by}" ?? "",
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

  //2A2F3A

  Widget _avatar() {
    return SizedBox(
        height: 300, child: RiveAnimation.asset("assets/mood_sad.riv"));
  }

  Widget _topBar() {
    var calories = 0;
    var steps = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Chip(
          padding: EdgeInsets.symmetric(horizontal: 8),
          avatar: Image.asset("assets/icon_footsteps.png"),
          backgroundColor: Colors.black,
          label: Text(
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
                onPressed: () {},
                style: buttonStyle,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                onPressed: () {},
                style: buttonStyle,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                onPressed: () {},
                style: buttonStyle,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                onPressed: () {},
                style: buttonStyle,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/icon_read.png",
                        width: 38,
                        height: 38,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Read",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ],
    );
  }

  Widget _carouselExercise() {
    var steps = 30.0;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircularProgressIndicator(
                strokeWidth: 8,
                value: steps,
                backgroundColor: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }
}
