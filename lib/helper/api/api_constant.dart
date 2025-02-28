class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://dev-api.phoenixcrm.io/portal/api/';
  static const String localUrl = 'https://915c-14-97-127-234.ngrok-free.app/portal/api/';

  // Authentication
  static const String loginUrl = '${baseUrl}auth/login';
  static const String refreshToken = '${baseUrl}auth/refresh_token';
  static const String getPermissions = '${baseUrl}auth/permissions';

  // Dashboard Endpoints
  static const String getDirectSale = '${baseUrl}overview/direct_sale';
  static const String getInitialSubscription = '${baseUrl}overview/initial_subscription';
  static const String getSubscriptionSalvage = '${baseUrl}overview/subscription_salvage';
  static const String getSubscriptionBill = '${baseUrl}overview/subscription_to_bill';
  static const String getRecurringSubscription = '${baseUrl}overview/recurring_subscription';
  static const String getUpsell = '${baseUrl}overview/upsell';
  static const String getTotalTransactions = '${baseUrl}overview/transactions/total';
  static const String getRefundTransactions = '${baseUrl}overview/transactions/refund';
  static const String getChargebackTransactions = '${baseUrl}overview/transactions/chargeback';
  static const String getLifetime = '${baseUrl}overview/life_time';
  static const String getNetSubscribers = '${baseUrl}overview/net_subscribers';
  static const String getTotalSalesRevenue = '${baseUrl}overview/total_sales_revenue';
  static const String getChargebackSummary = '${baseUrl}overview/chargeback_summary';
  static const String getCoverageHealth = '${baseUrl}overview/coverage_health';
  static const String getRefundRatio = '${baseUrl}overview/refund_ratio';

  // Dashboard Details
  static const String getDirectSalesRevenue = '${baseUrl}overview/direct-sales-revenue';
  static const String getDirectSaleDetail = '${baseUrl}overview/direct_sale';
  static const String getDirectSaleUniqueApprovalRatio = '${baseUrl}overview/unique-approval-ratio';
  static const String getDirectSaleOrders = '${baseUrl}overview/direct-sale-orders';

  static const String getInitialSubscriptionDeclinedBreakdown = '${baseUrl}overview/initial-subscription/declined-break-down';
  static const String getInitialSubscriptionDetails = '${baseUrl}overview/initial_subscription/details';
  static const String getInitialSubscriptionApprovalRatio = '${baseUrl}overview/initial-subscription-approval-ratio';
  static const String getInitialSubscriptionOrders = '${baseUrl}overview/initial-subscription-orders';

  static const String getRecurringSubscriptionDeclinedBreakdown = '${baseUrl}overview/recurring-subscription-decline';
  static const String getRecurringSubscriptionDetails = '${baseUrl}overview/recurring_subscription';
  static const String getRecurringSubscriptionApprovalRatio = '${baseUrl}overview/recurring/unique-approval-ratio';
  static const String getRecurringSubscriptionOrders = '${baseUrl}overview/recurring-subscription-list';

  static const String getSubscriptionSalvageDeclinedBreakdown = '${baseUrl}overview/subscription-salvage-decline';
  static const String getSubscriptionSalvageDetails = '${baseUrl}overview/subscription_salvage';
  static const String getSubscriptionSalvageApprovalRatio = '${baseUrl}overview/salvage/unique-approval-ratio';
  static const String getSubscriptionSalvageOrders = '${baseUrl}overview/subscription-salvage-list';

  // Notifications
  static const String getNotificationConfiguration = '${baseUrl}notifications/config';
  static const String setNotificationConfiguration = '${baseUrl}notifications/config';
  static const String getNotificationAll = '${baseUrl}notifications/all';
}
