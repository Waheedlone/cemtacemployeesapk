import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceUUid {
  Future<String> getUniqueDeviceId() async {
    String uniqueDeviceId = '';
 
    var deviceInfo = DeviceInfoPlugin();
 
    if (kIsWeb) {
      var webDeviceInfo = await deviceInfo.webBrowserInfo;
      uniqueDeviceId = 'web:${webDeviceInfo.browserName.name}:${webDeviceInfo.userAgent}';
    } else {
      try {
        if (Platform.isIOS) {
          var iosDeviceInfo = await deviceInfo.iosInfo;
          uniqueDeviceId = 'ios:${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}';
        } else if (Platform.isAndroid) {
          var androidDeviceInfo = await deviceInfo.androidInfo;
          uniqueDeviceId = 'android:${androidDeviceInfo.model}:${androidDeviceInfo.id}';
        } else if (Platform.isWindows) {
          var windowsInfo = await deviceInfo.windowsInfo;
          uniqueDeviceId = 'windows:${windowsInfo.computerName}:${windowsInfo.deviceId}';
        } else if (Platform.isMacOS) {
          var macInfo = await deviceInfo.macOsInfo;
          uniqueDeviceId = 'macos:${macInfo.computerName}:${macInfo.systemGUID}';
        } else if (Platform.isLinux) {
          var linuxInfo = await deviceInfo.linuxInfo;
          uniqueDeviceId = 'linux:${linuxInfo.name}:${linuxInfo.machineId}';
        } else {
          uniqueDeviceId = 'unknown:desktop';
        }
      } catch (e) {
        uniqueDeviceId = 'unknown:error:${e.toString()}';
      }
    }
 
    return uniqueDeviceId;
  }
}
