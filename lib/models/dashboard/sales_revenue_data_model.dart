import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/models/line_chart_model.dart';

class SalesRevenueDataResponse {
  List<SalesData>? result;

  SalesRevenueDataResponse({this.result});

  SalesRevenueDataResponse.fromJson(Map<String, dynamic> json) {

    if (json['Result'] != null && json['Result'] is List) {
      List<Map<String, dynamic>> filledData = sortTimeRanges(
        data: (json['Result'] as List).map((item) => item as Map<String, dynamic>)
            .toList(),
        timeKey: "Range",
      );
      result = filledData.map((v) => SalesData.fromJson(v)).toList();

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

