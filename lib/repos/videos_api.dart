import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Videos> getVideos(String type) async {
  final http.Response response = await http.get(
    Uri.parse(
        'https://script.google.com/macros/s/AKfycbx5k6Ec05KnEIe9BN1f-XZfKVhOkvNVnWITz1rBBp1twdtBpKQ/exec?type=$type'),
    headers: <String, String>{
      'accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print("Quote api call successful");
    return Videos.fromJson(response.body);
  } else {
    print("Quote api call FAILED");
    return Videos(title: "null", image: "null", link: "null");
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