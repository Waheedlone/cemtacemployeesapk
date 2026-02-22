import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceUUid {
  Future<String> getUniqueDeviceId() async {
    String uniqueDeviceId = '';

    var deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      var webDeviceInfo = await deviceInfo.webBrowserInfo;
      uniqueDeviceId = '${webDeviceInfo.browserName.name}:${webDeviceInfo.userAgent}';
    } else if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueDeviceId =
          '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}'; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueDeviceId =
          '${androidDeviceInfo.model}:${androidDeviceInfo.id}'; // unique ID on Android
    }

    return uniqueDeviceId;
  }
}
