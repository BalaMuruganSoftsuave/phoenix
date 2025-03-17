import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:phoenix/screens/dashboard.dart';
import 'package:phoenix/screens/login_screen.dart';
import 'package:phoenix/screens/splashscreen.dart';
import 'package:phoenix/screens/dashboard/dashboard_details_screen.dart';
import 'nav_observer.dart';

const String dashboardScreen='/dashboardScreen';
const String salesRevenueDetails='/salesRevenueDetails';
const String loginScreen = '/loginScreen';
const String splashScreen = '/splashScreen';



Route<Object?>? generateRoute(RouteSettings settings) {
  return getRoute(settings.name);
}

Route<Object?>? getRoute(String? name,
    {LinkedHashMap? args, Function(dynamic)? result}) {
  switch (name) {
    case splashScreen:
      return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
          settings: RouteSettings(name: name));
    case loginScreen:
      return MaterialPageRoute(
          builder: (context) => LoginScreen(),
          settings: RouteSettings(name: name));
    case dashboardScreen:
      return MaterialPageRoute(
          builder: (context) => Dashboard(args),
          settings: RouteSettings(name: name));
    case salesRevenueDetails:
      return MaterialPageRoute(
          builder: (context) => DashboardDetailsScreen(args!),
          settings: RouteSettings(name: name));

  }
  return null;
}

openScreen(String routeName,
    {bool forceNew = false,
      bool requiresAsInitial = false,
      LinkedHashMap? args,
      Function(dynamic)? result}) {
  var route = getRoute(routeName, args: args, result: result);
  var context = NavObserver.navKey.currentContext;

  if (route != null && context != null) {
    if (requiresAsInitial) {
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    } else if (forceNew || !NavObserver.instance.containsRoute(route)) {
      Navigator.push(context, route);
    } else {
      Navigator.popUntil(context, (route) {
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

back({LinkedHashMap? args}) {
  if (NavObserver.navKey.currentContext != null) {
    Navigator.pop(NavObserver.navKey.currentContext!, args);
  }
}

replaceCurrentScreen(String name, {LinkedHashMap? args}) {
  var route = getRoute(name, args: args);
  var context = NavObserver.navKey.currentContext;
  if (route != null && context != null) {
    Navigator.pushReplacement(context, route);
  }
}

