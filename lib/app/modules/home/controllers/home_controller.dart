import 'dart:async';

import 'package:absensi_operator/app/data/attendancesOverview.dart';
import 'package:absensi_operator/app/data/jadwal.dart';
import 'package:absensi_operator/app/services/api_services.dart';
import 'package:absensi_operator/app/widgets/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  var currentDate = ''.obs;
  var userName = ''.obs;
  var userProfilePic = ''.obs;
  var jadwalList = [].obs;
  var total_attendance = 0.obs;
  var total_lateness_checkin = 0.obs;
  var total_absent = 0.obs;
  Timer? attendanceTimer;
  var isLoading = true.obs;
  var greeting = ''.obs;
  var IdAttendance = ''.obs;

  void fetchUserName() async {
    final name = await SharedPreferencesHelper.getUserName();
    userName.value = name ?? 'User';
  }

  void fetchUserProfilePic() async {
    final profilePic = await SharedPreferencesHelper.getUserProfilePic();
    print("Profile Pic URL: $profilePic");
    userProfilePic.value = profilePic ?? '';
  }

  void fetchJadwalForCurrentWeek() async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId != null) {
        List<Jadwal> jadwal =
            await ApiService().getJadwalById(userId.toString());

        DateTime now = DateTime.now();
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

        if (now.isAfter(endOfWeek)) {
          startOfWeek = startOfWeek.add(const Duration(days: 7));
          endOfWeek = endOfWeek.add(const Duration(days: 7));
        }

        List<Jadwal> filteredJadwal = jadwal.where((j) {
          DateTime tanggalJadwal = DateTime.parse(j.tanggal ?? '');
          return tanggalJadwal
                  .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              tanggalJadwal.isBefore(endOfWeek.add(const Duration(days: 0)));
        }).toList();

        jadwalList.assignAll(filteredJadwal);
      } else {
        throw Exception('User ID not found');
      }
    } catch (e) {
      print('Error: $e');
    }
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

  void updateCurrentDate() {
    final now = DateTime.now();
    currentDate.value = DateFormat('d MMM y').format(now);
  }

  void updateGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      greeting.value = 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      greeting.value = 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      greeting.value = 'Good Evening';
    } else {
      greeting.value = 'Good Night';
    }
  }

  void OpenWhatsAppChat() {
    const phoneNumber = '+6285329370707';
    const url = 'https://wa.me/$phoneNumber';
    launch(url);
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserName();
    updateCurrentDate();
    fetchUserProfilePic();
    fetchJadwalForCurrentWeek();
    fetchAttendanceById();
    startAttendancePolling();
    updateGreeting();
  }

  @override
  void onClose() {
    stopAttendancePolling();
    super.onClose();
  }
}
