import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/cubit/dashboard/dashboard_cubit.dart';
import 'package:phoenix/cubit/dashboard/dashboard_state.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/models/bar_chart_model.dart';
import 'package:phoenix/models/dashboard/refund_ratio_data_model.dart';
import 'package:phoenix/models/line_chart_model.dart';
import 'package:phoenix/screens/dashboard/transaction_data_widget.dart';
import 'package:phoenix/widgets/charts/bar_chart.dart';
import 'package:phoenix/widgets/charts/line_chart.dart';
import 'package:phoenix/widgets/charts/pieChart.dart';
import 'package:phoenix/widgets/container_widget.dart';
import 'package:phoenix/widgets/filter_by_day_widget.dart';
import 'package:phoenix/widgets/loader.dart';
import 'package:phoenix/widgets/storefilter/phoenix_dropDown_Screen.dart';

import 'charge_back_summary_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                                      "Selected: $key, Range: ${range.start} - ${range.end}");
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
                          child: RefreshIndicator(
                            color: Colors.pink,
                            onRefresh: () async {
                              try {
                                await context.read<DashBoardCubit>().refresh(context);
                              } catch (e) {
                                debugPrint("Refresh failed: $e");
                              }
                              return Future.delayed(Duration(seconds: 1));
                            },
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

                                  SizedBox(height: 30),
                                  // Second Container Inside Column
                                  ContainerWidget(
                                    height: 62,
                                    title: TextHelper.salesRevenue,
                                    widget: state.totalSalesRevenueReqState ==
                                            ProcessState.loading
                                        ? Loader()
                                        : (state.totalSalesRevenueData
                                                        ?.result ??
                                                    [])
                                                .isEmpty
                                            ? NoDataWidget()
                                            : SalesRevenueChart(
                                                areaMap: true,
                                                chartModel: getSalesData(state
                                                        .totalSalesRevenueData
                                                        ?.result ??
                                                    [])),
                                    childWidget: Icon(Icons.add),
                                  ),

                                  SizedBox(height: 20),
                                  ContainerWidget(
                                      height: 60,
                                      title: TextHelper.netSubscribers,
                                      widget: state.netSubscribersReqState ==
                                              ProcessState.loading
                                          ? Loader()
                                          : (state.netSubscribersData?.result ??
                                                      [])
                                                  .isEmpty
                                              ? NoDataWidget()
                                              : SalesRevenueChart(
                                                  areaMap: false,
                                                  chartModel: getNetSubData(
                                                      state.netSubscribersData
                                                              ?.result ??
                                                          []))),

                                  SizedBox(height: 20),

                                  PieChartFilterWidget(
                                      isLoading:
                                          state.coverageHealthDataReqState ==
                                              ProcessState.loading,
                                      transactions: state
                                              .coverageHealthDataData?.result ??
                                          [],
                                      title: TextHelper.coverageHealth),
                                  SizedBox(height: 30),
                                  ChargebackSummary(),
                                  SizedBox(height: 20),

                                  ContainerWidget(
                                      title: TextHelper.directSaleRefundRatio,
                                      widget: state.refundRatioReqState ==
                                              ProcessState.loading
                                          ? Loader()
                                          : (state.refundRatioData?.result
                                                          ?.straightData ??
                                                      [])
                                                  .isEmpty
                                              ? NoDataWidget()
                                              : BarChartWidget(
                                                  chartData: getRefundData(state
                                                          .refundRatioData
                                                          ?.result
                                                          ?.straightData ??
                                                      []),
                                                  barRadius: 3,
                                                  barSpace: -1,
                                                )),

                                  SizedBox(height: 20),
                                  ContainerWidget(
                                      title: TextHelper.subscriptionRefundRatio,
                                      widget: state.refundRatioReqState ==
                                              ProcessState.loading
                                          ? Loader()
                                          : (state.refundRatioData?.result
                                                          ?.subscriptionData ??
                                                      [])
                                                  .isEmpty
                                              ? NoDataWidget()
                                              : BarChartWidget(
                                                  chartData: getRefundData(state
                                                          .refundRatioData
                                                          ?.result
                                                          ?.subscriptionData ??
                                                      []),
                                                  barRadius: 30,
                                                  barSpace: -30,
                                                  showBackDraw: true,
                                                  width: 70,
                                                ))
                                ],
                              ),
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

  getRefundData(List<RefundRatioData> data) {
    List<Map<String, dynamic>> data1 =
        data.map((e) => e.toJson()).toList();
    return processData(data1);
  }
}

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        translate(TextHelper.noDataOnThisPeriod),
        style: getTextTheme().bodyMedium?.copyWith(
            fontSize: Responsive.fontSize(context, 4),
            color: AppColors.subText),
      ),
    );
  }
}
