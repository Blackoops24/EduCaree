import 'package:flutter/material.dart';

class ResponsiveLayout {
  static bool isSmall(BuildContext context) => MediaQuery.of(context).size.width < 600;

  static bool isMedium(BuildContext context) => MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1024;

  static bool isLarge(BuildContext context) => MediaQuery.of(context).size.width >= 1024;

  static Widget layout({
    required BuildContext context,
    required Widget small,
    Widget? medium,
    Widget? large,
  }) {
    if (isLarge(context)) {
      return large ?? medium ?? small;
    }
    if (isMedium(context)) {
      return medium ?? small;
    }
    return small;
  }
}
