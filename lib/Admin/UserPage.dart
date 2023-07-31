// Admin/Dashboard.dart
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../model/DatabaseHelper.dart';
import '../model/User.dart';
import '../model/Cars.dart';
import '../model/Rental.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<User>> _userList;

  @override
  void initState() {
    super.initState();
    _updateUserList();
  }

  _updateUserList() {
    setState(() {
      _userList = DatabaseHelper.instance.getUsers();
    });
  }

  _deleteUser(User user) async {
    try {
      await DatabaseHelper.instance.deleteUser(user.id!);
      _updateUserList();
    } catch (e) {
      if (e.toString() == 'Exception: User sedang menyewa mobil') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Gagal menghapus'),
              content: Text('User sedang menyewa mobil'),
              actions: <Widget>[
                TextButton(
                  child: Text('Tutup'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _userList,
        builder: (context, AsyncSnapshot<List<User>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              User user = snapshot.data![index];
              return Dismissible(
                key: Key(user.id.toString()),
                background: Container(color: Colors.red),
                onDismissed: (direction) {
                  _deleteUser(user);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(user.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Username: ${user.username}, Email: ${user.email}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
