class ApiConstants {
  // Base URLs
  // static const String baseUrl = 'https://dev-api.phoenixcrm.io/portal/api/';
  static const String baseUrl = 'https://api.phoenixcrm.io/portal/api/';
  // static const String baseUrl = 'https://staging-api.phoenixcrm.io/portal/api/';

  static const String localUrl = 'https://915c-14-97-127-234.ngrok-free.app/portal/api/';
  static const String refactorOverview = 'refactor_overview';

  // Authentication
  static const String loginUrl = '${baseUrl}auth/login';
  static const String refreshToken = '${baseUrl}auth/refresh_token';
  static const String getPermissions = '${baseUrl}auth/permissions';

  // Dashboard Endpoints
  static const String getDirectSale = '$baseUrl$refactorOverview/direct_sale';
  static const String getInitialSubscription = '$baseUrl$refactorOverview/initial_subscription';
  static const String getSubscriptionSalvage = '$baseUrl$refactorOverview/subscription_salvage';
  static const String getSubscriptionBill = '$baseUrl$refactorOverview/subscription_to_bill';
  static const String getRecurringSubscription = '$baseUrl$refactorOverview/recurring_subscription';
  static const String getUpsell = '$baseUrl$refactorOverview/upsell';
  static const String getTotalTransactions = '$baseUrl$refactorOverview/transactions/total';
  static const String getRefundTransactions = '$baseUrl$refactorOverview/transactions/refund';
  static const String getChargebackTransactions = '$baseUrl$refactorOverview/transactions/chargeback';
  static const String getLifetime = '$baseUrl$refactorOverview/life_time';
  static const String getNetSubscribers = '$baseUrl$refactorOverview/net_subscribers';
  static const String getTotalSalesRevenue = '$baseUrl$refactorOverview/total_sales_revenue';
  static const String getChargebackSummary = '$baseUrl$refactorOverview/chargeback_summary';
  static const String getCoverageHealth = '$baseUrl$refactorOverview/coverage_health';
  static const String getRefundRatio = '$baseUrl$refactorOverview/refund_ratio';

  // Dashboard Details
  static const String getDirectSalesRevenue = '$baseUrl$refactorOverview/direct-sales-revenue';
  static const String getDirectSaleDetail = '$baseUrl$refactorOverview/direct_sale';
  static const String getDirectSaleUniqueApprovalRatio = '$baseUrl$refactorOverview/unique-approval-ratio';
  static const String getDirectSaleOrders = '$baseUrl$refactorOverview/direct-sale-orders';
  static const String getDirectSalesDeclinedBreakdown = '$baseUrl$refactorOverview/direct-sale-declined';

  static const String getInitialSubscriptionDeclinedBreakdown = '$baseUrl$refactorOverview/initial-subscription/declined-break-down';
  static const String getInitialSubscriptionDetails = '$baseUrl$refactorOverview/initial_subscription/details';
  static const String getInitialSubscriptionApprovalRatio = '$baseUrl$refactorOverview/initial-subscription-approval-ratio';
  static const String getInitialSubscriptionOrders = '$baseUrl$refactorOverview/initial-subscription-orders';

  static const String getRecurringSubscriptionDeclinedBreakdown = '$baseUrl$refactorOverview/recurring-subscription-decline';
  static const String getRecurringSubscriptionDetails = '$baseUrl$refactorOverview/recurring_subscription';
  static const String getRecurringSubscriptionApprovalRatio = '$baseUrl$refactorOverview/recurring/unique-approval-ratio';
  static const String getRecurringSubscriptionOrders = '$baseUrl$refactorOverview/recurring-subscription-list';

  static const String getSubscriptionSalvageDeclinedBreakdown = '$baseUrl$refactorOverview/subscription-salvage-decline';
  static const String getSubscriptionSalvageDetails = '$baseUrl$refactorOverview/subscription_salvage';
  static const String getSubscriptionSalvageApprovalRatio = '$baseUrl$refactorOverview/salvage/unique-approval-ratio';
  static const String getSubscriptionSalvageOrders = '$baseUrl$refactorOverview/subscription-salvage-list';


  static const String getUpsellDeclinedConstant = '$baseUrl$refactorOverview/upsell/declined-break-down';

  // Notifications
  static const String getNotificationConfiguration = '${baseUrl}notifications/config';
  static const String setNotificationConfiguration = '${baseUrl}notifications/config';
  static const String getNotificationAll = '${baseUrl}notifications/all';
}
