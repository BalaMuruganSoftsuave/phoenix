class DirectSaleRevenueDataResponse {
  List<DirectSaleDataResult>? result;

  DirectSaleRevenueDataResponse({this.result});

  DirectSaleRevenueDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null) {
      result = <DirectSaleDataResult>[];
      json['Result'].forEach((v) {
        result!.add( DirectSaleDataResult.fromJson(v));
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
  String? range;
  double? directSale;

  DirectSaleDataResult({this.range, this.directSale});

  DirectSaleDataResult.fromJson(Map<String, dynamic> json) {
    range = json['Range'];
    directSale = json['DirectSale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Range'] = range;
    data['DirectSale'] = directSale;
    return data;
  }
}

class DtSaleAppRatioDataResponse {
  List<DtSaleAppRatioDataResult>? result;

  DtSaleAppRatioDataResponse({this.result});

  DtSaleAppRatioDataResponse.fromJson(
      Map<String, dynamic> json) {
    if (json['Result'] != null) {
      result = <DtSaleAppRatioDataResult>[];
      json['Result'].forEach((v) {
        result!.add(DtSaleAppRatioDataResult.fromJson(v));
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

class DtSaleAppRatioDataResult {
  String? range;
  int? approvedCount;
  int? declinedCount;
  double? approvedPercentage;
  double? declinedPercentage;

  DtSaleAppRatioDataResult(
      {this.range,
        this.approvedCount,
        this.declinedCount,
        this.approvedPercentage,
        this.declinedPercentage});

  DtSaleAppRatioDataResult.fromJson(Map<String, dynamic> json) {
    range = json['Range'];
    approvedCount = json['ApprovedCount'];
    declinedCount = json['DeclinedCount'];
    approvedPercentage = json['ApprovedPercentage'];
    declinedPercentage = json['DeclinedPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Range'] = range;
    data['ApprovedCount'] = approvedCount;
    data['DeclinedCount'] = declinedCount;
    data['ApprovedPercentage'] = approvedPercentage;
    data['DeclinedPercentage'] = declinedPercentage;
    return data;
  }
}