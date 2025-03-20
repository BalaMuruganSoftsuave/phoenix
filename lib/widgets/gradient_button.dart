import 'package:flutter/material.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/utils.dart';

class GradientButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String text;

  const GradientButton(
      {super.key,
      required this.isLoading,
      required this.onPressed,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        padding:  EdgeInsets.symmetric(vertical:  Responsive.screenH(context, 2)),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF0B351), Color(0xFFFF5EC8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular( Responsive.screenH(context, 4)),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  translate(text),
                  style: getTextTheme().bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: Responsive.fontSize(context, 4),
                      fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
