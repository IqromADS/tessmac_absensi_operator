import 'dart:async';
import 'package:absensi_operator/app/data/getIdAttendances.dart';
import 'package:absensi_operator/app/data/jadwal.dart';
import 'package:absensi_operator/app/modules/absensi_preview/views/absensi_preview_view.dart';
import 'package:absensi_operator/app/services/api_services.dart';
import 'package:absensi_operator/app/widgets/utils.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_brightness/screen_brightness.dart';

class AbsensiController extends GetxController {
  // -------------------- Reactive Variables --------------------
  var latitudeTerminal = "".obs;
  var longitudeTerminal = "".obs;
  var idDevice = "".obs;
  var idUser = "".obs;
  var currentTime = ''.obs;
  var distanceMessage = "Checking your location...".obs;
  var countdownSeconds = 3.obs;
  var initialLocation = Rx<LatLng>(LatLng(0.0, 0.0));
  var markers = RxSet<Marker>();
  var isProcessing = false.obs;
  var isCountdownActive = false.obs;
  var isCameraInitialized = false.obs;
  var isGPSActive = true.obs;
  var idAttendance = 0.obs;
  var JamKeluar = "".obs;
  var isCheckIn = false.obs;

  // -------------------- Non-Reactive Variables --------------------
  int radius = 0;
  Timer? _timer;
  Timer? countdownTimer;
  Timer? locationTimer;
  GoogleMapController? googleMapController;
  late CameraController cameraController;
  late Future<void> initializeControllerFuture;

  @override
  void onInit() {
    super.onInit();
    fetchIdUser();
    fetchIdAttendanceAndReset();
    _initializeController();
    monitorGPSStatus();
  }

  @override
  void onClose() {
    _disposeResources();
    super.onClose();
  }

  // -------------------- Initialization --------------------
  void _initializeController() {
    _startClock();
    _fetchIdDevice();
    _requestLocationPermission();
    _fetchLocationData();
  }

  void _fetchLocationData() {
    fetchLatitude();
    fetchLongitude();
    fetchRadius();
  }

  void _disposeResources() {
    _stopCamera();
    _timer?.cancel();
    countdownTimer?.cancel();
    locationTimer?.cancel();
  }

  // -------------------- Time Management --------------------
  void _startClock() {
    currentTime.value = _formatCurrentTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      currentTime.value = _formatCurrentTime();
    });
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  // -------------------- GPS and Location --------------------
  void monitorGPSStatus() {
    Timer.periodic(const Duration(seconds: 2), (_) async {
      final gpsEnabled = await Geolocator.isLocationServiceEnabled();
      isGPSActive.value = gpsEnabled;

      if (gpsEnabled) {
        try {
          final position = await _getCurrentPosition();
          _updateDistanceMessage(position);
        } catch (e) {
          distanceMessage.value = "Error retrieving location.";
        }
      } else {
        distanceMessage.value = "Aktifkan GPS untuk melanjutkan.";
      }
    });
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      final gpsEnabled = await Geolocator.isLocationServiceEnabled();
      isGPSActive.value = gpsEnabled;

      if (!gpsEnabled) {
        distanceMessage.value = "Aktifkan GPS untuk melanjutkan.";
      } else {
        _startLocationUpdates();
      }
    } else {
      distanceMessage.value = "Permission lokasi tidak diberikan.";
    }
  }

  void _startLocationUpdates() {
    locationTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (isGPSActive.value) {
        try {
          final position = await _getCurrentPosition();
          _updateDistanceMessage(position);
        } catch (e) {
          distanceMessage.value = "Error updating location.";
        }
      }
    });
  }

  Future<Position> _getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void _updateDistanceMessage(Position position) {
    final distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      initialLocation.value.latitude,
      initialLocation.value.longitude,
    );

    distanceMessage.value = (distanceInMeters <= radius)
        ? "You are within the office range."
        : "Out of range for the office!";
  }

  // -------------------- Camera Management --------------------
  Future<void> initializeCamera() async {
    if (isCameraInitialized.value) return;
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.max,
      );

      initializeControllerFuture = cameraController.initialize();
      await initializeControllerFuture;
      isCameraInitialized.value = true;
    } catch (e) {
      isCameraInitialized.value = false;
      print("Error initializing camera: $e");
    }
  }

  void _stopCamera() {
    if (isCameraInitialized.value) {
      cameraController.dispose();
      isCameraInitialized.value = false;
    }
  }

  Future<void> takePictureWithGPSCheck() async {
    if (!isGPSActive.value) return;

    final imagePath = await takePicture();
    if (imagePath != null) {
      print("Foto berhasil diambil: $imagePath");
    } else {
      Get.snackbar("Error", "Gagal mengambil foto.");
    }
  }

  Future<String?> takePicture() async {
    try {
      await initializeControllerFuture;
      final image = await cameraController.takePicture();
      return image.path;
    } catch (e) {
      print("Error taking picture: $e");
      return null;
    }
  }

  void deactivateCamera() {
    _stopCamera();
  }

  // -------------------- Countdown and Capture --------------------
  void startCountdown() {
    countdownTimer?.cancel();
    isProcessing.value = true;
    isCountdownActive.value = true;
    countdownSeconds.value = 3;

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (countdownSeconds.value > 1) {
        countdownSeconds.value--;
      } else {
        countdownTimer?.cancel();
        _captureAndPreview();
      }
    });
  }

  void _captureAndPreview() async {
    final screenBrightness = ScreenBrightness();

    // Simpan kecerahan awal aplikasi
    final initialAppBrightness = await screenBrightness.application;

    try {
      // Atur kecerahan aplikasi ke maksimum
      await screenBrightness.setApplicationScreenBrightness(1.0);
    } catch (e) {
      print("Error setting brightness: $e");
    }

    final imagePath = await takePicture();
    if (imagePath != null) {
      final position = await _getCurrentPosition();
      final checkInLocation = '${position.latitude},${position.longitude}';
      final checkinDate = _formatDate(DateTime.now());

      // Navigasi ke halaman preview
      Get.to(() => const AbsensiPreviewView(), arguments: {
        'userid': idUser.value,
        'imagePath': imagePath,
        'check_in_location': checkInLocation,
        'idDevice': idDevice.value,
        'checkinDate': checkinDate,
        'idAttendance': idAttendance.value, // Kirim ID Attendance
      });
    } else {
      Get.snackbar("Error", "Failed to take picture.");
    }

    try {
      // Reset kecerahan aplikasi agar kontrol kembali ke sistem
      await screenBrightness.resetApplicationScreenBrightness();
    } catch (e) {
      print("Error resetting brightness: $e");
    }

    isProcessing.value = false;
    isCountdownActive.value = false;
  }

  // -------------------- Data Fetching --------------------
  Future<void> _fetchIdDevice() async {
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      idDevice.value = androidInfo.id ?? 'Unknown ID';
    } catch (e) {
      idDevice.value = 'Error fetching androidId: $e';
    }
  }

  void fetchIdUser() async {
    final id = await SharedPreferencesHelper.getUserId();
    idUser.value = id?.toString() ?? '';
    print('Id User: $idUser');
  }

  void fetchLatitude() async {
    final lat = await SharedPreferencesHelper.getlatitude();
    latitudeTerminal.value = lat ?? '';
    _updateLocation();
  }

  void fetchLongitude() async {
    final long = await SharedPreferencesHelper.getlongitude();
    longitudeTerminal.value = long ?? '';
    _updateLocation();
  }

  void fetchRadius() async {
    final rad = await SharedPreferencesHelper.getRadius();
    radius = rad ?? 0;
    print('Radius: $radius');
  }

//GET ID UNTUK CO
  Future<void> fetchIdAttendanceAndReset() async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId == null) {
        print('User ID not found');
        idAttendance.value = 0;
        return;
      }

      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      // Ambil data jadwal untuk hari ini dan kemarin
      final jadwal = await ApiService().getJadwalById(userId.toString());

      // Cari jadwal untuk hari ini
      final jadwalHariIni = jadwal.firstWhere(
        (j) {
          final tanggalJadwal = DateTime.parse(j.tanggal!);
          return tanggalJadwal.year == now.year &&
              tanggalJadwal.month == now.month &&
              tanggalJadwal.day == now.day;
        },
        orElse: () => Jadwal(
          hari: '',
          tanggal: '',
          shift: 'Libur', // Default ke "Libur"
          jamMasuk: null,
          jamKeluar: null,
        ),
      );

      // Cari jadwal untuk hari kemarin
      final jadwalKemarin = jadwal.firstWhere(
        (j) {
          final tanggalJadwal = DateTime.parse(j.tanggal!);
          return tanggalJadwal.year == yesterday.year &&
              tanggalJadwal.month == yesterday.month &&
              tanggalJadwal.day == yesterday.day;
        },
        orElse: () => Jadwal(
          hari: '',
          tanggal: '',
          shift: 'Libur', // Default ke "Libur"
          jamMasuk: null,
          jamKeluar: null,
        ),
      );

      // Jika hari ini libur
      if (jadwalHariIni.shift == 'Libur') {
        print('Hari ini libur. Mengecek jadwal kemarin...');

        // Jika kemarin adalah Shift 3
        if (jadwalKemarin.shift == 'Shift 3' &&
            jadwalKemarin.jamKeluar != null) {
          final jamKeluarKemarin = DateTime(
            yesterday.year,
            yesterday.month,
            yesterday.day,
            int.parse(jadwalKemarin.jamKeluar!.split(':')[0]),
            int.parse(jadwalKemarin.jamKeluar!.split(':')[1]),
          ).add(const Duration(days: 1)); // Shift 3 berakhir keesokan harinya

          if (now.isBefore(jamKeluarKemarin) ||
              jadwalKemarin.jamKeluar!.compareTo(jadwalKemarin.jamMasuk!) < 0) {
            print('Masih dalam waktu kerja Shift 3 dari jadwal kemarin.');

            // Ambil ID Attendance dari API
            final attendanceResponse =
                await ApiService().getAttendanceAbsent(userId);

            if (attendanceResponse.data.idAttendance != null) {
              final idAttendanceDate = DateTime.parse(attendanceResponse
                  .data.tanggalMasuk); // Tanggal dari ID Attendance

              // Validasi bahwa tanggal ID Attendance sesuai dengan kemarin
              if (idAttendanceDate.day == yesterday.day &&
                  idAttendanceDate.month == yesterday.month &&
                  idAttendanceDate.year == yesterday.year) {
                idAttendance.value = attendanceResponse.data.idAttendance!;
                await SharedPreferencesHelper.saveCheckInAttendanceId(
                    idAttendance.value.toString());
                await SharedPreferencesHelper.saveLastAttendanceDate(
                    now.toIso8601String());
                print(
                    "ID Attendance untuk Shift 3 kemarin disimpan: ${idAttendance.value}");
                return; // Tidak reset ID Attendance
              } else {
                print(
                    "ID Attendance tidak sesuai dengan jadwal kemarin. Melakukan reset.");
              }
            } else {
              print("No active attendance found for Shift 3.");
            }
          }
        }

        // Jika jadwal kemarin bukan Shift 3 atau ID Attendance tidak sesuai, lakukan reset
        print('Mengambil ID Attendance terbaru karena hari ini libur.');
        final attendanceResponse =
            await ApiService().getAttendanceAbsent(userId);

        if (attendanceResponse.data.idAttendance != null) {
          final tanggalMasuk = attendanceResponse.data.tanggalMasuk;
          final parsedTanggalMasuk = DateTime.parse(tanggalMasuk);

          // Pastikan tanggal ID Attendance sesuai dengan jadwal hari kemarin
          if (parsedTanggalMasuk.day == yesterday.day &&
              parsedTanggalMasuk.month == yesterday.month &&
              parsedTanggalMasuk.year == yesterday.year) {
            idAttendance.value = attendanceResponse.data.idAttendance!;
            await SharedPreferencesHelper.saveCheckInAttendanceId(
                idAttendance.value.toString());
            print("ID Attendance terbaru disimpan: ${idAttendance.value}");
          } else {
            idAttendance.value = 0;
            await SharedPreferencesHelper.removeCheckInAttendanceId();
            print("ID Attendance tidak sesuai dengan tanggal kemarin. Reset.");
          }
        } else {
          idAttendance.value = 0;
          await SharedPreferencesHelper.removeCheckInAttendanceId();
          print("No active attendance found. Resetting ID Attendance.");
        }
        return;
      }

      // Jika hari ini tidak libur, reset ID Attendance untuk jadwal baru
      final lastAttendanceDate =
          await SharedPreferencesHelper.getLastAttendanceDate();
      if (lastAttendanceDate == null ||
          DateTime.parse(lastAttendanceDate).isBefore(
            DateTime(now.year, now.month, now.day),
          )) {
        print("Hari baru dimulai, reset ID Attendance.");

        // Ambil ID Attendance terakhir dari API
        final attendanceResponse =
            await ApiService().getAttendanceAbsent(userId);

        if (attendanceResponse.data.idAttendance != null) {
          final tanggalMasuk = attendanceResponse.data.tanggalMasuk;
          final jamMasuk = attendanceResponse.data.jamMasuk;

          final lastShiftDate = DateTime.parse('$tanggalMasuk $jamMasuk');

          // Reset hanya jika attendance berasal dari jadwal sebelumnya
          if (lastShiftDate.isBefore(DateTime(now.year, now.month, now.day))) {
            print('Attendance dari hari sebelumnya, reset ID Attendance.');
            idAttendance.value = 0;
            await SharedPreferencesHelper.removeCheckInAttendanceId();
          } else {
            // Attendance valid untuk hari ini
            idAttendance.value = attendanceResponse.data.idAttendance!;
            await SharedPreferencesHelper.saveCheckInAttendanceId(
                idAttendance.value.toString());
            print("ID Attendance hari ini: ${idAttendance.value}");
          }
        } else {
          idAttendance.value = 0;
          await SharedPreferencesHelper.removeCheckInAttendanceId();
          print("No active attendance found. Resetting ID Attendance.");
        }
      } else {
        // Ambil ID Attendance dari SharedPreferences jika tidak perlu reset
        final savedIdAttendance =
            await SharedPreferencesHelper.getCheckInAttendanceId();
        if (savedIdAttendance != null && savedIdAttendance.isNotEmpty) {
          idAttendance.value = int.parse(savedIdAttendance);
          print("ID Attendance dari SharedPreferences: ${idAttendance.value}");
        } else {
          idAttendance.value = 0;
          print("No ID Attendance found in SharedPreferences.");
        }
      }

      // Perbarui tanggal terakhir dengan hari ini
      await SharedPreferencesHelper.saveLastAttendanceDate(
          now.toIso8601String());
    } catch (e) {
      print('Error fetching or resetting attendance: $e');
      idAttendance.value = 0;
    }
  }

  // -------------------- Map Management --------------------
  void setGoogleMapController(GoogleMapController controller) {
    googleMapController = controller;
    _moveToInitialLocation();
  }

  void _moveToInitialLocation() {
    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: initialLocation.value, zoom: 14),
      ),
    );
  }

  void _updateLocation() {
    initialLocation.value = LatLng(
      double.tryParse(latitudeTerminal.value) ?? 0.0,
      double.tryParse(longitudeTerminal.value) ?? 0.0,
    );
    _updateMarkers();
  }

  void _updateMarkers() {
    markers.value = {
      Marker(
        markerId: const MarkerId('Location'),
        position: initialLocation.value,
      ),
    };
  }
}
