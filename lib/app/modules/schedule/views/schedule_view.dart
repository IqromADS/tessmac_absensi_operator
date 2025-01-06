import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/schedule_controller.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ScheduleController());

    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      appBar: AppBar(
        title: Text(
          'Schedule',
          style: TextStyle(
            fontFamily: "HelveticaNeue",
            fontSize: 20.h,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF202224),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              controller.currentDate.value,
              style: TextStyle(
                fontFamily: "HelveticaNeue",
                fontSize: 16.h,
                fontWeight: FontWeight.w500,
                color: const Color(0xff202224),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.weeklySchedules.isEmpty) {
                return Center(child: Text('No schedule available'));
              } else {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: controller.weeklySchedules.length,
                  itemBuilder: (context, weekIndex) {
                    final weekData = controller.weeklySchedules[weekIndex];

                    return Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xff0066D8),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 13.h),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Week ${weekIndex + 1}',
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeue",
                                    fontSize: 20.h,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            child: Column(
                              children: weekData
                                  .map((schedule) {
                                    bool isHoliday = schedule.shift == 'Libur';
                                    return Container(
                                      color: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                schedule.hari,
                                                style: TextStyle(
                                                  fontFamily: "HelveticaNeue",
                                                  fontSize: 14.h,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                schedule.tanggal,
                                                style: TextStyle(
                                                  fontFamily: "HelveticaNeue",
                                                  fontSize: 12.h,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5.w),
                                          Column(
                                            children: [
                                              Container(
                                                width: 122.h,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 3.h),
                                                decoration: BoxDecoration(
                                                  color: isHoliday
                                                      ? const Color(0xffFF0000)
                                                      : Color(0xff0066D8),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    schedule.shift,
                                                    style: TextStyle(
                                                      fontSize: 14.h,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                (schedule.jamMasuk
                                                            ?.substring(0, 5) ??
                                                        "") +
                                                    " - " +
                                                    (schedule.jamKeluar
                                                            ?.substring(0, 5) ??
                                                        ""),
                                                style: TextStyle(
                                                  fontFamily: "HelveticaNeue",
                                                  fontSize: 12.h,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  .toList()
                                  .cast<Widget>(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
