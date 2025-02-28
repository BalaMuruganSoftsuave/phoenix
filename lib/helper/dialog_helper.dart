import 'package:flutter/material.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/font_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/helper/utils.dart';

import 'color_helper.dart'; // Update the import path as needed

void showLogoutDialog(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.darkBg2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Responsive.padding(context, 10)),
        ),
        title: Text(
          translate(TextHelper.logout),
          textAlign: TextAlign.center,
          style: getTextTheme().bodyLarge?.copyWith(
              fontWeight: FontHelper.semiBold, color: AppColors.white),
        ),
        content: Text(
          translate(TextHelper.logoutConfirm),
          textAlign: TextAlign.center,
          style: getTextTheme().displayMedium?.copyWith(
              fontWeight: FontHelper.medium, color: AppColors.subText),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.grey2,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Responsive.padding(context, 2)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.boxW(context, 5),
                    vertical: Responsive.boxH(context, 2),
                  ),
                ),
                child: Text(
                  translate(TextHelper.cancel),
                  style: getTextTheme().displayMedium?.copyWith(
                      fontWeight: FontHelper.medium, color: AppColors.white),
                ),
              ),
              ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Responsive.padding(context, 2)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.boxW(context, 5),
                    vertical: Responsive.boxH(context, 2),
                  ),
                ),
                child: Text(
                  translate(TextHelper.logout),
                  style: getTextTheme().displayMedium?.copyWith(
                      fontWeight: FontHelper.medium, color: AppColors.white),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

class CustomToast {
  static void show({
    required BuildContext context,
    required String message,
    required ToastStatus status,
  }) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;

    Color bgColor;
    IconData icon;

    switch (status) {
      case ToastStatus.success:
        bgColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case ToastStatus.failure:
        bgColor = Colors.red;
        icon = Icons.error;
        break;
      case ToastStatus.warning:
        bgColor = Colors.orange;
        icon = Icons.warning;
        break;
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: Responsive.boxH(context, 10),
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.boxW(context, 2),
                vertical: Responsive.boxH(context, 2)),
            decoration: BoxDecoration(
              color: Color(0xFF141E2D),
              borderRadius: BorderRadius.circular(Responsive.boxW(context, 2)),
              border:
                  Border.all(color: Color(0xFFA3AED0).withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    color: bgColor, size: Responsive.padding(context, 8)),
                SizedBox(width: Responsive.boxW(context, 3)),
                Expanded(
                  child: Text(
                    message,
                    style: getTextTheme().bodyMedium?.copyWith(
                        fontSize: Responsive.fontSize(context, 4),
                        color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
