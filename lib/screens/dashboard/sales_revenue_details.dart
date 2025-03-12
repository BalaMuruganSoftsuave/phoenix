import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/nav_helper.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/models/bar_chart_model.dart';
import 'package:phoenix/models/line_chart_model.dart';
import 'package:phoenix/widgets/card_data_widget.dart';
import 'package:phoenix/widgets/charts/pieChart.dart';
import 'package:phoenix/widgets/charts/bar_chart.dart';
import 'package:phoenix/widgets/charts/line_chart.dart';
import 'package:phoenix/widgets/container_widget.dart';
import 'package:phoenix/widgets/gap/widgets/gap.dart';

class SalesRevenueDetails extends StatelessWidget {
   SalesRevenueDetails(LinkedHashMap<dynamic, dynamic>? args, {super.key}){
     if(args != null){
         isDirectSale = args["isDirectSale"];
         image = args["image"];
         title = args["title"];
         color = args["color"];
     }
   }
   var isDirectSale;
   var image;
   var title;
   var color;
  var data={
    "Result": [
      {
        "Range": "02/27 12AM",
        "DirectSale": 4591.18
      },
      {
        "Range": "02/27 1AM",
        "DirectSale": 2612.95
      },
      {
        "Range": "02/27 2AM",
        "DirectSale": 1748.67
      },
      {
        "Range": "02/27 3AM",
        "DirectSale": 2448.4
      },
      {
        "Range": "02/27 4AM",
        "DirectSale": 1778.07
      },
      {
        "Range": "02/27 5AM",
        "DirectSale": 2245.87
      },
      {
        "Range": "02/27 6AM",
        "DirectSale": 2827.08
      },
      {
        "Range": "02/27 7AM",
        "DirectSale": 3348.03
      },
      {
        "Range": "02/27 8AM",
        "DirectSale": 6104.15
      },
      {
        "Range": "02/27 9AM",
        "DirectSale": 7754.23
      },
      {
        "Range": "02/27 10AM",
        "DirectSale": 7805.91
      },
      {
        "Range": "02/27 11AM",
        "DirectSale": 8646.07
      },
      {
        "Range": "02/27 12PM",
        "DirectSale": 7262.01
      },
      {
        "Range": "02/27 1PM",
        "DirectSale": 7110.58
      },
      {
        "Range": "02/27 2PM",
        "DirectSale": 7833.08
      },
      {
        "Range": "02/27 3PM",
        "DirectSale": 8379.92
      },
      {
        "Range": "02/27 4PM",
        "DirectSale": 6479.04
      },
      {
        "Range": "02/27 5PM",
        "DirectSale": 6832.99
      },
      {
        "Range": "02/27 6PM",
        "DirectSale": 8841.81
      },
      {
        "Range": "02/27 7PM",
        "DirectSale": 6659.24
      },
      {
        "Range": "02/27 8PM",
        "DirectSale": 7872.16
      },
      {
        "Range": "02/27 9PM",
        "DirectSale": 8727.03
      },
      {
        "Range": "02/27 10PM",
        "DirectSale": 6844.15
      },
      {
        "Range": "02/27 11PM",
        "DirectSale": 7026.83
      }
    ]
  };
   List<Map<String, dynamic>> rawData = [
     {"Void": 0, "Range": "02/21", "Refund": 10043.5, "Revenue": 182327.05},
     {"Void": 0, "Range": "02/22", "Refund": 8124.91, "Revenue": 150270.88},
     {"Void": 37, "Range": "02/23", "Refund": 4857.19, "Revenue": 110804.4},
     {"Void": 0, "Range": "02/24", "Refund": 8626.84, "Revenue": 107813.33},
     {"Void": 66.84, "Range": "02/25", "Refund": 11591.73, "Revenue": 114784.71},
     {"Void": 22.9, "Range": "02/26", "Refund": 8514.03, "Revenue": 149069.58},
     {"Void": 0, "Range": "02/27", "Refund": 7117.65, "Revenue": 141883.33},
   ];

  @override
  Widget build(BuildContext context) {
    List<SalesData> salesDataList = (data["Result"] as List)
        .map((item) => SalesData.fromJson(item))
        .toList();
    LineChartModel chartModel = LineChartModel.fromSalesData(salesDataList);
    List<ChartData> processedData = processData(rawData);
    return Scaffold(
      backgroundColor: Color(0xFF0B111A),
      body: SafeArea(
          child: Column(
            children: [
              Container(
                height: Responsive.boxH(context, 10),
                color:  AppColors.backgroundGrey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){ back();}, icon: Icon(Icons.arrow_back,color: AppColors.white,)),
                    Spacer(),
                    CircleAvatar(
                      backgroundColor: color,
                      child: Padding(
                        padding: EdgeInsets.all(Responsive.padding(context, 2)),
                        child: SvgPicture.asset(
                          image,
                          width: Responsive.boxW(context, 5),
                          height: Responsive.boxH(context, 5),
                        ),
                      ),
                    ),
                    Gap(16),
                    Text(title,style: getTextTheme().bodyMedium?.copyWith(color: Colors.white,fontWeight: FontWeight.bold,fontSize: Responsive.fontSize(context, 5)),),
                    Spacer()
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal:Responsive.padding(context, 2)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        RenderSection(title: "", cards: [
                      CardData(
                        circleBgColor: isDirectSale?Color(0xFFC237F3): Color(0xFF05CD99),
                        title: isDirectSale?'Total Direct Sales': "Total Approved",
                        subtitle: "hg2hh",
                        // subtitle: getSubtitle(directSale['ApprovedOrders'] ?? 0, directSale['ApprovalPercentage'] ?? 0),
                        image: isDirectSale?Assets.imagesCartHold : Assets.imagesDone,
                        // Replace with actual image
                        isLoading: false,
                        isGlowing: false,
                        imageWidth: !isDirectSale?5:null,
                        imageHeight: !isDirectSale?5:null,
                        onPress: () {
                        },
                      ),
                      CardData(
                          circleBgColor: isDirectSale?Color(0xFF05CD99) : Color(0xFFE84040),
                          title: isDirectSale?'Unique Approval Ratio':'Total Declined',
                          subtitle: "sss",
                          // subtitle: getSubtitle(initialSubscription['ApprovedOrders'] ?? 0, initialSubscription['ApprovalPercentage'] ?? 0),
                          image: isDirectSale?Assets.imagesDocDone:Assets.imagesClose,
                          isLoading: false,
                          isGlowing: false,
                          imageWidth: !isDirectSale?5:null,
                          imageHeight: !isDirectSale?5:null,
                          onPress: () {}),
                      CardData(
                        circleBgColor: Color(0xFF6AD2FF),
                        title: isDirectSale?'Average Order Value':'Approval Ratio',
                        subtitle: "jj",
                        // subtitle: getSubtitle(recurringSubscription['ApprovedOrders'] ?? 0, recurringSubscription['ApprovalPercentage'] ?? 0),
                        image: Assets.imagesStatisticsGraph,
                        isLoading: false,
                        isGlowing: false,
                        imageWidth: 6,
                        imageHeight: 6,
                        onPress: () {},
                      ),
                      CardData(
                        circleBgColor: Color(0xFFF36337),
                        title: isDirectSale?'Abandon Cart Ratio':'Canceled Subscribers',
                        subtitle: "jj",
                        // subtitle: getSubtitle(subscriptionSalvage['ApprovedOrders'] ?? 0, subscriptionSalvage['ApprovalPercentage'] ?? 0),
                        image: isDirectSale?Assets.imagesCartHold: Assets.imagesCanceledSubscribers,
                        isLoading: false,
                        isGlowing: false,
                        imageWidth: !isDirectSale?6:null,
                        imageHeight: !isDirectSale?6:null,
                        onPress: () {},
                      ),
                    ]),
                        Gap(10),
                        isDirectSale ?
                            ContainerWidget(height: 60,widget: SalesRevenueChart(areaMap: true,chartModel: chartModel))

                        :ContainerWidget(
                            widget: BarChartWidget(chartData: processedData, barRadius: 50, barSpace:-1,)
                        ),
                        Gap(20),
                        isDirectSale ? ContainerWidget(
                            widget: BarChartWidget(chartData: processedData, barRadius: 10, barSpace:-1,)
                        )
                         :
                        SizedBox(
                          height: 500,
                          child: PieChartFilterWidget(title: "Decline Breakdown",),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          )),
    );
  }
}
