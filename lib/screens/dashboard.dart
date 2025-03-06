import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phoenix/Cubit/dashboard/dashboard_cubit.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/font_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/screens/dashboard/dashboard_screen.dart';
import 'package:phoenix/widgets/bottom_navigation_widget/gbutton.dart';
import 'package:phoenix/widgets/bottom_navigation_widget/gnav.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    const Text(
      'Likes',
      style: optionStyle,
    ),
    const Text(
      'Search',
      style: optionStyle,
    ),
    const Text(
      'Profile',
      style: optionStyle,
    ),
  ];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: Responsive.boxH(context, 2),),
        color: AppColors.darkBg,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GNav(
              gap: Responsive.boxW(context, 4),
              activeColor: AppColors.pink,
              iconSize: Responsive.padding(context, 8),
              padding: EdgeInsets.symmetric(horizontal: Responsive.boxW(context, 4), vertical: Responsive.boxW(context, 2),),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.darkBg2,
              color: AppColors.darkBg2,
              backgroundColor: AppColors.darkBg,
              textStyle: getTextTheme().titleLarge?.copyWith(fontSize:Responsive.fontSize(context, 4),color: AppColors.pink,fontWeight: FontHelper.semiBold),
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
                  text: 'Likes',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            IconButton(
                onPressed: () {
                  CustomToast.show(context: context, message: "message", status: ToastStatus.failure);
                  // showLogoutDialog(context, () {
                  //   Navigator.of(context).pop(); // Close the dialog
                  //   // Add your logout logic here
                  // });
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
