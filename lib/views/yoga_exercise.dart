import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_app/repos/videos_api.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: videos,
            builder: (context, AsyncSnapshot<List<Videos>> snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator()),
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
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final Videos video;

  const VideoCard({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launch(video.link).onError((error, stackTrace) {
          print("Error: $error");
          return true;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
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
                      placeholder: 'assets/pl_image.png', image: video.image,fit: BoxFit.fill,)),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    video.title,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
