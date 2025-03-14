// import 'package:flutter/material.dart';
// import 'package:phoenix/helper/font_helper.dart';
// import 'package:phoenix/helper/responsive_helper.dart';
// import 'package:phoenix/models/line_chart_model.dart';
//
// import '../widgets/card_data_widget.dart';
// import '../widgets/charts/line_chart.dart';
//
// class DashboardScreen extends StatelessWidget {
//    DashboardScreen({super.key});
//   // final List<String> icons = [
//   //   'assets/Icons/detail.png',
//   //   'assets/Icons/initial.png',
//   //   'assets/Icons/recurring.png',
//   //   'assets/Icons/subscription.png',
//   //   'assets/Icons/upsell.png',
//   //   'assets/Icons/bill.png',
//   // ];
//
//
//    var data={
//      "Result": [
//        {
//          "Range": "02/25 12AM",
//          "DirectSale": 2910.12,
//          "UpsellSale": 0,
//          "InitialSale": 519.82,
//          "RecurringSale": 2515.31,
//          "SalvageSale": 179.95
//        },
//        {
//          "Range": "02/25 1AM",
//          "DirectSale": 2007.04,
//          "UpsellSale": 0,
//          "InitialSale": 559.8,
//          "RecurringSale": 6470.95,
//          "SalvageSale": 39.99
//        },
//        {
//          "Range": "02/25 2AM",
//          "DirectSale": 1937.92,
//          "UpsellSale": 0,
//          "InitialSale": 276.92,
//          "RecurringSale": 834.76,
//          "SalvageSale": 39.99
//        },
//        {
//          "Range": "02/25 3AM",
//          "DirectSale": 1321.69,
//          "UpsellSale": 0,
//          "InitialSale": 159.95,
//          "RecurringSale": 1045.72,
//          "SalvageSale": 0
//        },
//        {
//          "Range": "02/25 4AM",
//          "DirectSale": 898.74,
//          "UpsellSale": 0,
//          "InitialSale": 219.92,
//          "RecurringSale": 1125.74,
//          "SalvageSale": 39.99
//        },
//        {
//          "Range": "02/25 5AM",
//          "DirectSale": 2709.01,
//          "UpsellSale": 0,
//          "InitialSale": 119.96,
//          "RecurringSale": 991.77,
//          "SalvageSale": 0
//        },
//        {
//          "Range": "02/25 6AM",
//          "DirectSale": 1392.53,
//          "UpsellSale": 0,
//          "InitialSale": 179.94,
//          "RecurringSale": 888.8,
//          "SalvageSale": 0
//        },
//        {
//          "Range": "02/25 7AM",
//          "DirectSale": 3030.47,
//          "UpsellSale": 0,
//          "InitialSale": 369.88,
//          "RecurringSale": 1409.67,
//          "SalvageSale": 0
//        },
//        {
//          "Range": "02/25 8AM",
//          "DirectSale": 3848.41,
//          "UpsellSale": 0,
//          "InitialSale": 376.88,
//          "RecurringSale": 2412.33,
//          "SalvageSale": 0
//        },
//        {
//          "Range": "02/25 9AM",
//          "DirectSale": 5688.34,
//          "UpsellSale": 0,
//          "InitialSale": 649.79,
//          "RecurringSale": 3080.19,
//          "SalvageSale": 119.97
//        },
//        {
//          "Range": "02/25 10AM",
//          "DirectSale": 4488.93,
//          "UpsellSale": 0,
//          "InitialSale": 699.77,
//          "RecurringSale": 2929.34,
//          "SalvageSale": 0
//        },
//        {
//          "Range": "02/25 11AM",
//          "DirectSale": 1974.32,
//          "UpsellSale": 0,
//          "InitialSale": 179.94,
//          "RecurringSale": 1048.72,
//          "SalvageSale": 0
//        }
//      ]
//    };
//    @override
//    Widget build(BuildContext context) {
//      List<SalesData> salesDataList = (data["Result"] as List)
//          .map((item) => SalesData.fromJson(item))
//          .toList();
//      LineChartModel chartModel = LineChartModel.fromSalesData(salesDataList);
//      return Scaffold(
//        backgroundColor: Color(0xFF0B111A),
//        appBar: AppBar(),
//        body: SingleChildScrollView( // Allows entire screen to scroll
//          child: Padding(
//            padding: EdgeInsets.all(10), // Adjust padding
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: [
//                // First ListView
//                ListView.builder(
//                  itemCount: 6,
//                  shrinkWrap: true, // Important: prevents infinite height
//                  physics: NeverScrollableScrollPhysics(), // Prevents nested scrolling
//                  itemBuilder: (context, index) {
//                    return CardData("leading", "title", "subtitle");
//                  },
//                ),
//                 SizedBox(height: 30),
//                // Second Container Inside Column
//                Container(
//                  padding: EdgeInsets.all(10),
//                  decoration: BoxDecoration(
//                    border: Border.all(color: Color(0x33A3AED0), width: 0.5),
//                    borderRadius: BorderRadius.circular(15),
//                  ),
//                  child: Column(
//                    children: [
//                      Align(
//                        alignment: Alignment.topLeft,
//                        child: Text(
//                          "February 2024",
//                          style: TextStyle(color: Colors.white),
//                        ),
//                      ),
//                      ListView.builder(
//                        itemCount: 3,
//                        shrinkWrap: true, // Important
//                        physics: NeverScrollableScrollPhysics(),
//                        itemBuilder: (context, index) {
//                          return card("leading", "title", "subtitle");
//                        },
//                      ),
//                    ],
//                  ),
//                ),
//                SizedBox(height: 30),
//
//                Container(
//                  padding: EdgeInsets.all(10),
//                  decoration: BoxDecoration(
//                    border: Border.all(color: Color(0x33A3AED0), width: 0.5),
//                    borderRadius: BorderRadius.circular(15),
//                  ),
//                  child: Column(
//                    children: [
//                      Align(
//                        alignment: Alignment.topLeft,
//                        child: Text(
//                          "February 2024",
//                          style: TextStyle(color: Colors.white),
//                        ),
//                      ),
//                      ListView.builder(
//                        itemCount: 3,
//                        shrinkWrap: true, // Important
//                        physics: NeverScrollableScrollPhysics(),
//                        itemBuilder: (context, index) {
//                          return   card("leading", "title", "subtitle");
//                          ;
//                        },
//                      ),
//                    ],
//                  ),
//                ),
//
//                SizedBox(
//                  height: 300,
//                    child: SalesRevenueChart(areaMap: false,chartModel: chartModel)
//                ) ,
//                SizedBox(height: 20),
//                SizedBox(
//                  height: 300,
//                    child: SalesRevenueChart(areaMap: true,chartModel: chartModel)
//                ),
//
//
//              ],
//            ),
//          ),
//        ),
//      );
//    }
// }
