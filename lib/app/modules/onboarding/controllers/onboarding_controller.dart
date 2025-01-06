import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  // -------------------- Variabel dan Properti --------------------
  final PageController indicator =
      PageController(); // Pengontrol halaman onboarding
  final RxInt page =
      0.obs; // Variabel untuk menyimpan halaman yang sedang aktif

  // Data slide onboarding yang terdiri dari title dan description
  final List<Map<String, String>> slideData = [
    {
      'title': 'Check Your Attendance\nwith a Single Tap',
      'description':
          'Simply open the app, tap once, and your attendance is recorded. Stay focused on your work, not on the paperwork!'
    },
    {
      'title': 'Fast and Easy Attendance,\nAnytime',
      'description':
          'No matter the time or place, mark your attendance in seconds. Whether you’re starting a shift or checking out, it’s just a few taps away.'
    },
    {
      'title': 'Track Your Attendance with\nLocation and Photos',
      'description':
          'Easily confirm your presence with a quick photo and location check-in. Perfect for teams that need transparent, reliable attendance tracking'
    },
  ];

  // -------------------- Lifecycle Method --------------------
  @override
  void onClose() {
    // Menutup PageController saat controller dihancurkan
    indicator.dispose();
    super.onClose();
  }
}
