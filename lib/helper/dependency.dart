import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/cubit/auth/auth_cubit.dart';
import 'package:phoenix/helper/preference_helper.dart';
import 'package:phoenix/models/dashboard/additional_models.dart';

import '../cubit/dashboard/dashboard_cubit.dart';
import 'nav_observer.dart';

BuildContext? getCtx([BuildContext? context]) =>
    NavObserver.navKey.currentContext ?? context;

AuthCubit? getAuthCubit([BuildContext? context]) =>
    getCtx(context)?.read<AuthCubit>();

DashBoardCubit? getDashBoardCubit([BuildContext? context]) =>
    getCtx(context)?.read<DashBoardCubit>();

String getSubtitle(double approvedOrders, double approvalPercentage) {
  if (approvedOrders == 0) {
    return '-'; // Show "-" if ApprovedOrders is 0
  }
  if (approvalPercentage == 0) {
    return formatNumber(
        approvedOrders); // Show only ApprovedOrders if ApprovalPercentage is 0
  }
  return '${formatNumber(approvedOrders)}/${approvalPercentage.toStringAsFixed(1)}%'; // Show both if none are 0
}

String formatNumber(num number, {String locale = 'en_US'}) {
  final formatter = NumberFormat.decimalPattern(locale);
  return formatter.format(number);
}

/// Formats a number as currency (USD)
String formatCurrency(double value) {
  final format = NumberFormat.currency(locale: 'en_US', symbol: '\$');
  return format.format(value);
}

/// Calculates the percentage of `partialValue` to `totalValue`
/// - If `roundResult` is `true`, it rounds the result
/// - If `toFixed` is specified, it formats the number with the given decimal places
double percentage(
  double partialValue,
  double totalValue, {
  bool roundResult = false,
  int toFixed = 2,
}) {
  if (totalValue == 0) {
    print('Warning: Total value cannot be zero.');
    return 0;
  }

  double result = (100 * partialValue) / totalValue;

  if (result.isNaN) {
    return 0;
  }

  return roundResult
      ? result.roundToDouble()
      : double.parse(result.toStringAsFixed(toFixed));
}

class IdValueItem {
  String? id;
  String? name;

  IdValueItem({this.name, this.id});
}

List<IdValueItem> weekDays = [
  IdValueItem(id: "Sunday", name: "Sun"),
  IdValueItem(id: "Monday", name: "Mon"),
  IdValueItem(id: "Tuesday", name: "Tue"),
  IdValueItem(id: "Wednesday", name: "Wed"),
  IdValueItem(id: "Thursday", name: "Thu"),
  IdValueItem(id: "Friday", name: "Fri"),
  IdValueItem(id: "Saturday", name: "Sat"),
];

List<IdValueItem> notificationConfigurationItem = [
  IdValueItem(id: "0", name: "Hourly"),
  IdValueItem(id: "1", name: "Daily"),
  IdValueItem(id: "2", name: "Weekly"),
];


String getGroupBy(dynamic start, dynamic end) {
  // Ensure inputs are valid DateTime objects
  DateTime? startDate = _parseDate(start);
  DateTime? endDate = _parseDate(end);

  // Check if the parsed dates are valid
  if (startDate == null || endDate == null) {
    print('Invalid startDate or endDate');
    return '';
  }

  // Calculate the difference in days
  int dayDiff = endDate.difference(startDate).inDays.abs();

  if (dayDiff <= 2) {
    return 'hour';
  } else if (dayDiff <= 90) {
    return 'day';
  } else if (dayDiff > 90 && dayDiff <= 240) {
    return 'week';
  } else {
    return 'month';
  }
}

/// Helper function to safely parse date
DateTime? _parseDate(dynamic date) {
  if (date is DateTime) return date;
  if (date is String) {
    try {
      return DateTime.parse(date);
    } catch (e) {
      print('Error parsing date: $e');
    }
  }
  return null;
}

AdjustedDates adjustDates(String start, String end) {
  DateTime startDate = DateTime.parse(start);
  DateTime endDate = DateTime.parse(end);

  // Calculate the first day of the month for the start date
  DateTime adjustedStartDate = DateTime(startDate.year, startDate.month, 1);
  // Calculate the last day of the month for the end date
  DateTime adjustedEndDate = DateTime(endDate.year, endDate.month + 1, 0);
  DateTime adjustedEndDateMonth = DateTime(endDate.year, endDate.month + 1, 0);

  // Format the dates as "YYYY-MM-DD"
  String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  // Get month and year as "MMM YY"
  String startMonthName = DateFormat('MMM').format(adjustedStartDate);
  String endMonthName = DateFormat('MMM').format(adjustedEndDateMonth);

  int startYear = adjustedStartDate.year;
  int endYear = adjustedEndDateMonth.year;

  // Construct the month range
  String monthRange = (startMonthName == endMonthName && startYear == endYear)
      ? "$startMonthName $startYear"
      : "$startMonthName $startYear - $endMonthName $endYear";
  return AdjustedDates(
      adjustedStartDate: formatDate(adjustedStartDate),
      adjustedEndDate: formatDate(adjustedEndDate),
      monthRange: monthRange);
  // return {
  //   'adjustedStartDate': formatDate(adjustedStartDate),
  //   'adjustedEndDate': formatDate(adjustedEndDate),
  //   'monthRange': monthRange,
  // };



}
String timeAgo(String dateString) {
  DateTime dateTime = DateTime.parse(dateString).toLocal();
  Duration difference = DateTime.now().difference(dateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} secs ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 30) {
    int weeks = (difference.inDays / 7).floor();
    return '$weeks week${weeks > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 365) {
    int months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  } else {
    int years = (difference.inDays / 365).floor();
    return '$years year${years > 1 ? 's' : ''} ago';
  }
}
getUserName(){
 return PreferenceHelper.getUserName();
}




List<Map<String, dynamic>> sortTimeRanges({
  required List<Map<String, dynamic>>? data,
  required String timeKey, // The key containing time (e.g., "Range")
}) {
  if (data == null || data.isEmpty) return [];

  // Function to check if the time part exists in the "Range" string
  bool hasValidTime(String range) {
    List<String> parts = range.split(" ");
    return parts.length >= 2 && RegExp(r'\d{1,2}(AM|PM)').hasMatch(parts[1]);
  }

  // Check if all entries are missing valid time parts
  bool allMissingTimes = data.every((entry) => !hasValidTime(entry[timeKey]));

  // If all are missing valid times, return the original data
  if (allMissingTimes) return data;

  // Convert time to 24-hour format for sorting
  int parseTime(String range) {
    if (!hasValidTime(range)) return -1; // Invalid format
    List<String> parts = range.split(" ");
    String time = parts[1];
    int hour = int.parse(time.replaceAll(RegExp(r'[^0-9]'), ''));
    bool isPM = time.contains("PM");

    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    return hour;
  }

  // Sort the data without modifying its structure
  List<Map<String, dynamic>> sortedResults = List.from(data);
  sortedResults.sort((a, b) {
    int timeA = parseTime(a[timeKey]);
    int timeB = parseTime(b[timeKey]);
    return timeA.compareTo(timeB);
  });

  return sortedResults;
}
logout(){

}