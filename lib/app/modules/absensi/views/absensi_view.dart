import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/absensi_controller.dart';

class AbsensiView extends GetView<AbsensiController> {
  const AbsensiView({super.key});
  @override
  Widget build(BuildContext context) {
    final AbsensiController controller = Get.put(AbsensiController());
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () {
            if (!controller.isCameraInitialized.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                Container(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: Transform.scale(
                      scale: 1.70.h,
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: CameraPreview(controller.cameraController),
                      ),
                    ),
                  ),
                ),
                if (controller.isCountdownActive.value)
                  Center(
                    child: Obx(() {
                      return Text(
                        ' ${controller.countdownSeconds.value}',
                        style: TextStyle(
                          fontSize: 100.h,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      );
                    }),
                  ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 10.h),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 185.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target:
                                            controller.initialLocation.value,
                                        zoom: 14,
                                      ),
                                      markers: controller.markers.value,
                                      onMapCreated:
                                          (GoogleMapController mapController) {
                                        controller.setGoogleMapController(
                                            mapController);
                                      },
                                      mapToolbarEnabled: true,
                                      myLocationEnabled: true,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4).h,
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: controller
                                                      .distanceMessage.value ==
                                                  "Out of range for the office!"
                                              ? Colors.red
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 12)
                                              .h,
                                          child: Obx(() {
                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  controller.currentTime.value,
                                                  style: TextStyle(
                                                    fontFamily: "HelveticaNeue",
                                                    fontSize: 12.h,
                                                    fontWeight: FontWeight.w500,
                                                    color: controller
                                                                .distanceMessage
                                                                .value ==
                                                            "Out of range for the office!"
                                                        ? Colors.white
                                                        : const Color(
                                                            0xff888888),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  controller
                                                      .distanceMessage.value,
                                                  style: TextStyle(
                                                    fontFamily: "HelveticaNeue",
                                                    fontSize: 12.h,
                                                    fontWeight: FontWeight.w400,
                                                    color: controller
                                                                .distanceMessage
                                                                .value ==
                                                            "Out of range for the office!"
                                                        ? Colors.white
                                                        : const Color(
                                                            0xff888888),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Obx(() => ElevatedButton(
                                    onPressed: (!controller.isGPSActive.value ||
                                            controller.distanceMessage.value ==
                                                "Out of range for the office!")
                                        ? null
                                        : () {
                                            controller.startCountdown();
                                          },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        (!controller.isGPSActive.value ||
                                                controller.distanceMessage
                                                        .value ==
                                                    "Out of range for the office!")
                                            ? Colors.grey
                                            : const Color(0xff0066D8),
                                      ),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(vertical: 12.h)),
                                      minimumSize: MaterialStateProperty.all(
                                          Size(double.infinity, 48.h)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      )),
                                    ),
                                    child: Text(
                                      "Take Photo",
                                      style: TextStyle(
                                        fontSize: 16.h,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
