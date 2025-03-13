class DetailChartDeclinedBreakDownDataResponse {
  List<DetailChartDeclinedBreakDownDataResult>? result;

  DetailChartDeclinedBreakDownDataResponse({this.result});

  DetailChartDeclinedBreakDownDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null) {
      result = <DetailChartDeclinedBreakDownDataResult>[];
      json['Result'].forEach((v) {
        result!.add(DetailChartDeclinedBreakDownDataResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['Result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailChartDeclinedBreakDownDataResult {
  int? cancelled;
  String? declinedReason;
  int? declinedCount;

  DetailChartDeclinedBreakDownDataResult({this.cancelled, this.declinedReason, this.declinedCount});

  DetailChartDeclinedBreakDownDataResult.fromJson(Map<String, dynamic> json) {
    cancelled = json['Cancelled'];
    declinedReason = json['DeclinedReason'];
    declinedCount = json['DeclinedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Cancelled'] = cancelled;
    data['DeclinedReason'] = declinedReason;
    data['DeclinedCount'] = declinedCount;
    return data;
  }
}

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