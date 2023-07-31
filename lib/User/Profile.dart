// User/Profile.dart
import 'package:flutter/material.dart';
import '../model/DatabaseHelper.dart'; // Ganti dengan path yang sesuai
import '../model/User.dart'; // Ganti dengan path yang sesuai
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User?> futureUser;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  Future<User?> fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    return DatabaseHelper.instance.getUserByUsername(username!);
  }

  void updateProfile() {
    if (_formKey.currentState!.validate()) {
      User updatedUser = User(
        name: nameController.text,
        username: usernameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
      );

      DatabaseHelper.instance.updateUser(updatedUser).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile has been updated successfully.'),
          duration: Duration(seconds: 3),
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('There was an error: $error'),
          duration: Duration(seconds: 3),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          User user = snapshot.data!;
          nameController = TextEditingController(text: user.name);
          usernameController = TextEditingController(text: user.username);
          emailController = TextEditingController(text: user.email);
          phoneController = TextEditingController(text: user.phone);
          passwordController = TextEditingController(text: user.password);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextFormField(
                        controller: usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        controller: phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Phone'),
                      ),
                      TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: updateProfile,
                          child: Text('Update Profile'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else if (snapshot.data == null) {
          return Text("User not found");
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}
