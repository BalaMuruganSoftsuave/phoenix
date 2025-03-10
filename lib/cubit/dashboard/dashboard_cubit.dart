import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/helper/api/api_helper.dart';
import 'package:phoenix/helper/api/api_service.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/models/filter_payload_model.dart';
import 'package:phoenix/widgets/filter_by_day_widget.dart';

import 'dashboard_state.dart';

class DashBoardCubit extends Cubit<DashboardState> {
  DashBoardCubit() : super(DashboardState());
  final ApiService _apiService = ApiService();
  int _tokenRefreshAttempts = 0; // Track refresh attempts

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

      _tokenRefreshAttempts = 0; // Reset counter on success
      emit(state.copyWith(
          directSaleReqState: ProcessState.success, directSaleData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: getCtx(context)!,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(directSaleReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
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

      _tokenRefreshAttempts = 0; // Reset counter on success
      emit(state.copyWith(
          initialSubscriptionReqState: ProcessState.success,
          initialSubscriptionData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(
              initialSubscriptionReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
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

      _tokenRefreshAttempts = 0; // Reset counter on success
      emit(state.copyWith(
          recurringSubscriptionReqState: ProcessState.success,
          recurringSubscriptionData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(
              recurringSubscriptionReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
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

      _tokenRefreshAttempts = 0; // Reset counter on success
      emit(state.copyWith(
          subscriptionSalvageReqState: ProcessState.success,
          subscriptionSalvageData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(
              subscriptionSalvageReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
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

      _tokenRefreshAttempts = 0; // Reset counter on success
      emit(state.copyWith(
          upsellReqState: ProcessState.success, upsellData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(upsellReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
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

      _tokenRefreshAttempts = 0; // Reset counter on success
      emit(state.copyWith(
          subscriptionBillReqState: ProcessState.success,
          subscriptionBillData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(subscriptionBillReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
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

      _tokenRefreshAttempts = 0; // Reset counter on success
      emit(state.copyWith(
          totalTransactionReqState: ProcessState.success,
          totalTransactionData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(totalTransactionReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
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

      _tokenRefreshAttempts = 0; // Reset counter on success
      emit(state.copyWith(
          refundsReqState: ProcessState.success, refundsData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(refundsReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
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

      _tokenRefreshAttempts = 0; // Reset counter on success
      emit(state.copyWith(
          chargeBacksReqState: ProcessState.success, chargeBacksData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(chargeBacksReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
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

      _tokenRefreshAttempts = 0; // Reset counter on success
      emit(state.copyWith(
          lifeTimeReqState: ProcessState.success, lifeTimeData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(lifeTimeReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
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
      emit(state.copyWith(totalSalesRevenueReqState: ProcessState.loading));

      final res =
      await _apiService.getSalesRevenueData(state.filterPayload?.toJson());

      _tokenRefreshAttempts = 0; // Reset counter on success
      emit(state.copyWith(
          totalSalesRevenueReqState: ProcessState.success, totalSalesRevenueData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(totalSalesRevenueReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getLifeTimeData(context); // Retry fetching data after refresh
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
      emit(state.copyWith(netSubscribersReqState: ProcessState.loading));

      final res =
      await _apiService.getNetSubscriberData(state.filterPayload?.toJson());

      _tokenRefreshAttempts = 0; // Reset counter on success
      emit(state.copyWith(
          netSubscribersReqState: ProcessState.success, netSubscribersData: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(netSubscribersReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getNetSubscribersData(context); // Retry fetching data after refresh
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
}
