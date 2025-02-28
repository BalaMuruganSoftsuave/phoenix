import 'package:flutter/material.dart';


class WeekRowWidget extends StatelessWidget {
  const WeekRowWidget(this.widthGreaterThan200, {super.key, this.weekRowTextColor, this.labelTextStyle});
  final bool widthGreaterThan200;
  final Color? weekRowTextColor;
  final TextStyle? labelTextStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        WeekNameWidget(name: "Su", widthGreaterThan200: widthGreaterThan200,weekRowTextColor: weekRowTextColor,labelTextStyle: labelTextStyle,),
        WeekNameWidget(name: "Mo", widthGreaterThan200: widthGreaterThan200,weekRowTextColor: weekRowTextColor,labelTextStyle: labelTextStyle,),
        WeekNameWidget(name: "Tu", widthGreaterThan200: widthGreaterThan200,weekRowTextColor: weekRowTextColor,labelTextStyle: labelTextStyle,),
        WeekNameWidget(name: "We", widthGreaterThan200: widthGreaterThan200,weekRowTextColor: weekRowTextColor,labelTextStyle: labelTextStyle,),
        WeekNameWidget(name: "Th", widthGreaterThan200: widthGreaterThan200,weekRowTextColor: weekRowTextColor,labelTextStyle: labelTextStyle,),
        WeekNameWidget(name: "Fr", widthGreaterThan200: widthGreaterThan200,weekRowTextColor: weekRowTextColor,labelTextStyle: labelTextStyle,),
        WeekNameWidget(name: "Sa", widthGreaterThan200: widthGreaterThan200,weekRowTextColor: weekRowTextColor,labelTextStyle: labelTextStyle,)
      ],
    );
  }
}

class WeekNameWidget extends StatelessWidget {
  const WeekNameWidget({
    required this.name,
    required this.widthGreaterThan200,
    super.key, this.weekRowTextColor, this.labelTextStyle,
  });

  final String name;
  final bool widthGreaterThan200;
  final Color? weekRowTextColor;
  final TextStyle? labelTextStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: labelTextStyle ?? TextStyle(
          fontSize: 18, color: weekRowTextColor??Colors.black,fontWeight: FontWeight.bold),
    );
  }
}
