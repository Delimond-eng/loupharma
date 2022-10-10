import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigatorController extends GetxController {
  static NavigatorController instance = Get.find();
  final GlobalKey<NavigatorState> navigationKey = GlobalKey();

  var activeItem = "/".obs;
  var hoverItem = "".obs;

  changeActiveitemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isActive(String itemName) => activeItem.value == itemName;

  isHovering(String itemName) => hoverItem.value == itemName;

  Future<dynamic> navigateTo(String routeName) {
    Get.back();
    if (!isActive(routeName)) changeActiveitemTo(routeName);
    return navigationKey.currentState.pushNamed(routeName);
  }
}
