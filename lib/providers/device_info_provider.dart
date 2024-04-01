import 'package:flutter/material.dart';
import 'package:menu/api/api_4uRest.dart';
import 'package:menu/models/device_tracking_info.dart';

class DeviceInfoProvider with ChangeNotifier {
  DeviceTrackingInfo? _deviceInfo;

  DeviceTrackingInfo? get deviceInfo => _deviceInfo;

  void setDeviceInfo(DeviceTrackingInfo deviceInfo) {
    _deviceInfo = deviceInfo;
    notifyListeners();
  }

  Future<void> trackDevice(DeviceTrackingInfo? trackingInfo) async {
    if (trackingInfo != null) {
      try {
        await Api4uRest.httpPost(
            '/digital-menu/track-device', trackingInfo.toJson());
      } catch (e) {
        print('Error al rastrear el dispositivo: $e');
      }
    }
  }
}
