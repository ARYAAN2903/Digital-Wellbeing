import 'package:digital_wellbeing/models/app_info.dart';
import 'package:digital_wellbeing/service/event_stats/event_stats.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:digital_wellbeing/service/format_time.dart';
import 'package:flutter/material.dart';
import 'package:digital_wellbeing/service/usage_stats/usage_stats.dart';
import 'package:digital_wellbeing/components/bar_chart/bar_graph.dart';
import 'package:digital_wellbeing/service/utility/limit_string_length.dart';

class AppScreenTimePage extends StatefulWidget {
  final String appName;

  const AppScreenTimePage({Key? key, required this.appName}) : super(key: key);

  @override
  _AppScreenTimePageState createState() => _AppScreenTimePageState();
}

class _AppScreenTimePageState extends State<AppScreenTimePage> {
  late Future<Map<String, double>> _weeklyData;
  late String _activeButton;
  late Future<List<EventUsageInfo>> _appEventLogs;

  @override
  void initState() {
    super.initState();
    _weeklyData = CurrentWeekAppUsage(widget.appName);
    _activeButton = "Current Week";
    _appEventLogs = getAppEventLogs(widget.appName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            Image.asset(
              appInfoMap[widget.appName]?['imagePath'] ??
                  'assets/apps/default_app.png',
              width: 30,
            ),
            const SizedBox(width: 10,),
            Text(appInfoMap[widget.appName]?['name'] ?? limit_string_length(widget.appName),
              overflow: TextOverflow.fade,
              style: const TextStyle(color: Colors.white, fontSize: 16),),
          ],
        ),
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
                          _weeklyData = CurrentWeekAppUsage(widget.appName);
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
                          _weeklyData = PreviousWeekAppUsage(widget.appName);
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
                              return Text(
                                'No data available',
                                style: const TextStyle(
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