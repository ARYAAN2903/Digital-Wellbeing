import 'dart:async';

import 'package:usage_stats/usage_stats.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:digital_wellbeing/service/format_time.dart';

const String NOTIFICATION_INTURRUPTION = "12";
const String DEVICE_UNLOCK = "18";
//
// void EventStats() {
//   TodayNotificationCount();
//   TodayNotificationCountByApp("com.instagram.android");
//   TodayMobileUnlockCount();
// }

/*
* Today stats
* */

// total notification count
Future<int> TodayNotificationCount() async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime startDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day);

  DateTime startDateUtc = startDate.toUtc();
  DateTime endDateUtc = now.toUtc();

  List<EventUsageInfo> events = await UsageStats.queryEvents(startDateUtc, endDateUtc);

  int notificationCount = 0;

  for (var event in events) {
    if (event.eventType == NOTIFICATION_INTURRUPTION) {
      notificationCount++;
    }
  }
  print(notificationCount);
  return notificationCount;
}

// total notification count by app
Future<int> TodayNotificationCountByApp(String package_name) async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime startDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day);

  DateTime startDateUtc = startDate.toUtc();
  DateTime endDateUtc = now.toUtc();

  List<EventUsageInfo> events = await UsageStats.queryEvents(startDateUtc, endDateUtc);

  int notificationCount = 0;

  for (var event in events) {
    if (event.eventType == NOTIFICATION_INTURRUPTION) {
      if (event.packageName == package_name) {
          notificationCount++;
      }
    }
  }

  print(notificationCount);
  return notificationCount;
}

// mobile unlock count

Future<int> TodayMobileUnlockCount() async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime startDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day);

  DateTime startDateUtc = startDate.toUtc();
  DateTime endDateUtc = now.toUtc();

  List<EventUsageInfo> events = await UsageStats.queryEvents(startDateUtc, endDateUtc);

  int unlockCount = 0;

  for (var event in events) {
    if (event.eventType == DEVICE_UNLOCK) {
      unlockCount++;
    }
  }
  print(unlockCount);
  return unlockCount;
}

/*
* Function to get app event logs
* */

Future<List<EventUsageInfo>> getAppEventLogs(String package_name) async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime startDate =
  tz.TZDateTime(tz.local, now.year, now.month, now.day);

  DateTime startDateUtc = startDate.toUtc();
  DateTime endDateUtc = now.toUtc();

  List<EventUsageInfo> events = await UsageStats.queryEvents(startDateUtc, endDateUtc);

  // Filter events for the specified package name
  List<EventUsageInfo> packageEvents =
  events.where((event) => event.packageName == package_name).toList();

  return packageEvents;
}