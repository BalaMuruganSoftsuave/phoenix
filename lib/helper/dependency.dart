import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import 'nav_observer.dart';

BuildContext? getCtx([BuildContext? context]) =>
    NavObserver.navKey.currentContext ?? context;

String getSubtitle(int approvedOrders, double approvalPercentage) {
  if (approvedOrders == 0) {
    return '-'; // Show "-" if ApprovedOrders is 0
  }
  if (approvalPercentage == 0) {
    return formatNumber(approvedOrders); // Show only ApprovedOrders if ApprovalPercentage is 0
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

  return roundResult ? result.roundToDouble() : double.parse(result.toStringAsFixed(toFixed));
}