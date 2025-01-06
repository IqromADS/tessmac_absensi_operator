class LoginResponse {
  final int code;
  final String token;
  final String status;
  final String message;
  final UserData? data;

  LoginResponse({
    required this.code,
    required this.token,
    required this.status,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'],
      token: json['token'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final int idUser;
  final String nama;
  final String email;
  final String terminalName;
  final String phone;
  final int radius;
  final Location lokasi;
  final String roleName;
  final String profilPic;

  UserData({
    required this.idUser,
    required this.nama,
    required this.email,
    required this.terminalName,
    required this.phone,
    required this.radius,
    required this.lokasi,
    required this.roleName,
    required this.profilPic,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      idUser: json['id_user'],
      nama: json['nama'],
      email: json['email'],
      terminalName: json['terminal_name'],
      phone: json['phone'],
      radius: json['radius'],
      lokasi: Location.fromJson(json['lokasi']),
      roleName: json['role_name'],
      profilPic: json['profilPic'],
    );
  }
}

class Location {
  final String latitude;
  final String longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
