import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/models/dashboard/dashboard_overview_model.dart';
import 'package:phoenix/models/filter_payload_model.dart';
import 'package:phoenix/models/permission_model.dart';

class DashboardState {
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
      lifeTimeData: lifeTimeData?? this.lifeTimeData,
      lifeTimeReqState: lifeTimeReqState ?? this.lifeTimeReqState
    );
  }
}
