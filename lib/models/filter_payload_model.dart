class FilterPayload {
  String? startDate;
  String? endDate;
  List<int>? clientIds;
  List<int>? storeIds;
  String? groupBy;

  FilterPayload(
      {this.startDate,
        this.endDate,
        this.clientIds,
        this.storeIds,
        this.groupBy});

  FilterPayload.fromJson(Map<String, dynamic> json) {
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    clientIds = json['ClientIds'].cast<int>();
    storeIds = json['StoreIds'].cast<int>();
    groupBy = json['GroupBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StartDate'] = startDate;
    data['EndDate'] = endDate;
    data['ClientIds'] = clientIds;
    data['StoreIds'] = storeIds;
    data['GroupBy'] = groupBy;
    return data;
  }
}
