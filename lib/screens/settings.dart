import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final User? user; // Current user obtained after authentication

  const SettingsPage({Key? key, this.user}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showAccountInfo = false;

  // Developer information
  final List<Map<String, String>> developers = [
    {
      'name': 'Prakhar Sharma',
      'github': 'https://github.com/Prakhar29Sharma',
    },
    {
      'name': 'Aryaan Sawant',
      'github': 'https://github.com/ARYAAN2903',
    },
    {
      'name': 'Divij Sarkale',
      'github': 'https://github.com/divijms07',
    },
    {
      'name': 'Sraina Panchangam',
      'github': 'https://github.com/PSraina',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Account Settings
              ListTile(
                title: Text('Account Information'),
                leading: Icon(Icons.account_circle),
                onTap: () {
                  setState(() {
                    _showAccountInfo = !_showAccountInfo;
                  });
                },
              ),
              // Display Account Information if _showAccountInfo is true
              if (_showAccountInfo)
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Email: ${widget.user?.email ?? "Unknown"}',
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Username: ${widget.user?.displayName ?? "Unknown"}',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              // Help and Support
              ListTile(
                title: Text('Help and Support'),
                leading: Icon(Icons.help),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Help and Support'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              Text('For assistance, please contact us at support@example.com'),
                              SizedBox(height: 10),
                              Text('You can also visit our FAQ page for answers to common questions.'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              // Developer Credentials
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text('Developer Credentials', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color:Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(1.0), )),
                          ),
                          SizedBox(height: 10),
                          for (var developer in developers)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(developer['name']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, )),
                                GestureDetector(
                                  onTap: () {
                                    // Launch the GitHub URL
                                    launch(developer['github']!);
                                  },
                                  child: Text(
                                    developer['github']!,
                                    style: TextStyle(fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
