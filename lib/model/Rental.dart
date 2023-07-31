class Rental {
  int? id;
  int id_mobil;
  int id_user;
  int jumlah_hari;
  int total_biaya;

  Rental({
    this.id,
    required this.id_mobil,
    required this.id_user,
    required this.jumlah_hari,
    required this.total_biaya,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id_mobil': id_mobil,
      'id_user': id_user,
      'jumlah_hari': jumlah_hari,
      'total_biaya': total_biaya,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  static Rental fromMap(Map<String, dynamic> map) {
    return Rental(
      id: map['id'],
      id_mobil: map['id_mobil'],
      id_user: map['id_user'],
      jumlah_hari: map['jumlah_hari'],
      total_biaya: map['total_biaya'],
    );
  }
}
