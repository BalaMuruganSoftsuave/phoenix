import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phoenix/cubit/dashboard/dashboard_cubit.dart';
import 'package:phoenix/cubit/dashboard/dashboard_state.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/models/bar_chart_model.dart';
import 'package:phoenix/models/line_chart_model.dart';
import 'package:phoenix/screens/dashboard/transaction_data_widget.dart';
import 'package:phoenix/widgets/charts/pieChart.dart';
import 'package:phoenix/widgets/charts/refund_ratio_chart.dart';
import 'package:phoenix/widgets/charts/sales_revenue_chart.dart';
import 'package:phoenix/widgets/filter_by_day_widget.dart';
import 'package:phoenix/widgets/profile_menu_button.dart';
import 'package:phoenix/widgets/storefilter/phoenix_dropDown_Screen.dart';

import 'charge_back_summary_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var data = {
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
    {"Void": 906.71, "Range": "02/27", "Refund": 15466.63, "Revenue": 80499.81},
    {
      "Void": 1139.62,
      "Range": "02/28",
      "Refund": 13808.83,
      "Revenue": 69587.33
    },
    {"Void": 299.9, "Range": "03/01", "Refund": 9251, "Revenue": 151689.47},
    {"Void": 546.83, "Range": "03/02", "Refund": 4311.04, "Revenue": 100401.48},
    {
      "Void": 1543.51,
      "Range": "03/03",
      "Refund": 13382.84,
      "Revenue": 155845.19
    },
    {
      "Void": 1179.61,
      "Range": "03/04",
      "Refund": 15055.92,
      "Revenue": 130411.92
    },
    {"Void": 59.98, "Range": "03/05", "Refund": 1529.51, "Revenue": 21793.1}
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
        child: BlocBuilder<DashBoardCubit, DashboardState>(
          builder: (context, state) {
            return state.permissionReqState == ProcessState.loading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      SizedBox(
                        height: Responsive.boxH(context, 10),
                        child: AppBar(
                          backgroundColor: AppColors.darkBg,
                          centerTitle: false,
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
                                debugPrint("User logged out");
                                // Implement logout functionality here
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: FilterComponent(
                                onSelectionChange: (key, {range}) {
                                  context.read<DashBoardCubit>().updateFilter(
                                      context,
                                      startDate: formatter.format(range!.start),
                                      endDate: formatter.format(range.end));
                                  debugPrint(
                                      "Selected: $key, Range: ${range?.start} - ${range?.end}");
                                },
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: ClientStoreFilterWidget(
                                  state: state,
                                  onChanged: (clientIDs, storeIDs) {
                                    context.read<DashBoardCubit>().updateFilter(
                                        context,
                                        clientList: clientIDs,
                                        storeList: storeIDs);
                                    debugPrint(
                                        "Selected: $key, clientIDs: $clientIDs -storeIDs: $storeIDs");
                                  },
                                ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Responsive.padding(context, 2)),
                          child: SingleChildScrollView(
                            // Allows entire screen to scroll
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DashBoardFirstDataWidget(state: state),
                                TransactionDataWidget(
                                  state: state,
                                ),
                                SizedBox(height: 30),
                                LifeTimeDataWidget(
                                  state: state,
                                ),
                                ChargebackSummary(),
                                SizedBox(height: 30),
                                // Second Container Inside Column

                                SizedBox(
                                    height: 450,
                                    child: SalesRevenueChart(
                                        title: "Sales Revenue",
                                        areaMap: true,
                                        chartModel: chartModel)),
                                SizedBox(height: 20),

                                SizedBox(
                                    height: 450,
                                    child: SalesRevenueChart(
                                        title: "Net Subscribers",
                                        areaMap: false,
                                        chartModel: chartModel)),
                                SizedBox(height: 20),
                                SizedBox(
                                  height: 500,
                                  child: PieChartFilterWidget(
                                    title: "Coverage Health",
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),

                                SizedBox(
                                    height: 350,
                                    child: BarChartWidget(
                                      chartData: processedData,
                                      barRadius: 3,
                                      barSpace: -1,
                                      title: TextHelper.directSaleRefundRatio,
                                    )),
                                SizedBox(height: 20),

                                SizedBox(
                                    height: 350,
                                    child: BarChartWidget(
                                      chartData: processedData,
                                      barRadius: 30,
                                      barSpace: -30,
                                      title: TextHelper.directSaleRefundRatio,
                                      showBackDraw: true,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  String getSubtitle(int approvedOrders, double approvalPercentage) {
    return '$approvedOrders orders - ${approvalPercentage.toStringAsFixed(1)}% approval';
  }
}
