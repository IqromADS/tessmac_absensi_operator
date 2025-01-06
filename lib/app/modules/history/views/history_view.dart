import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryController());
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: Text(
          'History',
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
      body: FutureBuilder(
        future: controller.fetchHistoryForCurrentMonth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading data: ${snapshot.error}',
                style: TextStyle(fontSize: 16.h),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Obx(() {
              if (controller.historyList.isEmpty) {
                return const Center(
                  child: Text('No history available for this week'),
                );
              } else {
                return ListView.builder(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  itemCount: controller.historyList.length,
                  itemBuilder: (context, index) {
                    final history = controller.historyList[index];
                    return Card(
                      color: const Color(0xFFE7E7E7),
                      margin: EdgeInsets.only(bottom: 15.h),
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 65.h,
                              height: 65.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    history.checkinDate
                                            ?.split(' ')[0]
                                            .split('-')[2] ??
                                        '-',
                                    style: TextStyle(
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0066D8),
                                    ),
                                  ),
                                  Text(
                                    (history.day ?? '-').substring(0, 3),
                                    style: TextStyle(
                                      fontFamily: "HelveticaNeue",
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0066D8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Check-In',
                                          style: TextStyle(
                                            fontSize: 14.h,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF202224),
                                          ),
                                        ),
                                        Text(
                                          history.checkinDate != null &&
                                                  history.checkinDate!
                                                          .split(' ')[1] !=
                                                      '00:00:00'
                                              ? '${history.checkinDate!.split(' ')[1].split(':')[0]}:${history.checkinDate!.split(' ')[1].split(':')[1]}'
                                              : '-',
                                          style: TextStyle(
                                            fontSize: 12.h,
                                            color: const Color(0xFF202224),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 1.w,
                                      height: 40.h,
                                      color: const Color(0xFF202224),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Check-Out',
                                          style: TextStyle(
                                            fontSize: 14.h,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF202224),
                                          ),
                                        ),
                                        Text(
                                          history.checkoutDate != null
                                              ? '${history.checkoutDate!.split(' ')[1].split(':')[0]}:${history.checkoutDate!.split(' ')[1].split(':')[1]}'
                                              : '-',
                                          style: TextStyle(
                                            fontSize: 12.h,
                                            color: const Color(0xFF202224),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            });
          }
        },
      ),
    );
  }
}
