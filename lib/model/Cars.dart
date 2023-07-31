class Car {
  int? id;
  final String merk;
  final int tahun;
  final String warna;
  final String harga;
  final String picture; // penambahan properti picture

  Car({
    this.id,
    required this.merk,
    required this.tahun,
    required this.warna,
    required this.harga,
    required this.picture, // penambahan properti picture
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'merk': merk,
      'tahun': tahun,
      'warna': warna,
      'harga': harga,
      'picture': picture, // penambahan properti picture
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      merk: map['merk'],
      tahun: map['tahun'],
      warna: map['warna'],
      harga: map['harga'],
      picture: map['picture'], // penambahan properti picture
    );
  }
}
