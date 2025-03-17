import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/models/dashboard/detail_chart_data_model.dart';
import 'package:phoenix/widgets/custom_single_selection_dropdown.dart';
import 'package:phoenix/widgets/loader.dart';

import '../../helper/color_helper.dart';
import '../../helper/dependency.dart';
import '../../helper/responsive_helper.dart';
import '../../helper/utils.dart';

class PieChartWidget extends StatefulWidget {
  final String title;
  final bool isLoading;
  final List<DetailChartDeclinedBreakDownDataResult> data;

  const PieChartWidget({
    super.key,
    required this.title,
    required this.data,
    this.isLoading = false,
  });

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;
  Offset tooltipPosition = Offset.zero;
  late List<Color> colors;
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    // ✅ Separate All and Cancelled Data
    List<DetailChartDeclinedBreakDownDataResult> filteredData =
    widget.data.where((entry) {
      if (selectedFilter == "Cancelled") {
        return entry.cancelled == 1;
      } else {
        return entry.cancelled == 0;
      }
    }).toList();

    // ✅ Group data and calculate total
    Map<String, int> chartData = {};
    int total = 0;

    for (var entry in filteredData) {
      String reason = entry.reason;
      int value = entry.value;

      if (value > 0) {
        chartData[reason] = (chartData[reason] ?? 0) + value;
        total += value;
      }
    }

    List<MapEntry<String, int>> entries =
    chartData.entries.where((entry) => entry.value > 0).toList();

    return Container(
      padding: EdgeInsets.all(Responsive.padding(context, 3)),
      decoration: BoxDecoration(
        color: AppColors.darkBg2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(widget.title),
          const SizedBox(height: 10),
          if (widget.isLoading)
            const Center(child: Loader())
          else if (entries.isEmpty)
            const Center(child: Text("No data available"))
          else ...[
              _buildChart(entries, total),
              const SizedBox(height: 10),
              _buildLegend(entries, total),
            ],
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          translate(title),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        if (widget.data.isNotEmpty) _buildDropdown(),
      ],
    );
  }

  // ✅ Dropdown Filter
  Widget _buildDropdown() {
    return SingleSelectionDropDown(
      maxHeight: 100,
      initiallySelectedKey: selectedFilter,
      items: ["All", "Cancelled"].map((String value) {
        return CustomDataItems(
          id: value,
          name: value,
        );
      }).toList(),
      onSelection: (value) {
        setState(() {
          selectedFilter = value.id??"";
        });
      },
      // dropdownColor: AppColors.darkBg2,
    );
  }

  // ✅ Generate Pie Chart
  Widget _buildChart(List<MapEntry<String, int>> entries, int total) {
    colors = widget.data.isNotEmpty
        ? generateRandomColors(widget.data.length)
        : [];

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: Responsive.screenH(context, 30),
          child: PieChart(
            PieChartData(

              pieTouchData: PieTouchData(

                touchCallback: (FlTouchEvent event,
                    PieTouchResponse? pieTouchResponse) {
                  setState(() {
                    if (event is FlTapUpEvent || event is FlTapDownEvent) {
                      if (pieTouchResponse != null &&
                          pieTouchResponse.touchedSection != null) {
                        touchedIndex = pieTouchResponse
                            .touchedSection?.touchedSectionIndex ??
                            -1;
                        tooltipPosition = event.localPosition!;
                      } else {
                        touchedIndex = -1;
                      }
                    }
                  });
                },
              ),

              sections: _generatePieSections(entries, total),
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 40,
              sectionsSpace: 0,
            ),
          ),
        ),
        if (touchedIndex != -1 && touchedIndex < entries.length)
          _buildTooltip(
            entries[touchedIndex].key,
            entries[touchedIndex].value,
            total > 0
                ? ((entries[touchedIndex].value / total) * 100)
                .toStringAsFixed(1)
                : "0",
            tooltipPosition,
          ),
      ],
    );
  }

  List<PieChartSectionData> _generatePieSections(
      List<MapEntry<String, int>> entries, int total) {
    return List.generate(entries.length, (index) {
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 65 : 60;
      final entry = entries[index];

      return PieChartSectionData(
        value: entry.value.toDouble(),
        showTitle: false,
        color: _getColor(index),
        radius: radius.toDouble(),
      );
    });
  }

  // ✅ Tooltip for chart sections
  Widget _buildTooltip(
      String label, int value, String percentage, Offset position) {
    return Positioned(
      left: position.dx  ,
      top: position.dy  , // Center vertically
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          "$label\n$value ($percentage%)",
          style: const TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ✅ Legend for chart data
  Widget _buildLegend(List<MapEntry<String, int>> entries, int total) {
    entries.sort((a, b) => b.value.compareTo(a.value));

  return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: entries.map((entry) {
          double percentage = total > 0
              ? double.parse((entry.value / total * 100).toStringAsFixed(2))
              : 0.0;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // ✅ Align items to the start
              children: [
                // ✅ Color and Text on Top
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height:30,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: _getColor(entries.indexOf(entry)),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      entry.key,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // ✅ Value and Percentage aligned to the start
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Align to start
                  children: [
                    Text(
                      "     ${entry.value} ",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      "($percentage%)",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ✅ Get color for each section
  Color _getColor(int index) {
    if (colors.isEmpty) return Colors.grey;
    return colors[index % colors.length];
  }
}
