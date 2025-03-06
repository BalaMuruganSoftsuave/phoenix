import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/helper/api/api_helper.dart';
import 'package:phoenix/helper/api/api_service.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/models/filter_payload_model.dart';

import 'dashboard_state.dart';

class DashBoardCubit extends Cubit<DashboardState> {
  DashBoardCubit() : super(DashboardState());
  final ApiService _apiService = ApiService();
  int _tokenRefreshAttempts = 0; // Track refresh attempts

  void updateFilter(
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
      var groupBy = getGroupBy(startDate, endDate);
      state.filterPayload?.clientIds = clientList;
      state.filterPayload?.storeIds = storeList;
    }
    emit(state.copyWith(filterPayload: state.filterPayload));
  }

  void getPermissionsData(BuildContext context) async {
    try {
      emit(state.copyWith(permissionReqState: ProcessState.loading));

      final res = await _apiService.getPermissionsData();
      _tokenRefreshAttempts = 0; // Reset counter on success

      emit(state.copyWith(
          permissionReqState: ProcessState.success, permissions: res));
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(permissionReqState: ProcessState.failure));          return;
        }
        final isTokenRefreshed =
            await getAuthCubit(context)?.refreshToken(context) ?? false;

        if (isTokenRefreshed) {
          return getPermissionsData(
              context); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: context,
              message: "Session Expired",
              status: ToastStatus.failure);
          emit(state.copyWith(permissionReqState: ProcessState.failure));
        }
      } else {
        CustomToast.show(
            context: context,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(permissionReqState: ProcessState.failure));
      }
    } catch (e) {
      CustomToast.show(
          context: context, message: e.toString(), status: ToastStatus.failure);
      emit(state.copyWith(permissionReqState: ProcessState.failure));
    }
  }
}
