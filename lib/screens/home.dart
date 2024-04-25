import 'package:digital_wellbeing/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:digital_wellbeing/screens/dashboard.dart';
import 'package:digital_wellbeing/screens/analytics.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Initially selected index is 0, i.e., Dashboard

  final List<Widget> _pages = [
    const Dashboard(),
    const AnalyticsPage(),
     SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

