import 'package:absensi_operator/app/widgets/utils.dart';
import 'package:get/get.dart';

class PersonalInformationController extends GetxController {
  var userProfilePic = ''.obs;
  var terminalName = ''.obs;
  var roleName = ''.obs;
  var emailOperator = ''.obs;
  var phoneOperator = ''.obs;

  void fetchUserProfilePic() async {
    final profilePic = await SharedPreferencesHelper.getUserProfilePic();
    print("Profile Pic URL: $profilePic");
    userProfilePic.value = profilePic ?? '';
  }

  void fetchUserEmail() async {
    final email = await SharedPreferencesHelper.getUserEmail();
    print("Email fetched: $email");
    emailOperator.value = email ?? '';
  }

  void fetchUserPhone() async {
    final phone = await SharedPreferencesHelper.getphone();
    print("Phone fetched: $phone");
    phoneOperator.value = phone ?? '';
  }

  void fetchTerminalName() async {
    final terminal = await SharedPreferencesHelper.getTerminalName();
    terminalName.value = terminal ?? 'Terminal';
  }

  void fetchUserRole() async {
    final role = await SharedPreferencesHelper.getUserRole();
    roleName.value = role ?? 'Role';
    print("Role: $role");
  }

  @override
  void onInit() {
    fetchUserProfilePic();
    fetchTerminalName();
    fetchUserRole();
    fetchUserPhone();
    fetchUserEmail();
    super.onInit();
  }
}
