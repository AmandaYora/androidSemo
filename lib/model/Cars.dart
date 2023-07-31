class Car {
  int? id;
  final String merk;
  final int tahun;
  final String warna;
  final String harga;

  Car({
    this.id,
    required this.merk,
    required this.tahun,
    required this.warna,
    required this.harga,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'merk': merk,
      'tahun': tahun,
      'warna': warna,
      'harga': harga,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      merk: map['merk'],
      tahun: map['tahun'],
      warna: map['warna'],
      harga: map['harga'],
    );
  }
}
