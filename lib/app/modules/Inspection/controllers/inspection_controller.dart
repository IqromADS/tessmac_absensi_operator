import 'package:absensi_operator/app/data/vehiclePlates.dart';
import 'package:absensi_operator/app/services/api_services.dart';
import 'package:absensi_operator/app/widgets/utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InspectionController extends GetxController {
  var userProfilePic = ''.obs;
  var terminalName = ''.obs;
  var roleName = ''.obs;
  var userName = ''.obs;
  var isDropdownVisible = false.obs;
  var selectedPlate = "".obs;
  var plates = <VehiclePlates>[].obs;

  var isRedSelected = false.obs;
  var isYellowSelected = false.obs;
  var isGreenSelected = false.obs;

  var frontCameraPath = ''.obs;
  var rightCameraPath = ''.obs;
  var leftCameraPath = ''.obs;
  var personCameraPath = ''.obs;
  var truckCameraPath = ''.obs;

  final ImagePicker _picker = ImagePicker();

  void fetchUserProfilePic() async {
    final profilePic = await SharedPreferencesHelper.getUserProfilePic();
    userProfilePic.value = profilePic ?? '';
  }

  void fetchTerminalName() async {
    final terminal = await SharedPreferencesHelper.getTerminalName();
    terminalName.value = terminal ?? 'Terminal';
  }

  void fetchUserRole() async {
    final role = await SharedPreferencesHelper.getUserRole();
    roleName.value = role ?? 'Role';
  }

  void fetchUserName() async {
    final name = await SharedPreferencesHelper.getUserName();
    userName.value = name ?? 'User';
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('idUser');
    print('Retrieved idUser: $idUser');
    return idUser;
  }

  Future<void> openCameraFor(String type) async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        switch (type) {
          case "front":
            frontCameraPath.value = photo.path;
            break;
          case "right":
            rightCameraPath.value = photo.path;
            break;
          case "left":
            leftCameraPath.value = photo.path;
            break;
          case "person":
            personCameraPath.value = photo.path;
            break;
          case "truck":
            truckCameraPath.value = photo.path;
            break;
        }
      }
    } catch (e) {
      print("Failed to open camera: $e");
    }
  }

  Future<void> fetchVehiclePlates() async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();
      final apiService = ApiService();
      final fetchedPlates =
          await apiService.getVehiclePlatesById(userId.toString());
      plates.value = fetchedPlates;
      if (plates.isNotEmpty) {
        selectedPlate.value = plates.first.plat;
      }
    } catch (e) {
      print('Error fetching vehicle plates: $e');
    }
  }

  void updateCondition(String color, bool isSelected) {
    if (isSelected) {
      // Set the selected color to true and others to false
      if (color == 'Red') {
        isRedSelected.value = true;
        isYellowSelected.value = false;
        isGreenSelected.value = false;
      } else if (color == 'Yellow') {
        isRedSelected.value = false;
        isYellowSelected.value = true;
        isGreenSelected.value = false;
      } else if (color == 'Green') {
        isRedSelected.value = false;
        isYellowSelected.value = false;
        isGreenSelected.value = true;
      }
    } else {
      // Deselect the current checkbox
      if (color == 'Red') {
        isRedSelected.value = false;
      } else if (color == 'Yellow') {
        isYellowSelected.value = false;
      } else if (color == 'Green') {
        isGreenSelected.value = false;
      }
    }
  }

  Future<void> submitInspection() async {
    if (selectedPlate.value.isEmpty ||
        frontCameraPath.value.isEmpty ||
        rightCameraPath.value.isEmpty ||
        leftCameraPath.value.isEmpty ||
        personCameraPath.value.isEmpty ||
        truckCameraPath.value.isEmpty ||
        (!isRedSelected.value &&
            !isYellowSelected.value &&
            !isGreenSelected.value)) {
      print(
          "Validation failed. Ensure all fields and photos are filled correctly.");
      Get.snackbar(
        'Error',
        'All fields and photos must be filled!',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final condition = isRedSelected.value
        ? 'red'
        : isYellowSelected.value
            ? 'yellow'
            : 'green';

    try {
      final apiService = ApiService();
      final idUser = (await SharedPreferencesHelper.getUserId())?.toString();

      if (idUser == null || idUser.isEmpty) {
        throw Exception('User ID is missing. Ensure the user is logged in.');
      }

      await apiService.postInspection(
        idUser: idUser,
        plat: selectedPlate.value,
        frontCameraPath: frontCameraPath.value,
        rightCameraPath: rightCameraPath.value,
        leftCameraPath: leftCameraPath.value,
        personCameraPath: personCameraPath.value,
        frontTruckPath: truckCameraPath.value,
        condition: condition,
      );

      Get.snackbar('Success', 'Inspection submitted successfully!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print('Error submitting inspection: $e');
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onInit() {
    fetchUserName();
    fetchUserProfilePic();
    fetchTerminalName();
    fetchUserRole();
    fetchVehiclePlates();
    super.onInit();
  }
}
