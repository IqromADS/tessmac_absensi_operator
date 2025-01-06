import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Group.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60.w,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontFamily: "HelveticaNeue",
                          fontSize: 28.h,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Hello again, you've been missed!",
                    style: TextStyle(
                      fontFamily: "HelveticaNeue",
                      fontSize: 16.h,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 40, right: 20, left: 20).h,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                        fontFamily: "HelveticaNeue",
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff677687),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => TextField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          hintText: "Input Email",
                          hintStyle: TextStyle(
                            fontFamily: "HelveticaNeue",
                            fontSize: 14.h,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff20222480),
                          ),
                          filled: true,
                          fillColor: const Color(0xffF5F6F7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: controller.isEmailError.value
                                ? const BorderSide(color: Colors.red, width: 2)
                                : BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: controller.isEmailError.value
                                ? const BorderSide(color: Colors.red, width: 2)
                                : BorderSide.none,
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: SvgPicture.asset(
                              "assets/icons/email.svg",
                              width: 20.w,
                              height: 20.h,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: "HelveticaNeue",
                          fontSize: 14.h,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        cursorColor: const Color(0xff0066D8),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      "Password",
                      style: TextStyle(
                        fontFamily: "HelveticaNeue",
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff677687),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(() => TextField(
                          controller: controller.passwordController,
                          obscureText: controller.isPasswordHidden.value,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            hintText: "Input Password",
                            hintStyle: TextStyle(
                              fontFamily: "HelveticaNeue",
                              fontSize: 14.h,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff20222480),
                            ),
                            filled: true,
                            fillColor: const Color(0xffF5F6F7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: controller.isPasswordError.value
                                  ? const BorderSide(
                                      color: Colors.red, width: 2)
                                  : BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: controller.isPasswordError.value
                                  ? const BorderSide(
                                      color: Colors.red, width: 2)
                                  : BorderSide.none,
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: SvgPicture.asset(
                                "assets/icons/password.svg",
                                width: 20.w,
                                height: 20.h,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                controller.isPasswordHidden.value =
                                    !controller.isPasswordHidden.value;
                              },
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: "HelveticaNeue",
                            fontSize: 14.h,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          cursorColor: const Color(0xff0066D8),
                        )),
                    SizedBox(height: 48.h),
                    Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.login,
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
                          child: Obx(() => controller.isLoading.value
                              ? SizedBox(
                                  width: 24.h,
                                  height: 24.h,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                    fontFamily: "HelveticaNeue",
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                )),
                        ))
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
