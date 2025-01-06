import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24.h,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontFamily: "HelveticaNeue",
            fontSize: 20.h,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF202224),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.todayNotifications.isEmpty &&
            controller.yesterdayNotifications.isEmpty) {
          return const Center(
            child: Text('No notifications available'),
          );
        }

        return ListView(
          children: [
            if (controller.todayNotifications.isNotEmpty) ...[
              _buildSectionTitle('Today'),
              ...controller.todayNotifications.map(
                (notif) => _buildNotificationTile(notif, context),
              ),
            ],
            if (controller.yesterdayNotifications.isNotEmpty) ...[
              _buildSectionTitle('Yesterday'),
              ...controller.yesterdayNotifications.map(
                (notif) => _buildNotificationTile(notif, context),
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16).h,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.h,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotificationTile(
      Map<String, dynamic> notification, BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        "assets/icons/notification.svg",
        width: 24.h,
        height: 24.h,
      ),
      title: Text(
        notification['title'],
        style: TextStyle(
          fontFamily: "HelveticaNeue",
          fontSize: 16.h,
          fontWeight: FontWeight.w700,
          color: const Color(0xff0066D8),
        ),
      ),
      subtitle: Text(
        notification['body'],
        style: TextStyle(
          fontFamily: "HelveticaNeue",
          fontSize: 14.h,
          fontWeight: FontWeight.w500,
          color: const Color(0xff202224),
        ),
      ),
      trailing: Text(
        notification['scheduledTime'] != null
            ? DateFormat('HH:mm')
                .format(DateTime.parse(notification['scheduledTime']))
            : '',
        style: TextStyle(
          fontFamily: "HelveticaNeue",
          fontSize: 10.h,
          fontWeight: FontWeight.w500,
          color: const Color(0xff202224),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ).h,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            title: Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/alertnotif.svg",
                  width: 80.h,
                  height: 80.h,
                ),
                SizedBox(height: 10.h),
                Text(
                  notification['body'],
                  style: TextStyle(
                    fontFamily: "HelveticaNeue",
                    fontSize: 18.h,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff0066D8),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  notification['description'],
                  style: TextStyle(
                    fontFamily: "HelveticaNeue",
                    fontSize: 14.h,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff202224),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
