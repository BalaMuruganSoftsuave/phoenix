import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/cubit/dashboard/dashboard_cubit.dart';
import 'package:phoenix/cubit/dashboard/dashboard_state.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/nav_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/widgets/card_data_widget.dart';

class DashBoardFirstDataWidget extends StatelessWidget {
  final DashboardState state;

  const DashBoardFirstDataWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return RenderSection(title: "", cards: [
      CardData(
        circleBgColor: Color(0xFFF90182),
        title: state.directSaleData?.result?.firstOrNull?.label ??
            TextHelper.directSale,
        subtitle: getSubtitle(
            state.directSaleData?.result?.firstOrNull?.approvedOrders ?? 0,
            state.directSaleData?.result?.firstOrNull?.approvalPercentage ?? 0),
        image: Assets.imagesDirectSale,
        isLoading: state.directSaleReqState == ProcessState.loading,
        onPress: () {
          context.read<DashBoardCubit>().getDirectSaleDetailData(context);
          // context.read<DashBoardCubit>().getDirectSaleRevenueData(context);
          context
              .read<DashBoardCubit>()
              .getDetailChartBreakdownData(context, DashboardData.directSale);

          context.read<DashBoardCubit>().getDirectSaleApprovalRatio(context);

          openScreen(salesRevenueDetails,
              args: LinkedHashMap.from({
                "isDirectSale": true,
                "isUpsell": false,
                "image": Assets.imagesDirectSale,
                "title": "Direct Sale",
                "color": Color(0xFFF90182),
              }));
        },
      ),
      CardData(
          circleBgColor: Color(0xFFC237F3),
          title: state.initialSubscriptionData?.result?.firstOrNull?.label ??
              TextHelper.initialSubscription,
          subtitle: getSubtitle(
              state.initialSubscriptionData?.result?.firstOrNull
                      ?.approvedOrders ??
                  0,
              state.initialSubscriptionData?.result?.firstOrNull
                      ?.approvalPercentage ??
                  0),
          image: Assets.imagesInitialSubscription,
          isLoading: state.initialSubscriptionReqState == ProcessState.loading,
          onPress: () {
            context.read<DashBoardCubit>().getDashboardDetailData(
                context, DashboardData.initialSubscription);
            context.read<DashBoardCubit>().getDetailChartBreakdownData(
                context, DashboardData.initialSubscription);
            context.read<DashBoardCubit>().getDetailChartApprovalRatioData(
                context, DashboardData.initialSubscription);
            openScreen(salesRevenueDetails,
                args: LinkedHashMap.from({
                  "isDirectSale": false,
                  "isUpsell": false,
                  "image": Assets.imagesInitialSubscription,
                  "title": TextHelper.initialSubscription,
                  "color": Color(0xFFC237F3)
                }));
          }),
      CardData(
          circleBgColor: Color(0xFF05CD99),
          title: state.recurringSubscriptionData?.result?.firstOrNull?.label ??
              TextHelper.recurringSubscription,
          subtitle: getSubtitle(
              state.recurringSubscriptionData?.result?.firstOrNull
                      ?.approvedOrders ??
                  0,
              state.recurringSubscriptionData?.result?.firstOrNull
                      ?.approvalPercentage ??
                  0),
          image: Assets.imagesRecurringSubscription,
          isLoading:
              state.recurringSubscriptionReqState == ProcessState.loading,
          onPress: () {
            context.read<DashBoardCubit>().getDashboardDetailData(
                context, DashboardData.recurringSubscription);
            context.read<DashBoardCubit>().getDetailChartBreakdownData(
                context, DashboardData.recurringSubscription);
            context.read<DashBoardCubit>().getDetailChartApprovalRatioData(
                context, DashboardData.recurringSubscription);
            openScreen(salesRevenueDetails,
                args: LinkedHashMap.from({
                  "isDirectSale": false,
                  "isUpsell": false,
                  "image": Assets.imagesRecurringSubscription,
                  "title": TextHelper.recurringSubscription,
                  "color": Color(0xFF05CD99)
                }));
          }),
      CardData(
          circleBgColor: Color(0xFF6AD2FF),
          title: state.subscriptionSalvageData?.result?.firstOrNull?.label ??
              TextHelper.subscribersSalvage,
          subtitle: getSubtitle(
              state.subscriptionSalvageData?.result?.firstOrNull
                      ?.approvedOrders ??
                  0,
              state.subscriptionSalvageData?.result?.firstOrNull
                      ?.approvalPercentage ??
                  0),
          // subtitle: getSubtitle(subscriptionSalvage['ApprovedOrders'] ?? 0, subscriptionSalvage['ApprovalPercentage'] ?? 0),
          image: Assets.imagesSubscriptionSalvage,
          isLoading: state.subscriptionSalvageReqState == ProcessState.loading,
          onPress: () {
            context
                .read<DashBoardCubit>()
                .getDashboardDetailData(context, DashboardData.subSalvage);
            context
                .read<DashBoardCubit>()
                .getDetailChartBreakdownData(context, DashboardData.subSalvage);
            context.read<DashBoardCubit>().getDetailChartApprovalRatioData(
                context, DashboardData.subSalvage);
            openScreen(salesRevenueDetails,
                args: LinkedHashMap.from({
                  "isDirectSale": false,
                  "isUpsell": false,
                  "image": Assets.imagesSubscriptionSalvage,
                  "title": TextHelper.subscribersSalvage,
                  "color": Color(0xFF6AD2FF)
                }));
          }),
      CardData(
        circleBgColor: Color(0xFFF36337),
        title:
            state.upsellData?.result?.firstOrNull?.label ?? TextHelper.upsell,
        subtitle: getSubtitle(
            state.upsellData?.result?.firstOrNull?.approvedOrders ?? 0,
            state.upsellData?.result?.firstOrNull?.approvalPercentage ?? 0),
        // subtitle: getSubtitle(upsell['ApprovedOrders'] ?? 0, upsell['ApprovalPercentage'] ?? 0),
        image: Assets.imagesUpsell,
        isLoading: state.upsellReqState == ProcessState.loading,
        onPress: (){
          context
              .read<DashBoardCubit>()
              .getDetailChartBreakdownData(context, DashboardData.upsell);
          openScreen(salesRevenueDetails,
              args: LinkedHashMap.from({
                "isUpsell": true,
                "isDirectSale": false,
                "image": Assets.imagesUpsell,
                "title": "Upsell",
                "color": Color(0xFFF36337),
              }));
        }
      ),
      CardData(
        circleBgColor: Color(0xFFC237F3),
        title: state.subscriptionBillData?.result?.firstOrNull?.label ??
            TextHelper.subscriptionBill,
        subtitle: getSubtitle(
            state.subscriptionBillData?.result?.firstOrNull?.approvedOrders ??
                0,
            state.subscriptionBillData?.result?.firstOrNull
                    ?.approvalPercentage ??
                0),
        // subtitle: getSubtitle(subscriptionBill['ApprovedOrders'] ?? 0, subscriptionBill['ApprovalPercentage'] ?? 0),
        image: Assets.imagesSubscriptionToBill,
        isLoading: state.subscriptionBillReqState == ProcessState.loading,
      ),
    ]);
  }
}

class TransactionDataWidget extends StatelessWidget {
  final DashboardState state;

  const TransactionDataWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.padding(context, 2)),
      child: RenderSection(title: getTitle(), cards: [
        CardData(
          circleBgColor: Color(0xFFC237F3),
          title: TextHelper.totalTransactions,
          subtitle: double.parse(
                      state.totalTransactionData?.result?.totalTransactions ??
                          "0") >
                  0
              ? formatNumber(double.parse(
                  state.totalTransactionData?.result?.totalTransactions ?? "0"))
              : '-',
          image: Assets.imagesTotalTransactions,
          // Replace with actual asset
          isLoading: state.totalTransactionReqState == ProcessState.loading,
        ),
        CardData(
          circleBgColor: Color(0xFFE84040),
          title: TextHelper.refunds,
          subtitle: getSubtitle(
            double.parse(state.refundsData?.result?.refundTotal ?? "0"),
            percentage(
                double.parse(state.refundsData?.result?.refundTotal ?? "0"),
                double.parse(
                    state.totalTransactionData?.result?.totalTransactions ??
                        "0")),
          ),
          image: Assets.imagesRefundRatio,
          isLoading: state.refundsReqState == ProcessState.loading,
        ),
        CardData(
          circleBgColor: Color(0xFFF36337),
          title: TextHelper.chargebacks,
          subtitle: getSubtitle(
            double.parse(state.chargeBacksData?.result?.chargebackTotal ?? "0"),
            percentage(
              double.parse(
                  state.chargeBacksData?.result?.chargebackTotal ?? "0"),
              double.parse(
                  state.totalTransactionData?.result?.totalTransactions ?? "0"),
            ),
          ),
          image: Assets.imagesChargebackRatio,
          isLoading: state.chargeBacksReqState == ProcessState.loading,
        ),
      ]),
    );
  }

  getTitle() {
    if (state.filterPayload?.endDate != null &&
        state.filterPayload?.endDate != null) {
      return adjustDates(state.filterPayload?.startDate ?? "",
              state.filterPayload?.endDate ?? "")
          .monthRange;
    } else {
      return "";
    }
  }
}

class LifeTimeDataWidget extends StatelessWidget {
  final DashboardState state;

  const LifeTimeDataWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.padding(context, 2)),
      child: RenderSection(title: TextHelper.lifetime, cards: [
        CardData(
          circleBgColor: const Color(0xFF05CD99),
          title: TextHelper.activeSubscribers,
          subtitle: formatNumber(
              state.lifeTimeData?.result?.activeSubscriptions ?? 0),
          image: Assets.imagesActiveSubscribers,
          isLoading: state.lifeTimeReqState == ProcessState.loading,
        ),
        CardData(
          circleBgColor: const Color(0xFF6AD2FF),
          title: TextHelper.subscribersInSalvage,
          subtitle: formatNumber(
              state.lifeTimeData?.result?.subscriptionInSalvage ?? 0),

          // subtitle: formatNumber(lifeTimeData?["SubscriptionInSalvage"] ?? 0),
          image: Assets.imagesSubscriptionSalvage,
          isLoading: state.lifeTimeReqState == ProcessState.loading,
        ),
        CardData(
          circleBgColor: const Color(0xFFE84040),
          title: TextHelper.canceledSubscribers,
          subtitle: formatNumber(
              state.lifeTimeData?.result?.cancelledSubscriptions ?? 0),

          // subtitle: formatNumber(lifeTimeData?["CancelledSubscriptions"] ?? 0),
          image: Assets.imagesCanceledSubscribers,
          isLoading: state.lifeTimeReqState == ProcessState.loading,
        ),
      ]),
    );
  }
}
