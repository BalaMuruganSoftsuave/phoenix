import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/helper/api/api_helper.dart';
import 'package:phoenix/helper/api/api_service.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/models/dashboard/chargeback_summary_model.dart';
import 'package:phoenix/models/dashboard/coverage_health_data_model.dart';
import 'package:phoenix/models/dashboard/net_subscribers_model.dart';
import 'package:phoenix/models/dashboard/refund_ratio_data_model.dart';
import 'package:phoenix/models/dashboard/sales_revenue_data_model.dart';
import 'package:phoenix/models/filter_payload_model.dart';
import 'package:phoenix/models/line_chart_model.dart';
import 'package:phoenix/widgets/filter_by_day_widget.dart';

import 'dashboard_state.dart';

class DashBoardCubit extends Cubit<DashboardState> {
  DashBoardCubit() : super(DashboardState());
  final ApiService _apiService = ApiService();
  int _tokenRefreshAttempts = 0;
  int _refreshTokenForDirectSale = 0; // Track refresh attempts
  int _refreshTokenForInitialSub = 0; // Track refresh attempts
  int _refreshTokenForRecurringSub = 0; // Track refresh attempts
  int _refreshTokenForSubscriptionSal = 0; // Track refresh attempts
  int _refreshTokenForUpsellData = 0; // Track refresh attempts
  int _refreshTokenForSubscriptionToBill = 0; // Track refresh attempts
  int _refreshTokenForTotalTransaction = 0; // Track refresh attempts
  int _refreshTokenForRefundData = 0; // Track refresh attempts
  int _refreshTokenForChargeBackData = 0; // Track refresh attempts
  int _refreshTokenForLifeTimeData = 0; // Track refresh attempts
  int _refreshTokenForSalesRevenue = 0; // Track refresh attempts
  int _refreshTokenForNetSubscribers = 0; // Track refresh attempts
  int _refreshTokenForCoverageHealth = 0; // Track refresh attempts
  int _refreshTokenForChargeBackSummary = 0; // Track refresh attempts
  int _refreshTokenForRefundRatio = 0; // Track refresh attempts
  int _refreshTokenForDirectSaleDetailData = 0; // Track refresh attempts
  int _refreshTokenForDashboardDetailData = 0; // Track refresh attempts
  int _refreshTokenForDirectSaleRevenueData = 0; // Track refresh attempts
  int _refreshTokenForDirectSaleApprovalRatio = 0; // Track refresh attempts
  int _refreshTokenForDetailChartBreakDown = 0; // Track refresh attempts
  int _refreshTokenForDetailChartApprovalRatio = 0; // Track refresh attempts

  void updateFilter(context,
      {String? startDate,
      String? endDate,
      List<int>? clientList,
      List<int>? storeList}) async {
    if (startDate != null && endDate != null) {
      state.filterPayload ??= FilterPayload();
      var groupBy = getGroupBy(startDate, endDate);
      state.filterPayload?.startDate = startDate;
      state.filterPayload?.endDate = endDate;
      state.filterPayload?.groupBy = groupBy;
    }
    if (clientList != null && storeList != null) {
      state.filterPayload ??= FilterPayload();
      state.filterPayload?.clientIds = clientList;
      state.filterPayload?.storeIds = storeList;
    }
    emit(state.copyWith(filterPayload: state.filterPayload));
    refresh(context);
  }

  refresh(context) {
    getDirectSaleData(context);
    getInitialSubscriptionData(context);
    getRecurringSubscription(context);
    getSubscriptionSalvageData(context);
    getUpsellData(context);
    getSubscriptionToBillData(context);
    getTotalTransactionData(context);
    getRefundsData(context);
    getChargeBacksData(context);
    getLifeTimeData(context);
    getSalesRevenuesData(context);
    getNetSubscribersData(context);
    getCoverageHealthData(context);
    getChargeBackSummaryData(context);
    getRefundRatioData(context);
  }

  void getPermissionsData(BuildContext context) async {
    List<int> clientIDs = [];
    List<int> storeIds = [];

    try {
      emit(state.copyWith(permissionReqState: ProcessState.loading));

      final res = await _apiService.getPermissionsData();

      _tokenRefreshAttempts = 0; // Reset counter on success
      // Collect all client IDs
      if (res?.clientsList != null) {
        clientIDs = res!.clientsList!
            .where((e) => e.clientId != null)
            .map((e) => e.clientId!)
            .toList();
      }

      // Collect store IDs only for matching client IDs
      if (res?.storesList != null) {
        res!.storesList!.forEach((clientId, stores) {
          if (clientIDs.contains(int.tryParse(clientId))) {
            storeIds.addAll(
              stores
                  .where((store) => store.storeId != null)
                  .map((store) => store.storeId!),
            );
          }
        });
      }
      updateFilter(getCtx(context)!,
          startDate: formatter.format(DateTime.now()),
          endDate: formatter.format(DateTime.now()),
          clientList: clientIDs,
          storeList: storeIds);

      emit(state.copyWith(
          permissionReqState: ProcessState.success, permissions: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: getCtx(context)!,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(permissionReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
        final isTokenRefreshed = await getAuthCubit(getCtx(context)!)
                ?.refreshToken(getCtx(context)!) ??
            false;

        if (isTokenRefreshed) {
          return getPermissionsData(
              getCtx(context)!); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: getCtx(context)!,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(permissionReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: getCtx(context)!,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(permissionReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("permission api:  ${e.toString()}");
      CustomToast.show(
          context: getCtx(context)!,
          message: e.toString(),
          status: ToastStatus.failure);
      emit(state.copyWith(permissionReqState: ProcessState.failure));
    }
  }

  void getDirectSaleData(BuildContext context) async {
    try {
      emit(state.copyWith(directSaleReqState: ProcessState.loading));

      final res =
          await _apiService.getDirectSaleData(state.filterPayload?.toJson());

      _refreshTokenForDirectSale = 0; // Reset counter on success
      emit(state.copyWith(
          directSaleReqState: ProcessState.success, directSaleData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForDirectSale >= 2) {
          CustomToast.show(
              context: getCtx(context)!,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(directSaleReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForDirectSale++;
        final isTokenRefreshed = await getAuthCubit(getCtx(context)!)
                ?.refreshToken(getCtx(context)!) ??
            false;

        if (isTokenRefreshed) {
          return getDirectSaleData(
              getCtx(context)!); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: getCtx(context)!,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(directSaleReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: getCtx(context)!,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(directSaleReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("directSale api:  ${e.toString()}");
      CustomToast.show(
          context: getCtx(context)!,
          message: e.toString(),
          status: ToastStatus.failure);
      emit(state.copyWith(directSaleReqState: ProcessState.failure));
    }
  }

  void getInitialSubscriptionData(BuildContext context) async {
    try {
      emit(state.copyWith(initialSubscriptionReqState: ProcessState.loading));

      final res = await _apiService
          .getInitialSubscriptionData(state.filterPayload?.toJson());

      _refreshTokenForInitialSub = 0; // Reset counter on success
      emit(state.copyWith(
          initialSubscriptionReqState: ProcessState.success,
          initialSubscriptionData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForInitialSub >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(
              initialSubscriptionReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForInitialSub++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getInitialSubscriptionData(
              context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(
              initialSubscriptionReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(initialSubscriptionReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("getInitialSubscriptionData:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(initialSubscriptionReqState: ProcessState.failure));
    }
  }

  void getRecurringSubscription(BuildContext context) async {
    try {
      emit(state.copyWith(recurringSubscriptionReqState: ProcessState.loading));

      final res =
          await _apiService.getRecurringData(state.filterPayload?.toJson());

      _refreshTokenForRecurringSub = 0; // Reset counter on success
      emit(state.copyWith(
          recurringSubscriptionReqState: ProcessState.success,
          recurringSubscriptionData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForRecurringSub >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(
              recurringSubscriptionReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForRecurringSub++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getRecurringSubscription(
              context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(
              recurringSubscriptionReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(
            recurringSubscriptionReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("getRecurringSubscription api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(recurringSubscriptionReqState: ProcessState.failure));
    }
  }

  void getSubscriptionSalvageData(BuildContext context) async {
    try {
      emit(state.copyWith(subscriptionSalvageReqState: ProcessState.loading));

      final res = await _apiService
          .getSubscriptionSalvageData(state.filterPayload?.toJson());

      _refreshTokenForSubscriptionSal = 0; // Reset counter on success
      emit(state.copyWith(
          subscriptionSalvageReqState: ProcessState.success,
          subscriptionSalvageData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForSubscriptionSal >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(
              subscriptionSalvageReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForSubscriptionSal++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getSubscriptionSalvageData(
              context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(
              subscriptionSalvageReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(subscriptionSalvageReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("subscriptionSalvageReqState api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(subscriptionSalvageReqState: ProcessState.failure));
    }
  }

  void getUpsellData(BuildContext context) async {
    try {
      emit(state.copyWith(upsellReqState: ProcessState.loading));

      final res =
          await _apiService.getUpsellData(state.filterPayload?.toJson());

      _refreshTokenForUpsellData = 0; // Reset counter on success
      emit(state.copyWith(
          upsellReqState: ProcessState.success, upsellData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForUpsellData >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(upsellReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForUpsellData++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getUpsellData(context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(upsellReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(upsellReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("getUpsellData api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(upsellReqState: ProcessState.failure));
    }
  }

  void getSubscriptionToBillData(BuildContext context) async {
    try {
      emit(state.copyWith(subscriptionBillReqState: ProcessState.loading));

      final res = await _apiService
          .getSubscriptionBillData(state.filterPayload?.toJson());

      _refreshTokenForSubscriptionToBill = 0; // Reset counter on success
      emit(state.copyWith(
          subscriptionBillReqState: ProcessState.success,
          subscriptionBillData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForSubscriptionToBill >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(subscriptionBillReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForSubscriptionToBill++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getSubscriptionToBillData(
              context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(subscriptionBillReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(subscriptionBillReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("getSubscriptionToBillData api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(subscriptionBillReqState: ProcessState.failure));
    }
  }

  void getTotalTransactionData(BuildContext context) async {
    var dates = adjustDates(state.filterPayload?.startDate ?? "",
        state.filterPayload?.endDate ?? "");
    // Create a new payload object with updated dates
    var newPayload = state.filterPayload != null
        ? FilterPayload(
            startDate: dates.adjustedStartDate,
            endDate: dates.adjustedEndDate,
            // Copy other properties from the existing filterPayload
            clientIds: state.filterPayload!.clientIds,
            storeIds: state.filterPayload!.storeIds,
            groupBy: state.filterPayload!.groupBy,
            // Add more properties as needed
          )
        : null;
    try {
      emit(state.copyWith(totalTransactionReqState: ProcessState.loading));

      final res =
          await _apiService.getTotalTransactionsData(newPayload?.toJson());

      _refreshTokenForTotalTransaction = 0; // Reset counter on success
      emit(state.copyWith(
          totalTransactionReqState: ProcessState.success,
          totalTransactionData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForTotalTransaction >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(totalTransactionReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForTotalTransaction++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getTotalTransactionData(
              context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(totalTransactionReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(totalTransactionReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("totalTransaction api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(totalTransactionReqState: ProcessState.failure));
    }
  }

  void getRefundsData(BuildContext context) async {
    var dates = adjustDates(state.filterPayload?.startDate ?? "",
        state.filterPayload?.endDate ?? "");
    // Create a new payload object with updated dates
    var newPayload = state.filterPayload != null
        ? FilterPayload(
            startDate: dates.adjustedStartDate,
            endDate: dates.adjustedEndDate,
            // Copy other properties from the existing filterPayload
            clientIds: state.filterPayload!.clientIds,
            storeIds: state.filterPayload!.storeIds,
            groupBy: state.filterPayload!.groupBy,
            // Add more properties as needed
          )
        : null;
    try {
      emit(state.copyWith(refundsReqState: ProcessState.loading));

      final res =
          await _apiService.getRefundTransactionsData(newPayload?.toJson());

      _refreshTokenForRefundData = 0; // Reset counter on success
      emit(state.copyWith(
          refundsReqState: ProcessState.success, refundsData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForRefundData >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(refundsReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForRefundData++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getRefundsData(context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(refundsReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(refundsReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("refunds api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(refundsReqState: ProcessState.failure));
    }
  }

  void getChargeBacksData(BuildContext context) async {
    var dates = adjustDates(state.filterPayload?.startDate ?? "",
        state.filterPayload?.endDate ?? "");
    // Create a new payload object with updated dates
    var newPayload = state.filterPayload != null
        ? FilterPayload(
            startDate: dates.adjustedStartDate,
            endDate: dates.adjustedEndDate,
            // Copy other properties from the existing filterPayload
            clientIds: state.filterPayload!.clientIds,
            storeIds: state.filterPayload!.storeIds,
            groupBy: state.filterPayload!.groupBy,
            // Add more properties as needed
          )
        : null;
    try {
      emit(state.copyWith(chargeBacksReqState: ProcessState.loading));

      final res =
          await _apiService.getChargebackTransactionsData(newPayload?.toJson());

      _refreshTokenForChargeBackData = 0; // Reset counter on success
      emit(state.copyWith(
          chargeBacksReqState: ProcessState.success, chargeBacksData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForChargeBackData >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(chargeBacksReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForChargeBackData++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getChargeBacksData(
              context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(chargeBacksReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(chargeBacksReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("chargeBacks api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(chargeBacksReqState: ProcessState.failure));
    }
  }

  void getLifeTimeData(BuildContext context) async {
    try {
      emit(state.copyWith(lifeTimeReqState: ProcessState.loading));

      final res =
          await _apiService.getLifeTimeData(state.filterPayload?.toJson());

      _refreshTokenForLifeTimeData = 0; // Reset counter on success
      emit(state.copyWith(
          lifeTimeReqState: ProcessState.success, lifeTimeData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForLifeTimeData >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(lifeTimeReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForLifeTimeData++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getLifeTimeData(context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(lifeTimeReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(lifeTimeReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("lifeTimeReqState api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(lifeTimeReqState: ProcessState.failure));
    }
  }

  void getSalesRevenuesData(BuildContext context) async {
    try {
      emit(state.copyWith(
        totalSalesRevenueReqState: ProcessState.loading,
        totalSalesRevenueData: SalesRevenueDataResponse(result: []),
      ));

      final res =
          await _apiService.getSalesRevenueData(state.filterPayload?.toJson());

      _refreshTokenForSalesRevenue = 0; // Reset counter on success
      if(state.filterPayload?.groupBy=="hour") {
        var data = generateSlots<Map<String, dynamic>>(
          start: state.filterPayload?.startDate ?? "",
          end: state.filterPayload?.endDate ?? "",
          // existingData: data1,
          existingData: res?.result?.map((e) => e.toJson()).toList() ?? [],
          defaultValues: {
            'Range': '',
            'DirectSale': 0,
            'UpsellSale': 0,
            'InitialSale': 0,
            'RecurringSale': 0,
            'SalvageSale': 0
          },
          groupBy: state.filterPayload?.groupBy ?? "",
          getRange: (data) => data["Range"] ?? "",
        );
        state.totalSalesRevenueData?.result
            ?.addAll(data.map((e) => SalesData.fromJson(e)).toList());
      }
      emit(state.copyWith(
          totalSalesRevenueReqState: ProcessState.success,
          totalSalesRevenueData: state.filterPayload?.groupBy == "hour"
              ? state.totalSalesRevenueData
              : res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForSalesRevenue >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(totalSalesRevenueReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForSalesRevenue++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getSalesRevenuesData(
              context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(totalSalesRevenueReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(totalSalesRevenueReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("totalSalesRevenue api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(totalSalesRevenueReqState: ProcessState.failure));
    }
  }

  void getNetSubscribersData(BuildContext context) async {
    try {
      emit(state.copyWith(
          netSubscribersReqState: ProcessState.loading,
          netSubscribersData: NetSubscribersDataResponse(result: [])));

      final res =
          await _apiService.getNetSubscriberData(state.filterPayload?.toJson());

      _refreshTokenForNetSubscribers = 0; // Reset counter on success
      if(state.filterPayload?.groupBy=="hour") {
        var data = generateSlots<Map<String, dynamic>>(
          start: state.filterPayload?.startDate ?? "",
          end: state.filterPayload?.endDate ?? "",
          // existingData: data1,
          existingData: res?.result?.map((e) => e.toJson()).toList() ?? [],
          defaultValues: {
            'Range': '',
            'NewSubscriptions': 0,
            'CancelledSubscriptions': 0,
            'NetSubscriptions': 0,
          },
          groupBy: state.filterPayload?.groupBy ?? "",
          getRange: (data) => data["Range"] ?? "",
        );
        state.netSubscribersData?.result
            ?.addAll(data.map((e) => SubscriptionData.fromJson(e)).toList());
      }
      emit(state.copyWith(
          netSubscribersReqState: ProcessState.success,
          netSubscribersData: state.filterPayload?.groupBy == "hour"
              ? state.netSubscribersData
              : res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForNetSubscribers >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(netSubscribersReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForNetSubscribers++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getNetSubscribersData(
              context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(netSubscribersReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(netSubscribersReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("netSubscribers api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(netSubscribersReqState: ProcessState.failure));
    }
  }

  void getChargeBackSummaryData(BuildContext context) async {
    try {
      emit(state.copyWith(chargeBackSummaryReqState: ProcessState.loading));

      final res = await _apiService
          .getChargebackSummaryData(state.filterPayload?.toJson());

      _refreshTokenForCoverageHealth = 0; // Reset counter on success
      emit(state.copyWith(
          chargeBackSummaryReqState: ProcessState.success,
          chargeBackSummaryData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForCoverageHealth >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(
              chargeBackSummaryReqState: ProcessState.success,
              chargeBackSummaryData: ChargeBackSummaryDataResponse()));
          return;
        }
        _refreshTokenForCoverageHealth++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getChargeBackSummaryData(
              context); // Rery fetching data after refresh
        } else {
          // CustomToast.show(
          //     context: context,
          //     message: "Session Expired",
          //     status: ToastStatus.failure);
          emit(state.copyWith(
              chargeBackSummaryReqState: ProcessState.success,
              chargeBackSummaryData: ChargeBackSummaryDataResponse()));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(
            chargeBackSummaryReqState: ProcessState.success,
            chargeBackSummaryData: ChargeBackSummaryDataResponse()));
      }
    } catch (e) {
      debugLog("chargeback summary api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(
          chargeBackSummaryReqState: ProcessState.success,
          chargeBackSummaryData: ChargeBackSummaryDataResponse()));
    }
  }

  void getCoverageHealthData(BuildContext context) async {
    try {
      emit(state.copyWith(coverageHealthDataReqState: ProcessState.loading));

      final res = await _apiService
          .getCoverageHealthData(state.filterPayload?.toJson());

      _refreshTokenForChargeBackSummary = 0; // Reset counter on success
      emit(state.copyWith(
          coverageHealthDataReqState: ProcessState.success,
          coverageHealthDataData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForChargeBackSummary >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(
              coverageHealthDataReqState: ProcessState.failure,
              coverageHealthDataData: CoverageHealthDataResponse()));
          return;
        }
        _refreshTokenForChargeBackSummary++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getCoverageHealthData(
              context); // Retry fetching data after refresh
        } else {
          // CustomToast.show(
          //     context: context,
          //     message: "Session Expired",
          //     status: ToastStatus.failure);
          emit(state.copyWith(
              coverageHealthDataReqState: ProcessState.failure,
              coverageHealthDataData: CoverageHealthDataResponse()));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(
            coverageHealthDataReqState: ProcessState.failure,
            coverageHealthDataData: CoverageHealthDataResponse()));
      }
    } catch (e) {
      debugLog("coverageHealthDataReqState api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(
          coverageHealthDataReqState: ProcessState.failure,
          coverageHealthDataData: CoverageHealthDataResponse()));
    }
  }

  void getRefundRatioData(BuildContext context) async {
    var adjustDates = adjustStartEndDateRefund(
        state.filterPayload?.startDate ?? "",
        state.filterPayload?.endDate ?? "");
    var newPayload = state.filterPayload != null
        ? FilterPayload(
            startDate: adjustDates.startDate,
            endDate: adjustDates.endDate,
            // Copy other properties from the existing filterPayload
            clientIds: state.filterPayload!.clientIds,
            storeIds: state.filterPayload!.storeIds,
            groupBy: adjustDates.groupBy,
            // Add more properties as needed
          )
        : null;
    try {
      emit(state.copyWith(refundRatioReqState: ProcessState.loading));

      final res = await _apiService.getRefundRatioData(newPayload?.toJson());

      _refreshTokenForRefundRatio = 0; // Reset counter on success
      emit(state.copyWith(
          refundRatioReqState: ProcessState.success, refundRatioData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForRefundRatio >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(
              refundRatioReqState: ProcessState.failure,
              refundRatioData: RefundRatioDataResponse()));
          return;
        }
        _refreshTokenForRefundRatio++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getRefundRatioData(
              context); // Retry fetching data after refresh
        } else {
          // CustomToast.show(
          //     context: context,
          //     message: "Session Expired",
          //     status: ToastStatus.failure);
          emit(state.copyWith(
              refundRatioReqState: ProcessState.failure,
              refundRatioData: RefundRatioDataResponse()));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(
            refundRatioReqState: ProcessState.failure,
            refundRatioData: RefundRatioDataResponse()));
      }
    } catch (e) {
      debugLog("RefundRatioData api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(
          refundRatioReqState: ProcessState.failure,
          refundRatioData: RefundRatioDataResponse()));
    }
  }

  ///Detail Screen api
  void getDirectSaleDetailData(BuildContext context) async {
    try {
      emit(state.copyWith(dashboardDetailReqState: ProcessState.loading));

      final res = await _apiService
          .getDirectSaleDetailData(state.filterPayload?.toJson());
      _refreshTokenForDirectSaleDetailData = 0; // Reset counter on success
      emit(state.copyWith(
          dashboardDetailReqState: ProcessState.success,
          directSaleDetailData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForDirectSaleDetailData >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(dashboardDetailReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForDirectSaleDetailData++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getDirectSaleDetailData(
              context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(dashboardDetailReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(dashboardDetailReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("Direct Sale api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(dashboardDetailReqState: ProcessState.failure));
    }
  }

  void getDashboardDetailData(BuildContext context, DashboardData fromWhere) async {
    try {
      emit(state.copyWith(dashboardDetailReqState: ProcessState.loading));

      final res = fromWhere == DashboardData.initialSubscription
          ? await _apiService
              .getInitialSubscriptionDetailData(state.filterPayload?.toJson())
          : fromWhere == DashboardData.recurringSubscription
          ? await _apiService.getRecurringSubscriptionDetailData(
          state.filterPayload?.toJson())
          : await _apiService.getSubscriptionSalvageDetailData(
          state.filterPayload?.toJson());
      _refreshTokenForDashboardDetailData = 0; // Reset counter on success
      emit(state.copyWith(
          dashboardDetailReqState: ProcessState.success,
          dashboardDetailData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForDashboardDetailData >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(dashboardDetailReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForDashboardDetailData++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getDashboardDetailData(
              context, fromWhere); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(dashboardDetailReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(dashboardDetailReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("$fromWhere api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(dashboardDetailReqState: ProcessState.failure));
    }
  }

  void getDirectSaleRevenueData(BuildContext context) async {
    try {
      emit(state.copyWith(dashboardRevenueReqState: ProcessState.loading));

      final res = await _apiService
          .getDirectSaleRevenueData(state.filterPayload?.toJson());
      _refreshTokenForDirectSaleRevenueData = 0; // Reset counter on success
      emit(state.copyWith(
          dashboardRevenueReqState: ProcessState.success,
          directSaleRevenueData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForDirectSaleRevenueData >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(dashboardRevenueReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForDirectSaleRevenueData++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getDirectSaleRevenueData(
              context); // Retry fetching data after refresh
        } else {
          emit(state.copyWith(dashboardRevenueReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(dashboardRevenueReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("Direct Sale Revenue api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(dashboardRevenueReqState: ProcessState.failure));
    }
  }

  void getDirectSaleApprovalRatio(BuildContext context) async {
    try {
      emit(state.copyWith(dashboardAppRatioReqState: ProcessState.loading));

      final res = await _apiService
          .getDirectSaleApprovalRatioData(state.filterPayload?.toJson());
      _refreshTokenForDirectSaleApprovalRatio = 0; // Reset counter on success
      emit(state.copyWith(
          dashboardAppRatioReqState: ProcessState.success,
          directSaleAppRatioData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForDirectSaleApprovalRatio >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(dashboardAppRatioReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForDirectSaleApprovalRatio++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getDirectSaleApprovalRatio(
              context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(dashboardAppRatioReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(dashboardAppRatioReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("Direct Sale Approval api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(dashboardAppRatioReqState: ProcessState.failure));
    }
  }

  void getDetailChartBreakdownData(BuildContext context, DashboardData fromWhere) async {
    try {
      emit(state.copyWith(dashboardRevenueReqState: ProcessState.loading));

      final res = fromWhere == DashboardData.initialSubscription
          ? await _apiService.getInitialSubscriptionDeclinedBreakdown(
              state.filterPayload?.toJson())
          : fromWhere == DashboardData.recurringSubscription
          ? await _apiService.getRecurringSubscriptionDeclinedBreakdown(
          state.filterPayload?.toJson())
          : await _apiService.getSubscriptionSalvageDeclinedBreakdown(
          state.filterPayload?.toJson());
      _refreshTokenForDetailChartBreakDown = 0; // Reset counter on success
      emit(state.copyWith(
          dashboardRevenueReqState: ProcessState.success,
          detailChartDeclinedBreakDownData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForDetailChartBreakDown >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(dashboardRevenueReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForDetailChartBreakDown++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getDetailChartBreakdownData(
              context, fromWhere); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(dashboardRevenueReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(dashboardRevenueReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("$fromWhere api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(dashboardRevenueReqState: ProcessState.failure));
    }
  }

  void getDetailChartApprovalRatioData(BuildContext context, DashboardData fromWhere) async {
    try {
      emit(state.copyWith(dashboardAppRatioReqState: ProcessState.loading));

      final res = fromWhere == DashboardData.initialSubscription
          ? await _apiService.getInitialSubscriptionApprovalRatio(
              state.filterPayload?.toJson())
          : fromWhere == DashboardData.recurringSubscription
          ? await _apiService.getRecurringSubscriptionApprovalRatio(
          state.filterPayload?.toJson())
          : await _apiService.getSubscriptionSalvageApprovalRatio(
          state.filterPayload?.toJson());
      _refreshTokenForDetailChartApprovalRatio = 0; // Reset counter on success
      emit(state.copyWith(
          dashboardAppRatioReqState: ProcessState.success,
          detailChartAppRatioData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_refreshTokenForDetailChartApprovalRatio >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(dashboardAppRatioReqState: ProcessState.failure));
          return;
        }
        _refreshTokenForDetailChartApprovalRatio++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getDetailChartApprovalRatioData(
              context, fromWhere); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(dashboardAppRatioReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(dashboardAppRatioReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("$fromWhere api:  ${e.toString()}");
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(dashboardAppRatioReqState: ProcessState.failure));
    }
  }

  logout() {
    emit(DashboardState());
  }
}
