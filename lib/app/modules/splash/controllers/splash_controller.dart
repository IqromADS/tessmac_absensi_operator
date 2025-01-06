import 'package:absensi_operator/app/modules/onboarding/views/onboarding_view.dart';
import 'package:absensi_operator/app/widgets/bottomNav.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    Future.delayed(const Duration(seconds: 2), () {
      if (token != null && token.isNotEmpty) {
        Get.offAll(() => const BottomNavBar(), transition: Transition.fadeIn);
      } else {
        Get.offAll(() => const OnboardingView(), transition: Transition.fadeIn);
      }
    });
  }
}
