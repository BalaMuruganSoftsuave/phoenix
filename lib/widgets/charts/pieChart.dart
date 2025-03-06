import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../helper/color_helper.dart';
import '../../helper/font_helper.dart';
import '../../helper/responsive_helper.dart';
import '../../helper/utils.dart';

class PieChartFilterWidget extends StatefulWidget {
  const PieChartFilterWidget({super.key, this.title});
  final title;
  @override
  PieChartFilterWidgetState createState() => PieChartFilterWidgetState();
}

class PieChartFilterWidgetState extends State<PieChartFilterWidget> {
  String selectedFilter = "All";
  int touchedIndex = -1;
  Offset tooltipPosition = Offset.zero;

  final List<Map<String, dynamic>> transactions = [
    {"CardType": "MasterCard", "ChargeBackType": "Ethoca", "ApprovedTransactions": 116},
    {"CardType": "Visa", "ChargeBackType": "CDRN", "ApprovedTransactions": 58},
    {"CardType": "Visa", "ChargeBackType": "Ethoca", "ApprovedTransactions": 62},
    {"CardType": "MasterCard", "ChargeBackType": "CDRN", "ApprovedTransactions": 17},
    {"CardType": "Discover", "ChargeBackType": "Ethoca", "ApprovedTransactions": 2},
    {"CardType": "Visa", "ChargeBackType": "RDR", "ApprovedTransactions": 24},
    {"CardType": "American Express", "ChargeBackType": "Chargeback", "ApprovedTransactions": 20},
    {"CardType": "American Express", "ChargeBackType": "Ethoca", "ApprovedTransactions": 20},
  ];

  List<Map<String, dynamic>> filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _filterData("All");
  }

  void _filterData(String filter) {
    setState(() {
      selectedFilter = filter;
      touchedIndex = -1;
      filteredTransactions = filter == "All"
          ? List.from(transactions)
          : transactions.where((item) => item["CardType"] == filter).toList();
    });
  }

  Map<String, int> _calculateChargebackTotals() {
    Map<String, int> chargebackCounts = {"Chargeback": 0, "RDR": 0, "Ethoca": 0, "CDRN": 0};
    for (var item in filteredTransactions) {
      String type = item["ChargeBackType"] ?? "Unknown";
      int count = (item["ApprovedTransactions"] as num).toInt();
      chargebackCounts[type] = chargebackCounts.containsKey(type)
          ? chargebackCounts[type]! + count
          : count; // Add unknown types dynamically
    }
    return chargebackCounts;
  }

  Widget _buildDropdownFilter() {
    List<String> cardTypes = ["All", ...{...transactions.map((t) => t["CardType"])}];

    return DropdownButton<String>(
      value: selectedFilter,
      dropdownColor: AppColors.darkBg2,
      style: TextStyle(color: AppColors.text),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      onChanged: (String? newValue) {
        if (newValue != null) {
          _filterData(newValue);
        }
      },
      items: cardTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
    );
  }

  List<PieChartSectionData> _generatePieSections(List<MapEntry<String, int>> entries, int total) {
    return List.generate(entries.length, (index) {
      String chargebackType = entries[index].key;
      int count = entries[index].value;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 65 : 60;
      return PieChartSectionData(
        value: count.toDouble(),
        title: '',
        color: _getChargebackColor(chargebackType),
        radius: radius.toDouble(),
      );
    });
  }

  Widget _buildTooltip(String chargebackType, int count, String percentage, Offset position) {
    return Positioned(
      left: position.dx,  // Use the x-coordinate from the touch event
      top: position.dy,   // Use the y-coordinate from the touch event
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          "$chargebackType\n$count ($percentage%)",
          style: TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Color _getChargebackColor(String chargebackType) {
    switch (chargebackType) {
      case "Chargeback":
        return Colors.blue;
      case "RDR":
        return Colors.purple;
      case "Ethoca":
        return Colors.orange;
      case "CDRN":
      default:
        return Colors.green;
    }
  }

  Widget _buildFilterButtons() {
    List<String> cardTypes = ["All", ...{...transactions.map((t) => t["CardType"])}];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: cardTypes.map((filter) => _filterButton(filter)).toList(),
    );
  }

  Widget _filterButton(String filter) {
    return ElevatedButton(
      onPressed: () => _filterData(filter),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedFilter == filter ? Colors.blue : Colors.grey,
        foregroundColor: Colors.white,
      ),
      child: Text(filter),
    );
  }

  Widget _buildChargebackLegend(Map<String, int> chargebackTotals, int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,// or Column based on layout preference
      children: chargebackTotals.entries.map((entry) {
        double percentage = total > 0 ? (entry.value / total * 100) : 0;
        return LegendWidget(color: AppColors.purple, text: entry.key, amount: total);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> chargebackTotals = _calculateChargebackTotals();
    int totalTransactions = chargebackTotals.values.fold(0, (sum, item) => sum + item);
    List<MapEntry<String, int>> entries = chargebackTotals.entries.where((entry) => entry.value > 0).toList();

    return Container(
      padding:  EdgeInsets.all(Responsive.padding(context, 3)),
      decoration: BoxDecoration(
          color: AppColors.darkBg2,
          borderRadius: BorderRadius.circular(Responsive.padding(context, 3)),
          border: Border.all(color: AppColors.grey2)
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate(widget.title),
            textAlign: TextAlign.start, // Ensures text itself aligns left
            style: getTextTheme().titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: Responsive.fontSize(context, 4.8),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildDropdownFilter(),
            ],
          ),

          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 300,
                padding: EdgeInsets.all(10),

                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                        setState(() {
                          if (event is FlTapUpEvent || event is FlTapDownEvent) {
                            if (pieTouchResponse != null && pieTouchResponse.touchedSection != null) {
                              touchedIndex = pieTouchResponse.touchedSection?.touchedSectionIndex??0;
                              tooltipPosition = event.localPosition!; // Update tooltip position
                            } else {
                              touchedIndex = -1; // Reset if not touching any section
                            }
                          }
                        });
                      },
                    ),
                    sections: _generatePieSections(entries, totalTransactions),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 70,
                  ),
                ),
              ),
              if (touchedIndex != -1 && touchedIndex < entries.length)
                _buildTooltip(
                  entries[touchedIndex].key,
                  entries[touchedIndex].value,
                  totalTransactions > 0
                      ? (entries[touchedIndex].value / totalTransactions * 100).toStringAsFixed(1)
                      : "0",
                  tooltipPosition, // Pass the tooltip position here
                ),
            ],
          ),
          const SizedBox(height: 10),
          _buildChargebackLegend(chargebackTotals, totalTransactions),
        ],
      ),
    );
  }
}
class LegendWidget extends StatelessWidget {
  final Color color;
  final String text;
  final int amount; // API value

  const LegendWidget({
    super.key,
    required this.color,
    required this.text,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Row(
          children: [
            CircleAvatar(
              radius: 6, // Small dot
              backgroundColor: color,
            ),
            const SizedBox(width: 4),
            Text(
              text, // Revenue, Refund, Void
              style: getTextTheme().labelSmall?.copyWith(
                fontSize: Responsive.fontSize(getCtx()!, 3),
                color: AppColors.text,
                fontWeight: FontHelper.semiBold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '\$${amount.toStringAsFixed(2)}', // Example: $500
          style: getTextTheme().labelSmall?.copyWith(
            fontSize: Responsive.fontSize(getCtx()!, 3),
            color: AppColors.text,
            fontWeight: FontHelper.semiBold,
          ),
        ),
      ],
    );
  }
}
