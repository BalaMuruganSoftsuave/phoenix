import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/font_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/helper/utils.dart';

class ProfilePopupMenu extends StatefulWidget {
  final String userName;
  final VoidCallback onLogout;

  const ProfilePopupMenu({
    super.key,
    required this.userName,
    required this.onLogout,
  });

  @override
  State<ProfilePopupMenu> createState() => ProfilePopupMenuState();
}

class ProfilePopupMenuState extends State<ProfilePopupMenu> {
  OverlayEntry? overlayEntry;

  void showPopup(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset.zero);

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // This captures taps outside the popup
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent, // Captures taps outside
              onTap: hidePopup, // Close the popup when tapped outside
              child: Container(),
            ),
          ),
          Positioned(
            top: position.dy + Responsive.boxW(context, 15),
            right:Responsive.boxW(context,8),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Responsive.boxH(context, 2), horizontal: Responsive.boxW(context, 5),),
                width:Responsive.boxW(context, 40),
                decoration: BoxDecoration(
                  color: Color(0xFF141E2D),
                  borderRadius: BorderRadius.circular(Responsive.boxW(context, 2),),
                  border: Border.all(color: Color(0xFFA3AED0).withValues(alpha: 0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.userName,
                      style: getTextTheme().bodyMedium?.copyWith(
                        color: AppColors.subText,
                        fontWeight: FontHelper.regular,
                        fontSize :Responsive.fontSize(context, 4),
                      ),
                    ),
                    Divider(color: Color(0xFFA3AED0).withValues(alpha: 0.4)),
                    GestureDetector(
                      onTap: () {
                        widget.onLogout();
                        hidePopup();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(shaderCallback: (bounds)=> LinearGradient(colors: [AppColors.orange, AppColors.pink], begin: Alignment.topLeft, end: Alignment.bottomRight,).createShader(bounds),child: Icon(Icons.logout, color: AppColors.white, size: Responsive.padding(context, 6))),
                          SizedBox(width: Responsive.boxW(context, 2)),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [AppColors.orange, AppColors.pink],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds),
                            child: Text(
                              translate(TextHelper.logout),
                              style: getTextTheme().bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontHelper.regular,
                                fontSize: Responsive.fontSize(context, 4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    overlayState.insert(overlayEntry!);
  }


  void hidePopup() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (overlayEntry == null) {
          showPopup(context);
        } else {
          hidePopup();
        }
      },
      icon: Icon(
        Icons.account_circle,
        size: Responsive.boxW(context, 10),
        color: Color(0xFFA3AED0), // subText color
      ),
    );
  }
}
