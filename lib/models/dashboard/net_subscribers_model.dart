import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/models/line_chart_model.dart';

class NetSubscribersDataResponse {
  List<SubscriptionData>? result;

  NetSubscribersDataResponse({this.result});

  NetSubscribersDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null && json['Result'] is List) {
      // Convert List<dynamic> to List<Map<String, dynamic>>
      List<Map<String, dynamic>> netFilledData = sortTimeRanges(
        data: (json['Result'] as List)
            .map((item) => item as Map<String, dynamic>)
            .toList(),
        timeKey: "Range",
      );

      result = netFilledData.map((v) => SubscriptionData.fromJson(v)).toList();
    }
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'Result': result?.map((v) => v.toJson()).toList(),
  //   };
  // }
}
