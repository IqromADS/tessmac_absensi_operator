import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CallCenterController extends GetxController {
  void OpenWhatsAppChat() {
    const phoneNumber = '+6285329370707';
    const url = 'https://wa.me/$phoneNumber';
    launch(url);
  }

  void OpenPhoneDialer() {
    const phoneNumber = '+6285329370707';
    const url = 'tel:$phoneNumber';
    launch(url);
  }

  void OpenEmail() {
    const email = "arya@ayodyads.com";
    final url = 'mailto:$email';
    launch(url);
  }
}
