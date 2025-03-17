import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/cubit/notification/notification_state.dart';
import 'package:phoenix/helper/api/api_helper.dart';
import 'package:phoenix/helper/api/api_service.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/models/notification/notification_list_model.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState());
  final ApiService _apiService = ApiService();
  int _tokenRefreshAttempts = 0; // Track refresh attempts

  Future<bool> getNotificationConfiguration(BuildContext context) async {
    try {
      emit(state.copyWith(getNotificationReqState: ProcessState.loading));

      final res = await _apiService.getNotificationConfiguration();

      _tokenRefreshAttempts = 0;
      emit(state.copyWith(
          getNotificationReqState: ProcessState.success,
          notificationConfiguration: res));
      return true;
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: getCtx()!,
              message: TextHelper.sessionExpired,
              status: ToastStatus.failure);
          emit(state.copyWith(getNotificationReqState: ProcessState.failure));
          return false;
        }
        _tokenRefreshAttempts++;
        final isTokenRefreshed =
            await getAuthCubit(getCtx()!)?.refreshToken(getCtx()!) ?? false;

        if (isTokenRefreshed) {
          var res = getNotificationConfiguration(getCtx()!);
          return res; // Retry fetching data after refresh
        } else {
          emit(state.copyWith(getNotificationReqState: ProcessState.failure));
          return false;
        }
      } else {
        CustomToast.show(
            context: getCtx()!,
            message: e.message.toString(),
            status: ToastStatus.failure);
        emit(state.copyWith(getNotificationReqState: ProcessState.failure));
        return false;
      }
    } catch (e) {
      debugLog("getNotification api:  ${e.toString()}");
      CustomToast.show(
          context: getCtx()!,
          message: e.toString(),
          status: ToastStatus.failure);
      emit(state.copyWith(getNotificationReqState: ProcessState.failure));
      return false;
    }
  }

  Future<void> setNotificationConfiguration(BuildContext context, body) async {
    try {
      emit(state.copyWith(setNotificationReqState: ProcessState.loading));
      /// ???
      final res = await _apiService.setNotificationConfiguration(body);
      _tokenRefreshAttempts = 0; // Reset counter on success
      emit(state.copyWith(
        setNotificationReqState: ProcessState.success,
      ));
      Future.delayed(Duration(seconds: 1), () {
        CustomToast.show(
            context: getCtx()!,
            message: TextHelper.updatedSuccessfully,
            status: ToastStatus.success);
      });
    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          CustomToast.show(
              context: getCtx()!,
              message: TextHelper.sessionExpired,
              status: ToastStatus.failure);
          emit(state.copyWith(setNotificationReqState: ProcessState.failure));
          return;
        }
        _tokenRefreshAttempts++;
        final isTokenRefreshed =
            await getAuthCubit(getCtx()!)?.refreshToken(getCtx()!) ?? false;

        if (isTokenRefreshed) {
          return setNotificationConfiguration(
              getCtx()!, body); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: getCtx()!,
              message: TextHelper.sessionExpired,
              status: ToastStatus.failure);
          emit(state.copyWith(setNotificationReqState: ProcessState.failure));
        }
      } else {
        Future.delayed(Duration(seconds: 1), () {
          CustomToast.show(
              context: getCtx()!,
              message: e.message.toString(),
              status: ToastStatus.failure);
        });

        emit(state.copyWith(setNotificationReqState: ProcessState.failure));
      }
    } catch (e) {
      debugLog("setNotificationReqState api:  ${e.toString()}");
      Future.delayed(Duration(seconds: 1), () {
        CustomToast.show(
            context: getCtx()!,
            message: e.toString(),
            status: ToastStatus.failure);
      });
      emit(state.copyWith(setNotificationReqState: ProcessState.failure));
    }
  }

  Future<NotificationListResponse?> getNotificationList(BuildContext context, page) async {
    try {

      final res = await _apiService.getNotificationList(page);
      _tokenRefreshAttempts = 0; // Reset counter on success
  return res;

    } on ApiFailure catch (e) {
      if (e.code == 401) {
        if (_tokenRefreshAttempts >= 2) {
          return null;
        }
        _tokenRefreshAttempts++;
        final isTokenRefreshed =
            await getAuthCubit(getCtx()!)?.refreshToken(getCtx()!) ?? false;

        if (isTokenRefreshed) {
          return getNotificationList(
              getCtx()!, page); // Retry fetching data after refresh
        } else {
          CustomToast.show(
              context: getCtx()!,
              message: TextHelper.sessionExpired,
              status: ToastStatus.failure);
        }
      } else {
        Future.delayed(Duration(seconds: 1), () {
          CustomToast.show(
              context: getCtx()!,
              message: e.message.toString(),
              status: ToastStatus.failure);
        });

      }
    } catch (e) {
      debugLog("get notification list api:  ${e.toString()}");
      Future.delayed(Duration(seconds: 1), () {
        CustomToast.show(
            context: getCtx()!,
            message: e.toString(),
            status: ToastStatus.failure);
      });
    }
    return null;
  }
  logout() {
    emit(NotificationState());
  }
}
