import 'dart:convert';

class AdjustedDates {
  final String adjustedStartDate;
  final String adjustedEndDate;
  final String monthRange;

  AdjustedDates({
    required this.adjustedStartDate,
    required this.adjustedEndDate,
    required this.monthRange,
  });

  // Convert JSON to AdjustedDates object
  factory AdjustedDates.fromJson(Map<String, dynamic> json) {
    return AdjustedDates(
      adjustedStartDate: json['adjustedStartDate'],
      adjustedEndDate: json['adjustedEndDate'],
      monthRange: json['monthRange'],
    );
  }

  // Convert AdjustedDates object to JSON
  Map<String, dynamic> toJson() {
    return {
      'adjustedStartDate': adjustedStartDate,
      'adjustedEndDate': adjustedEndDate,
      'monthRange': monthRange,
    };
  }

  // Convert object to JSON string
  String toJsonString() => jsonEncode(toJson());

  // Convert JSON string to AdjustedDates object
  static AdjustedDates fromJsonString(String jsonString) =>
      AdjustedDates.fromJson(jsonDecode(jsonString));
}
