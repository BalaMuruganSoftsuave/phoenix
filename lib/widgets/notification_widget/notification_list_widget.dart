import 'package:flutter/material.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/widgets/notification_widget/small_container_widget.dart';

class NotificationListWidget extends StatefulWidget {
  final String title;
  final String time;
  final String description;

  const NotificationListWidget({
    Key? key,
    required this.title,
    required this.time,
    required this.description,
  }) : super(key: key);

  @override
  _NotificationListWidgetState createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget> {
  int? _expandedIndex;

  void toggleExpand(int index) {
    setState(() {
      _expandedIndex = (_expandedIndex == index) ? null : index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(right: 16,left: 10),
      itemCount: 10,
      itemBuilder: (context, index) {
        bool isExpanded = (_expandedIndex == index);
        return GestureDetector(
          onTap: () => toggleExpand(index),
          child: AnimatedContainer(
              duration: Duration(seconds: 1),
              padding: EdgeInsets.only(top:5,right: 12,bottom: 10,left: 12),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.darkBg2,
                border: Border.all(color: AppColors.borderColor, width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.circle, color: AppColors.successGreen, size: 10),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.time,
                                  style: TextStyle(color: AppColors.subText, fontSize: 10),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    size: 28,
                                    color: AppColors.subText,
                                  ),
                                  onPressed: () => toggleExpand(index),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 20,),
                                Text(
                                  widget.description,
                                  style: TextStyle(fontSize: 12, color: AppColors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SmallContainerWidget(
                              text1: TextHelper.subscriptionCount,
                              text2: '34',
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: SmallContainerWidget(
                              text1: TextHelper.subscriptionAmount,
                              text2: '4,023',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        );
      },
    );
  }
}
