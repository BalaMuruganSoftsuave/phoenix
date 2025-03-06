import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phoenix/Cubit/dashboard/dashboard_cubit.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/nav_helper.dart';
import 'package:phoenix/helper/preference_helper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      checkLogin(getCtx(context)!);
    });
    return Scaffold(
        backgroundColor: AppColors.darkBg2,
        body: Center(
          child: SvgPicture.asset(
            Assets.imagesPhoenixLogo,
            height: 100,
            width: 200,
          ),
        ));
  }

  void checkLogin(BuildContext context) {
    bool isLoggedIn = PreferenceHelper.getInitialLogin();
    if (isLoggedIn) {
      context.read<DashBoardCubit>().getPermissionsData(context);
      openScreen(dashboardScreen, requiresAsInitial: true);
    } else {
      openScreen(loginScreen, requiresAsInitial: true);
    }
  }
}
