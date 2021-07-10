import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Videos>> getVideos(String type) async {
  final http.Response response = await http.get(
    Uri.parse(
        'https://script.google.com/macros/s/AKfycbzoqr-gdu7_dJJOQXztsiEr98cO3aDipXjgQo0ltI9v6EJlV-U/exec?type=$type'),
    headers: <String, String>{
      'accept': 'application/json',
    },
  );

  List<Videos> myModel = [];

  if (response.statusCode == 200) {
    print("Video api call successful");

    var responseBody = response.body;
    var jsonBody = json.decode(responseBody);

    for(var data in jsonBody){
      myModel.add(new Videos(title: data['title'], image: data['image'], link: data['link']));
    }
    return myModel;
  } else {
    print("Video api call FAILED");
    return [];
  }
}

class Videos {
  String title;
  String image;
  String link;
  Videos({
    required this.title,
    required this.image,
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      "link" : link,
    };
  }

  factory Videos.fromMap(Map<String, dynamic> map) {
    return Videos(
      title: map['title'],
      image: map['image'],
      link : map["link"]
    );
  }

  factory Videos.fromJson(String source) => Videos.fromMap(json.decode(source));
}