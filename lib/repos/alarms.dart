import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_app/repos/storage_api.dart';

Future<void> setMidnightAlarm() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Cron cron = Cron();
  print("Cron Scheduled-");
  cron.schedule(new Schedule.parse('0 0 * * *'), () async {
    print("CRON TRIGGERED");
    Set<String> keys = prefs.getKeys();
    for (String key in keys) {
      if (!key.endsWith('_timeToday')) continue;
      prefs.setInt(key, 0);
      print("CHANGED $key");
    }
    _storePrevDay();
  });
}

Future<void> _storePrevDay() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  double? today = prefs.getDouble("total_score");
  double? yesterday = prefs.getDouble("yesterdayScore");
  double? dayBefore = prefs.getDouble("dayBefore_score");
  double? dayBefore2 = prefs.getDouble("dayBefore2_score");

  prefs.setDouble("total_score", 0);
  prefs.setDouble("yesterdayScore", today ?? 0.5);
  prefs.setDouble("dayBefore_score", yesterday ?? 0.5);
  prefs.setDouble("dayBefore2_score", dayBefore ?? 0.5);
}
