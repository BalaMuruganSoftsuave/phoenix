import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/cubit/dashboard/dashboard_cubit.dart';
import 'package:phoenix/cubit/notification/notification_cubit.dart';
import 'package:phoenix/helper/nav_helper.dart';
import 'package:phoenix/helper/theme_helper.dart';
import 'package:phoenix/helper/utils.dart';

import 'cubit/auth/auth_cubit.dart';
import 'helper/firebase_helper.dart';
import 'helper/nav_observer.dart';
import 'helper/preference_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceHelper.init();
  await EasyLocalization.ensureInitialized();

  // await FirebaseHelper.initializeFirebase();
  // await FirebaseHelper.getFCMToken();
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
          BlocProvider(
            create: (context) => DashBoardCubit(),
          ),
          BlocProvider(
            create: (context) => AuthCubit(),
          ),
          BlocProvider(
            create: (context) => NotificationCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [NavObserver.instance],
          initialRoute: splashScreen,
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
                  hideKeyboard(context);
                }
              },
              child: child,
            );
          },
        ));
  }
}
