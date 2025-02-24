import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Responsive {
  // Screen width and height percentages
  static double screenW(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * (percent / 100);
  }

  static double screenH(BuildContext context, double percent) {
    return MediaQuery.of(context).size.height * (percent / 100);
  }

  // Font size based on screen width
  static double fontSize(BuildContext context, double percent) {
    return screenW(context, percent) *(DeviceType.isMobile(context)?1:1.1);
  }

  // Padding based on screen width
  static double padding(BuildContext context, double percent) {
    final paddingVal = screenW(context, percent);
    return paddingVal;
  }

  // Responsive widget dimensions
  static double boxW(BuildContext context, double percent) {
    return screenW(context, percent);
  }

  static double boxH(BuildContext context, double percent) {
    return screenH(context, percent);
  }
}


class DeviceType {
  // Define width breakpoints for mobile and tablet
  static const double mobileWidth = 600;
  static const double tabletWidth = 1200;

  // Check if the device is a web browser
  static bool isWeb() {
    return kIsWeb;
  }

  // Check if the device is a mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileWidth && !isWeb();
  }

  // Check if the device is a tablet
  static bool isTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= mobileWidth && screenWidth < tabletWidth && !isWeb();
  }

  // Check if the device is a desktop or large screen (web or desktop app)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletWidth || isWeb();
  }
}


// Scaffold(
//       appBar: AppBar(title: Text('Responsive UI')),
//       body: Center(
//         child: Padding(
//           padding: Responsive.padding(context, 5),  // 5% padding
//           child: Container(
//             width: Responsive.boxW(context, 60),  // 60% width
//             height: Responsive.boxH(context, 30),  // 30% height
//             color: Colors.blue,
//             child: Center(
//               child: Text(
//                 'Responsive Box',
//                 style: TextStyle(
//                   fontSize: Responsive.fontSize(context, 4),  // 4% of screen width
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );