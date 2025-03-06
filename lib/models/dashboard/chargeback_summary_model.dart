class ChargeBackSummaryDataResponse {
  List<ChargeBackSummaryDataResult>? result;

  ChargeBackSummaryDataResponse({this.result});

  ChargeBackSummaryDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null) {
      result = <ChargeBackSummaryDataResult>[];
      json['Result'].forEach((v) {
        result!.add(ChargeBackSummaryDataResult.fromJson(v));
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

class ChargeBackSummaryDataResult {
  String? cardType;
  String? totalApprovedTransactions;
  int? totalChargeBacks;

  ChargeBackSummaryDataResult(
      {this.cardType, this.totalApprovedTransactions, this.totalChargeBacks});

  ChargeBackSummaryDataResult.fromJson(Map<String, dynamic> json) {
    cardType = json['CardType'];
    totalApprovedTransactions = json['TotalApprovedTransactions'];
    totalChargeBacks = json['TotalChargeBacks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CardType'] = cardType;
    data['TotalApprovedTransactions'] = totalApprovedTransactions;
    data['TotalChargeBacks'] = totalChargeBacks;
    return data;
  }
}
