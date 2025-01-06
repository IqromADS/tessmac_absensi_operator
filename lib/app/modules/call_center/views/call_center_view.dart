import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/call_center_controller.dart';

class CallCenterView extends GetView<CallCenterController> {
  const CallCenterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(CallCenterController());
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("assets/images/Group.png"),
          Padding(
            padding: EdgeInsets.only(top: 60.h, left: 24.h, right: 24.h),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 24.h,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Call Center",
                      style: TextStyle(
                        fontFamily: "HelveticaNeue",
                        fontSize: 20.h,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 110.h),
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
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.OpenEmail();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 60.h,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/ic_round-email.svg",
                              width: 22.w,
                              height: 22.h,
                            ),
                            SizedBox(width: 20.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeue",
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff202224),
                                  ),
                                ),
                                Text(
                                  "arya@ayodyads.com",
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeue",
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff202224),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        controller.OpenPhoneDialer();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 60.h,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/fluent_call-24-filled.svg",
                              width: 22.w,
                              height: 22.h,
                              color: Colors.black,
                            ),
                            SizedBox(width: 20.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone",
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeue",
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff202224),
                                  ),
                                ),
                                Text(
                                  "+6285329370707",
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeue",
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff202224),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        controller.OpenWhatsAppChat();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 60.h,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/ri_whatsapp-fill.svg",
                              width: 22.w,
                              height: 22.h,
                              color: Colors.black,
                            ),
                            SizedBox(width: 20.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Whatsapp",
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeue",
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff202224),
                                  ),
                                ),
                                Text(
                                  "+6285329370707",
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeue",
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff202224),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
