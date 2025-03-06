class PermissionResponse {
  Permissions? permissions;
  List<ClientsList>? clientsList;
  Map<String,List<StoreData>>? storesList;
  bool? isMaster;

  PermissionResponse(
      {this.permissions, this.clientsList, this.storesList, this.isMaster});

  PermissionResponse.fromJson(Map<String, dynamic> json) {
    permissions = json['Permissions'] != null
        ? Permissions.fromJson(json['Permissions'])
        : null;
    if (json['ClientsList'] != null) {
      clientsList = <ClientsList>[];
      json['ClientsList'].forEach((v) {
        clientsList!.add(ClientsList.fromJson(v));
      });
    }
    storesList = json['StoresList'] ;
    isMaster = json['IsMaster'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (permissions != null) {
      data['Permissions'] = permissions!.toJson();
    }
    if (clientsList != null) {
      data['ClientsList'] = clientsList!.map((v) => v.toJson()).toList();
    }

    data['IsMaster'] = isMaster;
    return data;
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

  Permissions(
      {this.phoenixAgents,
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
      this.template});

  Permissions.fromJson(Map<String, dynamic> json) {
    phoenixAgents = json['phoenix_agents'];
    billingSummary = json['billing_summary'];
    adminLogs = json['admin_logs'];
    userTypes = json['user_types'];
    users = json['users'];
    clients = json['clients'];
    transactions = json['transactions'];
    metaConversionApi = json['meta_conversion_api'];
    subscriptionBilling = json['subscription_billing'];
    eCommerceProducts = json['e_commerce_products'];
    collections = json['collections'];
    billingTypes = json['billing_types'];
    billingProfile = json['billing_profile'];
    merchantAccounts = json['merchant_accounts'];
    disputes = json['disputes'];
    orders = json['orders'];
    stores = json['stores'];
    abandonCarts = json['abandon_carts'];
    customers = json['customers'];
    advancedAnalytics = json['advanced_analytics'];
    overview = json['overview'];
    storeOverview = json['store_overview'];
    callCenters = json['call_centers'];
    clickFunnelProducts = json['click_funnel_products'];
    template = json['template'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoenix_agents'] = phoenixAgents;
    data['billing_summary'] = billingSummary;
    data['admin_logs'] = adminLogs;
    data['user_types'] = userTypes;
    data['users'] = users;
    data['clients'] = clients;
    data['transactions'] = transactions;
    data['meta_conversion_api'] = metaConversionApi;
    data['subscription_billing'] = subscriptionBilling;
    data['e_commerce_products'] = eCommerceProducts;
    data['collections'] = collections;
    data['billing_types'] = billingTypes;
    data['billing_profile'] = billingProfile;
    data['merchant_accounts'] = merchantAccounts;
    data['disputes'] = disputes;
    data['orders'] = orders;
    data['stores'] = stores;
    data['abandon_carts'] = abandonCarts;
    data['customers'] = customers;
    data['advanced_analytics'] = advancedAnalytics;
    data['overview'] = overview;
    data['store_overview'] = storeOverview;
    data['call_centers'] = callCenters;
    data['click_funnel_products'] = clickFunnelProducts;
    data['template'] = template;
    return data;
  }
}

class ClientsList {
  int? clientId;
  String? clientName;

  ClientsList({this.clientId, this.clientName});

  ClientsList.fromJson(Map<String, dynamic> json) {
    clientId = json['ClientId'];
    clientName = json['ClientName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClientId'] = clientId;
    data['ClientName'] = clientName;
    return data;
  }
}

class StoreData {
  int? storeId;
  String? storeName;

  StoreData({this.storeId, this.storeName});

  StoreData.fromJson(Map<String, dynamic> json) {
    storeId = json['StoreId'];
    storeName = json['StoreName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StoreId'] = storeId;
    data['StoreName'] = storeName;
    return data;
  }
}
