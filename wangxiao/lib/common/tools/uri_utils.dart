import 'package:url_launcher/url_launcher.dart';

class UriUtils {
  static void launchMail(String address, String subject, String body) {
    var url = "mailto:$address?subject=$subject&body=$body";
    _lauchURL(url);
  }

  static void launchBrowsers(String address) {
    _lauchURL(address);
  }

  static void launchTel(String phoneNo) {
    var url = "tel:$phoneNo";
    _lauchURL(url);
  }

  static void launchSMS(String phoneNo) {
    var url = "sms:$phoneNo";
    _lauchURL(url);
  }

  static _lauchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else
      throw new Exception('不能打开');
  }
}
