import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/DatabaseHelper.dart';
import '../model/Cars.dart';
import '../model/Rental.dart';

class RentPage extends StatefulWidget {
  const RentPage({Key? key}) : super(key: key);

  @override
  _RentPageState createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  late Future<List<Car>> futureCars;
  late String username;

  @override
  void initState() {
    super.initState();
    futureCars = DatabaseHelper.instance.getCars();
    _getUsername();
  }

  void _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  void _showRentDialog(Car car) {
    final _formKey = GlobalKey<FormState>();
    final _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rent ${car.merk}'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Number of days',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of days';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                int days = int.parse(_controller.text);
                int id_user =
                    await DatabaseHelper.instance.getUserIdByUsername(username);

                await DatabaseHelper.instance.insertSewa(
                  Rental(
                    id_mobil: car.id!,
                    id_user: id_user!,
                    jumlah_hari: days,
                    total_biaya: int.parse(car.harga) * days,
                  ),
                );

                Navigator.of(context).pop();
              }
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Car>>(
      future: futureCars,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Car car = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(car.merk,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '${car.tahun} - ${car.warna}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Text('Rp ${car.harga}',
                        style: TextStyle(color: Colors.grey[800])),
                    onTap: () => _showRentDialog(car),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}
