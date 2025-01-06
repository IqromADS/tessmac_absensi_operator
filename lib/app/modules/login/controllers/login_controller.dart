import 'package:absensi_operator/app/services/api_services.dart';
import 'package:absensi_operator/app/widgets/bottomNav.dart';
import 'package:absensi_operator/app/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isEmailError = false.obs;
  var isPasswordError = false.obs;
  var isSnackbarActive = false.obs;
  var isLoading = false.obs;

  final ApiService _apiService = ApiService();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    isEmailError.value = false;
    isPasswordError.value = false;

    if (emailController.text.trim().isEmpty) {
      isEmailError.value = true;
      showSnackbarOnce("Error", "Email tidak boleh kosong.");
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      isPasswordError.value = true;
      showSnackbarOnce("Error", "Password tidak boleh kosong.");
      return;
    }

    // Set loading to true
    isLoading.value = true;

    try {
      final response = await _apiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (response.status == 'success') {
        await SharedPreferencesHelper.saveToken(response.token);
        if (response.data != null) {
          await SharedPreferencesHelper.saveUserName(response.data!.nama);
          await SharedPreferencesHelper.saveUserRole(response.data!.roleName);
          await SharedPreferencesHelper.saveTerminalName(
              response.data!.terminalName);
        }

        Get.snackbar(
          "Login Successful",
          "Welcome ${response.data?.nama}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.transparent,
        );
        Get.offAll(() => const BottomNavBar(), transition: Transition.fadeIn);
      } else {
        _onLoginFailed(response.message);
      }
    } on Exception catch (e) {
      if (e.toString().contains("Tidak ada koneksi internet")) {
        showSnackbarOnce("Error",
            "Tidak ada koneksi internet. Silakan periksa jaringan Anda.");
      } else {
        _onLoginFailed(e.toString());
      }
    } finally {
      // Set loading to false after process completes
      isLoading.value = false;
    }
  }

  void _onLoginFailed(String message) {
    isEmailError.value = false;
    isPasswordError.value = false;

    if (message.contains("email") || message.contains("Email")) {
      isEmailError.value = true;
      showSnackbarOnce(
          "Login Failed", "Email salah. Periksa kembali email Anda.");
    } else if (message.contains("password") || message.contains("Password")) {
      isPasswordError.value = true;
      showSnackbarOnce(
          "Login Failed", "Password salah. Periksa kembali password Anda.");
    } else {
      showSnackbarOnce("Login Failed", message);
    }
  }

  void showSnackbarOnce(String title, String message) {
    if (!isSnackbarActive.value) {
      isSnackbarActive.value = true;
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.transparent,
      );
      Future.delayed(const Duration(seconds: 3), () {
        isSnackbarActive.value = false;
      });
    }
  }
}
