import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controllers/inspection_controller.dart';

class InspectionView extends GetView<InspectionController> {
  const InspectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InspectionController());

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset("assets/images/Group.png"),
          ),
          Padding(
              padding: EdgeInsets.only(top: 60.h, left: 24.w, right: 24.w),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Inspection",
                      style: TextStyle(
                        fontFamily: "HelveticaNeue",
                        fontSize: 20.h,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.only(top: 110.h),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                child: SingleChildScrollView(
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Text(
                                    controller.userName.value,
                                    style: TextStyle(
                                      fontFamily: "HelveticaNeue",
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff202224),
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    "${controller.roleName.value} - ${controller.terminalName.value}",
                                    style: TextStyle(
                                      fontFamily: "HelveticaNeue",
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff202224),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Obx(() {
                              return controller.userProfilePic.value.isNotEmpty
                                  ? CircleAvatar(
                                      radius: 50.w,
                                      backgroundImage: NetworkImage(
                                          controller.userProfilePic.value),
                                    )
                                  : CircleAvatar(
                                      radius: 40.h,
                                      child: const Icon(Icons.person),
                                    );
                            }),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Text(
                              "Plat ",
                              style: TextStyle(
                                fontFamily: "HelveticaNeue",
                                fontSize: 16.h,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff202224),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontFamily: "HelveticaNeue",
                                fontSize: 16.h,
                                fontWeight: FontWeight.w700,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),

                        GestureDetector(
                          onTap: () {
                            controller.isDropdownVisible.toggle();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xffB7B7B7), width: 2.w),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    controller.selectedPlate.value.isEmpty
                                        ? "Pilih Plat"
                                        : controller.selectedPlate.value,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SvgPicture.asset(
                                  controller.isDropdownVisible.value
                                      ? 'assets/icons/bxs_up-arrow.svg'
                                      : 'assets/icons/bxs_down-arrow.svg',
                                  width: 12.w,
                                  height: 12.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (controller.isDropdownVisible.value)
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xffB7B7B7), width: 2.w),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: controller.plates.map((plate) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.selectedPlate.value = plate.plat;
                                    controller.isDropdownVisible.value = false;
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                    child: Text(
                                      plate.plat,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 16.h,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                        // Elemen lainnya hanya muncul jika ada nilai pada dropdown
                        if (controller.selectedPlate.value.isNotEmpty) ...[
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Text(
                                "Device Photo ",
                                style: TextStyle(
                                  fontFamily: "HelveticaNeue",
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff202224),
                                ),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  fontFamily: "HelveticaNeue",
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          _buildCameraSection(
                            title: "Front Camera",
                            photoPath: controller.frontCameraPath,
                            onTap: () => controller.openCameraFor("front"),
                          ),
                          SizedBox(height: 10.h),
                          _buildCameraSection(
                            title: "Right Camera",
                            photoPath: controller.rightCameraPath,
                            onTap: () => controller.openCameraFor("right"),
                          ),
                          SizedBox(height: 10.h),
                          _buildCameraSection(
                            title: "Left Camera",
                            photoPath: controller.leftCameraPath,
                            onTap: () => controller.openCameraFor("left"),
                          ),
                          SizedBox(height: 10),
                          _buildCameraSection(
                            title: "Person Camera",
                            photoPath: controller.personCameraPath,
                            onTap: () => controller.openCameraFor("person"),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Text(
                                "Truck Photo ",
                                style: TextStyle(
                                  fontFamily: "HelveticaNeue",
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff202224),
                                ),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  fontFamily: "HelveticaNeue",
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          _buildCameraSection(
                            title: "Front Truck",
                            photoPath: controller.truckCameraPath,
                            onTap: () => controller.openCameraFor("truck"),
                          ),

                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Text(
                                "Condition ",
                                style: TextStyle(
                                  fontFamily: "HelveticaNeue",
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff202224),
                                ),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  fontFamily: "HelveticaNeue",
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          //Checkbox Condition
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => Row(
                                      children: [
                                        Transform.scale(
                                          scale: 1.h,
                                          child: Checkbox(
                                            value:
                                                controller.isRedSelected.value,
                                            onChanged: (value) {
                                              controller.updateCondition(
                                                  'Red', value!);
                                            },
                                            activeColor:
                                                const Color(0xff0066D8),
                                          ),
                                        ),
                                        Text(
                                          "Red",
                                          style: TextStyle(
                                            fontFamily: "HelveticaNeue",
                                            fontSize: 16.h,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff202224),
                                          ),
                                        ),
                                      ],
                                    )),
                                Obx(() => Row(
                                      children: [
                                        Transform.scale(
                                          scale: 1.h,
                                          child: Checkbox(
                                            value: controller
                                                .isYellowSelected.value,
                                            onChanged: (value) {
                                              controller.updateCondition(
                                                  'Yellow', value!);
                                            },
                                            activeColor:
                                                const Color(0xff0066D8),
                                          ),
                                        ),
                                        Text(
                                          "Yellow",
                                          style: TextStyle(
                                            fontFamily: "HelveticaNeue",
                                            fontSize: 16.h,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff202224),
                                          ),
                                        ),
                                      ],
                                    )),
                                Obx(() => Row(
                                      children: [
                                        Transform.scale(
                                          scale: 1.h,
                                          child: Checkbox(
                                            value: controller
                                                .isGreenSelected.value,
                                            onChanged: (value) {
                                              controller.updateCondition(
                                                  'Green', value!);
                                            },
                                            activeColor:
                                                const Color(0xff0066D8),
                                          ),
                                        ),
                                        Text(
                                          "Green",
                                          style: TextStyle(
                                            fontFamily: "HelveticaNeue",
                                            fontSize: 16.h,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff202224),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xff0066D8),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10).h,
                              child: Column(
                                children: [
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                      fontFamily: "HelveticaNeue",
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Text(
                                    "Green - Optimal Condition",
                                    style: TextStyle(
                                      fontFamily: "HelveticaNeue",
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "The device is operating at peak performance or in its intended state without any issues.",
                                    style: TextStyle(
                                      fontFamily: "HelveticaNeue",
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    "Yellow - Normal/Acceptable Condition",
                                    style: TextStyle(
                                      fontFamily: "HelveticaNeue",
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "The device is functioning normally but may not be at its optimal performance. Some minor issues might exist that do not significantly impact operation.",
                                    style: TextStyle(
                                        fontFamily: "HelveticaNeue",
                                        fontSize: 12.h,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    "Red - Suboptimal/Critical Condition",
                                    style: TextStyle(
                                      fontFamily: "HelveticaNeue",
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "The device is not functioning properly, is failing, or is at risk of significant damage. Immediate action is required",
                                    style: TextStyle(
                                      fontFamily: "HelveticaNeue",
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.submitInspection,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff0066D8)),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: 12.h)),
                              minimumSize: MaterialStateProperty.all(
                                  Size(double.infinity, 48.h)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                            child: controller.isLoading.value
                                ? SizedBox(
                                    width: 24.h,
                                    height: 24.h,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                : Text(
                                    "Submit",
                                    style: TextStyle(
                                      fontFamily: "HelveticaNeue",
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCameraSection({
  required String title,
  required RxString photoPath,
  required VoidCallback onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontFamily: "HelveticaNeue",
          fontSize: 12.h,
          fontWeight: FontWeight.w400,
          color: const Color(0xff7B7B7B),
        ),
      ),
      Obx(() {
        if (photoPath.value.isEmpty) {
          return GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffB7B7B7)),
                borderRadius: BorderRadius.circular(8.r),
                color: const Color(0xffF5F5F5),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: const Color(0xff7B7B7B),
                      size: 20.h,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Tap to open camera",
                      style: TextStyle(
                        fontFamily: "HelveticaNeue",
                        fontSize: 12.h,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff7B7B7B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffB7B7B7)),
              borderRadius: BorderRadius.circular(8.r),
              color: const Color(0xffF5F5F5),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  SvgPicture.asset("assets/icons/material-symbols_image.svg"),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      photoPath.value.split('/').last,
                      style: TextStyle(
                        fontFamily: "HelveticaNeue",
                        fontSize: 12.h,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff202224),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 20.h,
                    ),
                    onPressed: () {
                      photoPath.value = "";
                    },
                  ),
                ],
              ),
            ),
          );
        }
      }),
    ],
  );
}



