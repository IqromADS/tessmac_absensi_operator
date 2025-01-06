class CheckInResponse {
  final int code;
  final String status;
  final String message;
  final CheckInData data;

  CheckInResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory CheckInResponse.fromJson(Map<String, dynamic> json) {
    return CheckInResponse(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: CheckInData.fromJson(json['data']),
    );
  }
}

class CheckInData {
  final int idUser;
  final String? checkInPhoto;
  final String checkInDate;
  final String checkInLocation;
  final String idDevice;
  final String idAttendance;
  final String? checkInLateness;

  CheckInData({
    required this.idUser,
    this.checkInPhoto,
    required this.checkInDate,
    required this.checkInLocation,
    required this.idDevice,
    required this.idAttendance,
    this.checkInLateness,
  });

  factory CheckInData.fromJson(Map<String, dynamic> json) {
    return CheckInData(
      idUser: json['id_user'],
      checkInPhoto: json['check_in_photo'],
      checkInDate: json['check_in_date'],
      checkInLocation: json['check_in_location'],
      idDevice: json['id_device'],
      idAttendance: json['id_attendance'],
      checkInLateness: json['check_in_lateness'],
    );
  }
}
