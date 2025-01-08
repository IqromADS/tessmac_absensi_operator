import 'package:absensi_operator/app/modules/Inspection/controllers/inspection_controller.dart';
import 'package:absensi_operator/app/modules/Inspection/views/inspection_view.dart';
import 'package:absensi_operator/app/modules/absensi/controllers/absensi_controller.dart';
import 'package:absensi_operator/app/modules/absensi/views/absensi_view.dart';
import 'package:absensi_operator/app/modules/history/views/history_view.dart';
import 'package:absensi_operator/app/modules/home/views/home_view.dart';
import 'package:absensi_operator/app/modules/profile/views/profile_view.dart';
import 'package:absensi_operator/app/modules/schedule/views/schedule_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  DateTime? _lastPressedTime;

  final AbsensiController checkinController = Get.put(AbsensiController());
  final InspectionController inspectionController =
      Get.put(InspectionController());

  static final List<Widget> _screens = [
    const HomeView(),
    const HistoryView(),
    const AbsensiView(),
    const InspectionView(),
    const ScheduleView(),
    const ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 3) {
        // Reset state untuk InspectionView
        inspectionController.resetState();
      }

      // Logika untuk Absensi (Check-In) View
      if (_selectedIndex == 2 && index != 2) {
        if (checkinController.isCountdownActive.value) {
          checkinController.countdownTimer?.cancel();
          checkinController.isCountdownActive.value = false;
          checkinController.isProcessing.value = false;
        }
        checkinController.deactivateCamera();
      } else if (_selectedIndex != 2 && index == 2) {
        checkinController.initializeCamera();
      }

      // Perbarui index yang dipilih
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    DateTime currentTime = DateTime.now();

    if (_lastPressedTime == null ||
        currentTime.difference(_lastPressedTime!) > const Duration(seconds: 2)) {
      _lastPressedTime = currentTime;

      Get.snackbar(
        "Press Back Again",
        "Press back again within 2 seconds to exit the app.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return false; // Jangan keluar
    }

    SystemNavigator.pop(); // Keluar dari aplikasi
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildNavBarItem('assets/icons/home.svg', 'Home', 0),
              buildNavBarItem('assets/icons/history.svg', 'History', 1),
              buildNavBarItem(
                  'assets/icons/akar-icons_check-in.svg', 'Check In', 2),
              buildNavBarItem(
                  'assets/icons/cil_inspection.svg', 'Inspection', 3),
              buildNavBarItem('assets/icons/calendar.svg', 'Schedule', 4),
              buildNavBarItem('assets/icons/person.svg', 'Profile', 5),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget buildNavBarItem(String svgPath, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgPath,
            colorFilter: ColorFilter.mode(
              _selectedIndex == index
                  ? const Color(0xff0066D8)
                  : const Color(0xA0575869),
              BlendMode.srcIn,
            ),
            height: 20.h,
            width: 20.h,
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index
                  ? const Color(0xFF0066D8)
                  : const Color(0xA0575869),
            ),
          ),
        ],
      ),
    );
  }
}
