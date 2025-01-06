class InspectionResponse {
  int code;
  String status;
  String message;
  InspectionData data;

  InspectionResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory InspectionResponse.fromJson(Map<String, dynamic> json) {
    return InspectionResponse(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: InspectionData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class InspectionData {
  String plat;
  String idUser;
  String frontCamera;
  String rightCamera;
  String leftCamera;
  String personCamera;
  String frontTruck;
  String condition;

  InspectionData({
    required this.plat,
    required this.idUser,
    required this.frontCamera,
    required this.rightCamera,
    required this.leftCamera,
    required this.personCamera,
    required this.frontTruck,
    required this.condition,
  });

  factory InspectionData.fromJson(Map<String, dynamic> json) {
    return InspectionData(
      plat: json['plat'],
      idUser: json['id_user'],
      frontCamera: json['frontCamera'],
      rightCamera: json['rightCamera'],
      leftCamera: json['leftCamera'],
      personCamera: json['personCamera'],
      frontTruck: json['frontTruck'],
      condition: json['condition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plat': plat,
      'id_user': idUser,
      'frontCamera': frontCamera,
      'rightCamera': rightCamera,
      'leftCamera': leftCamera,
      'personCamera': personCamera,
      'frontTruck': frontTruck,
      'condition': condition,
    };
  }
}
