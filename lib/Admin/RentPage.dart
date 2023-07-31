// Admin/Dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../model/DatabaseHelper.dart';
import '../model/User.dart';
import '../model/Cars.dart';
import '../model/Rental.dart';
import 'AddCarPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentPage extends StatefulWidget {
  @override
  _RentPageState createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rentals", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<List<Rental>>(
        future: databaseHelper.getSewa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<Rental> sewaList = snapshot.data!;
            return ListView.builder(
              itemCount: sewaList.length,
              itemBuilder: (context, index) {
                Rental rental = sewaList[index];
                return FutureBuilder(
                  future: Future.wait([
                    databaseHelper.getCarById(rental.id_mobil),
                    databaseHelper.getUserById(rental.id_user),
                  ]),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasData) {
                      Car car = snapshot.data![0];
                      User user = snapshot.data![1];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Card(
                            elevation: 8,
                            shadowColor: Colors.black54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.deepPurple,
                                    Colors.purple[100]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                title: Text(
                                  'Nama Mobil: ${car.merk}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                subtitle: Text(
                                  'Nama User: ${user.name}, Jumlah Hari: ${rental.jumlah_hari}, Total Biaya: ${rental.total_biaya}',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Detail Sewa'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text('Nama Mobil: ${car.merk}'),
                                              Text('Tahun Mobil: ${car.tahun}'),
                                              Text('Warna Mobil: ${car.warna}'),
                                              Text('Harga Mobil: ${car.harga}'),
                                              Text('Nama User: ${user.name}'),
                                              Text(
                                                  'Username User: ${user.username}'),
                                              Text('Email User: ${user.email}'),
                                              Text(
                                                  'Jumlah Hari: ${rental.jumlah_hari}'),
                                              Text(
                                                  'Total Biaya: ${rental.total_biaya}'),
                                            ],
                                          ),
                                        ),
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
                                },
                              ),
                            ),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () async {
                                if (rental.id != null) {
                                  await databaseHelper.deleteSewa(rental.id!);
                                  sewaList.removeAt(index);
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }
        },
      ),
    );
  }
}
