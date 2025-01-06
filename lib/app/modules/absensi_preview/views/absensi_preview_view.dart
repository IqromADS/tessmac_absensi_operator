import 'dart:io';
import 'dart:math';

import 'package:absensi_operator/app/modules/absensi/controllers/absensi_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/absensi_preview_controller.dart';

class AbsensiPreviewView extends GetView<AbsensiPreviewController> {
  const AbsensiPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AbsensiPreviewController());
    final AbsensiController absensiController = Get.put(AbsensiController());

    return Scaffold(
      backgroundColor: Color(0xFFEDEDED),
      appBar: AppBar(
        title: Text(
          'Preview',
          style: TextStyle(
            fontSize: 20.h,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF202224),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          children: [
            Obx(() {
              if (controller.imagePath.isNotEmpty) {
                return Container(
                  width: double.infinity,
                  height: 450.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: Image.file(
                      File(controller.imagePath.value),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              } else {
                return const Text(
                  'Gambar tidak ditemukan',
                  style: TextStyle(fontSize: 20),
                );
              }
            }),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff0066D8).withOpacity(.20),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.h),
                              child: SvgPicture.asset(
                                  "assets/icons/gridicons_location.svg"),
                            ),
                          ),
                          SizedBox(width: 20.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current Location",
                                style: TextStyle(
                                  fontFamily: "HelveticaNeue",
                                  fontSize: 10.h,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      const Color(0xff202224).withOpacity(.50),
                                ),
                              ),
                              Obx(() => Text(
                                    controller.distanceMessage.value,
                                    style: TextStyle(
                                      fontFamily: "HelveticaNeue",
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff202224),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Column(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                  color: Color(0xff0066D8), width: 2),
                            ),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(vertical: 12.h)),
                            minimumSize: MaterialStateProperty.all(
                                Size(double.infinity, 48.h)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                          ),
                          child: Text(
                            "Retake Photo",
                            style: TextStyle(
                              fontFamily: "HelveticaNeue",
                              fontSize: 16.h,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff0066D8),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          onPressed: () {
                            if (!controller.isLoadingCheckin.value &&
                                !controller.isLoadingCheckout.value) {
                              if (controller.isCheckIn.value) {
                                controller.postCheckin();
                              } else {
                                controller.postCheckout();
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff0066D8)),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(vertical: 12.h)),
                            minimumSize: MaterialStateProperty.all(
                                Size(double.infinity, 48.h)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                          ),
                          child: Obx(() {
                            // Tampilkan loading jika proses sedang berlangsung
                            if (controller.isCheckIn.value &&
                                controller.isLoadingCheckin.value) {
                              return SizedBox(
                                height: 24.h,
                                width: 24.h,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              );
                            } else if (!controller.isCheckIn.value &&
                                controller.isLoadingCheckout.value) {
                              return SizedBox(
                                height: 24.h,
                                width: 24.h,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              );
                            } else {
                              // Tampilkan teks jika tidak ada proses loading
                              return Text(
                                controller.isCheckIn.value
                                    ? "Check-In"
                                    : "Check-Out",
                                style: TextStyle(
                                  fontFamily: "HelveticaNeue",
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
