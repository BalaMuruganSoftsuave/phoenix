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
import 'package:phoenix/widgets/charts/bar_chart.dart';
import 'package:phoenix/widgets/charts/line_chart.dart';
import 'package:phoenix/widgets/container_widget.dart';
import 'package:phoenix/widgets/filter_by_day_widget.dart';
import 'package:phoenix/widgets/loader.dart';
import 'package:phoenix/widgets/profile_menu_button.dart';
import 'package:phoenix/widgets/storefilter/phoenix_dropDown_Screen.dart';

import 'charge_back_summary_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});


  List<Map<String, dynamic>> rawData = [
    {
      "Void": 5188.27,
      "Range": "Jan 24",
      "Refund": 19381.51,
      "Revenue": 186087.95
    },
    {
      "Void": 5758.08,
      "Range": "Feb 24",
      "Refund": 21555.89,
      "Revenue": 197502.24
    },
    {
      "Void": 6067.98,
      "Range": "Mar 24",
      "Refund": 25356.15,
      "Revenue": 266304.43
    },
    {
      "Void": 6223.94,
      "Range": "Apr 24",
      "Refund": 23356.5,
      "Revenue": 275686.93
    },
    {
      "Void": 5597.13,
      "Range": "May 24",
      "Refund": 24267.05,
      "Revenue": 359478.23
    },
    {
      "Void": 9574.82,
      "Range": "Jun 24",
      "Refund": 28925.51,
      "Revenue": 523418.7
    },
    {
      "Void": 9856.73,
      "Range": "Jul 24",
      "Refund": 36955.39,
      "Revenue": 529075.94
    },
    {
      "Void": 8263.26,
      "Range": "Aug 24",
      "Refund": 51161.51,
      "Revenue": 797178.43
    },
    {
      "Void": 8307.45,
      "Range": "Sep 24",
      "Refund": 91153.21,
      "Revenue": 1285172.21
    },
    {
      "Void": 15564.12,
      "Range": "Oct 24",
      "Refund": 170985.57,
      "Revenue": 1397348.35
    },
    {
      "Void": 17594.55,
      "Range": "Nov 24",
      "Refund": 150770.05,
      "Revenue": 1907791.82
    },
    {
      "Void": 27908.08,
      "Range": "Dec 24",
      "Refund": 241363.89,
      "Revenue": 4137703.72
    }
  ];

  @override
  Widget build(BuildContext context) {
    List<ChartData> processedData = processData(rawData);

    return Scaffold(
      backgroundColor: Color(0xFF0B111A),
      body: SafeArea(
        child: BlocBuilder<DashBoardCubit, DashboardState>(
          builder: (context, state) {
            return state.permissionReqState == ProcessState.loading
                ? Center(child: Loader())
                : Column(
                    children: [
                      // SizedBox(
                      //   height: Responsive.boxH(context, 10),
                      //   child: AppBar(
                      //     backgroundColor: AppColors.darkBg,
                      //     centerTitle: false,
                      //     title: SvgPicture.asset(
                      //       Assets.imagesPhoenixLogo,
                      //       width: Responsive.boxW(context, 15),
                      //       height: Responsive.boxH(context, 5),
                      //     ),
                      //     actions: [
                      //       ProfilePopupMenu(
                      //         userName: "John Doe",
                      //         onLogout: () {
                      //           showLogoutDialog(context, () {});
                      //           debugPrint("User logged out");
                      //           // Implement logout functionality here
                      //         },
                      //       )
                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        height: 80,
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
                                ContainerWidget(
                                  height: 62,
                                  title: "Sales Revenue",
                                  widget: SalesRevenueChart(
                                      areaMap: true,
                                      chartModel: getSalesData(
                                          state.totalSalesRevenueData?.result ??
                                              [])),
                                  childWidget: Icon(Icons.add),
                                ),

                                SizedBox(height: 20),
                                ContainerWidget(
                                  height: 60,
                                    title: "Net Subscribers",
                                    widget: SalesRevenueChart(
                                        areaMap: false,
                                        chartModel: getNetSubData(state.netSubscribersData?.result??[]))),

                                SizedBox(height: 20),

                                SizedBox(
                                    height: Responsive.screenH(context, 55),
                                    child: PieChartFilterWidget(
                                        title: "Coverage Health")),

                                SizedBox(height: 20),

                                ContainerWidget(
                                    title: TextHelper.directSaleRefundRatio,
                                    widget: BarChartWidget(
                                      chartData: processedData,
                                      barRadius: 3,
                                      barSpace: -1,
                                    )),

                                SizedBox(height: 20),
                                ContainerWidget(
                                    title: TextHelper.directSaleRefundRatio,
                                    widget: BarChartWidget(
                                      chartData: processedData,
                                      barRadius: 30,
                                      barSpace: -30,
                                      showBackDraw: true,
                                    ))
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

  getSalesData(List<SalesData> data) {
    return LineChartModel.fromSalesData(data);

  }

  getNetSubData(List<SubscriptionData> data) {
    return LineChartModel.fromSubscriptions(data);
  }
}
