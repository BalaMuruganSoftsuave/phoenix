class SalesRevenueDataResponse {
  List<SalesRevenueDataResult>? result;

  SalesRevenueDataResponse({this.result});

  SalesRevenueDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null) {
      result = <SalesRevenueDataResult>[];
      json['Result'].forEach((v) {
        result!.add(SalesRevenueDataResult.fromJson(v));
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

class SalesRevenueDataResult {
  String? range;
  double? directSale;
  int? upsellSale;
  double? initialSale;
  double? recurringSale;
  int? salvageSale;

  SalesRevenueDataResult(
      {this.range,
      this.directSale,
      this.upsellSale,
      this.initialSale,
      this.recurringSale,
      this.salvageSale});

  SalesRevenueDataResult.fromJson(Map<String, dynamic> json) {
    range = json['Range'];
    directSale = json['DirectSale'];
    upsellSale = json['UpsellSale'];
    initialSale = json['InitialSale'];
    recurringSale = json['RecurringSale'];
    salvageSale = json['SalvageSale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Range'] = range;
    data['DirectSale'] = directSale;
    data['UpsellSale'] = upsellSale;
    data['InitialSale'] = initialSale;
    data['RecurringSale'] = recurringSale;
    data['SalvageSale'] = salvageSale;
    return data;
  }
}
