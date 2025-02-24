// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:phoenix/screens/dashboard_screen.dart';
// import '../helper/dependency.dart';
// import '../helper/responsive_helper.dart';
//
// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});
//
//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//
//   }
//
//   // List of widgets for each screen/tab
//   final List<Widget> _screens = [
//     const DashboardScreen(),
//
//   ];
//
//
//   // Update the current index when tapping on a BottomNavigationBarItem
//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//
//
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Wrap(
//           spacing: Responsive.padding(context, 5),
//           children: [
//             Image.asset(
//               'assets/images/logo2.png', // Path to your first image
//               fit: BoxFit.cover,
//               height: 40,
//             ),
//             Image.asset(
//               'assets/images/logo1.png', // Path to your second image
//               fit: BoxFit.cover,
//               height: 40,
//             ),
//             Image.asset(
//               'assets/images/logo.png', // Path to your third image
//               fit: BoxFit.cover,
//               height: 40,
//             ),
//           ],
//         ),
//         actions: [
//           Padding(
//             padding:  EdgeInsets.only(right:  Responsive.boxW(getCtx()!, 2),),
//             child: PopupMenuButton<Map<String, String>>(
//               onSelected: (Map<String, String> locale) {
//                 context.setLocale(Locale(locale['languageCode']!, locale['countryCode']!));
//                 context
//                     .read<AuthCubit>()
//                     .changeLanguage(locale['languageCode']);
//               },
//               itemBuilder: (BuildContext context) => const <PopupMenuEntry<Map<String, String>>>[
//                 PopupMenuItem<Map<String, String>>(
//                   value:  {'languageCode': 'en', 'countryCode': 'US'},
//                   child: Text('English'),
//                 ),
//                 PopupMenuItem<Map<String, String>>(
//                   value:  {'languageCode': 'fr', 'countryCode': 'FR'},
//                   child: Text('Français'),
//                 ),
//               ],
//               child: const Icon(Icons.translate,color: Colors.black,),
//             ),
//           ),
//         ],
//       ),
//       body:_screens[_currentIndex],
//
//       bottomNavigationBar: SizedBox(
//         height: MediaQuery.of(context).size.shortestSide > 600 ? 80 : 70, // Custom height for tablets
//         child: BottomNavigationBar(
//           backgroundColor: ColorHelper.white,
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: Theme.of(context).primaryColor,
//           currentIndex: _currentIndex,
//           onTap: _onTabTapped,
//           items:  [
//             BottomNavigationBarItem(
//               icon: const Icon(Icons.home),
//               label: tr("home"),
//             ),
//
//             // if(checkRole())
//             BottomNavigationBarItem(
//               icon: const Icon(Icons.edit),
//               label: tr("followUps"),
//             ),
//             BottomNavigationBarItem(
//               icon: const Icon(Icons.add_chart_sharp),
//               label: tr("surveys"),
//             ),
//             BottomNavigationBarItem(
//               icon: const Icon(Icons.person),
//               label: tr("profile"),
//             ),
//           ],
//         ),
//       ),
//
//       // Display the current screen
//     );
//   }
// }