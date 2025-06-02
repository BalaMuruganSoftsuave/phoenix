import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/cubit/dashboard/dashboard_cubit.dart';
import 'package:phoenix/cubit/dashboard/dashboard_state.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dependency.dart';
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
import 'package:phoenix/widgets/custom_single_selection_dropdown.dart';
import 'package:phoenix/widgets/filter_by_day_widget.dart';
import 'package:phoenix/widgets/loader.dart';
import 'package:phoenix/widgets/storefilter/phoenix_dropDown_Screen.dart';

import 'charge_back_summary_widget.dart';
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<String> selectedNetSubscriberFilter =
  ValueNotifier("netPerDay");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B111A),
      body: SafeArea(
        child: BlocBuilder<DashBoardCubit, DashboardState>(
          builder: (context, state) {
            var cumulativeData = SubscriptionData.getCumulativeSubscriptionData(
                state.netSubscribersData?.result ?? []);
            return state.permissionReqState == ProcessState.loading
                ? Center(child: Loader())
                : Column(
              children: [
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
                                  " clientIDs: $clientIDs -storeIDs: $storeIDs");
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
                          selectedNetSubscriberFilter.value="netPerDay";
                          await context
                              .read<DashBoardCubit>()
                              .refresh(context);

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
                            Visibility(
                              visible: state.lifeTimeReqState ==
                                  ProcessState.success,
                              child: LifeTimeDataWidget(
                                state: state,
                              ),
                            ),

                            SizedBox(height: 30),
                            // Second Container Inside Column
                            ContainerWidget(
                              height: 62,
                              title: TextHelper.salesRevenue,
                              subTitle: Visibility(
                                visible:
                                state.totalSalesRevenueReqState ==
                                    ProcessState.success,
                                child: Row(
                                  children: [
                                    Text(
                                      "Total : ",
                                      style: getTextTheme()
                                          .bodyMedium
                                          ?.copyWith(
                                          color: AppColors.grey,
                                          fontWeight:
                                          FontWeight.w600),
                                    ),
                                    Text(
                                      calculateTotalSum(state
                                          .totalSalesRevenueData
                                          ?.result ??
                                          []) >
                                          0
                                          ? formatCurrency(
                                          calculateTotalSum(state
                                              .totalSalesRevenueData
                                              ?.result ??
                                              []))
                                          : "0".toString(),
                                      style: getTextTheme()
                                          .bodyMedium
                                          ?.copyWith(
                                          color: AppColors.white,
                                          fontWeight:
                                          FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
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
                              childWidget: Container(
                                padding: EdgeInsets.all(2),
                                height: Responsive.boxH(context, 5),
                                width: Responsive.boxW(context, 35),
                                decoration: BoxDecoration(
                                    color: AppColors.darkBg,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        width: 0.5,
                                        color: AppColors.white),
                                    shape: BoxShape.rectangle),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Total Revenue",
                                      textAlign: TextAlign.center,
                                      style: getTextTheme()
                                          .bodyMedium
                                          ?.copyWith(
                                          color: AppColors.white,
                                          fontSize:
                                          Responsive.fontSize(
                                              context, 3.5)),
                                    )),
                              ),
                            ),

                            SizedBox(height: 20),
                            ValueListenableBuilder(
                                valueListenable:
                                selectedNetSubscriberFilter,
                                builder:
                                    (context, String selectedValue, _) {
                                  return ContainerWidget(
                                      height: 60,
                                      title: TextHelper.netSubscribers,
                                      childWidget: _buildDropdown(
                                          context, selectedValue),
                                      widget: state
                                          .netSubscribersReqState ==
                                          ProcessState.loading
                                          ? Loader()
                                          : (state.netSubscribersData
                                          ?.result ??
                                          [])
                                          .isEmpty
                                          ? NoDataWidget()
                                          : SalesRevenueChart(
                                          areaMap: false,
                                          chartModel: getNetSubData(
                                              selectedValue=="cumulative"? cumulativeData:state.netSubscribersData
                                                  ?.result ??
                                                  [])));
                                }),

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
                            if (state.refundRatioReqState ==
                                ProcessState.success) ...[
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
                                    chartData: getRefundData(
                                        state
                                            .refundRatioData
                                            ?.result
                                            ?.straightData ??
                                            []),
                                    barRadius: 3,
                                    barSpace: -1,
                                    barWidth:
                                    DeviceType.isMobile(
                                        context)
                                        ? 30
                                        : 50,
                                    width: Responsive.screenW(
                                        context,
                                        !DeviceType.isMobile(
                                            context)
                                            ? 25
                                            : 30),
                                  )),
                              SizedBox(height: 20),
                              ContainerWidget(
                                  title:
                                  TextHelper.subscriptionRefundRatio,
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
                                    barSpace:
                                    DeviceType.isMobile(
                                        context)
                                        ? -30
                                        : -50,
                                    barWidth:
                                    DeviceType.isMobile(
                                        context)
                                        ? 30
                                        : 50,
                                    showBackDraw: true,
                                    width: Responsive.screenW(
                                        context,
                                        !DeviceType.isMobile(
                                            context)
                                            ? 20
                                            : 25),
                                  ))
                            ],
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

  Widget _buildDropdown(context, selectedValue) {
    return SingleSelectionDropDown(
      maxHeight:
      Responsive.screenH(context, DeviceType.isMobile(context) ? 15 : 12),
      initiallySelectedKey: selectedValue,
      items: netSubscriberFilter,
      onSelection: (value) {
        selectedNetSubscriberFilter.value = value.id!;
      },
      // dropdownColor: AppColors.darkBg2,
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
    List<Map<String, dynamic>> data1 = data.map((e) => e.toJson()).toList();
    return processData(data1);
  }

  double calculateTotalSum(List<SalesData> data) {
    return data.fold(
        0,
            (total, entry) =>
        total +
            (entry.directSale ?? 0) +
            (entry.upsellSale ?? 0) +
            (entry.initialSale ?? 0) +
            (entry.recurringSale ?? 0) +
            (entry.salvageSale ?? 0));
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
