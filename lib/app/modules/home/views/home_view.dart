import 'package:absensi_operator/app/modules/notification/views/notification_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dotted_line/dotted_line.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        return controller.userProfilePic.value.isNotEmpty
                            ? CircleAvatar(
                                radius: 50.h,
                                backgroundImage: NetworkImage(
                                    controller.userProfilePic.value),
                              )
                            : CircleAvatar(
                                radius: 50.h,
                                child: const Icon(Icons.person),
                              );
                      }),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => const NotificationView(),
                            transition: Transition.fadeIn,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.h),
                            child: SvgPicture.asset(
                              "assets/icons/notification.svg",
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Obx(() => RichText(
                        text: TextSpan(
                          text: "${controller.greeting}, ",
                          style: TextStyle(
                            fontFamily: "HelveticaNeue",
                            fontSize: 20.h,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: "${controller.userName}",
                              style: TextStyle(
                                fontFamily: "HelveticaNeue",
                                fontSize: 20.h,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 10.h),
                  Text(
                    "Let's be productive today!",
                    style: TextStyle(
                      fontFamily: "HelveticaNeue",
                      fontSize: 14.h,
                      fontWeight: FontWeight.w200,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 300.h - (300.h / 20),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 31.h),
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
                                borderRadius: BorderRadius.circular(18.r)),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  "${controller.total_absent} Day",
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  "${controller.total_lateness_checkin} Day",
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
                    SizedBox(height: 10.h),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Weekly Schedule",
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeue",
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff202224),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Obx(() {
                                  if (controller.jadwalList.isEmpty) {
                                    return Center(
                                      child: Text(
                                        "No schedules available",
                                        style: TextStyle(
                                          fontFamily: "HelveticaNeue",
                                          fontSize: 16.h,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff202224),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Column(
                                      children:
                                          controller.jadwalList.map((jadwal) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.h),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 4.h,
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  if (jadwal.hari != "Sunday")
                                                    DottedLine(
                                                      direction: Axis.vertical,
                                                      lineLength: 40.w,
                                                      dashLength: 4.w,
                                                      dashGapLength: 4.h,
                                                      lineThickness: 2.h,
                                                      dashColor: Colors.grey,
                                                    ),
                                                ],
                                              ),
                                              SizedBox(width: 16.w),
                                              // Informasi Jadwal
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Hari
                                                  Text(
                                                    jadwal.hari,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "HelveticaNeue",
                                                      fontSize: 12.h,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: const Color(
                                                          0xff202224),
                                                    ),
                                                  ),
                                                  // Tanggal
                                                  Text(
                                                    jadwal.tanggal,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "HelveticaNeue",
                                                      fontSize: 10.h,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: const Color(
                                                          0xff20222480),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Container(
                                                width: 214.h,
                                                height: 36.h,
                                                decoration: BoxDecoration(
                                                  color: jadwal.shift == "Libur"
                                                      ? const Color(0xffFF0000)
                                                      : const Color(0xff0066D8),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 24.w),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        jadwal.shift,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "HelveticaNeue",
                                                          fontSize: 14.h,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        (jadwal.jamMasuk
                                                                    ?.substring(
                                                                        0, 5) ??
                                                                "") +
                                                            " - " +
                                                            (jadwal.jamKeluar
                                                                    ?.substring(
                                                                        0, 5) ??
                                                                ""),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "HelveticaNeue",
                                                          fontSize: 12.h,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.h,
            right: 16.h,
            child: GestureDetector(
              onTap: () {
                controller.OpenWhatsAppChat();
              },
              child: Container(
                width: 80.w,
                height: 80.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset("assets/icons/logos_whatsapp-icon.svg"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
