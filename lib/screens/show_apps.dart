import 'package:digital_wellbeing/screens/app_stats.dart';
import 'package:flutter/material.dart';
import 'package:digital_wellbeing/models/app_info.dart';
import '../service/format_time.dart';

class ShowAllPageWrapper extends StatelessWidget {
  final List<MapEntry<String, int>> appEntries;

  const ShowAllPageWrapper({Key? key, required this.appEntries}) : super(key: key);

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
        title: const Text('All Apps', style: TextStyle(color: Colors.white),),
      ),
      body: ShowAllAppsPage(appEntries: appEntries),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class ShowAllAppsPage extends StatelessWidget {
  final List<MapEntry<String, int>> appEntries;

  const ShowAllAppsPage({Key? key, required this.appEntries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primary
            .withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.separated(
        itemCount: appEntries.length,
        itemBuilder: (context, index) {
          final appEntry = appEntries[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppScreenTimePage(appName: appEntry.key),
                ),
              );
            },
            child: ListTile(
              leading: Image.asset(
                appInfoMap[appEntry.key]?['imagePath'] ?? 'assets/apps/default_app.png',
                width: 40,
              ),
              title: Text(appInfoMap[appEntry.key]?['name'] ?? appEntry.key, style: (const TextStyle(fontSize: 13)),),
              subtitle: Text(formatTime(appEntry.value), style: (const TextStyle(fontSize: 11)),),
              trailing: const Icon(Icons.navigate_next_rounded),
            ),
          );

        },
        separatorBuilder: (context, index) => const Divider(), // Add a divider between each list tile
      ),
    );
  }
}