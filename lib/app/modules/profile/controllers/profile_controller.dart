import 'dart:async';

import 'package:absensi_operator/app/data/attendancesOverview.dart';
import 'package:absensi_operator/app/modules/login/views/login_view.dart';
import 'package:absensi_operator/app/services/api_services.dart';
import 'package:absensi_operator/app/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileController extends GetxController {
  var currentDate = ''.obs;
  var userName = ''.obs;
  var userProfilePic = ''.obs;
  var roleName = ''.obs;
  var terminalName = ''.obs;
  var total_attendance = 0.obs;
  var total_lateness_checkin = 0.obs;
  var total_absent = 0.obs;
  Timer? attendanceTimer;
  var isSnackbarActive = false.obs;

  void fetchUserName() async {
    final name = await SharedPreferencesHelper.getUserName();
    userName.value = name ?? 'User';
  }

  void fetchUserProfilePic() async {
    final profilePic = await SharedPreferencesHelper.getUserProfilePic();
    print("Profile Pic URL: $profilePic");
    userProfilePic.value = profilePic ?? '';
  }

  void fetchUserRole() async {
    final role = await SharedPreferencesHelper.getUserRole();
    roleName.value = role ?? 'Role';
    print("Role: $role");
  }

  void fetchTerminalName() async {
    final terminal = await SharedPreferencesHelper.getTerminalName();
    terminalName.value = terminal ?? 'Terminal';
  }

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat('d MMM y').format(now);
  }

  void startAttendancePolling() {
    attendanceTimer?.cancel();
    attendanceTimer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        fetchAttendanceById();
      },
    );
  }

  void stopAttendancePolling() {
    attendanceTimer?.cancel();
  }

  void fetchAttendanceById() async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();

      if (userId != null) {
        AttendancesResponseOverView response =
            await ApiService().getAttendanceByIdOverview(userId.toString());

        total_attendance.value = response.data.totalAttendance;
        total_lateness_checkin.value = response.data.totalLatenessCheckin;
        total_absent.value = response.data.totalAbsent;
      } else {
        print('User ID not found');
      }
    } catch (e) {
      print('Error fetching attendance: $e');
    }
  }

  Future<void> logout() async {
    try {
      await ApiService().logout();
      await SharedPreferencesHelper.clear();
      Get.offAll(() => const LoginView(), transition: Transition.fadeIn);

      showSnackbarOnce(
        "Logout",
        "You have successfully logged out",
      );
    } catch (e) {
      showSnackbarOnce(
        "Logout Failed",
        "Cek koneksi internet Anda",
      );
      print('Error logging out: $e');
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
        colorText: Colors.white,
      );

      Future.delayed(const Duration(seconds: 3), () {
        isSnackbarActive.value = false;
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    updateCurrentDate();
    fetchUserName();
    fetchUserProfilePic();
    fetchUserRole();
    fetchTerminalName();
    startAttendancePolling();
    fetchAttendanceById();
  }

  @override
  void onClose() {
    stopAttendancePolling();
    super.onClose();
  }
}
