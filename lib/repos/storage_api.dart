import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, int>> getCarouselData() async {
  //await setDummyData();
  Map<String, int> data = Map();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Set<String> keys = prefs.getKeys();

  for (String key in keys) {
    try {
      data[key] = prefs.getInt(key) ?? 0;
    } catch (error) {
      continue;
    }
    print(" $key - ${data[key]}");
  }
  return data;
}

Future<Map<String, String?>> getAvatarData() async {
  Map<String, String?> data = Map();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  data["avatarName"] = prefs.getString("avatarName");
  data["avatarGender"] = prefs.getString("avatarGender");
  return data;
}

Future<void> setDummyData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // print(prefs.getString("userName"));
  // print(prefs.getString("userAge"));
  // print(prefs.getString("userHeight"));
  // print(prefs.getInt("Work_goal"));
  // print(prefs.getString("userWeight"));
  // print(prefs.getInt("Side Project_goal"));
  // print(prefs.getDouble("Step_goal"));
}

Future<double> calculateScore(Map<String, int> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double? yesterday = prefs.getDouble("yesterdayScore");
  double? dayBefore = prefs.getDouble("dayBefore_score");
  double? dayBefore2 = prefs.getDouble("dayBefore2_score");

  double res = 0;
  double avg = 0;
  int n = 0;
  Set<String> keys = prefs.getKeys();
  for (String key in keys) {
    if (key.endsWith('_goal')) {
      if (key == "Step_goal") continue;
      int? temp = prefs.getInt('${(key.split('_'))[0]}_timeToday') ?? 0;
      double val = temp / prefs.getInt(key)!;

      avg += val;

      n++;
    }
  }

  res = avg / n;

  res =
      (res + (yesterday ?? 0.5) + (dayBefore ?? 0.5) + (dayBefore2 ?? 0.5)) / 4;
  print("res $res");
  prefs.setDouble("total_score", res);
  return res;
}
