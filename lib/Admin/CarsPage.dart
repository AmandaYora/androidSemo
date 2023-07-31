import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../model/DatabaseHelper.dart';
import '../model/User.dart';
import '../model/Cars.dart';
import '../model/Rental.dart';
import 'AddCarPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarsPage extends StatefulWidget {
  @override
  _CarsPageState createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  late Future<List<Car>> _carList;

  @override
  void initState() {
    super.initState();
    _updateCarList();
  }

  _updateCarList() {
    setState(() {
      _carList = DatabaseHelper.instance.getCars();
    });
  }

  _deleteCar(Car car) async {
    try {
      await DatabaseHelper.instance.deleteCar(car.id!);
      _updateCarList();
    } catch (e) {
      if (e.toString() == 'Exception: Mobil sedang disewa') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Gagal menghapus'),
              content: Text('Mobil sedang disewa'),
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
        future: _carList,
        builder: (context, AsyncSnapshot<List<Car>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              Car car = snapshot.data![index];
              return Dismissible(
                key: UniqueKey(),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0),
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  _deleteCar(car);
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
                      title: Text(car.merk,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        "Tahun: ${car.tahun}, Warna: ${car.warna}, Harga/hari: ${car.harga}",
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCarPage()),
          ).then((value) => _updateCarList());
        },
      ),
    );
  }
}
