import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/cubit/dashboard/dashboard_cubit.dart';
import 'package:phoenix/cubit/dashboard/dashboard_state.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/models/dashboard/chargeback_summary_model.dart';
import 'package:phoenix/screens/dashboard/dashboard_screen.dart';
import 'package:phoenix/widgets/container_widget.dart';
import 'package:phoenix/widgets/loader.dart';

class ChargebackSummary extends StatelessWidget {
  const ChargebackSummary({
    super.key,
  });

  List formatChargebackData(List<ChargeBackSummaryDataResult> data) {
    return data.expand((item) {
      String cardType = item.cardType ?? "";
      String totalApprovedTransactions =
          (item.totalApprovedTransactions ?? "0").toString();
      String totalChargeBacks = (item.totalChargeBacks ?? "0").toString();

      double chargebackRatio =
          (int.parse(totalChargeBacks) / int.parse(totalApprovedTransactions)) *
              100;

      // Display as '0' instead of '0%'
      String formattedRatio =
          chargebackRatio == 0 ? '0' : '${chargebackRatio.toStringAsFixed(2)}%';

      String? keyPrefix;
      if (cardType == 'MasterCard') {
        keyPrefix = 'MC';
      } else if (cardType == 'American Express') {
        keyPrefix = 'AMEX';
      } else if (cardType.isNotEmpty) {
        keyPrefix = cardType;
      }

      // Skip if keyPrefix is unknown (empty)
      if (keyPrefix?.toLowerCase() == "unknown") return [];

      return [
        {
          'key': '$keyPrefix Approved Transactions',
          'value': formatNumber(num.parse(totalApprovedTransactions))
        },
        {'key': '$keyPrefix Chargebacks', 'value': totalChargeBacks},
        {'key': '$keyPrefix Chargeback Ratio', 'value': formattedRatio}
      ];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ContainerWidget(
      title: TextHelper.chargeBackSummary,
      widget: BlocBuilder<DashBoardCubit, DashboardState>(
        builder: (context, state) {
          var data =
              formatChargebackData(state.chargeBackSummaryData?.result ?? []);
          return state.chargeBackSummaryReqState == ProcessState.loading
              ? Loader()
              : (state.chargeBackSummaryData?.result ?? []).isEmpty
                  ? NoDataWidget()
                  : Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: AppColors.darkBg,
                          borderRadius: BorderRadius.circular(12)),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(item["key"] ?? "",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ),
                                    Text((item["value"] ?? "").toString(),
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.grey.shade600),
                            ],
                          );
                        },
                      ),
                    );
        },
      ),
    );
  }
}
