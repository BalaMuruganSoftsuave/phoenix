import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phoenix/cubit/notification/notification_cubit.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/font_helper.dart';
import 'package:phoenix/helper/nav_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/screens/dashboard/dashboard_screen.dart';
import 'package:phoenix/screens/notification/notification_screen.dart';
import 'package:phoenix/widgets/bottom_navigation_widget/gbutton.dart';
import 'package:phoenix/widgets/bottom_navigation_widget/gnav.dart';
import 'package:phoenix/widgets/profile_menu_button.dart';

class Dashboard extends StatefulWidget {
  int tab = 0;

  Dashboard(LinkedHashMap<dynamic, dynamic>? args, {super.key}) {
    if (args != null) {
      tab = args["tab"] ?? 0;
    }
  }

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    NotificationScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      print(widget.tab);
      _selectedIndex = widget.tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          Responsive.boxH(context, 8),
        ),
        child: AppBar(
          backgroundColor: AppColors.darkBg,
          centerTitle: false,
          title: SvgPicture.asset(
            Assets.imagesPhoenixLogo,
            width: Responsive.boxW(context, 15),
            height: Responsive.boxH(context, 5),
          ),
          actions: [
            ProfilePopupMenu(
              userName: getUserName(),
              onLogout: () {
                showLogoutDialog(context, () {
                  back();
                  CustomToast.show(
                      context: context,
                      message: "Logout SuccessFully",
                      status: ToastStatus.success);
                  logout();
                  openScreen(loginScreen, requiresAsInitial: true);
                });
                debugPrint("User logged out");
              },
            )
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          bottom: Responsive.boxH(context, 2),
        ),
        color: AppColors.darkBg,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GNav(
              tabMargin: EdgeInsets.symmetric(horizontal: 10),
              gap: Responsive.boxW(context, 4),
              activeColor: AppColors.pink,
              iconSize: Responsive.padding(context, 8),
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.boxW(context, 4),
                vertical: Responsive.boxW(context, 2),
              ),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.darkBg2,
              color: AppColors.darkBg2,
              backgroundColor: AppColors.darkBg,
              textStyle: getTextTheme().titleLarge?.copyWith(
                  fontSize: Responsive.fontSize(context, 4),
                  color: AppColors.pink,
                  fontWeight: FontHelper.semiBold),
              tabs: [
                GButton(
                  leading: SvgPicture.asset(
                    Assets.imagesHome,
                    height: Responsive.boxH(context, 3),
                    width: Responsive.boxW(context, 3),
                    colorFilter: _selectedIndex == 0
                        ? ColorFilter.mode(AppColors.pink, BlendMode.srcIn)
                        : null,
                  ),
                  text: 'Home',
                ),
                GButton(
                  leading: SvgPicture.asset(
                    Assets.imagesNotification,
                    height: Responsive.boxH(context, 3),
                    width: Responsive.boxW(context, 3),
                    colorFilter: _selectedIndex == 1
                        ? ColorFilter.mode(AppColors.pink, BlendMode.srcIn)
                        : null,
                  ),
                  text: 'Notification',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                context
                    .read<NotificationCubit>()
                    .getNotificationConfiguration(context);
              },
            ),
            IconButton(
                onPressed: () {
                  showLogoutDialog(context, () {
                    back();
                    CustomToast.show(
                        context: context,
                        message: "Logout SuccessFully",
                        status: ToastStatus.success);
                    logout();
                    openScreen(loginScreen, requiresAsInitial: true);
                  });
                },
                icon: Icon(
                  Icons.logout,
                  color: AppColors.subText,
                ))
          ],
        ),
      ),
    );
  }
}
