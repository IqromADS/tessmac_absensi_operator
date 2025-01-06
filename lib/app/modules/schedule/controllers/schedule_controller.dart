import 'package:absensi_operator/app/data/jadwal.dart';
import 'package:absensi_operator/app/services/api_services.dart';
import 'package:absensi_operator/app/widgets/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScheduleController extends GetxController {
  // -------------------- Variabel dan Properti --------------------
  var currentDate = ''.obs;
  var jadwalList = [].obs;
  var weeklySchedules = [].obs;
  // -------------------- Method untuk Mengambil Data Jadwal --------------------

  void fetchJadwalByUserId() async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId != null) {
        List<Jadwal> jadwal =
            await ApiService().getJadwalById(userId.toString());
        jadwalList.assignAll(jadwal);

        // Mengelompokkan jadwal berdasarkan minggu
        _groupSchedulesByWeek(jadwal);
      } else {
        throw Exception('User ID not found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // -------------------- Method untuk Mengelompokkan Jadwal Berdasarkan Minggu --------------------
  void _groupSchedulesByWeek(List<Jadwal> jadwal) {
    final groupedWeeks = <int, List<Jadwal>>{};

    for (var schedule in jadwal) {
      final date = DateTime.parse(schedule.tanggal);
      final weekOfYear =
          _getWeekOfYear(date); // Mendapatkan minggu keberapa tahun itu

      if (!groupedWeeks.containsKey(weekOfYear)) {
        groupedWeeks[weekOfYear] = [];
      }

      groupedWeeks[weekOfYear]?.add(schedule);
    }

    // Menyimpan data yang sudah dikelompokkan berdasarkan minggu
    weeklySchedules.assignAll(groupedWeeks.values.toList());
  }

  // Mendapatkan minggu ke berapa dalam setahun berdasarkan tanggal
  int _getWeekOfYear(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final difference = date.difference(startOfYear).inDays;
    return ((difference / 7).floor()) + 1;
  }

  // -------------------- Method untuk Update Waktu --------------------
  void updateCurrentDate() {
    var now = DateTime.now();
    currentDate.value =
        DateFormat('MMMM y').format(now); // Format bulan dan tahun
  }

  // -------------------- Lifecycle Method --------------------
  @override
  void onInit() {
    super.onInit();
    fetchJadwalByUserId(); // Ambil jadwal saat controller diinisialisasi
    updateCurrentDate(); // Perbarui tanggal saat ini
  }
}
