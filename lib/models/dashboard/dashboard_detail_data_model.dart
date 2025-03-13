class DirectSaleDataResponse {
  List<DirectSaleDataResult>? result;

  DirectSaleDataResponse({this.result});

  DirectSaleDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null) {
      result = <DirectSaleDataResult>[];
      json['Result'].forEach((v) {
        result!.add(DirectSaleDataResult.fromJson(v));
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

class DirectSaleDataResult {
  String? label;
  num? approvedOrders;
  num? averageOrderValue;
  num? approvalPercentage;
  num? abandonCartRatio;

  DirectSaleDataResult(
      {this.label,
        this.approvedOrders,
        this.averageOrderValue,
        this.approvalPercentage,
        this.abandonCartRatio});

  DirectSaleDataResult.fromJson(Map<String, dynamic> json) {
    label = json['Label'];
    approvedOrders = json['ApprovedOrders'];
    averageOrderValue = double.parse(((json['AverageOrderValue']?? "0").toString()));
    approvalPercentage = json['ApprovalPercentage'];
    abandonCartRatio = double.parse(((json['AbandonCartRatio']?? "0").toString()));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Label'] = label;
    data['ApprovedOrders'] = approvedOrders;
    data['AverageOrderValue'] = averageOrderValue;
    data['ApprovalPercentage'] = approvalPercentage;
    data['AbandonCartRatio'] = abandonCartRatio;
    return data;
  }
}


class DashboardDetailDataResponse {
  List<DashboardDetailDataResult>? result;

  DashboardDetailDataResponse({this.result});

  DashboardDetailDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null) {
      result = <DashboardDetailDataResult>[];
      json['Result'].forEach((v) {
        result!.add(DashboardDetailDataResult.fromJson(v));
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

class DashboardDetailDataResult {
  String? label;
  num? approvedOrders;
  num? declinedOrders;
  num? cancelledSubscriptions;
  num? approvalPercentage;

  DashboardDetailDataResult(
      {this.label,
      this.approvedOrders,
      this.declinedOrders,
      this.cancelledSubscriptions,
      this.approvalPercentage});

  DashboardDetailDataResult.fromJson(Map<String, dynamic> json) {
    label = json['Label'];
    approvedOrders = json["ApprovedOrders"] != null
        ? double.tryParse(json["ApprovedOrders"].toString()) ?? 0.0
        : json['TotalApproved'] ;

    declinedOrders = json['DeclinedOrders']!=null?double.parse('${json['DeclinedOrders']}'): json['TotalDeclined'];
    cancelledSubscriptions = json['CancelledSubscriptions']!=null?double.parse('${json['CancelledSubscriptions']}'): json['CanceledSubscribers'];
    approvalPercentage = json["ApprovalRatio"] != null
        ? double.parse((json["ApprovalRatio"] ?? "0").toString())
        : double.parse((json["ApprovalPercentage"] ?? "0").toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Label'] = label;
    data['ApprovedOrders'] = approvedOrders;
    data['DeclinedOrders'] = declinedOrders;
    data['CancelledSubscriptions'] = cancelledSubscriptions;
    data['ApprovalPercentage'] = approvalPercentage;
    return data;
  }
}
