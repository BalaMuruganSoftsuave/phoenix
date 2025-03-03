import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/screens/dashboard/transaction_data_widget.dart';
import 'package:phoenix/widgets/filter_by_day_widget.dart';
import 'package:phoenix/widgets/glowing_card.dart';
import 'package:phoenix/widgets/profile_menu_button.dart';

import '../../models/bar_chart_model.dart';
import '../../models/line_chart_model.dart';
import '../../widgets/charts/pieChart.dart';
import '../../widgets/charts/refund_ratio_chart.dart';
import '../../widgets/charts/sales_revenue_chart.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});
  var data={
    "Result": [
      {
        "Range": "02/25 12AM",
        "DirectSale": 2910.12,
        "UpsellSale": 0,
        "InitialSale": 519.82,
        "RecurringSale": 2515.31,
        "SalvageSale": 179.95
      },
      {
        "Range": "02/25 1AM",
        "DirectSale": 2007.04,
        "UpsellSale": 0,
        "InitialSale": 559.8,
        "RecurringSale": 6470.95,
        "SalvageSale": 39.99
      },
      {
        "Range": "02/25 2AM",
        "DirectSale": 1937.92,
        "UpsellSale": 0,
        "InitialSale": 276.92,
        "RecurringSale": 834.76,
        "SalvageSale": 39.99
      },
      {
        "Range": "02/25 3AM",
        "DirectSale": 1321.69,
        "UpsellSale": 0,
        "InitialSale": 159.95,
        "RecurringSale": 1045.72,
        "SalvageSale": 0
      },
      {
        "Range": "02/25 4AM",
        "DirectSale": 898.74,
        "UpsellSale": 0,
        "InitialSale": 219.92,
        "RecurringSale": 1125.74,
        "SalvageSale": 39.99
      },
      {
        "Range": "02/25 5AM",
        "DirectSale": 2709.01,
        "UpsellSale": 0,
        "InitialSale": 119.96,
        "RecurringSale": 991.77,
        "SalvageSale": 0
      },
      {
        "Range": "02/25 6AM",
        "DirectSale": 1392.53,
        "UpsellSale": 0,
        "InitialSale": 179.94,
        "RecurringSale": 888.8,
        "SalvageSale": 0
      },
      {
        "Range": "02/25 7AM",
        "DirectSale": 3030.47,
        "UpsellSale": 0,
        "InitialSale": 369.88,
        "RecurringSale": 1409.67,
        "SalvageSale": 0
      },
      {
        "Range": "02/25 8AM",
        "DirectSale": 3848.41,
        "UpsellSale": 0,
        "InitialSale": 376.88,
        "RecurringSale": 2412.33,
        "SalvageSale": 0
      },
      {
        "Range": "02/25 9AM",
        "DirectSale": 5688.34,
        "UpsellSale": 0,
        "InitialSale": 649.79,
        "RecurringSale": 3080.19,
        "SalvageSale": 119.97
      },
      {
        "Range": "02/25 10AM",
        "DirectSale": 4488.93,
        "UpsellSale": 0,
        "InitialSale": 699.77,
        "RecurringSale": 2929.34,
        "SalvageSale": 0
      },
      {
        "Range": "02/25 11AM",
        "DirectSale": 1974.32,
        "UpsellSale": 0,
        "InitialSale": 179.94,
        "RecurringSale": 1048.72,
        "SalvageSale": 0
      }
    ]
  };
   List<Map<String, dynamic>> rawData = [
     {"Void": 0, "Range": "02/21", "Refund": 10043.5, "Revenue": 182327.05},
     {"Void": 0, "Range": "02/22", "Refund": 8124.91, "Revenue": 150270.88},
     {"Void": 37, "Range": "02/23", "Refund": 4857.19, "Revenue": 110804.4},
     {"Void": 0, "Range": "02/24", "Refund": 8626.84, "Revenue": 107813.33},
     {"Void": 66.84, "Range": "02/25", "Refund": 11591.73, "Revenue": 114784.71},
     {"Void": 22.9, "Range": "02/26", "Refund": 8514.03, "Revenue": 149069.58},
     {"Void": 0, "Range": "02/27", "Refund": 7117.65, "Revenue": 141883.33},
   ];

  @override
  Widget build(BuildContext context) {
    List<SalesData> salesDataList = (data["Result"] as List)
        .map((item) => SalesData.fromJson(item))
        .toList();
    LineChartModel chartModel = LineChartModel.fromSalesData(salesDataList);
    List<ChartData> processedData = processData(rawData);

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
                      showLogoutDialog(context, () {});
                      print("User logged out");
                      // Implement logout functionality here
                    },
                  )
                ],
              ),
            ),
            FilterComponent(
              onSelectionChange: (key, {range}) {
                print("Selected: $key, Range: ${range?.start} - ${range?.end}");
              },
            ),
            Expanded(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal:Responsive.padding(context, 2)),
                child: SingleChildScrollView(
                  // Allows entire screen to scroll
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashBoardFirstDataWidget(),
                      TransactionDataWidget(),
                      SizedBox(height: 30),
                      LifeTimeDataWidget(),

                      // First ListView

                      SizedBox(height: 30),
                      // Second Container Inside Column
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0x33A3AED0), width: 0.5),
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
                          border:
                              Border.all(color: Color(0x33A3AED0), width: 0.5),
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
                      SizedBox(height: 20),


                      SizedBox(
                          height: 450,
                          child: SalesRevenueChart(title:"Sales Revenue",areaMap: true,chartModel: chartModel)
                      ),
                      SizedBox(height: 20),

                      SizedBox(
                          height: 450,
                          child: SalesRevenueChart(title:"Net Subscribers",areaMap: false,chartModel: chartModel)
                      ) ,
                      SizedBox(height: 20),
                      SizedBox(
                        height: 500,
                        child: PieChartFilterWidget(title: "Coverage Health",),
                      ),
                      SizedBox(height: 20,),

                      SizedBox(
                          height: 350,
                          child: BarChartWidget(chartData: processedData, barRadius: 10, barSpace:-1, title: TextHelper.directSaleRefundRatio,)
                      ),
                      SizedBox(height: 20),

                      SizedBox(
                          height: 350,
                          child: BarChartWidget(chartData: processedData, barRadius: 33, barSpace: -33, title: TextHelper.directSaleRefundRatio,)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String getSubtitle(int approvedOrders, double approvalPercentage) {
    return '$approvedOrders orders - ${approvalPercentage.toStringAsFixed(1)}% approval';
  }
}
