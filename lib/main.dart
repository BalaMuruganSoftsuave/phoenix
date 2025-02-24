import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/helper/nav_helper.dart';

import 'Cubit/dashboard/dashboard_cubit.dart';
import 'helper/nav_observer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
            BlocProvider(create: (context)=>DashBoardCubit()),
        ],
        child: MaterialApp(
          navigatorObservers: [NavObserver.instance],
          initialRoute: dashboardScreen,
          onGenerateRoute: generateRoute ,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
          navigatorKey: NavObserver.navKey,
    ));

  }
}

