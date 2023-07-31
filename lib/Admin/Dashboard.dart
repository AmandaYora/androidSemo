// Admin/Dashboard.dart
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../model/DatabaseHelper.dart';
import '../model/User.dart';
import '../model/Cars.dart';
import '../model/Rental.dart';
import 'AddCarPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CarsPage.dart';
import 'Profile.dart';
import 'RentPage.dart';
import 'UserPage.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    CarsPage(),
    RentPage(),
    UsersPage(),
    ProfilePage(),
  ];

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepPurple,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(MdiIcons.car),
            label: 'Mobil',
          ),
          new BottomNavigationBarItem(
            icon: Icon(MdiIcons.shopping),
            label: 'Sewa',
          ),
          new BottomNavigationBarItem(
            icon: Icon(MdiIcons.account),
            label: 'User',
          ),
          new BottomNavigationBarItem(
            icon: Icon(MdiIcons.accountCircle),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
