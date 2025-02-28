import 'package:flutter/material.dart';
import 'package:phoenix/generated/assets.dart';
import 'package:phoenix/helper/dependency.dart';
import 'package:phoenix/helper/responsive_helper.dart';
import 'package:phoenix/helper/text_helper.dart';
import 'package:phoenix/helper/utils.dart';
import 'package:phoenix/widgets/card_data_widget.dart';

class DashBoardFirstDataWidget extends StatelessWidget {
  const DashBoardFirstDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RenderSection(title: "", cards: [
      CardData(
        circleBgColor: Color(0xFFF90182),
        title: 'Direct Sale',
        subtitle: "hghh",
        // subtitle: getSubtitle(directSale['ApprovedOrders'] ?? 0, directSale['ApprovalPercentage'] ?? 0),
        image: Assets.imagesDirectSale,
        // Replace with actual image
        isLoading: false,
        onPress: () {},
      ),
      CardData(
          circleBgColor: Color(0xFFC237F3),
          title: 'Initial Subscription',
          subtitle: "sss",
          // subtitle: getSubtitle(initialSubscription['ApprovedOrders'] ?? 0, initialSubscription['ApprovalPercentage'] ?? 0),
          image: Assets.imagesInitialSubscription,
          isLoading: false,
          onPress: () {}),
      CardData(
        circleBgColor: Color(0xFF05CD99),
        title: 'Recurring Subscription',
        subtitle: "jj",
        // subtitle: getSubtitle(recurringSubscription['ApprovedOrders'] ?? 0, recurringSubscription['ApprovalPercentage'] ?? 0),
        image: Assets.imagesRecurringSubscription,
        isLoading: false,
        onPress: () {},
      ),
      CardData(
        circleBgColor: Color(0xFF6AD2FF),
        title: 'Subscription Salvage',
        subtitle: "jj",
        // subtitle: getSubtitle(subscriptionSalvage['ApprovedOrders'] ?? 0, subscriptionSalvage['ApprovalPercentage'] ?? 0),
        image: Assets.imagesSubscriptionSalvage,
        isLoading: false,
        onPress: () {},
      ),
      CardData(
        circleBgColor: Color(0xFFF36337),
        title: 'Upsell',
        subtitle: "jj",
        // subtitle: getSubtitle(upsell['ApprovedOrders'] ?? 0, upsell['ApprovalPercentage'] ?? 0),
        image: Assets.imagesUpsell,
        isLoading: false,
      ),
      CardData(
        circleBgColor: Color(0xFFC237F3),
        title: 'Subscription to Bill',
        subtitle: "jj",
        // subtitle: getSubtitle(subscriptionBill['ApprovedOrders'] ?? 0, subscriptionBill['ApprovalPercentage'] ?? 0),
        image: Assets.imagesSubscriptionToBill,
        isLoading: false,
      ),
    ]);
  }
}

class TransactionDataWidget extends StatelessWidget {
  const TransactionDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: Responsive.padding(context, 2)),
      child: RenderSection(title: "Sep 2023", cards: [
        CardData(
          circleBgColor: Color(0xFFC237F3),
          title: 'Total Transactions',
          subtitle: 100 > 0 ? formatNumber(100) : '-',
          image: Assets.imagesTotalTransactions, // Replace with actual asset
          isLoading: false,
        ),
        CardData(
          circleBgColor: Color(0xFFE84040),
          title: 'Refunds',
          subtitle: getSubtitle(
            100,
            percentage(10, 100),
          ),
          image: Assets.imagesRefundRatio,
          isLoading: false,      ),
        CardData(
          circleBgColor: Color(0xFFF36337),
          title: 'Chargebacks',
          subtitle: getSubtitle(
            100,
            percentage(10, 100),
          ),
          image: Assets.imagesChargebackRatio,
          isLoading: false,      ),
      ]),
    );
  }
}

class LifeTimeDataWidget extends StatelessWidget {
  const LifeTimeDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: Responsive.padding(context, 2)),
      child: RenderSection(title: translate(TextHelper.lifetime), cards: [
        CardData(
          circleBgColor: const Color(0xFFC237F3),
          title: "Active Subscribers",
          subtitle: "100",
          // subtitle: formatNumber(lifeTimeData?["ActiveSubscriptions"] ?? 0),
          image: Assets.imagesActiveSubscribers,
          isLoading: false,
        ),
        CardData(
          circleBgColor: const Color(0xFFE84040),
          title: "Subscribers in Salvage",
          subtitle: "100",
          // subtitle: formatNumber(lifeTimeData?["SubscriptionInSalvage"] ?? 0),
          image: Assets.imagesSubscriptionSalvage,
          isLoading: false,
        ),
        CardData(
          circleBgColor: const Color(0xFFF36337),
          title: "Canceled Subscribers",
          subtitle: "100",
          // subtitle: formatNumber(lifeTimeData?["CancelledSubscriptions"] ?? 0),
          image: Assets.imagesCanceledSubscribers,
          isLoading: false,
        ),
      ]),
    );
  }
}
