import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'User.dart';
import 'Cars.dart';
import 'Rental.dart';

class DatabaseHelper {
  static final _dbName = 'rental.db';
  static final _dbVersion = 1;
  static final _usersTableName = 'users';
  static final _carsTableName = 'mobil';
  static final _sewaTableName = 'sewa';

  static final columnName = 'name';
  static final columnUsername = 'username';
  static final columnEmail = 'email';
  static final columnPhone = 'phone';
  static final columnPassword = 'password';
  static final columnRole = 'role';

  // Making it a Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  // Open the database and create it if it doesn't exist
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path,
        version: _dbVersion, onCreate: _onCreate, onConfigure: _onConfigure);
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $_usersTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnUsername TEXT NOT NULL,
            $columnEmail TEXT NOT NULL,
            $columnPhone TEXT NOT NULL,
            $columnPassword TEXT NOT NULL,
            $columnRole TEXT NOT NULL
          )
          ''');

    // Membuat tabel mobil
    await db.execute('''
      CREATE TABLE $_carsTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        merk TEXT NOT NULL,
        tahun INTEGER NOT NULL,
        warna TEXT NOT NULL,
        harga TEXT NOT NULL,
        picture TEXT NOT NULL
      )
    ''');

    // Membuat tabel sewa
    await db.execute('''
      CREATE TABLE $_sewaTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_mobil INTEGER,
        id_user INTEGER,
        jumlah_hari INTEGER,
        total_biaya INTEGER,
        FOREIGN KEY(id_mobil) REFERENCES $_carsTableName(id),
        FOREIGN KEY(id_user) REFERENCES $_usersTableName(id)
      )
    ''');
  }

  // Method to initialize the database and insert default data if needed
  Future<void> initializeDatabaseWithDefaultData() async {
    Database db = await instance.database;

    // Check if the "users" table is empty.
    List<Map<String, dynamic>> users = await db.query(_usersTableName);
    if (users.isEmpty) {
      // If the "users" table is empty, insert the default data.
      User defaultUser = User(
        name: 'Admin',
        username: 'admin',
        email: 'admin@example.com',
        phone: '1234567890',
        password: 'admin',
        role: 'admin',
      );

      // Insert the default user into the "users" table.
      await db.insert(_usersTableName, defaultUser.toMap());
    }
  }

  Future<int> insert(User user) async {
    Database db = await instance.database;
    return await db.insert(_usersTableName, user.toMap());
  }

  Future<User?> getUserByUsername(String username) async {
    Database db = await instance.database;
    var result = await db.query(_usersTableName,
        where: '$columnUsername = ?', whereArgs: [username]);

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<int> getUserIdByUsername(String username) async {
    User? user = await getUserByUsername(username);
    if (user != null) {
      if (user.id != null) {
        return user.id!;
      } else {
        throw Exception('User ID is missing');
      }
    } else {
      throw Exception('User not found');
    }
  }

  Future<List<Car>> getCars() async {
    Database db = await instance.database;
    var cars = await db.query(_carsTableName);
    return List.generate(cars.length, (i) {
      return Car.fromMap(cars[i]);
    });
  }

  Future<void> updateUser(User user) async {
    Database db = await instance.database;
    if (user.id != null) {
      await db.update(_usersTableName, user.toMap(),
          where: 'id = ?', whereArgs: [user.id]);
    } else {
      throw Exception('User ID is missing for updating user info');
    }
  }

  Future<List<User>> getUsers() async {
    Database db = await instance.database;
    var users = await db.query(_usersTableName);
    return List.generate(users.length, (i) {
      return User.fromMap(users[i]);
    });
  }

  Future<int> insertCar(Car car) async {
    Database db = await instance.database;
    return await db.insert(_carsTableName, car.toMap());
  }

  Future<int> insertSewa(Rental rental) async {
    Database db = await instance.database;
    return await db.insert(_sewaTableName, rental.toMap());
  }

  Future<List<Rental>> getSewa() async {
    Database db = await instance.database;
    var rentals = await db.query(_sewaTableName);
    return List.generate(rentals.length, (i) {
      return Rental.fromMap(rentals[i]);
    });
  }

  Future<Car?> getCarById(int id) async {
    Database db = await instance.database;
    var result =
        await db.query(_carsTableName, where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return Car.fromMap(result.first);
    }
    return null;
  }

  Future<void> updateCar(Car car) async {
    Database db = await instance.database;
    if (car.id != null) {
      await db.update(_carsTableName, car.toMap(),
          where: 'id = ?', whereArgs: [car.id]);
    } else {
      throw Exception('Car ID is missing for updating car info');
    }
  }

  Future<User?> getUserById(int id) async {
    Database db = await instance.database;
    var result =
        await db.query(_usersTableName, where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<int> deleteSewa(int id) async {
    Database db = await instance.database;
    return await db.delete(_sewaTableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteCar(int id) async {
    Database db = await instance.database;

    // Contoh pemeriksaan sewa mobil
    var result =
        await db.query(_sewaTableName, where: 'id_mobil = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      throw Exception('Mobil sedang disewa');
    } else {
      await db.delete(_carsTableName, where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<int> deleteUser(int id) async {
    Database db = await instance.database;

    var rental =
        await db.query(_sewaTableName, where: 'id_user = ?', whereArgs: [id]);
    if (rental.isNotEmpty) {
      throw Exception('User sedang menyewa mobil');
    }

    return await db.delete(_usersTableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isCarRented(int id) async {
    final db = await database;
    var sewa = await db.query('sewa', where: 'id_mobil = ?', whereArgs: [id]);
    return sewa.isNotEmpty;
  }

  // Other methods for querying, updating, and deleting can be created here as well.
}
