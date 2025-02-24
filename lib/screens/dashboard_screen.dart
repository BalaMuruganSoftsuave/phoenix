import 'package:flutter/material.dart';
import 'package:phoenix/helper/font_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/widgets/dashboard_card.dart';

import '../widgets/sales_revenue_chart.dart';

class DashboardScreen extends StatelessWidget {
   DashboardScreen({super.key});
  // final List<String> icons = [
  //   'assets/Icons/detail.png',
  //   'assets/Icons/initial.png',
  //   'assets/Icons/recurring.png',
  //   'assets/Icons/subscription.png',
  //   'assets/Icons/upsell.png',
  //   'assets/Icons/bill.png',
  // ];
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Color(0xFF0B111A),
       appBar: AppBar(),
       body: SingleChildScrollView( // Allows entire screen to scroll
         child: Padding(
           padding: EdgeInsets.all(10), // Adjust padding
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               // First ListView
               ListView.builder(
                 itemCount: 6,
                 shrinkWrap: true, // Important: prevents infinite height
                 physics: NeverScrollableScrollPhysics(), // Prevents nested scrolling
                 itemBuilder: (context, index) {
                   return card("leading", "title", "subtitle");
                 },
               ),
                SizedBox(height: 30),
               // Second Container Inside Column
               Container(
                 padding: EdgeInsets.all(10),
                 decoration: BoxDecoration(
                   border: Border.all(color: Color(0x33A3AED0), width: 0.5),
                   borderRadius: BorderRadius.circular(15),
                 ),
                 child: Column(
                   children: [
                     Align(
                       alignment: Alignment.topLeft,
                       child: Text(
                         "February 2024",
                         style: TextStyle(color: Colors.white),
                       ),
                     ),
                     ListView.builder(
                       itemCount: 3,
                       shrinkWrap: true, // Important
                       physics: NeverScrollableScrollPhysics(),
                       itemBuilder: (context, index) {
                         return card("leading", "title", "subtitle");
                       },
                     ),
                   ],
                 ),
               ),
               SizedBox(height: 30),

               Container(
                 padding: EdgeInsets.all(10),
                 decoration: BoxDecoration(
                   border: Border.all(color: Color(0x33A3AED0), width: 0.5),
                   borderRadius: BorderRadius.circular(15),
                 ),
                 child: Column(
                   children: [
                     Align(
                       alignment: Alignment.topLeft,
                       child: Text(
                         "February 2024",
                         style: TextStyle(color: Colors.white),
                       ),
                     ),
                     ListView.builder(
                       itemCount: 3,
                       shrinkWrap: true, // Important
                       physics: NeverScrollableScrollPhysics(),
                       itemBuilder: (context, index) {
                         return   card("leading", "title", "subtitle");
                         ;
                       },
                     ),
                   ],
                 ),
               ),

               SizedBox(
                 height: 300,
                   child: SalesRevenueChart(isShowingMainData: true,)
               )
             ],
           ),
         ),
       ),
     );
   }
}
