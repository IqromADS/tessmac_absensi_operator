import 'dart:async';
import 'package:absensi_operator/app/data/jadwal.dart';
import 'package:absensi_operator/app/modules/absensi/controllers/absensi_controller.dart';
import 'package:absensi_operator/app/modules/absensi_preview/views/succes_absensi_view.dart';
import 'package:absensi_operator/app/services/api_services.dart';
import 'package:absensi_operator/app/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AbsensiPreviewController extends GetxController {
  // -------------------- Observables --------------------
  RxString imagePath = ''.obs;
  RxString distanceMessage = 'Calculating distance...'.obs;
  RxString idDevice = ''.obs;
  RxString checkInLocation = ''.obs;
  RxString latitudeTerminal = ''.obs;
  RxString longitudeTerminal = ''.obs;
  RxString idUser = ''.obs;
  RxBool isLibur = false.obs;
  Rx<String?> idAttendance = Rx<String?>(null);
  RxBool check_in_lateness = true.obs;
  RxBool check_out_lateness = true.obs;
  var isSnackbarActive = false.obs;
  late String checkinDate;
  var isLoading = false.obs;
  var isLoadingCheckin = false.obs;
  var isLoadingCheckout = false.obs;
  var isCheckIn = false.obs;

  // -------------------- Lifecycle Hooks --------------------
  @override
  void onInit() {
    super.onInit();
    _initializeController();
    fetchIdAttendanceOnLogin();
    isCheckIn.value = idAttendance.value == '0';
  }

  // -------------------- Initialization --------------------
  void _initializeController() {
    final arguments = Get.arguments;
    print('Arguments received: $arguments');
    imagePath.value = arguments['imagePath'] ?? '';
    checkInLocation.value = arguments['check_in_location'] ?? '';
    idDevice.value = arguments['idDevice'] ?? '';
    idUser.value = arguments['userid'] ?? '';

    if (imagePath.value.isEmpty) {
      showSnackbarOnce('Error', 'Image not found. Please take a new photo.');
      return;
    }

    fetchLatitude();
    fetchLongitude();
    _calculateDistanceFromOffice();
    getJadwalHariIni();
  }

  // -------------------- Utility Functions --------------------
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  // -------------------- Data Fetching --------------------
  void fetchLatitude() async {
    final lat = await SharedPreferencesHelper.getlatitude();
    latitudeTerminal.value = lat ?? '';
  }

  void fetchLongitude() async {
    final long = await SharedPreferencesHelper.getlongitude();
    longitudeTerminal.value = long ?? '';
  }

  void getJadwalHariIni() async {
    final userId = await SharedPreferencesHelper.getUserId();
    if (userId == null) {
      print('User ID not found');
      return;
    }

    try {
      final jadwal = await ApiService().getJadwalById(userId.toString());
      final today = DateTime.now();

      // Cari jadwal untuk hari ini atau jadwal shift 3 yang melintasi hari
      final jadwalHariIni = jadwal.where((j) {
        final tanggalJadwal = DateTime.tryParse(j.tanggal!);
        if (tanggalJadwal == null) {
          print('Invalid date format: ${j.tanggal}');
          return false;
        }

        if (tanggalJadwal.year == today.year &&
            tanggalJadwal.month == today.month &&
            tanggalJadwal.day == today.day) {
          return true; // Jadwal untuk hari ini
        }

        // Periksa jadwal shift 3 yang melintasi hari
        if (j.shift == "Shift 3" && j.jamMasuk != null && j.jamKeluar != null) {
          final jamMasuk = DateFormat('HH:mm').parse(j.jamMasuk!);
          final jamMasukDateTime = DateTime(
            tanggalJadwal.year,
            tanggalJadwal.month,
            tanggalJadwal.day,
            jamMasuk.hour,
            jamMasuk.minute,
          );

          final jamKeluar = DateFormat('HH:mm').parse(j.jamKeluar!);
          final jamKeluarDateTime = DateTime(
            tanggalJadwal.year,
            tanggalJadwal.month,
            tanggalJadwal.day + 1, // Shift 3 berakhir keesokan harinya
            jamKeluar.hour,
            jamKeluar.minute,
          );

          return today.isAfter(jamMasukDateTime) &&
              today.isBefore(jamKeluarDateTime);
        }

        return false;
      }).toList();

      if (jadwalHariIni.isNotEmpty) {
        final jadwalAktif = jadwalHariIni[0];

        final jamKeluarString = jadwalAktif.jamKeluar;
        if (jamKeluarString != null) {
          final jamKeluarTime = DateFormat('HH:mm').parse(jamKeluarString);
          final jamKeluarDateTime = jadwalAktif.shift == "Shift 3"
              ? DateTime(today.year, today.month, today.day + 1,
                  jamKeluarTime.hour, jamKeluarTime.minute)
              : DateTime(today.year, today.month, today.day, jamKeluarTime.hour,
                  jamKeluarTime.minute);

          await SharedPreferencesHelper.saveJamKeluar(
              jamKeluarDateTime.toIso8601String());
        }
      } else {
        print(
            'Tidak ada jadwal untuk hari ini atau shift 3 yang masih berlaku.');
      }
    } catch (e) {
      print('Failed to retrieve schedule: $e');
    }
  }

  // -------------------- Distance Calculation --------------------
  Future<void> _calculateDistanceFromOffice() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        double.parse(latitudeTerminal.value),
        double.parse(longitudeTerminal.value),
      );
      print(
          'Latitude: ${latitudeTerminal.value}, Longitude: ${longitudeTerminal.value}');
      distanceMessage.value =
          'You are ${distanceInMeters.round()} meters from the office';
    } catch (e) {
      distanceMessage.value = 'Failed to get location';
    }
  }

  void fetchIdAttendanceOnLogin() async {
    final savedIdAttendance =
        await SharedPreferencesHelper.getCheckInAttendanceId();
    final today = DateTime.now();

    if (savedIdAttendance != null && savedIdAttendance.isNotEmpty) {
      idAttendance.value = savedIdAttendance;

      final lastAttendanceDate =
          await SharedPreferencesHelper.getLastAttendanceDate();
      if (lastAttendanceDate == null ||
          DateTime.parse(lastAttendanceDate).day != today.day) {
        idAttendance.value = '0';
        await SharedPreferencesHelper.removeCheckInAttendanceId();
      }

      isCheckIn.value = idAttendance.value == '0'; // Perbarui isCheckIn
    } else {
      idAttendance.value = '0'; // Belum check-in
      isCheckIn.value = true;
    }
    print('IdAttendance retrieved: $idAttendance');
  }

  // -------------------- Check-In Process --------------------
  Future<void> postCheckin() async {
    if (isLibur.value) {
      if (idAttendance.value != 0) {
        showSnackbarOnce(
            'Checkout Required', 'Selesaikan checkout terlebih dahulu.');
        return;
      }
      showSnackbarOnce(
          'Libur', 'Hari ini kamu libur, tidak bisa melakukan check-in.');
      return;
    }

    final userId = await SharedPreferencesHelper.getUserId();
    if (userId == null) {
      showSnackbarOnce('Error', 'User ID tidak ditemukan. Coba lagi.');
      return;
    }

    // Jika sudah check-in, tidak boleh melakukan check-in lagi
    if (idAttendance.value != "0") {
      showSnackbarOnce(
          'Already Checked In', 'Anda sudah melakukan check-in hari ini.');
      return;
    }

    isLoadingCheckin.value = true;

    try {
      if (imagePath.value.isEmpty) {
        showSnackbarOnce('Error', 'No image available for check-in.');
        return;
      }

      final today = DateTime.now();
      final jadwal = await ApiService().getJadwalById(userId.toString());

      // Cari jadwal hari ini
      final jadwalHariIni = jadwal.firstWhere(
        (j) {
          final tanggalJadwal = DateTime.parse(j.tanggal!);
          return tanggalJadwal.year == today.year &&
              tanggalJadwal.month == today.month &&
              tanggalJadwal.day == today.day;
        },
        orElse: () => Jadwal(hari: "", tanggal: "", shift: "Libur"),
      );

      if (jadwalHariIni.shift == "Libur") {
        showSnackbarOnce(
            'Libur', 'Hari ini kamu libur, tidak bisa melakukan check-in.');
        return;
      }

      final jamMasukTime =
          DateFormat('HH:mm').parse(jadwalHariIni.jamMasuk ?? "00:00");
      final jamMasukDateTime = DateTime(
        today.year,
        today.month,
        today.day,
        jamMasukTime.hour,
        jamMasukTime.minute,
      );

      final now = DateTime.now();
      final startCheckInTime =
          jamMasukDateTime.subtract(const Duration(hours: 1));

      // Periksa apakah check-in diizinkan
      if (now.isBefore(startCheckInTime)) {
        showSnackbarOnce('Check-In Not Allowed',
            'Check-in hanya diperbolehkan dari jam ${DateFormat('HH:mm').format(startCheckInTime)}.');
        return;
      }

      // Kirim data check-in ke server
      final response = await ApiService().postCheckInWithImage(
        imagePath: imagePath.value,
        checkInLocation: checkInLocation.value,
        idDevice: idDevice.value,
        idUser: idUser.value,
        checkInDate: _formatDate(DateTime.now()),
      );

      if (response.status == 'success' || response.status == 'alert') {
        final checkInTime = DateTime.parse(response.data.checkInDate);

        // Hitung keterlambatan jika ada
        String? latenessString;
        if (checkInTime.isAfter(jamMasukDateTime)) {
          final latenessDuration = checkInTime.difference(jamMasukDateTime);
          final latenessHours = latenessDuration.inHours;
          final latenessMinutes = latenessDuration.inMinutes % 60;

          latenessString = "$latenessHours hours and $latenessMinutes minutes";
        }

        // Simpan idAttendance
        idAttendance.value = response.data.idAttendance.toString();
        await SharedPreferencesHelper.saveCheckInAttendanceId(
            response.data.idAttendance.toString());
        await SharedPreferencesHelper.saveLastAttendanceDate(
            DateTime.now().toIso8601String());

        // Simpan jam keluar
        if (jadwalHariIni.jamKeluar != null) {
          await SharedPreferencesHelper.saveJamKeluar(jadwalHariIni.jamKeluar!);
        }

        print('idAttendance setelah check-in: ${idAttendance.value}');

        isCheckIn.value = false;

        // Navigasi ke halaman sukses
        Get.off(
          SuccesAbsensiView(isCheckIn: true),
          arguments: {'lateness': latenessString},
        );
      } else {
        showSnackbarOnce('Check-In Failed', response.message);
      }
    } catch (e) {
      showSnackbarOnce('Error', 'Terjadi kesalahan saat check-in. Coba lagi.');
      print('Error during check-in: $e');
    } finally {
      isLoadingCheckin.value = false;
    }
  }

  Future<void> postCheckout() async {
    final jamKeluarString = await SharedPreferencesHelper.getJamKeluar();
    if (jamKeluarString == null || jamKeluarString.isEmpty) {
      showSnackbarOnce('Error', 'Jadwal jam keluar tidak ditemukan.');
      return;
    }

    if (idAttendance.value == null || idAttendance.value!.isEmpty) {
      showSnackbarOnce('Error', 'ID Attendance tidak valid.');
      return;
    }

    isLoadingCheckout.value = true;

    try {
      DateTime jamKeluarTime;
      // Parsing jamKeluarString
      if (jamKeluarString.contains('T') || jamKeluarString.contains('-')) {
        jamKeluarTime = DateTime.tryParse(jamKeluarString) ??
            (throw FormatException(
                'Format jam keluar tidak valid: $jamKeluarString'));
      } else {
        final today = DateTime.now();
        final splitJamKeluar = jamKeluarString.split(':');
        jamKeluarTime = DateTime(
          today.year,
          today.month,
          today.day,
          int.parse(splitJamKeluar[0]),
          int.parse(splitJamKeluar[1]),
        );
      }

      final now = DateTime.now();
      final checkoutLimit = jamKeluarTime.add(const Duration(minutes: 30));

      // Validasi waktu checkout
      // Pastikan waktu sekarang berada dalam rentang waktu checkout
      if (now.isBefore(jamKeluarTime) || now.isAfter(checkoutLimit)) {
        // Log tambahan untuk debugging
        print("Sekarang: ${now.toIso8601String()}");
        print("Jam Keluar: ${jamKeluarTime.toIso8601String()}");
        print("Batas Akhir Checkout: ${checkoutLimit.toIso8601String()}");

        // Tampilkan pesan kesalahan
        showSnackbarOnce(
          'Checkout Not Allowed',
          'Checkout hanya diperbolehkan dari ${DateFormat('HH:mm').format(jamKeluarTime)} hingga ${DateFormat('HH:mm').format(checkoutLimit)}.',
        );
        return;
      }

      // Kirim data checkout ke server
      final response = await ApiService().postCheckout(
        imagePath: imagePath.value,
        checkOutLocation: checkInLocation.value,
        idDevice: idDevice.value,
        idUser: idUser.value,
        idAttendance: idAttendance.value!,
        checkOutDate: _formatDate(DateTime.now()),
      );

      if (response.status == 'success') {
        await SharedPreferencesHelper.removeCheckInAttendanceId();
        await SharedPreferencesHelper.clearJamKeluar();
        await SharedPreferencesHelper.removeLastAttendanceDate();
        await SharedPreferencesHelper.removeCheckInAttendanceId();

        idAttendance.value = null;
        isCheckIn.value = true;
        print('Checkout berhasil, idAttendance dan jam keluar dihapus.');
        Get.off(const SuccesAbsensiView(isCheckIn: false));
      } else {
        showSnackbarOnce('Checkout Failed', response.message);
      }
    } catch (e) {
      print('Error during checkout: $e');
      showSnackbarOnce('Error', 'Terjadi kesalahan saat checkout. Coba lagi.');
    } finally {
      isLoadingCheckout.value = false;
    }
  }

  // -------------------- Utility --------------------
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
