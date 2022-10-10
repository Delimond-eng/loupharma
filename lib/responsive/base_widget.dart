import 'package:flutter/material.dart';

import 'sizing_info.dart';
import 'ui_responsive_utils.dart';

class Responsive extends StatelessWidget {
  final Widget Function(BuildContext context, SizingInfo info) builder;
  const Responsive({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, boxConstraints) {
        var sizeInfo = SizingInfo(
          orientation: mediaQuery.orientation,
          deviceScreenType: getDeviceType(mediaQuery),
          screenSize: mediaQuery.size,
          localWidgetSize:
              Size(boxConstraints.maxWidth, boxConstraints.maxHeight),
        );
        return builder(context, sizeInfo);
      },
    );
  }
}
