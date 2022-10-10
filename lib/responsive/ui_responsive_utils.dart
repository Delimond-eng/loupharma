import 'package:flutter/widgets.dart';
import 'enum_screens.dart';

DeviceScreenType getDeviceType(MediaQueryData mediaQuery) {
  var orientation = mediaQuery.orientation;
  double deviceWidth = mediaQuery.size.width;

  if (deviceWidth >= 900.0) {
    return DeviceScreenType.Desktop;
  }
  if (deviceWidth >= 600.0) {
    return DeviceScreenType.Tablet;
  }

  if (deviceWidth <= 500.0) {
    return DeviceScreenType.Mobile;
  }

  return DeviceScreenType.Mobile;
}
