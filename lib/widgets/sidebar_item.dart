import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/controllers.dart';

class SidebarMenuItem extends StatelessWidget {
  final String itemName;
  final String label;
  final Function onTap;
  final IconData icon;
  final bool disabled;
  const SidebarMenuItem(
      {Key key,
      this.itemName,
      this.onTap,
      this.icon,
      this.label,
      this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? () {} : onTap,
      onHover: (value) {
        if (disabled) {
          navigatorController.onHover("not hovering");
        } else {
          value
              ? navigatorController.onHover(itemName)
              : navigatorController.onHover("not hovering");
        }
      },
      child: Obx(
        () => Container(
          margin: const EdgeInsets.only(
            bottom: 8.0,
            right: 8.0,
            left: 8.0,
          ),
          decoration: BoxDecoration(
            color: disabled
                ? Colors.transparent
                : ((navigatorController.isHovering(itemName) ||
                        navigatorController.isActive(itemName))
                    ? Colors.indigo
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: disabled
                ? null
                : ((navigatorController.isHovering(itemName) ||
                        navigatorController.isActive(itemName))
                    ? [
                        BoxShadow(
                            color: Colors.black.withOpacity(.2),
                            blurRadius: 2,
                            offset: const Offset(0, 1))
                      ]
                    : null),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        icon ?? Icons.data_saver_off_rounded,
                        color: disabled
                            ? Colors.grey
                            : (navigatorController.isHovering(itemName) ||
                                    navigatorController.isActive(itemName)
                                ? Colors.white
                                : Colors.black),
                        size: 18.0,
                      ),
                    ),
                    if (!navigatorController.isActive(itemName))
                      Flexible(
                        child: Text(
                          label,
                          style: GoogleFonts.didactGothic(
                              color: disabled
                                  ? Colors.grey
                                  : (navigatorController.isHovering(itemName)
                                      ? Colors.white
                                      : Colors.black),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    else
                      Flexible(
                        child: Text(
                          label,
                          style: GoogleFonts.didactGothic(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
