class AttendancesResponseOverView {
  final int code;
  final String status;
  final String message;
  final AttendanceData data;

  AttendancesResponseOverView({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory AttendancesResponseOverView.fromJson(Map<String, dynamic> json) {
    return AttendancesResponseOverView(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: AttendanceData.fromJson(json['data']),
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

class AttendanceData {
  final int totalAttendance;
  final int totalLatenessCheckin;
  final int totalLatenessCheckout;
  final int totalAbsent;

  AttendanceData({
    required this.totalAttendance,
    required this.totalLatenessCheckin,
    required this.totalLatenessCheckout,
    required this.totalAbsent,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      totalAttendance: json['total_attendance'],
      totalLatenessCheckin: json['total_lateness_checkin'],
      totalLatenessCheckout: json['total_lateness_checkout'],
      totalAbsent: json['total_absent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_attendance': totalAttendance,
      'total_lateness_checkin': totalLatenessCheckin,
      'total_lateness_checkout': totalLatenessCheckout,
      'total_absent': totalAbsent,
    };
  }
}
