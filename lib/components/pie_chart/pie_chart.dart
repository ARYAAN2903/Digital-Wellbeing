import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:digital_wellbeing/service/usage_stats/usage_stats.dart';
import 'package:digital_wellbeing/models/app_info.dart';

class PieChartSample extends StatefulWidget {
  const PieChartSample({super.key, required usageData});

  @override
  _PieChartSampleState createState() => _PieChartSampleState();
}

class _PieChartSampleState extends State<PieChartSample> {
  Map<String, double> usageData = {};

  @override
  void initState() {
    super.initState();
    fetchUsageData();
  }

  Future<void> fetchUsageData() async {
    // Fetch app usage data asynchronously
    Map<String, double> data = await DailyAppUsage();
    setState(() {
      usageData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: DailyAppUsage(), // Call the AppUsage function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Text('Data not available, Try refreshing the page!');
        } else {
          // Retrieve top 5 apps
          Map<String, double> top5Apps = _getTop5Apps(snapshot.data!);
          return PieChart(
            dataMap: top5Apps,
            // Use the fetched data
            animationDuration: const Duration(milliseconds: 1000),
            chartLegendSpacing: 50,
            chartRadius: MediaQuery.of(context).size.width / 1.8,
            colorList: const [
              Color(0xff0293ee),
              Color(0xfff8b250),
              Color(0xff845bef),
              Color(0xff13d38e),
              Color(0xffd0dff0),
            ],
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 25,
            centerText: "App Usage",
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.bottom,
              showLegends: true,
              legendShape: BoxShape.circle,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: true,
              showChartValuesOutside: true,
              chartValueBackgroundColor: Colors.white70,
              decimalPlaces: 0,
            ),
          );
        }
      },
    );
  }

  Map<String, double> _getTop5Apps(Map<String, double> usageData) {
    // Sort the usage data by value in descending order
    List<MapEntry<String, double>> sortedEntries = usageData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Retrieve top 6 apps
    Map<String, double> top5Apps = {};
    for (int i = 0; i < sortedEntries.length && i < 6; i++) {
      top5Apps[appInfoMap[sortedEntries[i].key]?['name'] ?? sortedEntries[i].key] = sortedEntries[i].value;
    }
    return top5Apps;
  }
}
