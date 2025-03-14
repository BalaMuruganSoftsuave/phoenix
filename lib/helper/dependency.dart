import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/cubit/auth/auth_cubit.dart';
import 'package:phoenix/cubit/notification/notification_cubit.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/preference_helper.dart';
import 'package:phoenix/models/dashboard/additional_models.dart';
import 'package:phoenix/models/filter_payload_model.dart';

import '../cubit/dashboard/dashboard_cubit.dart';
import 'nav_observer.dart';

BuildContext? getCtx([BuildContext? context]) =>
    NavObserver.navKey.currentContext ?? context;

AuthCubit? getAuthCubit([BuildContext? context]) =>
    getCtx(context)?.read<AuthCubit>();

DashBoardCubit? getDashBoardCubit([BuildContext? context]) =>
    getCtx(context)?.read<DashBoardCubit>();
 NotificationCubit? getNotificationCubit([BuildContext? context]) =>
    getCtx(context)?.read<NotificationCubit>();

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

String checkNullable(num value) {
  if (value == 0) {
    return '-';
  }
  return "${value.toStringAsFixed(1)}%";
}

String formatNumber(num number, {String locale = 'en_US'}) {
  if (number == 0) {
    return '-';
  }
  final formatter = NumberFormat.decimalPattern(locale);
  return formatter.format(number);
}

/// Formats a number as currency (USD)
String formatCurrency(double value) {
  if (value == 0) {
    return '-';
  }
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

getUserName() {
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

FilterPayload adjustStartEndDateRefund(String startDate, String endDate) {
  DateTime start = DateTime.parse(startDate);
  DateTime end = DateTime.parse(endDate);
  DateTime today = DateTime.now();

  // Calculate the difference in days between start and end
  int diffDays = end.difference(start).inDays.abs();

  // If the difference is less than 7 days, set start date to 7 days before the end date
  if (diffDays < 7) {
    end = end;
    start = end.subtract(const Duration(days: 6));
  }

  // Determine the groupBy value based on the difference in days
  String groupByValue;
  if (diffDays <= 30) {
    groupByValue = 'day';
  } else if (diffDays <= 210) {
    groupByValue = 'week';
  } else {
    groupByValue = 'month';
  }

  // Format the dates as "YYYY-MM-DD"
  String formatDate(DateTime date) => date.toIso8601String().split('T')[0];

  return FilterPayload(
      startDate: formatDate(start),
      endDate: formatDate(end),
      groupBy: groupByValue);
}

logout() {
  PreferenceHelper.clearPreferences();
}

List<Color> generateRandomColors(int length) {
  return List<Color>.generate(length, (i) {
    final hue = (i * 360) / length;
    return HSLColor.fromAHSL(1.0, hue, 0.7, 0.5).toColor();
  });
}

List<T> generateDateSlots<T>({
  required String start,
  required String end,
  required T defaultValues,
  required String groupBy, // "hour" | "day" | "week" | "month"
}) {
  DateTime startDate = DateTime.parse(start);
  DateTime endDate = DateTime.parse(end);
  List<T> slots = [];
  DateTime current = startDate;

  while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
    String formattedRange = '';

    switch (groupBy) {
      case 'hour':
        formattedRange = DateFormat('hh a').format(current); // e.g., "12 AM"
        break;
      case 'day':
        formattedRange = DateFormat('MM/dd').format(current); // e.g., "12/04"
        break;
      case 'week':
        formattedRange = DateFormat('MMM d').format(current); // e.g., "Dec 4"
        break;
      case 'month':
        formattedRange = DateFormat('MMMM yyyy').format(current); // e.g., "December 2024"
        break;
    }

    // Add slot with default values
    slots.add({...defaultValues as Map<String, dynamic>, 'Range': formattedRange} as T);

    // Increment based on grouping type
    switch (groupBy) {
      case 'hour':
        current = current.add(const Duration(hours: 1));
        break;
      case 'day':
        current = current.add(const Duration(days: 1));
        break;
      case 'week':
        current = current.add(const Duration(days: 7));
        break;
      case 'month':
        current = DateTime(current.year, current.month + 1, current.day);
        break;
    }
  }

  return slots;
}
List<T> generateSlots<T>({
  required String start,
  required String end,
  required List<T> existingData,
  required T defaultValues,
  required String groupBy, // "hour" or "day"
  required String Function(T) getRange,
}) {
  DateTime startDate = DateTime.parse(start);
  DateTime endDate = DateTime.parse(end);

  if (endDate.year == DateTime.now().year &&
      endDate.month == DateTime.now().month &&
      endDate.day == DateTime.now().day) {
    // If end date is today, set to current time
    var now = DateTime.now().hour;
    endDate = DateTime(
        endDate.year, endDate.month, endDate.day, now < 20 ? now + 3 : now, 59);
  } else {
    // If end date is a different day, set to 11:59 PM
    endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59);
  }

  List<T> slots = [];
  DateTime current = startDate;

  // Create a map of existing data for quick lookup
  Map<String, T> dataMap = {
    for (var data in existingData) getRange(data): data
  };

  while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
    String range = groupBy == 'hour'
        ? '${current.month.toString().padLeft(2, '0')}/${current.day.toString().padLeft(2, '0')} '
            '${current.hour == 0 ? 12 : current.hour > 12 ? current.hour - 12 : current.hour}'
            '${current.hour < 12 ? 'AM' : 'PM'}':
        // : '${current.month.toString().padLeft(2, '0')}/${current.day.toString().padLeft(2, '0')}';
     groupBy == 'day'?  DateFormat('MM/dd').format(current):
     groupBy == 'week'?  DateFormat('MMM d').format(current):
     DateFormat('MMMM yyyy').format(current) ;


    if (dataMap.containsKey(range)) {
      // Add existing data
      slots.add(dataMap[range]!);
    } else {
      // Add default values if not available
      slots
          .add({...defaultValues as Map<String, dynamic>, 'Range': range} as T);
    }

    // Increment based on grouping type
    current = groupBy == 'hour' ? current.add(const Duration(hours: 1)):
    current = groupBy =='day'? current.add(const Duration(days: 1)):
    current=groupBy=='week'? current.add(const Duration(days: 7)) :
    current = DateTime(current.year, current.month + 1, current.day);

  }

  return slots;
}

var colors = [
  AppColors.orange,
  AppColors.secUi,
  AppColors.successGreen,
  AppColors.pink,
  AppColors.purple,

];

