import 'package:flutter/material.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/models/dashboard/chargeback_summary_model.dart';
import 'package:phoenix/models/dashboard/coverage_health_data_model.dart';
import 'package:phoenix/models/dashboard/dashboard_detail_data_model.dart';
import 'package:phoenix/models/dashboard/dashboard_overview_model.dart';
import 'package:phoenix/models/dashboard/detail_chart_data_model.dart';
import 'package:phoenix/models/dashboard/direct_sale_data_model.dart';
import 'package:phoenix/models/dashboard/net_subscribers_model.dart';
import 'package:phoenix/models/dashboard/refund_ratio_data_model.dart';
import 'package:phoenix/models/dashboard/sales_revenue_data_model.dart';
import 'package:phoenix/models/filter_payload_model.dart';
import 'package:phoenix/models/permission_model.dart';

class DashboardState {
  String? selectedKey;

  DateTimeRange? selectedRange;
  DateTimeRange? selectedCustomRange;
  FilterPayload? filterPayload;
  PermissionResponse? permissions;
  ProcessState? permissionReqState;
  DashBoardOverViewResponse? directSaleData;
  ProcessState? directSaleReqState;
  DashBoardOverViewResponse? initialSubscriptionData;
  ProcessState? initialSubscriptionReqState;
  DashBoardOverViewResponse? recurringSubscriptionData;
  ProcessState? recurringSubscriptionReqState;
  DashBoardOverViewResponse? subscriptionSalvageData;
  ProcessState? subscriptionSalvageReqState;
  DashBoardOverViewResponse? upsellData;
  ProcessState? upsellReqState;
  DashBoardOverViewResponse? subscriptionBillData;
  ProcessState? subscriptionBillReqState;
  DashBoardSecondData? totalTransactionData;
  ProcessState? totalTransactionReqState;
  DashBoardSecondData? refundsData;
  ProcessState? refundsReqState;
  DashBoardSecondData? chargeBacksData;
  ProcessState? chargeBacksReqState;
  LifeTimeDataResponse? lifeTimeData;
  ProcessState? lifeTimeReqState;
  SalesRevenueDataResponse? totalSalesRevenueData;
  ProcessState? totalSalesRevenueReqState;
  NetSubscribersDataResponse? netSubscribersData;
  ProcessState? netSubscribersReqState;
  CoverageHealthDataResponse? coverageHealthDataData;
  ProcessState? coverageHealthDataReqState;
  ChargeBackSummaryDataResponse? chargeBackSummaryData;
  ProcessState? chargeBackSummaryReqState;
  RefundRatioDataResponse? refundRatioData;
  ProcessState? refundRatioReqState;
  ProcessState? dashboardDetailReqState;
  ProcessState? dashboardRevenueReqState;
  ProcessState? dashboardAppRatioReqState;
  DirectSaleDataResponse? directSaleDetailData;
  DashboardDetailDataResponse? dashboardDetailData;
  DirectSaleRevenueDataResponse? directSaleRevenueData;
  DtSaleAppRatioDataResponse? directSaleAppRatioData;
  DetailChartDeclinedBreakDownDataResponse? detailChartDeclinedBreakDownData;
  DetailChartApprovalRatioDataResponse? detailChartAppRatioData;

  DashboardState({
    this.filterPayload,
    this.permissions,
    this.permissionReqState = ProcessState.none,
    this.chargeBacksData,
    this.chargeBacksReqState = ProcessState.none,
    this.directSaleData,
    this.directSaleReqState = ProcessState.none,
    this.initialSubscriptionData,
    this.initialSubscriptionReqState = ProcessState.none,
    this.lifeTimeData,
    this.lifeTimeReqState = ProcessState.none,
    this.recurringSubscriptionData,
    this.recurringSubscriptionReqState = ProcessState.none,
    this.refundsData,
    this.refundsReqState = ProcessState.none,
    this.subscriptionBillData,
    this.subscriptionBillReqState = ProcessState.none,
    this.subscriptionSalvageData,
    this.subscriptionSalvageReqState = ProcessState.none,
    this.totalTransactionData,
    this.totalTransactionReqState = ProcessState.none,
    this.upsellData,
    this.upsellReqState = ProcessState.none,
    this.totalSalesRevenueData,
    this.totalSalesRevenueReqState = ProcessState.none,
    this.netSubscribersData,
    this.netSubscribersReqState = ProcessState.none,
    this.chargeBackSummaryData,
    this.chargeBackSummaryReqState = ProcessState.none,
    this.coverageHealthDataData,
    this.coverageHealthDataReqState = ProcessState.none,
    this.refundRatioData,
    this.refundRatioReqState = ProcessState.none,
    this.dashboardDetailReqState = ProcessState.none,
    this.dashboardDetailData,
    this.directSaleDetailData,
    this.directSaleRevenueData,
    this.directSaleAppRatioData,
    this.detailChartAppRatioData,
    this.detailChartDeclinedBreakDownData,
    this.dashboardAppRatioReqState = ProcessState.none,
    this.dashboardRevenueReqState = ProcessState.none,
    this.selectedCustomRange,
    this.selectedKey = "today",
    this.selectedRange,
  });

  DashboardState copyWith({
    FilterPayload? filterPayload,
    PermissionResponse? permissions,
    ProcessState? permissionReqState,
    DashBoardOverViewResponse? directSaleData,
    ProcessState? directSaleReqState,
    DashBoardOverViewResponse? initialSubscriptionData,
    ProcessState? initialSubscriptionReqState,
    DashBoardOverViewResponse? recurringSubscriptionData,
    ProcessState? recurringSubscriptionReqState,
    DashBoardOverViewResponse? subscriptionSalvageData,
    ProcessState? subscriptionSalvageReqState,
    DashBoardOverViewResponse? upsellData,
    ProcessState? upsellReqState,
    DashBoardOverViewResponse? subscriptionBillData,
    ProcessState? subscriptionBillReqState,
    DashBoardSecondData? totalTransactionData,
    ProcessState? totalTransactionReqState,
    DashBoardSecondData? refundsData,
    ProcessState? refundsReqState,
    DashBoardSecondData? chargeBacksData,
    ProcessState? chargeBacksReqState,
    LifeTimeDataResponse? lifeTimeData,
    ProcessState? lifeTimeReqState,
    SalesRevenueDataResponse? totalSalesRevenueData,
    ProcessState? totalSalesRevenueReqState,
    NetSubscribersDataResponse? netSubscribersData,
    ProcessState? netSubscribersReqState,
    CoverageHealthDataResponse? coverageHealthDataData,
    ProcessState? coverageHealthDataReqState,
    ChargeBackSummaryDataResponse? chargeBackSummaryData,
    ProcessState? chargeBackSummaryReqState,
    RefundRatioDataResponse? refundRatioData,
    ProcessState? refundRatioReqState,
    ProcessState? dashboardDetailReqState,
    DirectSaleDataResponse? directSaleDetailData,
    DashboardDetailDataResponse? dashboardDetailData,
    DirectSaleRevenueDataResponse? directSaleRevenueData,
    DtSaleAppRatioDataResponse? directSaleAppRatioData,
    DetailChartDeclinedBreakDownDataResponse? detailChartDeclinedBreakDownData,
    DetailChartApprovalRatioDataResponse? detailChartAppRatioData,
    ProcessState? dashboardAppRatioReqState,
    ProcessState? dashboardRevenueReqState,
    String? selectedKey,
    DateTimeRange? selectedRange,
    DateTimeRange? selectedCustomRange,
  }) {
    return DashboardState(
        filterPayload: filterPayload ?? this.filterPayload,
        permissions: permissions ?? this.permissions,
        permissionReqState: permissionReqState ?? this.permissionReqState,
        directSaleData: directSaleData ?? this.directSaleData,
        directSaleReqState: directSaleReqState ?? this.directSaleReqState,
        initialSubscriptionData:
            initialSubscriptionData ?? this.initialSubscriptionData,
        initialSubscriptionReqState:
            initialSubscriptionReqState ?? this.initialSubscriptionReqState,
        recurringSubscriptionData:
            recurringSubscriptionData ?? this.recurringSubscriptionData,
        recurringSubscriptionReqState:
            recurringSubscriptionReqState ?? this.recurringSubscriptionReqState,
        subscriptionSalvageData:
            subscriptionSalvageData ?? this.subscriptionSalvageData,
        subscriptionSalvageReqState:
            subscriptionSalvageReqState ?? this.subscriptionSalvageReqState,
        subscriptionBillData: subscriptionBillData ?? this.subscriptionBillData,
        subscriptionBillReqState:
            subscriptionBillReqState ?? this.subscriptionBillReqState,
        upsellData: upsellData ?? this.upsellData,
        upsellReqState: upsellReqState ?? this.upsellReqState,
        totalTransactionData: totalTransactionData ?? this.totalTransactionData,
        totalTransactionReqState:
            totalTransactionReqState ?? this.totalTransactionReqState,
        chargeBacksData: chargeBacksData ?? this.chargeBacksData,
        chargeBacksReqState: chargeBacksReqState ?? this.chargeBacksReqState,
        refundsData: refundsData ?? this.refundsData,
        refundsReqState: refundsReqState ?? this.refundsReqState,
        lifeTimeData: lifeTimeData ?? this.lifeTimeData,
        lifeTimeReqState: lifeTimeReqState ?? this.lifeTimeReqState,
        totalSalesRevenueData:
            totalSalesRevenueData ?? this.totalSalesRevenueData,
        totalSalesRevenueReqState:
            totalSalesRevenueReqState ?? this.totalSalesRevenueReqState,
        netSubscribersData: netSubscribersData ?? this.netSubscribersData,
        netSubscribersReqState:
            netSubscribersReqState ?? this.totalSalesRevenueReqState,
        chargeBackSummaryData:
            chargeBackSummaryData ?? this.chargeBackSummaryData,
        chargeBackSummaryReqState:
            chargeBackSummaryReqState ?? this.chargeBackSummaryReqState,
        coverageHealthDataData:
            coverageHealthDataData ?? this.coverageHealthDataData,
        coverageHealthDataReqState:
            coverageHealthDataReqState ?? this.coverageHealthDataReqState,
        refundRatioData: refundRatioData ?? this.refundRatioData,
        refundRatioReqState: refundRatioReqState ?? this.refundRatioReqState,
        dashboardDetailReqState:
            dashboardDetailReqState ?? this.dashboardDetailReqState,
        directSaleDetailData: directSaleDetailData ?? this.directSaleDetailData,
        dashboardDetailData: dashboardDetailData ?? this.dashboardDetailData,
        directSaleAppRatioData:
            directSaleAppRatioData ?? this.directSaleAppRatioData,
        directSaleRevenueData:
            directSaleRevenueData ?? this.directSaleRevenueData,
        detailChartDeclinedBreakDownData: detailChartDeclinedBreakDownData ??
            this.detailChartDeclinedBreakDownData,
        detailChartAppRatioData:
            detailChartAppRatioData ?? this.detailChartAppRatioData,
        dashboardRevenueReqState:
            dashboardRevenueReqState ?? this.dashboardRevenueReqState,
        dashboardAppRatioReqState:
            dashboardAppRatioReqState ?? this.dashboardAppRatioReqState,
        selectedCustomRange: selectedCustomRange ?? this.selectedCustomRange,
        selectedRange: selectedRange ?? this.selectedRange,
        selectedKey: selectedKey ?? this.selectedKey);
  }
}
