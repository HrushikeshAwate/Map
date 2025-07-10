// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'location_service.dart';
import 'screens/map_screen.dart';
import 'screens/table_screen.dart';
import 'notification.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  await initializeNotificationService();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocationService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}


Future<void> requestPermissions() async {
  await Permission.location.request();
  await Permission.notification.request();
  await Permission.ignoreBatteryOptimizations.request(); 
  await Permission.locationAlways.request(); // ⬅️ this is the key!

}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [const MapScreen(), const TableScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.table_chart), label: 'Table'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}