import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ExpandableMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final MaterialColor color;
  final List<Widget> children;
  const ExpandableMenuItem(
      {Key key, this.icon, this.label, this.color, this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Column(
          children: <Widget>[
            ExpandablePanel(
              theme: const ExpandableThemeData(
                fadeCurve: Curves.bounceIn,
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToExpand: true,
                tapBodyToCollapse: false,
                hasIcon: false,
              ),
              header: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200].withOpacity(.7),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              color: Colors.black,
                              size: 18.0,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              label,
                              style: TextStyle(
                                color: color ?? Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      ),
                      ExpandableIcon(
                        theme: ExpandableThemeData(
                          expandIcon: CupertinoIcons.chevron_down,
                          collapseIcon: CupertinoIcons.chevron_up,
                          iconColor: color ?? Colors.black54,
                          iconSize: 15.0,
                          iconRotationAngle: math.pi / 2,
                          hasIcon: false,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              collapsed: Container(),
              expanded: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
