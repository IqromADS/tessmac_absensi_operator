class NotificationResponse {
  final int code;
  final String status;
  final String message;
  final List<NotificationData> data;

  NotificationResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => NotificationData.fromJson(item))
          .toList(),
    );
  }
}

class NotificationData {
  final String title;
  final String body;
  final String description;
  final String date;

  NotificationData({
    required this.title,
    required this.body,
    required this.description,
    required this.date,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['title'],
      body: json['body'],
      description: json['description'],
      date: json['date'],
    );
  }
}
