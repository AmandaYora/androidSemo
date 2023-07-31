import 'package:flutter/material.dart';
import '../model/DatabaseHelper.dart';
import '../model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User?> futureUser;
  final _formKey = GlobalKey<FormState>();
  int? userId; // User ID added here

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
    User? user = await DatabaseHelper.instance.getUserByUsername(username!);
    if (user != null) {
      userId = user.id; // save user id
    }
    return user;
  }

  void updateProfile() {
    if (_formKey.currentState!.validate()) {
      User updatedUser = User(
        id: userId, // use saved user id
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
    return Scaffold(
      body: FutureBuilder<User?>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            User user = snapshot.data!;
            nameController = TextEditingController(text: user.name);
            usernameController = TextEditingController(text: user.username);
            emailController = TextEditingController(text: user.email);
            phoneController = TextEditingController(text: user.phone);
            passwordController = TextEditingController(text: user.password);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 30.0),
                  Text(
                    "Hello, ${user.name}!",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            buildTextField(nameController, "Name"),
                            const SizedBox(height: 10.0),
                            buildTextField(usernameController, "Username"),
                            const SizedBox(height: 10.0),
                            buildTextField(emailController, "Email"),
                            const SizedBox(height: 10.0),
                            buildTextField(phoneController, "Phone"),
                            const SizedBox(height: 10.0),
                            buildTextField(passwordController, "Password",
                                isPassword: true),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: updateProfile,
                              child: Text('Update Profile'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                padding: const EdgeInsets.all(16.0),
                                primary: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (snapshot.data == null) {
            return Center(child: Text("User not found"));
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  TextField buildTextField(TextEditingController controller, String labelText,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        isDense: true,
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }
}
