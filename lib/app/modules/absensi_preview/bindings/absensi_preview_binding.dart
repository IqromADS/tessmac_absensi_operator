import 'package:get/get.dart';

import '../controllers/absensi_preview_controller.dart';

class AbsensiPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbsensiPreviewController>(
      () => AbsensiPreviewController(),
    );
  }
}
