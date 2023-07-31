import 'package:flutter/material.dart';
import 'CheckAuth.dart';
import 'Auth/Login.dart';
import 'Admin/Dashboard.dart'; // ensure this is the correct path
import 'User/Dashboard.dart'; // ensure this is the correct path
import 'model/DatabaseHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database in the background
  await DatabaseHelper.instance.initializeDatabaseWithDefaultData();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CheckAuth(),
        '/admin': (context) => AdminDashboard(),
        '/user': (context) => UserDashboard(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
