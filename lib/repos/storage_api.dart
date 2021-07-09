import 'package:shared_preferences/shared_preferences.dart';

void getCarouselData() async {
  await setDummyData();
  Map<String, int?> data = Map();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Set<String> keys = prefs.getKeys();

  for (String key in keys) {
    data[key] = prefs.getInt(key) ?? 0;
    print(" $key - ${data[key]}");
  }
}

Future<void> setDummyData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt("Work_goal", 180000);
  prefs.setInt("Side Project_goal", 180000);
}
