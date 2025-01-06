import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.checkLoginStatus();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "PresenSee",
              style: TextStyle(
                fontSize: 32.h,
                fontFamily: "HelveticaNeue",
                color: const Color(0xff0066D8),
              ),
            ),
            Text(
              "Jangan Lupa Absen Ya!",
              style: TextStyle(
                fontSize: 12.h,
                fontFamily: "HelveticaNeue",
                color: const Color(0xff363062),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
