import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phoenix/generated/assets.dart';

void showLoader(BuildContext context) {
  showDialog(
    context: context,barrierColor: Colors.black.withValues(alpha: 0.1),
    barrierDismissible: false, // Prevent closing when tapping outside
    builder: (_) => const Loader(),
  );
}

void hideLoader(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
}

class Loader extends StatelessWidget {
  const Loader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        // Blurred background overlay
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(),
            ),
          ),
        ),
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
                SvgPicture.asset(
                  Assets.imagesPhoenixBird,
                  width: 30,
                  height: 30,
                ),
              const SizedBox(height: 16),
              // Gradient CircularProgressIndicator
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.transparent, // Hide the default color
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [
                      Color(0xFFF0B351), // Start color
                      Color(0xFFFF5ACD), // End color
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds);
                },
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



