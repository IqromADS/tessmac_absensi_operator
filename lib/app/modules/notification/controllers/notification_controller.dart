import 'package:absensi_operator/app/data/notif.dart';
import 'package:absensi_operator/app/services/api_services.dart';
import 'package:absensi_operator/app/widgets/utils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationController extends GetxController {
  var todayNotifications = <Map<String, dynamic>>[].obs;
  var yesterdayNotifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    AwesomeNotifications().setListeners(
      onNotificationDisplayedMethod: onNotificationDisplayed,
      onActionReceivedMethod: onNotificationActionReceived,
    );

    fetchAndScheduleNotifications();
  }

  Future<void> fetchAndScheduleNotifications() async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId == null) {
        print('User ID not found. Please login first.');
        return;
      }

      final checkInResponse =
          await ApiService().getNotifCheckIn(userId.toString());
      final checkOutResponse =
          await ApiService().getNotifCheckOut(userId.toString());

      _processAndScheduleNotifications(
        checkInResponse.data,
        subtractDuration: Duration(hours: 1),
        type: 'check-in',
      );
      _processAndScheduleNotifications(
        checkOutResponse.data,
        subtractDuration: Duration(minutes: 30),
        type: 'check-out',
      );
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  void _processAndScheduleNotifications(
    List<NotificationData> notifications, {
    required Duration subtractDuration,
    required String type,
  }) {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));

    for (var notif in notifications) {
      final notifTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(notif.date);
      final scheduledTime = notifTime.subtract(subtractDuration);

      final notificationMap = {
        'title': notif.title,
        'body': notif.body,
        'description': notif.description,
        'time': notif.date,
        'scheduledTime': scheduledTime.toIso8601String(),
        'type': type,
      };

      // Jika notifikasi adalah untuk hari kemarin
      if (DateFormat('yyyy-MM-dd').format(notifTime) ==
          DateFormat('yyyy-MM-dd').format(yesterday)) {
        yesterdayNotifications.add(notificationMap);
      }

      // Jika waktunya sudah tercapai, tambahkan ke todayNotifications
      if (scheduledTime.isBefore(now) &&
          DateFormat('yyyy-MM-dd').format(notifTime) ==
              DateFormat('yyyy-MM-dd').format(now)) {
        todayNotifications.add(notificationMap);
      }

      // Jadwalkan notifikasi untuk waktu yang sesuai
      if (scheduledTime.isAfter(now)) {
        _scheduleNotification(
          id: scheduledTime.hashCode,
          title: notif.title,
          body: notif.body,
          description: notif.description,
          scheduledTime: scheduledTime,
        );
      }
    }

    // Refresh daftar notifikasi
    yesterdayNotifications.refresh();
    todayNotifications.refresh();
  }

  void _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required String description,
    required DateTime scheduledTime,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        payload: {
          'description': description,
          'time': scheduledTime.toIso8601String(),
        },
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        year: scheduledTime.year,
        month: scheduledTime.month,
        day: scheduledTime.day,
        hour: scheduledTime.hour,
        minute: scheduledTime.minute,
        second: 0,
        millisecond: 0,
        repeats: false,
      ),
    );
  }

  // Menangani notifikasi yang ditampilkan
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayed(
      ReceivedNotification receivedNotification) async {
    NotificationController notificationController = Get.find();
    notificationController.addNotificationToList(receivedNotification);
  }

  // Menangani aksi notifikasi yang diklik
  @pragma("vm:entry-point")
  static Future<void> onNotificationActionReceived(
      ReceivedAction receivedAction) async {
    print('Notification action received: ${receivedAction.title}');
    NotificationController notificationController = Get.find();

    // Tambahkan notifikasi yang diklik ke dalam daftar todayNotifications
    notificationController.addNotificationToList(receivedAction);
  }

  // Menambahkan notifikasi ke daftar
  void addNotificationToList(dynamic notification) {
    final now = DateTime.now();
    final notificationDate = DateFormat('yyyy-MM-dd HH:mm:ss')
        .parse(notification.payload?['time'] ?? now.toIso8601String());

    if (notificationDate.isBefore(now)) {
      final notificationMap = {
        'title': notification.title ?? 'No Title',
        'body': notification.body ?? 'No Body',
        'description': notification.payload?['description'] ?? 'No Description',
        'scheduledTime': notification.payload?['time'] ?? '',
        'time': notificationDate.toIso8601String(),
      };
      todayNotifications.add(notificationMap);
      todayNotifications.refresh();
    }
  }
}
