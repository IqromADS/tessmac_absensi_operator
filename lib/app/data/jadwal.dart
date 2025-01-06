class Jadwal {
  String hari;
  String tanggal;
  String shift;
  String? jamMasuk;
  String? jamKeluar;

  Jadwal(
      {required this.hari,
      required this.tanggal,
      required this.shift,
      this.jamMasuk,
      this.jamKeluar});

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      hari: json['hari'],
      tanggal: json['tanggal'],
      shift: json['shift'],
      jamMasuk: json['jam_masuk'],
      jamKeluar: json['jam_keluar'],
    );
  }
}
