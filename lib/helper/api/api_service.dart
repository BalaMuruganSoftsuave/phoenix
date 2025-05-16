import 'dart:async';

import 'package:dio/dio.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/preference_helper.dart';
import 'package:phoenix/models/dashboard/chargeback_summary_model.dart';
import 'package:phoenix/models/dashboard/coverage_health_data_model.dart';
import 'package:phoenix/models/dashboard/dashboard_detail_data_model.dart';
import 'package:phoenix/models/dashboard/dashboard_overview_model.dart';
import 'package:phoenix/models/dashboard/detail_chart_data_model.dart';
import 'package:phoenix/models/dashboard/direct_sale_data_model.dart';
import 'package:phoenix/models/dashboard/net_subscribers_model.dart';
import 'package:phoenix/models/dashboard/refund_ratio_data_model.dart';
import 'package:phoenix/models/dashboard/sales_revenue_data_model.dart';
import 'package:phoenix/models/login_response_model.dart';
import 'package:phoenix/models/notification/notification_configuration_model.dart';
import 'package:phoenix/models/notification/notification_list_model.dart';
import 'package:phoenix/models/permission_model.dart';

import 'api_constant.dart';
import 'api_helper.dart';

class ApiService {
  final APIHelper _apiHelper = APIHelper();
  CancelToken? _loginCancelToken;
  CancelToken? _refreshCancelToken;

  /// Login API Call
  Future<LoginResponse?> login(String userName, String password,
      {String? fcm,})
  async {
    _loginCancelToken?.cancel("Cancelled previous login request");

    // Create new token for this request
    _loginCancelToken = CancelToken();
    try {
      final response = await _apiHelper.makeReq(
        ApiConstants.loginUrl,
        {
          "Username": userName,
          "Password": password,
          "DeviceToken": fcm,
        },
        cancelToken: _loginCancelToken
      );
      return LoginResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse?> getRefreshToken(String token)
  async {
    try {
      _refreshCancelToken?.cancel("Cancelled previous refresh request");
    } catch (_) {
      debugLog("Cancelled previous refresh request");
    }
    _refreshCancelToken = CancelToken();
    try {
      final response = await _apiHelper.makeReq(
        ApiConstants.refreshToken,
        {
          "RefreshToken": token,
        },
        cancelToken: _refreshCancelToken
      );
      return LoginResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<PermissionResponse?> getPermissionsData(CancelToken? cancelToken) async {

    var token = PreferenceHelper.getAccessToken();
    try {
      final response = await _apiHelper.makeReq(ApiConstants.getPermissions, {},
          method: Method.get, token: token ?? "",cancelToken: cancelToken);
      return PermissionResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardOverViewResponse?> getDirectSaleData(body,CancelToken? cancelToken) async {

    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getDirectSale, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return DashBoardOverViewResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardOverViewResponse?> getInitialSubscriptionData(body,CancelToken? cancelToken) async {
    var token = PreferenceHelper.getAccessToken();
    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getInitialSubscription, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return DashBoardOverViewResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardOverViewResponse?> getSubscriptionSalvageData(body,CancelToken? cancelToken) async {

    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getSubscriptionSalvage, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return DashBoardOverViewResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardOverViewResponse?> getSubscriptionBillData(body,CancelToken? cancelToken) async {

    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getSubscriptionBill, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return DashBoardOverViewResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardOverViewResponse?> getRecurringData(body,CancelToken? cancelToken) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getRecurringSubscription, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return DashBoardOverViewResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardOverViewResponse?> getUpsellData(body,CancelToken? cancelToken) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(ApiConstants.getUpsell, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return DashBoardOverViewResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardSecondData?> getTotalTransactionsData(body,CancelToken? cancelToken) async {

    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getTotalTransactions, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return DashBoardSecondData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardSecondData?> getRefundTransactionsData(body,CancelToken? cancelToken) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getRefundTransactions, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return DashBoardSecondData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardSecondData?> getChargebackTransactionsData(body,CancelToken? cancelToken) async {

    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getChargebackTransactions, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return DashBoardSecondData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<LifeTimeDataResponse?> getLifeTimeData(body,CancelToken? cancelToken) async {

    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(ApiConstants.getLifetime, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return LifeTimeDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<SalesRevenueDataResponse?> getSalesRevenueData(body,CancelToken? cancelToken) async {

    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getTotalSalesRevenue, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return SalesRevenueDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<NetSubscribersDataResponse?> getNetSubscriberData(body,CancelToken? cancelToken) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getNetSubscribers, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return NetSubscribersDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ChargeBackSummaryDataResponse?> getChargebackSummaryData(body,CancelToken? cancelToken) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getChargebackSummary, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return ChargeBackSummaryDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CoverageHealthDataResponse?> getCoverageHealthData(body,CancelToken? cancelToken) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getCoverageHealth, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return CoverageHealthDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<RefundRatioDataResponse?> getRefundRatioData(body,CancelToken? cancelToken) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getRefundRatio, body,
          method: Method.post, token: token ?? "",cancelToken: cancelToken);
      return RefundRatioDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  Future<NotificationConfigurationResponse?> getNotificationConfiguration() async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getNotificationConfiguration, {},
          method: Method.get, token: token ?? "");
      return NotificationConfigurationResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  Future<void> setNotificationConfiguration(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
     await _apiHelper.makeReq(
          ApiConstants.setNotificationConfiguration, body,
          method: Method.post, token: token ?? "");

    } catch (e) {
      rethrow;
    }
  }
 getNotificationList(int pageNumber) async {
    var token = PreferenceHelper.getAccessToken();
    try {
      final response = await _apiHelper.makeReq(
          "${ApiConstants.getNotificationAll}?Page=$pageNumber&Limit=10", {},
          method: Method.get, token: token ?? "");
      return NotificationListResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DirectSaleDataResponse> getDirectSaleDetailData(body) async{
    var token = PreferenceHelper.getAccessToken();

    try{
      final response = await _apiHelper.makeReq(
        ApiConstants.getDirectSaleDetail, body,
        method: Method.post, token: token ?? "");
      return DirectSaleDataResponse.fromJson(response);
    } catch(e){
      rethrow;
    }
  }

  Future<DashboardDetailDataResponse> getInitialSubscriptionDetailData(body) async{
    var token = PreferenceHelper.getAccessToken();

    try{
      final response = await _apiHelper.makeReq(
        ApiConstants.getInitialSubscriptionDetails, body,
        method: Method.post, token: token ?? "");
      return DashboardDetailDataResponse.fromJson(response);
    }  catch(e){
      rethrow;
    }
  }

  Future<DashboardDetailDataResponse> getRecurringSubscriptionDetailData(body) async{
    var token = PreferenceHelper.getAccessToken();

    try{
      final response = await _apiHelper.makeReq(
          ApiConstants.getRecurringSubscriptionDetails, body,
          method: Method.post, token: token ?? "");
      return DashboardDetailDataResponse.fromJson(response);
    }  catch(e){
      rethrow;
    }
  }

  Future<DashboardDetailDataResponse> getSubscriptionSalvageDetailData(body) async{
    var token = PreferenceHelper.getAccessToken();

    try{
      final response = await _apiHelper.makeReq(
          ApiConstants.getSubscriptionSalvageDetails, body,
          method: Method.post, token: token ?? "");
      return DashboardDetailDataResponse.fromJson(response);
    }  catch(e){
      rethrow;
    }
  }

  Future<DirectSaleRevenueDataResponse> getDirectSaleRevenueData(body) async{
    var token = PreferenceHelper.getAccessToken();

    try{
      final response = await _apiHelper.makeReq(
        ApiConstants.getDirectSalesRevenue, body,
        method: Method.post, token: token ?? "");
      return DirectSaleRevenueDataResponse.fromJson(response);
    }catch(e){
      rethrow;
    }
  }

  Future<DtSaleAppRatioDataResponse> getDirectSaleApprovalRatioData(body) async{
    var token = PreferenceHelper.getAccessToken();

    try{
      final response = await _apiHelper.makeReq(
          ApiConstants.getDirectSaleUniqueApprovalRatio, body,
          method: Method.post, token: token ?? "");
      return DtSaleAppRatioDataResponse.fromJson(response);
    }catch(e){
      rethrow;
    }
  }

  Future<DetailChartDeclinedBreakDownDataResponse> getInitialSubscriptionDeclinedBreakdown(body) async{
    var token = PreferenceHelper.getAccessToken();

    try{
      final response = await _apiHelper.makeReq(
          ApiConstants.getInitialSubscriptionDeclinedBreakdown, body,
          method: Method.post, token: token ?? "");
      return DetailChartDeclinedBreakDownDataResponse.fromJson(response);
    }catch(e){
      rethrow;
    }
  }

  Future<DetailChartDeclinedBreakDownDataResponse> getRecurringSubscriptionDeclinedBreakdown(body) async{
    var token = PreferenceHelper.getAccessToken();

    try{
      final response = await _apiHelper.makeReq(
          ApiConstants.getRecurringSubscriptionDeclinedBreakdown, body,
          method: Method.post, token: token ?? "");
      return DetailChartDeclinedBreakDownDataResponse.fromJson(response);
    }catch(e){
      rethrow;
    }
  }

  Future<DetailChartDeclinedBreakDownDataResponse> getSubscriptionSalvageDeclinedBreakdown(body) async{
    var token = PreferenceHelper.getAccessToken();

    try{
      final response = await _apiHelper.makeReq(
          ApiConstants.getSubscriptionSalvageDeclinedBreakdown, body,
          method: Method.post, token: token ?? "");
      return DetailChartDeclinedBreakDownDataResponse.fromJson(response);
    }catch(e){
      rethrow;
    }
  }

  Future<DetailChartApprovalRatioDataResponse> getInitialSubscriptionApprovalRatio(body) async{
    var token = PreferenceHelper.getAccessToken();

    try{
      final response = await _apiHelper.makeReq(
          ApiConstants.getInitialSubscriptionApprovalRatio, body,
          method: Method.post, token: token ?? "");
      return DetailChartApprovalRatioDataResponse.fromJson(response);
    }catch(e){
      rethrow;
    }
  }

  Future<DetailChartApprovalRatioDataResponse> getRecurringSubscriptionApprovalRatio(body) async{
    var token = PreferenceHelper.getAccessToken();

    try{
      final response = await _apiHelper.makeReq(
          ApiConstants.getRecurringSubscriptionApprovalRatio, body,
          method: Method.post, token: token ?? "");
      return DetailChartApprovalRatioDataResponse.fromJson(response);
    }catch(e){
      rethrow;
    }
  }

  Future<DetailChartApprovalRatioDataResponse> getSubscriptionSalvageApprovalRatio(body) async{
    var token = PreferenceHelper.getAccessToken();

    try{
      final response = await _apiHelper.makeReq(
          ApiConstants.getSubscriptionSalvageApprovalRatio, body,
          method: Method.post, token: token ?? "");
      return DetailChartApprovalRatioDataResponse.fromJson(response);
    }catch(e){
      rethrow;
    }
  }
}
