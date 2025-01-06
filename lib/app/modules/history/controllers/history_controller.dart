import 'package:absensi_operator/app/widgets/utils.dart';
import 'package:get/get.dart';
import 'package:absensi_operator/app/services/api_services.dart';
import 'package:absensi_operator/app/data/history.dart';

class HistoryController extends GetxController {
  var historyList = <History>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistoryForCurrentMonth();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> fetchHistoryForCurrentMonth() async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId == null) {
        print('User ID not found');
        return;
      }

      final allHistory = await ApiService().getHistoryById(userId.toString());

      // Filter data bulan ini
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      final filteredHistory = allHistory.where((history) {
        final checkinDate = history.checkinDate != null
            ? DateTime.parse(history.checkinDate!)
            : null;
        if (checkinDate != null) {
          return checkinDate
                  .isAfter(firstDayOfMonth.subtract(const Duration(days: 1))) &&
              checkinDate.isBefore(lastDayOfMonth.add(const Duration(days: 1)));
        }
        return false;
      }).toList();

      historyList.value = filteredHistory;
    } catch (e) {
      print('Error fetching history: $e');
    }
  }
}
