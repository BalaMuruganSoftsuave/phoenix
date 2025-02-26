import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/helper/nav_helper.dart';
import 'package:phoenix/helper/theme_helper.dart';
import 'package:phoenix/helper/utils.dart';

import 'Cubit/dashboard/dashboard_cubit.dart';
import 'helper/nav_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale('en', 'US'),
        ],
        path: 'language', // <-- change the path of the translation files
        fallbackLocale: Locale('en', 'US'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DashBoardCubit()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [NavObserver.instance],
          initialRoute: dashboardScreen,
          onGenerateRoute: generateRoute,
          title: 'Phoenix',
          theme: ThemeHelper.lightTheme(context),
          navigatorKey: NavObserver.navKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) {
            return GestureDetector(
              onTap: () {
                if (Platform.isIOS) {
                  print("object");
                  hideKeyboard(context);
                }
              },
              child: child,
            );
          },
        ));
  }
}
