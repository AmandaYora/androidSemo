// CheckAuth.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auth/Login.dart';
import 'Admin/Dashboard.dart'; // Buat nama class menjadi Dashboard
import 'User/Dashboard.dart'; // Buat nama class menjadi Dashboard

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    // Check if user is logged in
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final role = prefs.getString('role');

    if (username != null && role != null) {
      if (role == 'admin') {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AdminDashboard())); // Update ke Dashboard
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => UserDashboard())); // Update ke Dashboard
      }
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can display a loading screen here while the check is being performed
    return Container(
      color: Colors.white,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
