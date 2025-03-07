import 'package:flutter/material.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/font_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/helper/utils.dart';

import 'color_helper.dart'; // Update the import path as needed

void showLogoutDialog(context, VoidCallback onConfirm) {
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

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating, // Makes it float above UI
      margin: EdgeInsets.all(16), // Adds spacing around the snackbar
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).clearSnackBars(); // Clears old toasts
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
