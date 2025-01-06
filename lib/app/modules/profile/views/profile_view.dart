import 'package:absensi_operator/app/modules/call_center/views/call_center_view.dart';
import 'package:absensi_operator/app/modules/notification/views/notification_view.dart';
import 'package:absensi_operator/app/modules/personal_information/views/personal_information_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 280.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Group.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                    fontFamily: "HelveticaNeue",
                    fontSize: 20.h,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5.h),
                Obx(() {
                  return controller.userProfilePic.value.isNotEmpty
                      ? CircleAvatar(
                          radius: 50.h,
                          backgroundImage:
                              NetworkImage(controller.userProfilePic.value),
                        )
                      : CircleAvatar(
                          radius: 50.h,
                          child: const Icon(Icons.person),
                        );
                }),
                SizedBox(height: 10.h),
                Obx(
                  () => Text(
                    controller.userName.value,
                    style: TextStyle(
                      fontFamily: "HelveticaNeue",
                      fontSize: 24.h,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 5.h),
                Obx(
                  () => Text(
                    controller.roleName.value +
                        " - " +
                        controller.terminalName.value,
                    style: TextStyle(
                      fontFamily: "HelveticaNeue",
                      fontSize: 14.h,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Positioned(
                top: 280.h - (280.h / 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 31.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Overview",
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeue",
                                    fontSize: 24.h,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xff202224),
                                  ),
                                ),
                                Obx(
                                  () => Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(18.r)),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.w,
                                          right: 20.w,
                                          top: 8.h,
                                          bottom: 8.h),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icons/solar_calendar-bold-duotone.svg"),
                                          SizedBox(width: 12.w),
                                          Text(
                                            controller.currentDate.value,
                                            style: TextStyle(
                                              fontFamily: "HelveticaNeue",
                                              fontSize: 16.h,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff202224),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 25.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Presences",
                                        style: TextStyle(
                                          fontFamily: "HelveticaNeue",
                                          fontSize: 12.h,
                                          fontWeight: FontWeight.w300,
                                          color: const Color(0xff202224),
                                        ),
                                      ),
                                      Obx(
                                        () => Text(
                                          "${controller.total_attendance.value} Day",
                                          style: TextStyle(
                                            fontFamily: "HelveticaNeue",
                                            fontSize: 20.h,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff202224),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Absences",
                                        style: TextStyle(
                                          fontFamily: "HelveticaNeue",
                                          fontSize: 12.h,
                                          fontWeight: FontWeight.w300,
                                          color: const Color(0xff202224),
                                        ),
                                      ),
                                      Obx(
                                        () => Text(
                                          "${controller.total_absent.value} Day",
                                          style: TextStyle(
                                            fontFamily: "HelveticaNeue",
                                            fontSize: 20.h,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff202224),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Lateness",
                                        style: TextStyle(
                                          fontFamily: "HelveticaNeue",
                                          fontSize: 12.h,
                                          fontWeight: FontWeight.w300,
                                          color: const Color(0xff202224),
                                        ),
                                      ),
                                      Obx(
                                        () => Text(
                                          "${controller.total_lateness_checkin.value} Day",
                                          style: TextStyle(
                                            fontFamily: "HelveticaNeue",
                                            fontSize: 20.h,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff202224),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 20.h, bottom: 20.h, left: 20.w, right: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => const PersonalInformationView(),
                                    transition: Transition.fadeIn,
                                    duration: const Duration(milliseconds: 500),
                                  );
                                },
                                child: Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/fluent_person-16-filled.svg"),
                                        Text(
                                          "Personal Information",
                                          style: TextStyle(
                                            fontFamily: "HelveticaNeue",
                                            fontSize: 16.h,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff202224),
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => const NotificationView(),
                                    transition: Transition.fadeIn,
                                    duration: const Duration(milliseconds: 500),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/mingcute_notification-fill.svg"),
                                        Text(
                                          "Notifications",
                                          style: TextStyle(
                                            fontFamily: "HelveticaNeue",
                                            fontSize: 16.h,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff402224),
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => const CallCenterView(),
                                    transition: Transition.fadeIn,
                                    duration: const Duration(milliseconds: 500),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/fluent_call-24-filled.svg"),
                                        Text(
                                          "Call Center",
                                          style: TextStyle(
                                            fontFamily: "HelveticaNeue",
                                            fontSize: 16.h,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff402224),
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/solar_logout-2-bold.svg"),
                                        Text(
                                          "Log Out",
                                          style: TextStyle(
                                            fontFamily: "HelveticaNeue",
                                            fontSize: 16.h,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.transparent,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                                "assets/icons/Group 97.svg",
                                                width: 65.w,
                                                height: 65.h),
                                            SizedBox(height: 20.h),
                                            Text(
                                              "Log Out",
                                              style: TextStyle(
                                                fontFamily: "HelveticaNeue",
                                                fontSize: 20.h,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xff202224),
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              "Are you sure you want to log out? You'll need to login again to use the app.",
                                              style: TextStyle(
                                                fontFamily: "HelveticaNeue",
                                                fontSize: 14.h,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xff677687),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 6.h,
                                                      horizontal: 10.w),
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "HelveticaNeue",
                                                      fontSize: 14.h,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 25.w),
                                              ElevatedButton(
                                                onPressed: () {
                                                  controller.logout();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xff0066D8),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 6.h,
                                                      horizontal: 10.w),
                                                  child: Text("Log Out",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "HelveticaNeue",
                                                        fontSize: 14.h,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
