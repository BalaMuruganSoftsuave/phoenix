class PermissionResponse {
  Permissions? permissions;
  List<ClientsList>? clientsList;
  Map<String, List<StoreData>>? storesList;
  bool? isMaster;

  PermissionResponse(
      {this.permissions, this.clientsList, this.storesList, this.isMaster});

  factory PermissionResponse.fromJson(Map<String, dynamic> json) {
    // Helper to add "Select All" to a list
    List<T> addSelectAll<T>(List<T> list, T Function() createSelectAll,
        bool Function(T) isSelectAll) {
      if (list.isNotEmpty && !list.any(isSelectAll)) {
        list.insert(0, createSelectAll());
      }
      return list;
    }

    return PermissionResponse(
      permissions: json['Permissions'] == null
          ? null
          : Permissions.fromJson(json['Permissions']),

      // Add "Select All" for clientsList
      clientsList: addSelectAll(
          (json['ClientsList'] as List?)
                  ?.map((v) => ClientsList.fromJson(v))
                  .toList() ??
              [],
          () => ClientsList(clientId: -1, clientName: "Select All"),
          (item) => item.clientId == -1),

      // Add "Select All" for storesList
      storesList: (json['StoresList'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(
                key,
                (value as List).map((e) => StoreData.fromJson(e)).toList(),
              )),

      isMaster: json['IsMaster'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Permissions': permissions?.toJson(),
      'ClientsList': clientsList?.map((v) => v.toJson()).toList(),
      'StoresList': storesList?.map(
          (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList())),
      'IsMaster': isMaster,
    };
  }
}

class Permissions {
  String? phoenixAgents;
  String? billingSummary;
  String? adminLogs;
  String? userTypes;
  String? users;
  String? clients;
  String? transactions;
  String? metaConversionApi;
  String? subscriptionBilling;
  String? eCommerceProducts;
  String? collections;
  String? billingTypes;
  String? billingProfile;
  String? merchantAccounts;
  String? disputes;
  String? orders;
  String? stores;
  String? abandonCarts;
  String? customers;
  String? advancedAnalytics;
  String? overview;
  String? storeOverview;
  String? callCenters;
  String? clickFunnelProducts;
  String? template;

  Permissions({
    this.phoenixAgents,
    this.billingSummary,
    this.adminLogs,
    this.userTypes,
    this.users,
    this.clients,
    this.transactions,
    this.metaConversionApi,
    this.subscriptionBilling,
    this.eCommerceProducts,
    this.collections,
    this.billingTypes,
    this.billingProfile,
    this.merchantAccounts,
    this.disputes,
    this.orders,
    this.stores,
    this.abandonCarts,
    this.customers,
    this.advancedAnalytics,
    this.overview,
    this.storeOverview,
    this.callCenters,
    this.clickFunnelProducts,
    this.template,
  });

  factory Permissions.fromJson(Map<String, dynamic> json) {
    return Permissions(
      phoenixAgents: json['phoenix_agents'],
      billingSummary: json['billing_summary'],
      adminLogs: json['admin_logs'],
      userTypes: json['user_types'],
      users: json['users'],
      clients: json['clients'],
      transactions: json['transactions'],
      metaConversionApi: json['meta_conversion_api'],
      subscriptionBilling: json['subscription_billing'],
      eCommerceProducts: json['e_commerce_products'],
      collections: json['collections'],
      billingTypes: json['billing_types'],
      billingProfile: json['billing_profile'],
      merchantAccounts: json['merchant_accounts'],
      disputes: json['disputes'],
      orders: json['orders'],
      stores: json['stores'],
      abandonCarts: json['abandon_carts'],
      customers: json['customers'],
      advancedAnalytics: json['advanced_analytics'],
      overview: json['overview'],
      storeOverview: json['store_overview'],
      callCenters: json['call_centers'],
      clickFunnelProducts: json['click_funnel_products'],
      template: json['template'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoenix_agents': phoenixAgents,
      'billing_summary': billingSummary,
      'admin_logs': adminLogs,
      'user_types': userTypes,
      'users': users,
      'clients': clients,
      'transactions': transactions,
      'meta_conversion_api': metaConversionApi,
      'subscription_billing': subscriptionBilling,
      'e_commerce_products': eCommerceProducts,
      'collections': collections,
      'billing_types': billingTypes,
      'billing_profile': billingProfile,
      'merchant_accounts': merchantAccounts,
      'disputes': disputes,
      'orders': orders,
      'stores': stores,
      'abandon_carts': abandonCarts,
      'customers': customers,
      'advanced_analytics': advancedAnalytics,
      'overview': overview,
      'store_overview': storeOverview,
      'call_centers': callCenters,
      'click_funnel_products': clickFunnelProducts,
      'template': template,
    };
  }
}

class ClientsList {
  int? clientId;
  String? clientName;

  ClientsList({this.clientId, this.clientName});

  factory ClientsList.fromJson(Map<String, dynamic> json) {
    return ClientsList(
      clientId: json['ClientId'] as int?,
      clientName: json['ClientName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ClientId': clientId,
      'ClientName': clientName,
    };
  }
}

class StoreData {
  int? storeId;
  String? storeName;

  StoreData({this.storeId, this.storeName});

  factory StoreData.fromJson(Map<String, dynamic> json) {
    return StoreData(
      storeId: json['StoreId'] as int?,
      storeName: json['StoreName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StoreId': storeId,
      'StoreName': storeName,
    };
  }
}
