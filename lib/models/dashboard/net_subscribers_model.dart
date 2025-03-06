class NetSubscribersDataResponse {
  List<NetSubscribersDataResult>? result;

  NetSubscribersDataResponse({this.result});

  NetSubscribersDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null) {
      result = <NetSubscribersDataResult>[];
      json['Result'].forEach((v) {
        result!.add( NetSubscribersDataResult.fromJson(v));
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

class NetSubscribersDataResult {
  String? range;
  int? newSubscriptions;
  int? cancelledSubscriptions;
  int? netSubscriptions;

  NetSubscribersDataResult(
      {this.range,
        this.newSubscriptions,
        this.cancelledSubscriptions,
        this.netSubscriptions});

  NetSubscribersDataResult.fromJson(Map<String, dynamic> json) {
    range = json['Range'];
    newSubscriptions = json['NewSubscriptions'];
    cancelledSubscriptions = json['CancelledSubscriptions'];
    netSubscriptions = json['NetSubscriptions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Range'] = range;
    data['NewSubscriptions'] = newSubscriptions;
    data['CancelledSubscriptions'] = cancelledSubscriptions;
    data['NetSubscriptions'] = netSubscriptions;
    return data;
  }
}
