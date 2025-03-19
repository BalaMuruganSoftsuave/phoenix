import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix/cubit/notification/notification_cubit.dart';
import 'package:phoenix/helper/color_helper.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/models/notification/notification_list_model.dart';
import 'package:phoenix/widgets/gap/widgets/gap.dart';

class NotificationListWidget extends StatefulWidget {
  const NotificationListWidget({super.key});

  @override
  _NotificationListWidgetState createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget> {
  final List<NotificationListResult> _notifications = [];
  int _page = 0;
  bool _isLoading = false;
  bool _hasMoreData = true;
  final ScrollController _scrollController = ScrollController();
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMoreData) {
        _fetchNotifications();
      }
    });
  }

  Future<void> _fetchNotifications() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      NotificationListResponse? response = await context
          .read<NotificationCubit>()
          .getNotificationList(context, _page);

      if (response != null) {
        setState(() {
          _notifications.addAll(response.result ?? []);
          _page++;
        });
      } else {
        _hasMoreData = false;
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleExpand(int index) {
    setState(() {
      _expandedIndex = (_expandedIndex == index) ? null : index;
    });
  }

  Map<String, List<NotificationListResult>> _groupNotifications() {
    final Map<String, List<NotificationListResult>> grouped = {
      'Today': [],
      'Yesterday': [],
      'This Week': [],
      'Last Week': [],
      'This Month': [],
      'Last Month': [],
      'Older': []
    };

    DateTime now = DateTime.now();

    for (var notification in _notifications) {
      DateTime createdAt =
          DateTime.parse(notification.createdAt ?? "").toLocal();

      if (createdAt.year == now.year &&
          createdAt.month == now.month &&
          createdAt.day == now.day) {
        grouped['Today']!.add(notification);
      } else if (createdAt.year == now.year &&
          createdAt.month == now.month &&
          createdAt.day == now.day - 1) {
        grouped['Yesterday']!.add(notification);
      } else if (createdAt.isAfter(now.subtract(Duration(days: now.weekday)))) {
        grouped['This Week']!.add(notification);
      } else if (createdAt
          .isAfter(now.subtract(Duration(days: now.weekday + 7)))) {
        grouped['Last Week']!.add(notification);
      } else if (createdAt.year == now.year && createdAt.month == now.month) {
        grouped['This Month']!.add(notification);
      } else if (createdAt.year == now.year &&
          createdAt.month == now.month - 1) {
        grouped['Last Month']!.add(notification);
      } else {
        grouped['Older']!.add(notification);
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = _groupNotifications();
    final sectionHeaders = groupedNotifications.keys
        .where((key) => groupedNotifications[key]!.isNotEmpty)
        .toList();

    return RefreshIndicator(
      onRefresh: (){
        _page=0;
        return _fetchNotifications();
      } ,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: sectionHeaders.fold<int>(
              0,
              (total, key) => total + groupedNotifications[key]!.length + 1,
            ) +
            (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          int currentIndex = 0;

          for (var header in sectionHeaders) {
            // Render section header
            if (index == currentIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  header,
                  style: getTextTheme().bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.subText),
                ),
              );
            }
            currentIndex++;

            // Render items within the section
            for (var notification in groupedNotifications[header]!) {
              if (index == currentIndex) {
                return _buildNotificationItem(notification, currentIndex);
              }
              currentIndex++;
            }
          }

          // Render loading indicator at the end
          if (_isLoading && index == currentIndex) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: Colors.pink),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNotificationItem(
      NotificationListResult notification, int index) {
    bool isExpanded = (_expandedIndex == index);

    return GestureDetector(
      onTap: () => _toggleExpand(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.darkBg2,
          border: Border.all(color: AppColors.subText.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 13.0),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: const Icon(Icons.circle, color: Colors.green, size: 10),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title ?? "",
                                style: getTextTheme().bodyMedium?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                              ),
                              Gap(8),
                              Text(
                                notification.body ?? "",
                                style: getTextTheme()
                                    .bodyMedium
                                    ?.copyWith(fontSize: 12, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      timeAgo(notification.createdAt ?? ""),
                      style: getTextTheme()
                          .bodyMedium
                          ?.copyWith(color: AppColors.grey, fontSize: 11),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 28,
                      color: Colors.grey,
                    ),
                  ],
                ),

              ],
            ),


if(!isExpanded)
SizedBox(height: 10,),
            // Expanded content
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SmallContainerWidget(
                        text1: 'Subscription Count',
                        text2: '${notification.metadata?.count ?? 0}',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SmallContainerWidget(
                        text1: 'Subscription Amount',
                        text2: '${notification.metadata?.amount ?? 0}',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class SmallContainerWidget extends StatelessWidget {
  final String text1;
  final String text2;

  const SmallContainerWidget({
    super.key,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.darkBg2.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text1,
            style: getTextTheme()
                .bodyMedium
                ?.copyWith(color: AppColors.text, fontSize: 12,fontWeight: FontWeight.w600),
          ),
          Text(
            text2,
            style: getTextTheme()
                .bodyMedium
                ?.copyWith(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
