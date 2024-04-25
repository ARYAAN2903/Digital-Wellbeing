import 'package:digital_wellbeing/components/pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digital_wellbeing/models/app_info.dart';
import 'package:digital_wellbeing/screens/app_stats.dart';
import 'package:digital_wellbeing/screens/show_apps.dart';
import 'package:digital_wellbeing/service/usage_stats/usage_stats.dart';
import 'package:digital_wellbeing/service/format_time.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<int> _dailyTotalUsage;
  late Future<Map<String, double>> _dailyAppUsage;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _dailyTotalUsage = DailyTotalUsage();
      _dailyAppUsage = DailyAppUsage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              // Show logout confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Logout user
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Today's App Usage",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    PieChartSample(usageData: _dailyAppUsage),
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
                              "Total Screen Time",
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
                            future: _dailyTotalUsage,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                return Text(
                                  formatTime(snapshot.data!),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "Most Used Apps",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          FutureBuilder(
                            future: ActualDailyAppUsage(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                final List<MapEntry<String, int>>
                                appEntries =
                                snapshot.data!.entries.toList();
                                return Column(
                                  children: [
                                    for (int i = 0;
                                    i < appEntries.length && i < 10;
                                    i++) // Limit to top 10
                                      Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AppScreenTimePage(
                                                          appName: appEntries[
                                                          i]
                                                              .key),
                                                ),
                                              );
                                            },
                                            child: ListTile(
                                              leading: Image.asset(
                                                appInfoMap[appEntries[i].key]
                                                ?['imagePath'] ??
                                                    'assets/apps/default_app.png',
                                                width: 40,
                                              ),
                                              title: Text(
                                                appInfoMap[appEntries[i].key]
                                                ?['name'] ??
                                                    appEntries[i].key,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                              subtitle: Text(
                                                formatTime(
                                                    appEntries[i].value),
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                              trailing: const Icon(
                                                  Icons.navigate_next_rounded),
                                            ),
                                          ),
                                          const Divider(
                                            indent: 0,
                                            endIndent: 0,
                                          ),
                                        ],
                                      ),
                                    if (appEntries.length >
                                        10) // Show "Show All" option if there are more than 10 apps
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ShowAllPageWrapper(
                                                      appEntries: appEntries),
                                            ),
                                          );
                                        },
                                        child: const Text('Show All'),
                                      ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _refreshData();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }
}
