import 'dart:io';

import 'package:fireapp/domain/models/base/device_type.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeviceRepository {

  Future<DeviceType> getDeviceType() async {
    if (Platform.isAndroid) {
      return DeviceType.android;
    } else if (Platform.isIOS) {
      return DeviceType.ios;
    }

    return DeviceType.unknown;
  }

}