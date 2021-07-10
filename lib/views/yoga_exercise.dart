import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_app/repos/videos_api.dart';
import 'package:tracker_app/views/yogaRoutine.dart';
import 'package:url_launcher/url_launcher.dart';

class YogaExercise extends StatefulWidget {
  final String type;

  const YogaExercise({Key? key, required this.type}) : super(key: key);

  @override
  _YogaExerciseState createState() => _YogaExerciseState();
}

class _YogaExerciseState extends State<YogaExercise> {
  late Future<List<Videos>> videos;

  @override
  void initState() {
    videos = getVideos(widget.type.toLowerCase());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          widget.type,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: videos,
          builder: (context, AsyncSnapshot<List<Videos>> snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(),
                ),
              );
            } else
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, p) {
                  return VideoCard(video: snapshot.data![p]);
                },
                scrollDirection: Axis.vertical,
              );
          },
        ),
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final Videos video;

  const VideoCard({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (video.title == '?' && video.link == '?' && video.image == '?') {
      return _ExerciseButton(context);
    }
    return GestureDetector(
      onTap: () async {
        await launch(video.link).onError((error, stackTrace) {
          print("Error: $error");
          return true;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Card(
          color: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/pl_image.png',
                    height: 180,
                    image: video.image,
                    fit: BoxFit.fill,
                  )),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  video.title,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _ExerciseButton(context) {
    return Wrap(
      children: [
        _ButtonBuilder(
          context,
          'assets/ic_breath.png',
          'Breathing',
          YogaExerciseRoutinePage(
            name: 'Breathing Exercise',
            titles: ["Breathe in", "Hold Breath", "Breathe Out","Breathe in", "Hold Breath", "Breathe Out"],
            intervals: [6000, 8000, 9000,6000, 8000, 9000],
          ),
        ),
        _ButtonBuilder(
          context,
          'assets/ic_push_up.png',
          'Push Ups',
          YogaExerciseRoutinePage(
            name: 'Push ups',
            titles: ["Push up!!", "Break!!", "Push up!", "Break!!", "Almost!!"],
            intervals: [15000, 15000, 15000, 15000, 15000],
          ),
        ),
        _ButtonBuilder(
          context,
          'assets/ic_rope.png',
          'Jumping',
          YogaExerciseRoutinePage(
            name: 'Jumping Exercise',
            titles: [
              "Jump!!",
              "Take Rest",
              "Jump Again!",
              "Rest Time!!",
              "You Got it!"
            ],
            intervals: [20000, 12000, 20000, 12000,20000],
          ),
        ),
        _ButtonBuilder(
          context,
          'assets/ic_situp.png',
          'Sit Ups',
          YogaExerciseRoutinePage(
            name: 'Sit Ups',
            titles: [
              "Sit up!!",
              "Take Rest",
              "Sit up!",
              "Rest Time!!",
              "Again Sit up!"
            ],
            intervals: [15000, 15000, 15000, 15000, 15000],
          ),
        ),
      ],
    );
  }

  Widget _ButtonBuilder(context, asset, title, page) {
    var buttonStyle = ElevatedButton.styleFrom(
      primary: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        style: buttonStyle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                asset,
                width: 38,
                height: 38,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
