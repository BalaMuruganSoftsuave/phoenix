import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phoenix/cubit/dashboard/dashboard_cubit.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/nav_helper.dart';
import 'package:phoenix/helper/preference_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getData(); // Ensures it runs only once
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg2,
      body: Center(
        child: SvgPicture.asset(
          Assets.imagesPhoenixLogo,
          height: 100,
          width: 200,
        ),
      ),
    );
  }

  void checkLogin() {
    bool isLoggedIn = PreferenceHelper.getInitialLogin();
    if (isLoggedIn) {
      context.read<DashBoardCubit>().getPermissionsData(context);
      openScreen(dashboardScreen, requiresAsInitial: true);
    } else {
      openScreen(loginScreen, requiresAsInitial: true);
    }
  }

  void getData() async {
    await Future.delayed(const Duration(seconds: 2), () {
      checkLogin();
    });
  }
}
