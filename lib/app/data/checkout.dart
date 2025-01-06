class CheckOutResponse {
  final int code;
  final String status;
  final String message;
  final CheckOutData? data;

  CheckOutResponse({
    required this.code,
    required this.status,
    required this.message,
    this.data,
  });

  factory CheckOutResponse.fromJson(Map<String, dynamic> json) {
    return CheckOutResponse(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? CheckOutData.fromJson(json['data']) : null,
    );
  }
}

class CheckOutData {
  final int idUser;
  final String? checkOutPhoto;
  final String? checkOutDate;
  final String? checkOutLocation;
  final String? idDevice;
  final int idAttendance;
  final String? checkInLateness;

  CheckOutData({
    required this.idUser,
    this.checkOutPhoto,
    this.checkOutDate,
    this.checkOutLocation,
    this.idDevice,
    required this.idAttendance,
    this.checkInLateness,
  });

  factory CheckOutData.fromJson(Map<String, dynamic> json) {
    return CheckOutData(
      idUser: json['id_user'],
      checkOutPhoto: json['check_out_photo'],
      checkOutDate: json['check_out_date'],
      checkOutLocation: json['check_out_location'],
      idDevice: json['id_device'],
      idAttendance: int.tryParse(json['id_attendance'].toString()) ?? 0,
      checkInLateness: json['check_in_lateness'],
    );
  }
}
