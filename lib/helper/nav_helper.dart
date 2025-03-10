import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:phoenix/screens/dashboard.dart';
import 'package:phoenix/screens/login_screen.dart';
import 'package:phoenix/screens/splashscreen.dart';
import 'package:phoenix/screens/dashboard/dashboard_screen.dart';
import 'package:phoenix/screens/dashboard/sales_revenue_details.dart';

import 'dependency.dart';
import 'nav_observer.dart';

const String dashboardScreen='/dashboardScreen';
const String salesRevenueDetails='/salesRevenueDetails';
const String loginScreen = '/loginScreen';
const String splashScreen = '/splashScreen';

Route<Object?> _customPageRoute(Widget page, {required String name}){
  return PageRouteBuilder(
      pageBuilder: (context,animation, secondaryAnimation) => page,
    settings:  RouteSettings(name:name),
    transitionsBuilder: (context,animation, secondaryAnimation, child){
      const begin = Offset(1.0, 0.0); // Slide in from right
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300)
  );
}

Route<Object?>? generateRoute(RouteSettings settings){
  return getRoute(settings.name);
}

Route<Object?>? getRoute(String? name,
    {LinkedHashMap? args, Function? result}) {
  switch (name) {
    case splashScreen:
      return _customPageRoute(SplashScreen(), name: name!);
    case dashboardScreen:
      return _customPageRoute( Dashboard(args),name: name!,);
    case salesRevenueDetails:
      return _customPageRoute(SalesRevenueDetails(args), name: salesRevenueDetails);
    case loginScreen:
      return _customPageRoute(LoginScreen(), name: name!);
  }
  return null;
}
openScreen(String routeName,
    {bool forceNew = false,
      bool requiresAsInitial = false,
      LinkedHashMap? args,
      Function? result,
      BuildContext? ctx}) async {
  final route = getRoute(routeName, args: args, result: result);
  final context = ctx ?? NavObserver.navKey.currentContext;
  if (route != null && context != null) {
    if (requiresAsInitial) {
      // ignore: use_build_context_synchronously
      await Navigator.pushAndRemoveUntil(
          getCtx(context)!, route, (route) => false);
    } else if (forceNew || !NavObserver.instance.containsRoute(route)) {
      // ignore: use_build_context_synchronously
      return await Navigator.push(getCtx(context)!, route);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.popUntil(getCtx(context)!, (route) {
        if (route.settings.name == routeName) {
          if (args != null) {
            (route.settings.arguments as Map)["result"] = args;
          }
          return true;
        }
        return false;
      });
    }
  }
}

void back([LinkedHashMap? args]){
  if(NavObserver.navKey.currentContext !=null){
    Navigator.pop(NavObserver.navKey.currentContext!,args);
  }
}