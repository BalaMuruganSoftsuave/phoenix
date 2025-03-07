import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/preference_helper.dart';
import 'package:phoenix/models/dashboard/chargeback_summary_model.dart';
import 'package:phoenix/models/dashboard/coverage_health_data_model.dart';
import 'package:phoenix/models/dashboard/dashboard_overview_model.dart';
import 'package:phoenix/models/dashboard/net_subscribers_model.dart';
import 'package:phoenix/models/dashboard/refund_ratio_data_model.dart';
import 'package:phoenix/models/dashboard/sales_revenue_data_model.dart';
import 'package:phoenix/models/login_response_model.dart';
import 'package:phoenix/models/permission_model.dart';

import 'api_constant.dart';
import 'api_helper.dart';

class ApiService {
  final APIHelper _apiHelper = APIHelper();

  /// Login API Call
  Future<LoginResponse?> login(String userName, String password,
      {String? fcm}) async {
    try {
      final response = await _apiHelper.makeReq(
        ApiConstants.loginUrl,
        {
          "Username": userName,
          "Password": password,
          "DeviceToken": fcm,
        },
      );
      return LoginResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse?> getRefreshToken(String token) async {
    try {
      final response = await _apiHelper.makeReq(
        ApiConstants.refreshToken,
        {
          "RefreshToken": token,
        },
      );
      return LoginResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<PermissionResponse?> getPermissionsData() async {
    var token = PreferenceHelper.getAccessToken();
    try {
      final response = await _apiHelper.makeReq(ApiConstants.getPermissions, {},
          method: Method.get, token: token ?? "");
      return PermissionResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardOverViewResponse?> getDirectSaleData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getDirectSale, body,
          method: Method.post, token: token ?? "");
      return DashBoardOverViewResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardOverViewResponse?> getInitialSubscriptionData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getInitialSubscription, body,
          method: Method.post, token: token ?? "");
      return DashBoardOverViewResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardOverViewResponse?> getSubscriptionSalvageData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getSubscriptionSalvage, body,
          method: Method.post, token: token ?? "");
      return DashBoardOverViewResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardOverViewResponse?> getSubscriptionBillData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getSubscriptionBill, body,
          method: Method.post, token: token ?? "");
      return DashBoardOverViewResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardOverViewResponse?> getRecurringData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getRecurringSubscription, body,
          method: Method.post, token: token ?? "");
      return DashBoardOverViewResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardOverViewResponse?> getUpsellData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(ApiConstants.getUpsell, body,
          method: Method.post, token: token ?? "");
      return DashBoardOverViewResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardSecondData?> getTotalTransactionsData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getTotalTransactions, body,
          method: Method.post, token: token ?? "");
      return DashBoardSecondData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardSecondData?> getRefundTransactionsData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getRefundTransactions, body,
          method: Method.post, token: token ?? "");
      return DashBoardSecondData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DashBoardSecondData?> getChargebackTransactionsData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getChargebackTransactions, body,
          method: Method.post, token: token ?? "");
      return DashBoardSecondData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<LifeTimeDataResponse?> getLifeTimeData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(ApiConstants.getLifetime, body,
          method: Method.post, token: token ?? "");
      return LifeTimeDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<SalesRevenueDataResponse?> getSalesRevenueData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getTotalSalesRevenue, body,
          method: Method.post, token: token ?? "");
      return SalesRevenueDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<NetSubscribersDataResponse?> getNetSubscriberData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getNetSubscribers, body,
          method: Method.post, token: token ?? "");
      return NetSubscribersDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ChargeBackSummaryDataResponse?> getChargebackSummaryData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getChargebackSummary, body,
          method: Method.post, token: token ?? "");
      return ChargeBackSummaryDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CoverageHealthDataResponse?> getCoverageHealthData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getCoverageHealth, body,
          method: Method.post, token: token ?? "");
      return CoverageHealthDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<RefundRatioDataResponse?> getRefundRatioData(body) async {
    var token = PreferenceHelper.getAccessToken();

    try {
      final response = await _apiHelper.makeReq(
          ApiConstants.getRefundRatio, body,
          method: Method.post, token: token ?? "");
      return RefundRatioDataResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
