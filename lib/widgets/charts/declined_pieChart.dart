import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/models/dashboard/detail_chart_data_model.dart';
import 'package:phoenix/widgets/charts/legend_widget.dart';
import 'package:phoenix/widgets/container_widget.dart';
import 'package:phoenix/widgets/custom_single_selection_dropdown.dart';
import 'package:phoenix/widgets/legend_widget.dart';
import 'package:phoenix/widgets/loader.dart';

import '../../helper/dependency.dart';
import '../../helper/responsive_helper.dart';
import '../../helper/utils.dart';

class PieChartWidget extends StatefulWidget {
  final String title;
  final bool isLoading;
  final bool isFilterDropdownNeeded;
  final List<DetailChartDeclinedBreakDownDataResult> data;

  const PieChartWidget({
    super.key,
    required this.title,
    required this.data,
    this.isLoading = false,
    this.isFilterDropdownNeeded = true,
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

    return ContainerWidget(
      title: widget.title,
      childWidget: (widget.data.isNotEmpty&& widget.isFilterDropdownNeeded) ? _buildDropdown() : null,
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isLoading)
            const Center(child: Loader())
          else if (entries.isEmpty)
             Center(child: Text("No data available",style: getTextTheme().bodyMedium?.copyWith(color: Colors.white),))
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
          style: getTextTheme().bodyMedium?.copyWith(
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
      maxHeight:
          Responsive.screenH(context, DeviceType.isMobile(context) ? 15 : 12),
      initiallySelectedKey: selectedFilter,
      items: ["All", "Cancelled"].map((String value) {
        return CustomDataItems(
          id: value,
          name: value,
        );
      }).toList(),
      onSelection: (value) {
        setState(() {
          selectedFilter = value.id ?? "";
        });
      },
      // dropdownColor: AppColors.darkBg2,
    );
  }

  // ✅ Generate Pie Chart
  Widget _buildChart(List<MapEntry<String, int>> entries, int total) {
    colors =
        widget.data.isNotEmpty ? generateRandomColors(widget.data.length) : [];

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: Responsive.screenH(context, 40),
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback:
                    (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
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
              centerSpaceRadius:DeviceType.isMobile(context)? 60:80,
              sectionsSpace: 0,
            ),
          ),
        ),
        if (touchedIndex != -1 && touchedIndex < entries.length)
          _buildTooltip(
            context,
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
    entries.sort((a, b) => b.value.compareTo(a.value));
    return List.generate(entries.length, (index) {
      final isTouched = index == touchedIndex;
      final radius = isTouched ? DeviceType.isMobile(context)? 65:120 : DeviceType.isMobile(context)? 60:100;
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
  Widget _buildTooltip(BuildContext context,
      String label, int value, String percentage, Offset position) {
    var width = MediaQuery.sizeOf(context).width - position.dx;
    return Positioned(
      left: width > 180 ? position.dx : position.dx - width*1.2,
      top: position.dy, // Center vertically
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.darkBg,
          border: Border.all(color: AppColors.text),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          "$label\n$value ($percentage%)",
          style: getTextTheme()
              .bodyMedium
              ?.copyWith(color: Colors.white, fontSize: Responsive.fontSize(context, 3),),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ✅ Legend for chart data
  Widget _buildLegend(List<MapEntry<String, int>> entries, int total) {
    entries.sort((a, b) => b.value.compareTo(a.value));

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: entries.map((entry) {
            double percentage = total > 0
                ? double.parse((entry.value / total * 100).toStringAsFixed(2))
                : 0.0;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IntrinsicWidth(
                child: LegendWidget(
                  text: entry.key,
                  subText: "${entry.value} ($percentage%)",
                  color: _getColor(entries.indexOf(entry)),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ✅ Get color for each section
  Color _getColor(int index) {
    if (colors.isEmpty) return Colors.grey;
    return colors[index % colors.length];
  }
}
