import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoenix/cubit/dashboard/dashboard_cubit.dart';
import 'package:phoenix/cubit/dashboard/dashboard_state.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/nav_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/models/bar_chart_model.dart';
import 'package:phoenix/models/dashboard/detail_chart_data_model.dart';
import 'package:phoenix/models/dashboard/direct_sale_data_model.dart';
import 'package:phoenix/models/line_chart_model.dart';
import 'package:phoenix/widgets/card_data_widget.dart';
import 'package:phoenix/widgets/charts/bar_chart.dart';
import 'package:phoenix/widgets/charts/declined_pieChart.dart';
import 'package:phoenix/widgets/container_widget.dart';
import 'package:phoenix/widgets/gap/widgets/gap.dart';
import 'package:phoenix/widgets/loader.dart';

import 'dashboard_screen.dart';

class DashboardDetailsScreen extends StatelessWidget {
  DashboardDetailsScreen(LinkedHashMap<dynamic, dynamic>? args, {super.key}) {
    if (args != null) {
      isDirectSale = args["isDirectSale"];
      isUpsell = args["isUpsell"];
      image = args["image"];
      title = args["title"];
      color = args["color"];
    }
  }

  var isDirectSale;
  var isUpsell;
  var image;
  String? title;
  var color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B111A),
      body: SafeArea(child: BlocBuilder<DashBoardCubit, DashboardState>(
          // buildWhen: (oldState,newState)=>oldState.dashboardDetailReqState!=newState.dashboardDetailReqState,
          builder: (context, state) {
        return Column(
          children: [
            Container(
              height: Responsive.boxH(context, 10),
              color: AppColors.backgroundGrey,
              child:Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: back,
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 48), // reserve space on right
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: color,
                        radius: Responsive.boxW(
                            context, DeviceType.isMobile(context) ? 5 : 3),
                        child: Padding(
                          padding: EdgeInsets.all(Responsive.padding(
                              context, DeviceType.isMobile(context) ? 2 : 1.5)),
                          child: SvgPicture.asset(
                            image,
                            width: Responsive.boxW(context, 10),
                            height: Responsive.boxH(context, 10),
                          ),
                        ),
                      ),
                      Gap(16),
                      Text(
                        translate(title ?? ''),
                        style: getTextTheme().bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.fontSize(context, 5)),
                      ),
                    ],
                  ),
                ],
              )

            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Responsive.padding(context, 2)),
                child: SingleChildScrollView(
                  child: isUpsell
                      ? Column(
                          children: [
                            Gap(24),
                            PieChartWidget(
                              title: TextHelper.declineBreakdown,
                              data: processDetailData(state
                                      .detailChartDeclinedBreakDownData
                                      ?.result ??
                                  []),
                              isFilterDropdownNeeded: false,
                              isLoading: state.dashboardRevenueReqState ==
                                  ProcessState.loading,
                            )
                          ],
                        )
                      : Column(
                          children: [
                            RenderSection(title: "", cards: [
                              CardData(
                                circleBgColor: isDirectSale
                                    ? Color(0xFFC237F3)
                                    : Color(0xFF05CD99),
                                title: isDirectSale
                                    ? TextHelper.totalDirectSales
                                    : TextHelper.totalApproved,
                                subtitle: isDirectSale
                                    ? formatNumber(state
                                            .directSaleDetailData
                                            ?.result
                                            ?.firstOrNull
                                            ?.approvedOrders ??
                                        0)
                                    : formatNumber(state
                                            .dashboardDetailData
                                            ?.result
                                            ?.firstOrNull
                                            ?.approvedOrders ??
                                        0),
                                // subtitle: getSubtitle(directSale['ApprovedOrders'] ?? 0, directSale['ApprovalPercentage'] ?? 0),
                                image: isDirectSale
                                    ? Assets.imagesCartHold
                                    : Assets.imagesDone,
                                // Replace with actual image
                                isLoading: state.dashboardDetailReqState ==
                                    ProcessState.loading,
                                isGlowing: true,
                                imageWidth: !isDirectSale ? 5 : null,
                                imageHeight: !isDirectSale ? 5 : null,
                                onPress: () {},
                              ),
                              CardData(
                                  circleBgColor: isDirectSale
                                      ? Color(0xFF05CD99)
                                      : Color(0xFFE84040),
                                  title: isDirectSale
                                      ? TextHelper.uniqueApprovalRatio
                                      : TextHelper.totalDeclined,
                                  subtitle: isDirectSale
                                      ? checkNullable(state
                                              .directSaleDetailData
                                              ?.result
                                              ?.firstOrNull
                                              ?.approvalPercentage ??
                                          0)
                                      : formatNumber(state
                                              .dashboardDetailData
                                              ?.result
                                              ?.firstOrNull
                                              ?.declinedOrders ??
                                          0),
                                  // subtitle: getSubtitle(initialSubscription['ApprovedOrders'] ?? 0, initialSubscription['ApprovalPercentage'] ?? 0),
                                  image: isDirectSale
                                      ? Assets.imagesDocDone
                                      : Assets.imagesClose,
                                  isLoading: state.dashboardDetailReqState ==
                                      ProcessState.loading,
                                  isGlowing: true,
                                  imageWidth: !isDirectSale ? 5 : null,
                                  imageHeight: !isDirectSale ? 5 : null,
                                  onPress: () {}),
                              CardData(
                                circleBgColor: Color(0xFF6AD2FF),
                                title: isDirectSale
                                    ? TextHelper.averageOrderValue
                                    : TextHelper.approvalRatio,
                                // subtitle: formatCurrency(state.directSaleDetailData?.result?.first.averageOrderValue ?? 0.0),
                                subtitle: isDirectSale
                                    ? formatCurrency(double.parse((state
                                                .directSaleDetailData
                                                ?.result
                                                ?.firstOrNull
                                                ?.averageOrderValue ??
                                            0)
                                        .toString()))
                                    : checkNullable(state
                                            .dashboardDetailData
                                            ?.result
                                            ?.firstOrNull
                                            ?.approvalPercentage ??
                                        0),
                                // subtitle: getSubtitle(recurringSubscription['ApprovedOrders'] ?? 0, recurringSubscription['ApprovalPercentage'] ?? 0),
                                image: Assets.imagesStatisticsGraph,
                                isLoading: state.dashboardDetailReqState ==
                                    ProcessState.loading,
                                isGlowing: true,
                                imageWidth: 6,
                                imageHeight: 6,
                                onPress: () {},
                              ),
                              CardData(
                                circleBgColor: Color(0xFFF36337),
                                title: isDirectSale
                                    ? TextHelper.abandonCartRatio
                                    : TextHelper.canceledSubscribers,
                                subtitle: isDirectSale
                                    ? checkNullable(state
                                            .directSaleDetailData
                                            ?.result
                                            ?.firstOrNull
                                            ?.abandonCartRatio ??
                                        0)
                                    : formatNumber(state
                                            .dashboardDetailData
                                            ?.result
                                            ?.firstOrNull
                                            ?.cancelledSubscriptions ??
                                        0),
                                // subtitle: getSubtitle(subscriptionSalvage['ApprovedOrders'] ?? 0, subscriptionSalvage['ApprovalPercentage'] ?? 0),
                                image: isDirectSale
                                    ? Assets.imagesCartHold
                                    : Assets.imagesCanceledSubscribers,
                                isLoading: state.dashboardDetailReqState ==
                                    ProcessState.loading,
                                isGlowing: true,
                                imageWidth: !isDirectSale ? 6 : null,
                                imageHeight: !isDirectSale ? 6 : null,
                                onPress: () {},
                              ),
                            ]),
                            Gap(10),
                            isDirectSale
                                ? PieChartWidget(
                                    title: TextHelper.declineBreakdown,
                                    data: processDetailData(state
                                            .detailChartDeclinedBreakDownData
                                            ?.result ??
                                        []),
                                    isFilterDropdownNeeded: false,
                                    isLoading: state.dashboardRevenueReqState ==
                                        ProcessState.loading,
                                  )
                                // ContainerWidget(
                                //         height: 60,
                                //         title: TextHelper.salesRevenue,
                                //         widget: state.dashboardAppRatioReqState ==
                                //                 ProcessState.loading
                                //             ? Loader()
                                //             : (state.directSaleRevenueData?.result ?? [])
                                //                     .isEmpty
                                //                 ? NoDataWidget()
                                //                 : SalesRevenueChart(
                                //                     areaMap: true,
                                //                     chartModel: getDirectSaleData(state
                                //                             .directSaleRevenueData
                                //                             ?.result ??
                                //                         []),
                                //                     isDetailScreen: true,
                                //                   ),
                                //       )
                                : ContainerWidget(
                                    title: TextHelper.uniqueApprovalRatio,
                                    widget: state.dashboardAppRatioReqState ==
                                            ProcessState.loading
                                        ? Loader()
                                        : (state.detailChartAppRatioData
                                                        ?.result ??
                                                    [])
                                                .isEmpty
                                            ? NoDataWidget()
                                            : BarChartWidget(
                                                chartData: getApprovalRatioData(
                                                    state.detailChartAppRatioData
                                                            ?.result ??
                                                        []),
                                                barRadius: 20,
                                                barSpace: -20,
                                                showAllRods: true,
                                                barWidth: !DeviceType.isMobile(
                                                        context)
                                                    ? 40
                                                    : 30,
                                                width: Responsive.screenW(
                                                    context,
                                                    !DeviceType.isMobile(
                                                            context)
                                                        ? 20
                                                        : 25),
                                                isLegendRequired: false,
                                              )),
                            Gap(20),
                            isDirectSale
                                ? ContainerWidget(
                                    title: TextHelper.uniqueApprovalRatio,
                                    widget: state.dashboardAppRatioReqState ==
                                            ProcessState.loading
                                        ? Loader()
                                        : (state.directSaleAppRatioData
                                                        ?.result ??
                                                    [])
                                                .isEmpty
                                            ? NoDataWidget()
                                            : BarChartWidget(
                                                chartData: getProcessData(state
                                                        .directSaleAppRatioData
                                                        ?.result ??
                                                    []),
                                                barRadius: 20,
                                                barSpace: -20,
                                                showAllRods: true,
                                                barWidth: !DeviceType.isMobile(
                                                        context)
                                                    ? 40
                                                    : 30,
                                                width: Responsive.screenW(
                                                    context,
                                                    !DeviceType.isMobile(
                                                            context)
                                                        ? 15
                                                        : 25),
                                                isLegendRequired: false,
                                              ))
                                : PieChartWidget(
                                    title: TextHelper.declineBreakdown,
                                    data: processDetailData(state
                                            .detailChartDeclinedBreakDownData
                                            ?.result ??
                                        []),
                                    isLoading: state.dashboardRevenueReqState ==
                                        ProcessState.loading,
                                  ),
                            Gap(20),
                          ],
                        ),
                ),
              ),
            ),
          ],
        );
      })),
    );
  }

  getDirectSaleData(List<DirectSaleDetailDataResult> salesDataList) {
    return LineChartModel.fromDirectSalesData(salesDataList);
  }

  getProcessData(List<DtSaleAppRatioDataResult> data) {
    var result = data.map((e) => e.toChartJson()).toList();
    return processData(result);
  }

  List<DetailChartDeclinedBreakDownDataResult> processDetailData(
      List<DetailChartDeclinedBreakDownDataResult> data) {
    // ✅ Directly map the data or apply any transformation if required
    return data.map((entry) {
      return DetailChartDeclinedBreakDownDataResult(
        reason: entry.reason,
        value: entry.value,
        percentage: entry.percentage,
        cancelled: entry.cancelled,
      );
    }).toList();
  }

  getApprovalRatioData(List<DetailChartApprovalRatioDataResult> data) {
    var result = data.map((e) => e.toChartJson()).toList();
    return processData(result);
  }
}
