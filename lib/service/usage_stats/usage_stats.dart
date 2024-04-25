import 'package:usage_stats/usage_stats.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

Future<int> DailyTotalUsage() async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime startDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day);

  DateTime startDateUtc = startDate.toUtc();
  DateTime endDateUtc = now.toUtc();

  int totalScreenTime = 0;

  // Define a list of system app package names
  List<String> systemApps = [
    // system apps any if we want to exclude
    "com.android.launcher",
  ];

  Map<String, UsageInfo> maxUsageMap = {};

  List<UsageInfo> usageStats =
      await UsageStats.queryUsageStats(startDateUtc, endDateUtc);

  for (var usageInfo in usageStats) {
    String packageName = usageInfo.packageName!;
    // Exclude system apps from calculation
    if (!systemApps.contains(packageName)) {
      if (!maxUsageMap.containsKey(packageName) ||
          int.parse(usageInfo.totalTimeInForeground ?? '0') >
              int.parse(
                  maxUsageMap[packageName]?.totalTimeInForeground ?? '0')) {
        maxUsageMap[packageName] = usageInfo;
      }
    }
  }

  List<UsageInfo> result = maxUsageMap.values.toList();

  result.sort((a, b) => int.parse(b.totalTimeInForeground ?? '0')
      .compareTo(int.parse(a.totalTimeInForeground ?? '0')));

  for (var usageInfo in result) {
    totalScreenTime += int.parse(usageInfo.totalTimeInForeground ?? '0');
  }

  return totalScreenTime;
}

// package_name : usage_duration in percentage
Future<Map<String, double>> DailyAppUsage() async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime startDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day);

  DateTime startDateUtc = startDate.toUtc();
  DateTime endDateUtc = now.toUtc();

  Map<String, double> appUsageStats = {};

  // Define a list of system app package names
  List<String> systemApps = [
    // system apps any if we want to exclude
    "com.android.launcher",
  ];

  Map<String, UsageInfo> maxUsageMap = {};

  List<UsageInfo> usageStats =
      await UsageStats.queryUsageStats(startDateUtc, endDateUtc);

  for (var usageInfo in usageStats) {
    String packageName = usageInfo.packageName!;
    // Exclude system apps from calculation
    if (!systemApps.contains(packageName)) {
      if (!maxUsageMap.containsKey(packageName) ||
          int.parse(usageInfo.totalTimeInForeground ?? '0') >
              int.parse(
                  maxUsageMap[packageName]?.totalTimeInForeground ?? '0')) {
        maxUsageMap[packageName] = usageInfo;
      }
    }
  }

  List<UsageInfo> result = maxUsageMap.values.toList();

  result.sort((a, b) => int.parse(b.totalTimeInForeground ?? '0')
      .compareTo(int.parse(a.totalTimeInForeground ?? '0')));

  int total = 0;
  for (var usageInfo in result) {
    total += int.parse(usageInfo.totalTimeInForeground ?? '0');
  }

  for (var usageInfo in result) {
    appUsageStats[usageInfo.packageName!] =
        ((int.parse(usageInfo.totalTimeInForeground ?? '0') / total) * 100);
  }

  return appUsageStats;
}

Future<Map<String, int>> ActualDailyAppUsage() async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime startDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day);

  DateTime startDateUtc = startDate.toUtc();
  DateTime endDateUtc = now.toUtc();

  Map<String, int> appUsageStats = {};

  // Define a list of system app package names
  List<String> systemApps = [
    // system apps any if we want to exclude
    "com.android.launcher",
  ];

  Map<String, UsageInfo> maxUsageMap = {};

  List<UsageInfo> usageStats =
      await UsageStats.queryUsageStats(startDateUtc, endDateUtc);

  for (var usageInfo in usageStats) {
    String packageName = usageInfo.packageName!;
    // Exclude system apps from calculation
    if (!systemApps.contains(packageName)) {
      if (!maxUsageMap.containsKey(packageName) ||
          int.parse(usageInfo.totalTimeInForeground ?? '0') >
              int.parse(
                  maxUsageMap[packageName]?.totalTimeInForeground ?? '0')) {
        maxUsageMap[packageName] = usageInfo;
      }
    }
  }

  List<UsageInfo> result = maxUsageMap.values.toList();

  result.sort((a, b) => int.parse(b.totalTimeInForeground ?? '0')
      .compareTo(int.parse(a.totalTimeInForeground ?? '0')));

  for (var usageInfo in result) {
    appUsageStats[usageInfo.packageName!] =
        int.parse(usageInfo.totalTimeInForeground ?? '0');
  }

  return appUsageStats;
}

Future<Map<String, double>> CurrentWeekAppUsage(String packageName) async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  DateTime startDateUtc = _getStartOfCurrentWeek(now).toUtc();
  DateTime endDateUtc = startDateUtc.add(const Duration(days: 7)).toUtc();

  // Define a list of system app package names
  List<String> systemApps = [
    // system apps any if we want to exclude
    "com.android.launcher",
  ];

  Map<String, double> appUsageStats = {};

  List<UsageInfo> usageStats = await UsageStats.queryUsageStats(startDateUtc, endDateUtc);

  for (var usageInfo in usageStats) {
    String currentPackageName = usageInfo.packageName!;
    // Exclude system apps from calculation
    if (!systemApps.contains(currentPackageName) && currentPackageName == packageName) {
      double usageTime = double.parse(usageInfo.totalTimeInForeground ?? '0');
      int lastTimeUsed = int.parse(usageInfo.firstTimeStamp!); // Parse to int
      DateTime usageDate = DateTime.fromMillisecondsSinceEpoch(lastTimeUsed);
      String dayOfWeek = _getDayOfWeek(usageDate.weekday);
      appUsageStats.update(dayOfWeek, (value) => value + usageTime, ifAbsent: () => usageTime);
    }
  }
  return appUsageStats;
}

Future<Map<String, double>> PreviousWeekAppUsage(String packageName) async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  DateTime startDateUtc = _getStartOfPreviousWeek(_getStartOfCurrentWeek(now)).toUtc();
  DateTime endDateUtc = startDateUtc.add(const Duration(days: 7));

  // Define a list of system app package names
  List<String> systemApps = [
    // system apps any if we want to exclude
    "com.android.launcher",
  ];

  Map<String, double> appUsageStats = {};

  List<UsageInfo> usageStats = await UsageStats.queryUsageStats(startDateUtc, endDateUtc);

  for (var usageInfo in usageStats) {
    String currentPackageName = usageInfo.packageName!;
    // Exclude system apps from calculation
    if (!systemApps.contains(currentPackageName) && currentPackageName == packageName) {
      double usageTime = double.parse(usageInfo.totalTimeInForeground ?? '0');
      int lastTimeUsed = int.parse(usageInfo.lastTimeUsed!); // Parse to int
      DateTime usageDate = DateTime.fromMillisecondsSinceEpoch(lastTimeUsed);
      String dayOfWeek = _getDayOfWeek(usageDate.weekday);
      appUsageStats.update(dayOfWeek, (value) => value + usageTime, ifAbsent: () => usageTime);
    }
  }
  return appUsageStats;
}

String _getDayOfWeek(int dayIndex) {
  // Weekday index starts from 1 (Monday) to 7 (Sunday)
  List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return days[dayIndex - 1];
}

Future<Map<String, double>> CurrentWeekScreenUsage() async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  // Get current date and time in local time zone
  tz.TZDateTime now = tz.TZDateTime.now(tz.local);

  // Get the start of the current week (Sunday)
  tz.TZDateTime startOfCurrentWeek = _getStartOfCurrentWeek(now);

  // Get the end of the current week (Saturday)
  tz.TZDateTime endOfCurrentWeek = startOfCurrentWeek.add(const Duration(days: 7));

  // Define a list of system app package names
  List<String> systemApps = [
    // system apps any if we want to exclude
    "com.android.launcher",
  ];

  Map<String, double> appUsageStats = {};

  List<UsageInfo> usageStats = await UsageStats.queryUsageStats(startOfCurrentWeek.toUtc(), endOfCurrentWeek.toUtc());

  for (var usageInfo in usageStats) {
    String packageName = usageInfo.packageName!;
    // Exclude system apps from calculation
    if (!systemApps.contains(packageName)) {
      double usageTime = double.parse(usageInfo.totalTimeInForeground ?? '0');
      int lastTimeUsed = int.parse(usageInfo.firstTimeStamp!); // Parse to int
      DateTime usageDate = DateTime.fromMillisecondsSinceEpoch(lastTimeUsed);
      String dayOfWeek = _getDayOfWeek(usageDate.weekday);
      appUsageStats.update(dayOfWeek, (value) => value + usageTime, ifAbsent: () => usageTime);
    }
  }
  return appUsageStats;
}

Future<Map<String, double>> PreviousWeekScreenUsage() async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  // Get current date and time in local time zone
  tz.TZDateTime now = tz.TZDateTime.now(tz.local);

  // Get the start of the previous week (Sunday)
  tz.TZDateTime startOfPreviousWeek = _getStartOfPreviousWeek(now);

  // Get the end of the previous week (Saturday)
  tz.TZDateTime endOfPreviousWeek = startOfPreviousWeek.add(const Duration(days: 7));

  // Define a list of system app package names
  List<String> systemApps = [
    // system apps any if we want to exclude
    "com.android.launcher",
  ];

  Map<String, double> appUsageStats = {};

  List<UsageInfo> usageStats = await UsageStats.queryUsageStats(startOfPreviousWeek.toUtc(), endOfPreviousWeek.toUtc());

  for (var usageInfo in usageStats) {
    String packageName = usageInfo.packageName!;
    // Exclude system apps from calculation
    if (!systemApps.contains(packageName)) {
      double usageTime = double.parse(usageInfo.totalTimeInForeground ?? '0');
      int lastTimeUsed = int.parse(usageInfo.lastTimeUsed!); // Parse to int
      DateTime usageDate = DateTime.fromMillisecondsSinceEpoch(lastTimeUsed);
      String dayOfWeek = _getDayOfWeek(usageDate.weekday);
      appUsageStats.update(dayOfWeek, (value) => value + usageTime, ifAbsent: () => usageTime);
    }
  }
  return appUsageStats;
}

// current week screen time

Future<int> CurrentWeekTotalUsage() async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  // Get current date and time in local time zone
  tz.TZDateTime now = tz.TZDateTime.now(tz.local);

  // Get the start of the current week (Sunday)
  tz.TZDateTime startOfCurrentWeek = _getStartOfCurrentWeek(now);

  // Get the end of the current week (Saturday)
  tz.TZDateTime endOfCurrentWeek = startOfCurrentWeek.add(const Duration(days: 7));

  int totalScreenTime = 0;

  // Define a list of system app package names
  List<String> systemApps = [
    // system apps any if we want to exclude
    "com.android.launcher",
  ];

  Map<String, UsageInfo> maxUsageMap = {};

  List<UsageInfo> usageStats = await UsageStats.queryUsageStats(startOfCurrentWeek.toUtc(), endOfCurrentWeek.toUtc());

  for (var usageInfo in usageStats) {
    String packageName = usageInfo.packageName!;
    // Exclude system apps from calculation
    if (!systemApps.contains(packageName)) {
      if (!maxUsageMap.containsKey(packageName) ||
          int.parse(usageInfo.totalTimeInForeground ?? '0') >
              int.parse(
                  maxUsageMap[packageName]?.totalTimeInForeground ?? '0')) {
        maxUsageMap[packageName] = usageInfo;
      }
    }
  }

  List<UsageInfo> result = maxUsageMap.values.toList();

  result.sort((a, b) => int.parse(b.totalTimeInForeground ?? '0')
      .compareTo(int.parse(a.totalTimeInForeground ?? '0')));

  for (var usageInfo in result) {
    totalScreenTime += int.parse(usageInfo.totalTimeInForeground ?? '0');
  }

  return totalScreenTime;
}

// previous week screen time
Future<int> PreviousWeekTotalUsage() async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  // Get current date and time in local time zone
  tz.TZDateTime now = tz.TZDateTime.now(tz.local);

  // Get the start of the previous week (Sunday)
  tz.TZDateTime startOfPreviousWeek = _getStartOfPreviousWeek(now);

  // Get the end of the previous week (Saturday)
  tz.TZDateTime endOfPreviousWeek = startOfPreviousWeek.add(const Duration(days: 7));

  int totalScreenTime = 0;

  // Define a list of system app package names
  List<String> systemApps = [
    // system apps any if we want to exclude
    "com.android.launcher",
  ];

  Map<String, UsageInfo> maxUsageMap = {};

  List<UsageInfo> usageStats = await UsageStats.queryUsageStats(startOfPreviousWeek.toUtc(), endOfPreviousWeek.toUtc());

  for (var usageInfo in usageStats) {
    String packageName = usageInfo.packageName!;
    // Exclude system apps from calculation
    if (!systemApps.contains(packageName)) {
      if (!maxUsageMap.containsKey(packageName) ||
          int.parse(usageInfo.totalTimeInForeground ?? '0') >
              int.parse(
                  maxUsageMap[packageName]?.totalTimeInForeground ?? '0')) {
        maxUsageMap[packageName] = usageInfo;
      }
    }
  }

  List<UsageInfo> result = maxUsageMap.values.toList();

  result.sort((a, b) => int.parse(b.totalTimeInForeground ?? '0')
      .compareTo(int.parse(a.totalTimeInForeground ?? '0')));

  for (var usageInfo in result) {
    totalScreenTime += int.parse(usageInfo.totalTimeInForeground ?? '0');
  }

  return totalScreenTime;
}

// Function to get the start of the week (Sunday)
tz.TZDateTime _getStartOfCurrentWeek(tz.TZDateTime date) {
  print(date.weekday);
  switch(date.weekday) {
    case 1:
      return date.subtract(Duration(days: 1, hours: date.hour, minutes: date.minute, seconds: date.second, milliseconds: date.millisecond, microseconds: date.microsecond));
    case 2:
      return date.subtract(Duration(days: 2, hours: date.hour, minutes: date.minute, seconds: date.second, milliseconds: date.millisecond, microseconds: date.microsecond));
    case 3:
      return date.subtract(Duration(days: 3, hours: date.hour, minutes: date.minute, seconds: date.second, milliseconds: date.millisecond, microseconds: date.microsecond));
    case 4:
      return date.subtract(Duration(days: 4, hours: date.hour, minutes: date.minute, seconds: date.second, milliseconds: date.millisecond, microseconds: date.microsecond));
    case 5:
      return date.subtract(Duration(days: 5, hours: date.hour, minutes: date.minute, seconds: date.second, milliseconds: date.millisecond, microseconds: date.microsecond));
    case 6:
      return date.subtract(Duration(days: 6, hours: date.hour, minutes: date.minute, seconds: date.second, milliseconds: date.millisecond, microseconds: date.microsecond));
    case 7:
      return date.subtract(Duration(days: 0, hours: date.hour, minutes: date.minute, seconds: date.second, milliseconds: date.millisecond, microseconds: date.microsecond));
    default:
      return date;
  }
}

// Function to get the start of the previous week (Sunday)
tz.TZDateTime _getStartOfPreviousWeek(tz.TZDateTime date) {
  return _getStartOfCurrentWeek(date).subtract(const Duration(days: 8));
}
