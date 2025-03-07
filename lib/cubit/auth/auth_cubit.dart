import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/helper/api/api_helper.dart';
import 'package:phoenix/helper/api/api_service.dart';
import 'package:phoenix/helper/dialog_helper.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/nav_helper.dart';
import 'package:phoenix/helper/preference_helper.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/models/login_response_model.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());
  final ApiService _apiService = ApiService();

  login(context, String userName, String password) async {
    try {
      emit(state.copyWith(authState: ProcessState.loading));
      LoginResponse? res = await _apiService.login(userName, password);
      await PreferenceHelper.saveInitialLogin();
      await PreferenceHelper.saveAccessToken(res?.accessToken ?? "");
      await PreferenceHelper.saveRefreshToken(res?.refreshToken ?? "");
      await PreferenceHelper.saveUserName(res?.name ?? "");
      emit(state.copyWith(authState: ProcessState.success));
    } on ApiFailure catch (e) {
      CustomToast.show(
          context: context, message: e.message, status: ToastStatus.failure);
      emit(state.copyWith(authState: ProcessState.failure));
      debugLog("Login api issue : \n${e.message.toString()}");
    } catch (e) {
      debugLog("Login api issue: \n${e.toString()}");
    } finally {
      emit(state.copyWith(authState: ProcessState.none));
    }
  }

  refreshToken(context) async {
    try {
      var token = PreferenceHelper.getRefreshToken();
      LoginResponse? res = await _apiService.getRefreshToken(token ?? "");
      await PreferenceHelper.saveAccessToken(res?.accessToken ?? "");
      await PreferenceHelper.saveRefreshToken(res?.refreshToken ?? "");
      return true;
    } on ApiFailure catch (e) {
      CustomToast.show(
          context: getCtx(context)!, message:"Session Expired Please login", status: ToastStatus.failure);
      emit(state.copyWith(authState: ProcessState.failure));
      openScreen(loginScreen);
      debugLog("refreshToken issue : \n${e.message.toString()}");
      return false;
    } catch (e) {
      debugLog("refreshToken issue: \n${e.toString()}");
      return false;
    } finally {}
  }
}
