import 'package:flutter/material.dart';
import 'package:digital_wellbeing/service/format_time.dart';
import 'package:digital_wellbeing/service/usage_stats/usage_stats.dart';
import 'package:digital_wellbeing/components/bar_chart/bar_graph.dart';
import 'package:digital_wellbeing/service/event_stats/event_stats.dart';
import 'package:flutter/widgets.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {

  late Future<Map<String, double>> _weeklyData;
  late String _activeButton;
  late Future<int> _notificationCount;
  late Future<int> _deviceUnlockCount;

  @override
  void initState() {
    super.initState();
    _weeklyData = CurrentWeekScreenUsage();
    _notificationCount = TodayNotificationCount();
    _deviceUnlockCount = TodayMobileUnlockCount();
    _activeButton = "Current Week";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                // option to switch between current week and previous week
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _weeklyData = CurrentWeekScreenUsage();
                          _activeButton = 'Current Week';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _activeButton == 'Current Week'
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Current Week',
                          style: TextStyle(color: _activeButton == 'Current Week'
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _weeklyData = PreviousWeekScreenUsage();
                          _activeButton = 'Previous Week';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _activeButton == 'Current Week'
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                              : Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Previous Week',
                          style: TextStyle(color: _activeButton == 'Current Week'
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50,),
                FutureBuilder<Map<String, double>>(
                  future: _weeklyData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      // Display bar chart with weekly app usage data
                      print(snapshot.data!);
                      return Container(
                        height: 220,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: MyBarGraph(
                            weeklySummary: _prepareWeeklySummary(snapshot.data!)),
                      );
                    } else {
                      return const Text('No data available');
                    }
                  },
                ),
                const SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    left: 10,
                    right: 10,
                  ),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Total Screen Time ${
                              _activeButton == 'Current Week' ? 'This Week' : 'Previous Week'
                          }",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FutureBuilder(
                          future: _weeklyData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            else if (snapshot.data!.isEmpty) {
                              return const Text(
                                  'No data available',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )
                              );
                            }
                            else {
                              return Text(formatTime(snapshot.data!.values.reduce((a, b) => a + b).toInt()),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ));
                            }
                          }),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                          left: 10,
                          right: 10,
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Notifications Today",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.8),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            FutureBuilder(
                                future: _notificationCount,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  else {
                                    return Text(snapshot.data.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ));
                                  }
                                }),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                          left: 10,
                          right: 10,
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Phone Unlocks Today",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.8),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            FutureBuilder(
                                future: _deviceUnlockCount,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  else {
                                    return Text(snapshot.data.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ));
                                  }
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<double> _prepareWeeklySummary(Map<String, double> weeklyData) {
  List<double> summary = List.filled(7, 0.0); // Initialize list with zeros

  // Map day names to their corresponding index in the summary list
  Map<String, int> dayIndex = {
    'Sun': 0,
    'Mon': 1,
    'Tue': 2,
    'Wed': 3,
    'Thu': 4,
    'Fri': 5,
    'Sat': 6,
  };

  // Update summary list with available data
  weeklyData.forEach((day, value) {
    if (dayIndex.containsKey(day)) {
      summary[dayIndex[day]!] = value.toDouble();
    }
  });
  return summary;
}