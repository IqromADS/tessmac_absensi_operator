import 'package:absensi_operator/app/modules/login/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 150.h),
            child: PageView(
              controller: controller.indicator,
              children: [
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 400.h,
                      child: SvgPicture.asset(
                        "assets/images/onb1.svg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 400.h,
                      child: SvgPicture.asset(
                        "assets/images/onb2.svg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 400.h,
                      child: SvgPicture.asset(
                        "assets/images/onb3.svg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
              onPageChanged: (index) {
                controller.page.value = index;
              },
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: 20.w,
            right: 20.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indikator halaman
                SmoothPageIndicator(
                  controller: controller.indicator,
                  count: 3,
                  effect: SlideEffect(
                    activeDotColor: Color(0Xff0066D8),
                    spacing: 8.w,
                    radius: 4.h,
                    dotWidth: 8.h,
                    dotHeight: 8.h,
                    dotColor: Color(0XffD9D9D9),
                  ),
                ),
                SizedBox(height: 16.h),

                // Teks yang berbeda-beda untuk setiap halaman
                Obx(() {
                  int currentPage = controller.page.value;

                  return SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10).h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.slideData[currentPage]['title']!,
                            style: TextStyle(
                              fontFamily: "HelveticaNeue",
                              fontSize: 24.h,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF202224),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            controller.slideData[currentPage]['description']!,
                            style: TextStyle(
                              fontFamily: "HelveticaNeue",
                              fontSize: 12.h,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF202224),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                SizedBox(height: 30.h),

                // Tombol Next atau Start
                Obx(() {
                  int currentPage = controller.page.value;

                  return ElevatedButton(
                    onPressed: () {
                      if (currentPage < 2) {
                        controller.indicator.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        // Aksi ketika tombol "Start" di halaman terakhir

                        Get.off(
                          () => LoginView(),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 500),
                        );
                      }
                    },
                    child: Text(
                      currentPage == 2 ? 'Start' : 'Next',
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0066D8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      minimumSize: Size(double.infinity, 50.h),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
