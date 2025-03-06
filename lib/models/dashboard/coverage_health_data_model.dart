class CoverageHealthDataResponse {
  List<CoverageHealthDataResult>? result;

  CoverageHealthDataResponse({this.result});

  CoverageHealthDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null) {
      result = <CoverageHealthDataResult>[];
      json['Result'].forEach((v) {
        result!.add( CoverageHealthDataResult.fromJson(v));
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

class CoverageHealthDataResult {
  String? cardType;
  String? chargeBackType;
  int? approvedTransactions;

  CoverageHealthDataResult({this.cardType, this.chargeBackType, this.approvedTransactions});

  CoverageHealthDataResult.fromJson(Map<String, dynamic> json) {
    cardType = json['CardType'];
    chargeBackType = json['ChargeBackType'];
    approvedTransactions = json['ApprovedTransactions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CardType'] = cardType;
    data['ChargeBackType'] = chargeBackType;
    data['ApprovedTransactions'] = approvedTransactions;
    return data;
  }
}
