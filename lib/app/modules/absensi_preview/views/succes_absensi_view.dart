import 'package:absensi_operator/app/modules/absensi/controllers/absensi_controller.dart';
import 'package:absensi_operator/app/widgets/bottomNav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SuccesAbsensiView extends GetView {
  final bool isCheckIn;

  const SuccesAbsensiView({Key? key, required this.isCheckIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lateness =
        Get.arguments != null ? Get.arguments['lateness'] as String? : null;

    final AbsensiController absensiController = Get.find<AbsensiController>();

    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.only(top: 40.h, bottom: 20.h, left: 20.w, right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isCheckIn ? "Shift Start!" : "Shift Completed!",
              style: TextStyle(
                fontFamily: "HelveticaNeue",
                fontSize: 34.h,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF202224),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 280.h,
                    height: 280.h,
                    child: lateness != null
                        ? Lottie.asset(
                            'assets/icons/Alert.json',
                            fit: BoxFit.cover,
                          )
                        : Lottie.asset(
                            'assets/icons/Animation - 1730794959049.json',
                            fit: BoxFit.cover,
                          ),
                  ),
                  if (lateness != null) ...[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 5).h,
                      decoration: BoxDecoration(
                        color: Color(0xffFF0000),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "You're late ",
                            style: TextStyle(
                              fontFamily: "HelveticaNeue",
                              fontSize: 14.h,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            lateness,
                            style: TextStyle(
                              fontFamily: "HelveticaNeue",
                              fontSize: 14.h,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: "HelveticaNeue",
                          fontSize: 16.h,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff202224),
                        ),
                        children: isCheckIn
                            ? const [
                                TextSpan(text: 'As a '),
                                TextSpan(
                                  text: 'monitoring operator',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                TextSpan(
                                    text:
                                        ', your attention to detail ensures every journey is '),
                                TextSpan(
                                  text: 'safe and compliant.',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                TextSpan(text: ' Let’s work '),
                                TextSpan(
                                  text: 'diligently',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                TextSpan(
                                    text:
                                        ', follow all protocols, and maintain '),
                                TextSpan(
                                  text: 'high',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700),
                                ),
                                TextSpan(
                                    text:
                                        ' safety standards for our drivers today.'),
                              ]
                            : const [
                                TextSpan(
                                    text:
                                        'Your commitment to driver monitoring and safety standards makes a '),
                                TextSpan(
                                  text: 'lasting impact.',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                TextSpan(
                                    text:
                                        ' Take pride in today’s work, and we look forward to your '),
                                TextSpan(
                                  text: 'energy and focus',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                TextSpan(text: ' next shift.'),
                              ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  absensiController.deactivateCamera();
                  Get.off(
                    () => BottomNavBar(),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 500),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff0066D8)),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 12.h)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
                child: Text(
                  "Back to Home",
                  style: TextStyle(
                    fontSize: 16.h,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
