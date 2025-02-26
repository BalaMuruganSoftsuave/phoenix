import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/widgets/filter_by_day_widget.dart';
import 'package:phoenix/widgets/glowing_card.dart';
import 'package:phoenix/widgets/profile_menu_button.dart';

import '../widgets/sales_revenue_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B111A),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: Responsive.boxH(context, 10),
              child: AppBar(
                backgroundColor: AppColors.darkBg,
                centerTitle: true,
                title: SvgPicture.asset(
                  Assets.imagesPhoenixLogo,
                  width: Responsive.boxW(context, 15),
                  height: Responsive.boxH(context, 5),
                ),
                actions: [
                  ProfilePopupMenu(
                    userName: "John Doe",
                    onLogout: () {
                      showLogoutDialog(context, (){});
                      print("User logged out");
                      // Implement logout functionality here
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                // Allows entire screen to scroll
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FilterComponent(
                    onSelectionChange: (key, {range}) {
                                print("Selected: $key, Range: ${range?.start} - ${range?.end}");
                                },
                                ),
                    GlowingCard(
                        svgAsset: Assets.imagesActiveSubscribers,
                        title: "title",
                        subtitle: "subtitle",
                        circleBgColor: Colors.yellow),
                    // First ListView

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
                        ],
                      ),
                    ),

                    SizedBox(
                        height: 300,
                        child: SalesRevenueChart(
                          isShowingMainData: true,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
