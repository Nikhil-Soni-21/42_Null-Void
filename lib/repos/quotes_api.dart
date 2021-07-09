import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Quote> getQuote() async {
  final http.Response response = await http.get(
    Uri.parse(
        'https://script.google.com/macros/s/AKfycbx5k6Ec05KnEIe9BN1f-XZfKVhOkvNVnWITz1rBBp1twdtBpKQ/exec'),
    headers: <String, String>{
      'accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print("Quote api call successfull");
    return Quote.fromJson(response.body);
  } else {
    print("Quote api call FAILED");
    return Quote(quote: " ", by: " ");
  }
}

class Quote {
  String quote;
  String by;
  Quote({
    required this.quote,
    required this.by,
  });

  Map<String, dynamic> toMap() {
    return {
      'quote': quote,
      'by': by,
    };
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      quote: map['quote'],
      by: map['by'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Quote.fromJson(String source) => Quote.fromMap(json.decode(source));
}
