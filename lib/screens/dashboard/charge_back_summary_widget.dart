import 'package:flutter/material.dart';
import 'package:phoenix/models/dashboard/chargeback_summary_model.dart';

class ChargebackSummary extends StatelessWidget {
  const ChargebackSummary({
    super.key,
  });

  List<Map<String, String>> formatChargebackData(List<ChargeBackSummaryDataResult> data) {
    return data.expand((item) {
      String cardType = item.cardType??"";
      String totalApprovedTransactions =
          item.totalApprovedTransactions.toString();
      String totalChargeBacks = item.totalChargeBacks.toString();

      double chargebackRatio =
          (int.parse(totalChargeBacks) / int.parse(totalApprovedTransactions)) *
              100;
      String formattedRatio = chargebackRatio.toStringAsFixed(2);

      String keyPrefix = cardType == 'MasterCard'
          ? 'MC'
          : (cardType == 'American Express' ? 'AMEX' : cardType);

      return [
        {
          'key': '$keyPrefix Approved Transactions',
          'value': totalApprovedTransactions
        },
        {'key': '$keyPrefix Chargebacks', 'value': totalChargeBacks},
        {'key': '$keyPrefix Chargeback Ratio', 'value': '$formattedRatio%'}
      ];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Chargeback Summary',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 10),
          // BlocBuilder<DashBoardCubit, DashboardState>(
          //   builder: (context, state) {
          //     return ListView.builder(
          //       shrinkWrap: true,
          //       itemCount: snapshot.data!.length,
          //       itemBuilder: (context, index) {
          //         final item = snapshot.data![index];
          //         return Column(
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.symmetric(
          //                   vertical: 10.0, horizontal: 15.0),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Expanded(
          //                     child: Text(item['key']!,
          //                         style: TextStyle(
          //                             fontSize: 14, color: Colors.white)),
          //                   ),
          //                   Text(item['value']!,
          //                       style: TextStyle(
          //                           fontSize: 14, color: Colors.white)),
          //                 ],
          //               ),
          //             ),
          //             Divider(color: Colors.grey.shade600),
          //           ],
          //         );
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
