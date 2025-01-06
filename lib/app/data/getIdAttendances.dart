class AttendanceResponseAbsent {
  final int code;
  final String status;
  final String message;
  final AttendanceData data;

  AttendanceResponseAbsent({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory AttendanceResponseAbsent.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseAbsent(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: AttendanceData.fromJson(json['data']),
    );
  }
}

class AttendanceData {
  final int idAttendance;
  final int userId;
  final String createdAt;
  final String tanggalMasuk;
  final String tanggalKeluar;
  final String shift;
  final String jamMasuk;
  final String? jamKeluar; // Perbarui ke tipe nullable

  AttendanceData({
    required this.idAttendance,
    required this.userId,
    required this.createdAt,
    required this.tanggalMasuk,
    required this.tanggalKeluar,
    required this.shift,
    required this.jamMasuk,
    this.jamKeluar, // Tambahkan dukungan null
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      idAttendance: json['id_attandance'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      tanggalMasuk: json['tanggal_masuk'],
      tanggalKeluar: json['tanggal_keluar'],
      shift: json['shift'],
      jamMasuk: json['jam_masuk'],
      jamKeluar: json['jam_keluar'], // Properti ini bisa null
    );
  }
}
