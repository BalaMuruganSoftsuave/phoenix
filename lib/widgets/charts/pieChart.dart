import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/models/dashboard/coverage_health_data_model.dart';
import 'package:phoenix/screens/dashboard/dashboard_screen.dart';
import 'package:phoenix/widgets/custom_single_selection_dropdown.dart';
import 'package:phoenix/widgets/loader.dart';

import '../../helper/color_helper.dart';
import '../../helper/responsive_helper.dart';
import '../../helper/utils.dart';
import 'legend_widget.dart';


class PieChartFilterWidget extends StatefulWidget {
  const PieChartFilterWidget(
      {super.key,
      required this.title,
      required this.transactions,
      this.isLoading = false});

  final String title;
  final bool isLoading;
  final List<CoverageHealthDataResult> transactions;

  @override
  PieChartFilterWidgetState createState() => PieChartFilterWidgetState();
}

class PieChartFilterWidgetState extends State<PieChartFilterWidget> {
  String selectedFilter = "All";
  int touchedIndex = -1;
  Offset tooltipPosition = Offset.zero;

  List<CoverageHealthDataResult> filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _filterData("All");
  }

  @override
  void didUpdateWidget(covariant PieChartFilterWidget oldWidget) {
    // TODO: implement didUpdateWidget
    _filterData("All");
    super.didUpdateWidget(oldWidget);
  }

  void _filterData(String filter) {
    setState(() {
      selectedFilter = filter;
      touchedIndex = -1;
      filteredTransactions = filter == "All"
          ? widget.transactions
          : widget.transactions
              .where((item) => item.cardType == filter)
              .toList();
    });
  }

  Map<String, int> _calculateChargebackTotals() {
    Map<String, int> chargebackCounts = {};
    for (var item in filteredTransactions) {
      String type = item.chargeBackType ?? "Unknown";
      int count = (item.approvedTransactions as num).toInt();
      chargebackCounts[type] = chargebackCounts.containsKey(type)
          ? chargebackCounts[type]! + count
          : count; // Add unknown types dynamically
    }
    return chargebackCounts;
  }

  Widget _buildDropdownFilter() {
    List<String> cardTypes = [
      "All",
      ...{...widget.transactions.map((t) => t.cardType ?? "")}
    ];
    return SingleSelectionDropDown(
        initiallySelectedKey: "All",
        items: cardTypes.map<CustomDataItems>((String value) {
          return CustomDataItems(
              id: value, name: value.toString().toTitleCase());
        }).toList(),
        onSelection: (newValue) {
          if (newValue.id != null) {
            _filterData(newValue.id ?? "");
          }
        });
  }

  List<PieChartSectionData> _generatePieSections(
      List<MapEntry<String, int>> entries, int total) {
    return List.generate(entries.length, (index) {
      int count = entries[index].value;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 65 : 60;
      return PieChartSectionData(
        value: count.toDouble(),
        title: '',
        color: colors[index],
        radius: radius.toDouble(),
      );
    });
  }

  Widget _buildTooltip(
      String chargebackType, int count, String percentage, Offset position) {
    return Positioned(
      left: position.dx, // Use the x-coordinate from the touch event
      top: position.dy, // Use the y-coordinate from the touch event
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


  Widget _buildChargebackLegend(Map<String, int> chargebackTotals, int total) {
    List<MapEntry<String, int>> entries = chargebackTotals.entries.toList();

    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: entries.map((entry) {
        double percentage = total > 0
            ? double.parse((entry.value / total * 100).toStringAsFixed(2))
            : 0.0;
        // Get index of entry
        int index = entries.indexOf(entry);
        return LegendWidget(
          color: colors[index % colors.length], // Use index for color cycling
          text: entry.key,
          subText: '${formatCurrency(entry.value.toDouble())} ($percentage%)',
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> chargebackTotals = _calculateChargebackTotals();
    int totalTransactions =
        chargebackTotals.values.fold(0, (sum, item) => sum + item);
    List<MapEntry<String, int>> entries =
        chargebackTotals.entries.where((entry) => entry.value > 0).toList();

    return Container(
      padding: EdgeInsets.all(Responsive.padding(context, 3)),
      decoration: BoxDecoration(
          color: AppColors.darkBg2,
          borderRadius: BorderRadius.circular(Responsive.padding(context, 3)),
          border: Border.all(color: AppColors.grey2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  translate(widget.title),
                  textAlign: TextAlign.start, // Ensures text itself aligns left
                  style: getTextTheme().titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: Responsive.fontSize(context, 4.8),
                      ),
                ),
              ),
              if (widget.transactions.isNotEmpty) _buildDropdownFilter(),
            ],
          ),
          const SizedBox(height: 10),
          if (widget.isLoading) ...[Loader()],
          if (!widget.isLoading && widget.transactions.isEmpty) ...[
            NoDataWidget()
          ],
          if (!widget.isLoading && widget.transactions.isNotEmpty) ...[
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 300,
                  padding: EdgeInsets.all(10),
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event,
                            PieTouchResponse? pieTouchResponse) {
                          setState(() {
                            if (event is FlTapUpEvent ||
                                event is FlTapDownEvent) {
                              if (pieTouchResponse != null &&
                                  pieTouchResponse.touchedSection != null) {
                                touchedIndex = pieTouchResponse
                                        .touchedSection?.touchedSectionIndex ??
                                    0;
                                tooltipPosition = event
                                    .localPosition!; // Update tooltip position
                              } else {
                                touchedIndex =
                                    -1; // Reset if not touching any section
                              }
                            }
                          });
                        },
                      ),
                      sections:
                          _generatePieSections(entries, totalTransactions),
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
                        ? (entries[touchedIndex].value /
                                totalTransactions *
                                100)
                            .toStringAsFixed(1)
                        : "0",
                    tooltipPosition, // Pass the tooltip position here
                  ),
              ],
            ),
            const SizedBox(height: 10),
            _buildChargebackLegend(chargebackTotals, totalTransactions),
          ],
        ],
      ),
    );
  }
}
