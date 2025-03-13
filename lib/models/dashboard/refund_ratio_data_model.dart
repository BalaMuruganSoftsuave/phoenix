class RefundRatioDataResponse {
  Result? result;

  RefundRatioDataResponse({this.result});

  RefundRatioDataResponse.fromJson(Map<String, dynamic> json) {
    result = json['Result'] != null ? Result.fromJson(json['Result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['Result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  List<RefundRatioData>? straightData;
  List<RefundRatioData>? subscriptionData;

  Result({this.straightData, this.subscriptionData});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['StraightData'] != null) {
      straightData = <RefundRatioData>[];
      json['StraightData'].forEach((v) {
        straightData!.add(RefundRatioData.fromJson(v));
      });
    }
    if (json['SubscriptionData'] != null) {
      subscriptionData = <RefundRatioData>[];
      json['SubscriptionData'].forEach((v) {
        subscriptionData!.add(RefundRatioData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (straightData != null) {
      data['StraightData'] = straightData!.map((v) => v.toJson()).toList();
    }
    if (subscriptionData != null) {
      data['SubscriptionData'] =
          subscriptionData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RefundRatioData {
  num? voidData;
  String? range;
  num? refund;
  num? revenue;

  RefundRatioData({this.voidData, this.range, this.refund, this.revenue});

RefundRatioData.fromJson(Map<String, dynamic> json) {
  voidData = json['Void'];
range = json['Range'];
refund = json['Refund'];
revenue = json['Revenue'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = <String, dynamic>{};
data['Void'] = voidData;
data['Range'] = range;
data['Refund'] = refund;
data['Revenue'] = revenue;
return data;
}
}
