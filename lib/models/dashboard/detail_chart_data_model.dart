class DetailChartDeclinedBreakDownDataResponse {
  List<DetailChartDeclinedBreakDownDataResult>? result;

  DetailChartDeclinedBreakDownDataResponse({this.result});

  factory DetailChartDeclinedBreakDownDataResponse.fromJson(
      Map<String, dynamic> json) {
    if (json['Result'] == null) {
      return DetailChartDeclinedBreakDownDataResponse(result: []);
    }

    List<Map<String, dynamic>> rawData =
    List<Map<String, dynamic>>.from(json['Result']);

    // ✅ Separate data for all and cancelled
    Map<String, double> allData = {};
    Map<String, double> cancelledData = {};

    double totalAll = 0;
    double totalCancelled = 0;

    for (var map in rawData) {
      String reason = map['DeclinedReason'] ?? "";
      int cancelled = map['Cancelled'] ?? 0;
      double value = (map['DeclinedCount'] ?? 0).toDouble();

      if (value > 0) {
        // ✅ Sum for "All"
        allData[reason] = (allData[reason] ?? 0) + value;
        totalAll += value;

        // ✅ Sum for "Cancelled" only if cancelled = 1
        if (cancelled == 1) {
          cancelledData[reason] = (cancelledData[reason] ?? 0) + value;
          totalCancelled += value;
        }
      }
    }

    // ✅ Create result list with computed percentages
    List<DetailChartDeclinedBreakDownDataResult> result = [];

    // ✅ Add All Data
    allData.forEach((reason, value) {
      result.add(DetailChartDeclinedBreakDownDataResult(
        reason: reason,
        value: value,
        cancelled: 0, // For "All" data
        percentage: totalAll > 0 ? (value / totalAll) * 100 : 0,
      ));
    });

    // ✅ Add Cancelled Data
    cancelledData.forEach((reason, value) {
      result.add(DetailChartDeclinedBreakDownDataResult(
        reason: reason,
        value: value,
        cancelled: 1, // For "Cancelled" data
        percentage: totalCancelled > 0 ? (value / totalCancelled) * 100 : 0,
      ));
    });

    return DetailChartDeclinedBreakDownDataResponse(result: result);
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result?.map((v) => v.toMap()).toList(),
    };
  }
}

class DetailChartDeclinedBreakDownDataResult {
  final String reason;
  final double value;
  final double percentage;
  final int cancelled;

  DetailChartDeclinedBreakDownDataResult({
    required this.reason,
    required this.value,
    required this.percentage,
    required this.cancelled,
  });

  Map<String, dynamic> toMap() {
    return {
      'reason': reason,
      'value': value,
      'percentage': percentage,
      'cancelled': cancelled,
    };
  }
}

// class DetailChartDeclinedBreakDownDataResult {
//   int? cancelled;
//   String? declinedReason;
//   int? declinedCount;
//
//   DetailChartDeclinedBreakDownDataResult({this.cancelled, this.declinedReason, this.declinedCount});
//
//   DetailChartDeclinedBreakDownDataResult.fromJson(Map<String, dynamic> json) {
//     cancelled = json['Cancelled'];
//     declinedReason = json['DeclinedReason'];
//     declinedCount = json['DeclinedCount'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Cancelled'] = cancelled;
//     data['DeclinedReason'] = declinedReason;
//     data['DeclinedCount'] = declinedCount;
//     return data;
//   }
// }

class DetailChartApprovalRatioDataResponse {
  List<DetailChartApprovalRatioDataResult>? result;

  DetailChartApprovalRatioDataResponse({this.result});

  DetailChartApprovalRatioDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null) {
      result = <DetailChartApprovalRatioDataResult>[];
      json['Result'].forEach((v) {
        result!.add(DetailChartApprovalRatioDataResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['Result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailChartApprovalRatioDataResult {
  String? range;
  num? totalOrders;
  num? approvedOrders;
  num? cancelledOrders;

  DetailChartApprovalRatioDataResult({this.range, this.totalOrders, this.approvedOrders});

  DetailChartApprovalRatioDataResult.fromJson(Map<String, dynamic> json) {
    range = json['Range'];
    totalOrders = json['TotalOrders'];
    approvedOrders =  json["ApprovedOrders"] != null
        ? int.tryParse(json["ApprovedOrders"].toString()) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Range'] = range;
    data['TotalOrders'] = totalOrders;
    data['ApprovedOrders'] = approvedOrders;
    return data;
  }
  Map<String, dynamic> toChartJson() {
    var declinedOrders = (totalOrders??0) - (approvedOrders??0);
    var approvedPercentage = (totalOrders??0) > 0
        ? ((approvedOrders??0) / (totalOrders??0)) * 100
        : 0;
    var declinedPercentage = (totalOrders??0) > 0
        ? ((declinedOrders??0) / (totalOrders??0)) * 100
        : 0;
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Range'] = range;
    data['Approved'] = approvedPercentage;
    data['Declined'] = declinedPercentage;
    return data;
  }
}