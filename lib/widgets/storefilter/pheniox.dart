class Phoenix {
  Permissions permissions;
  List<ClientsList> clientsList;
  Map<String, List<StoresList>> storesList;
  bool isMaster;

  Phoenix({
    required this.permissions,
    required this.clientsList,
    required this.storesList,
    required this.isMaster,
  });

}

class ClientsList {
  int clientId;
  String clientName;

  ClientsList({
    required this.clientId,
    required this.clientName,
  });

  static final List<ClientsList> clientsList = [
    ClientsList(clientId: -1, clientName: "Select All"),
    ClientsList(clientId: 37, clientName: "Lang New"),
    ClientsList(clientId: 73, clientName: "Manita Ventures LLC"),
    ClientsList(clientId: 21, clientName: "FJ Brands"),
    ClientsList(clientId: 85, clientName: "4Lyfe LLC"),
    ClientsList(clientId: 86, clientName: "CartClick LLC"),
    ClientsList(clientId: 87, clientName: "Elite GCCS LLC."),
    ClientsList(clientId: 88, clientName: "Glo Operations"),
    ClientsList(clientId: 89, clientName: "J Rob Inc"),
    ClientsList(clientId: 90, clientName: "Matrix International"),
    ClientsList(clientId: 91, clientName: "Merbeautyapparel Inc"),
    ClientsList(clientId: 92, clientName: "Parkshores LLC"),
    ClientsList(clientId: 93, clientName: "Robust Growth Ltd"),
    ClientsList(clientId: 94, clientName: "Shuttledeals.com"),
    ClientsList(clientId: 95, clientName: "Woa eCommerce LLC"),
    ClientsList(clientId: 96, clientName: "Wulo LLC"),
    ClientsList(clientId: 78, clientName: "Landy Group"),
    ClientsList(clientId: 98, clientName: "Brandon Aguilera"),
    ClientsList(clientId: 99, clientName: "Sammir"),
    ClientsList(clientId: 100, clientName: "David Bitton Media Ltd."),
    ClientsList(clientId: 42, clientName: "Eric Zu"),
    ClientsList(clientId: 102, clientName: "Aries Kai LLC"),
    ClientsList(clientId: 103, clientName: "Mundaneco LLC"),
    ClientsList(clientId: 104, clientName: "Epic eCommerce LLC"),
    ClientsList(clientId: 105, clientName: "Transcend LLC"),
    ClientsList(clientId: 106, clientName: "Jungle Labs LLC."),
    ClientsList(clientId: 107, clientName: "Hoop Closet LLC"),
    ClientsList(clientId: 108, clientName: "Merbeauty Apparel Inc - Delete"),
    ClientsList(clientId: 109, clientName: "Purely Nutra LLC"),
    ClientsList(clientId: 110, clientName: "Peak Footwear LLC"),
    ClientsList(clientId: 111, clientName: "Koi Capital Ventures LLC"),
    ClientsList(clientId: 112, clientName: "Midas Media Moguls LLC"),
    ClientsList(clientId: 113, clientName: "Summit Marketing Group"),
    ClientsList(clientId: 114, clientName: "Ecom Master Limited"),
    ClientsList(clientId: 115, clientName: "Ecom Brands LLC"),
    ClientsList(clientId: 116, clientName: "Prfct Agency LLC"),
    ClientsList(clientId: 117, clientName: "PF Unlimited Enterprises"),
    ClientsList(clientId: 118, clientName: "AG Lapietra LLC"),
    ClientsList(clientId: 119, clientName: "Masked LLC"),
    ClientsList(clientId: 120, clientName: "glossiedeals.com"),
    ClientsList(clientId: 121, clientName: "vip.getfrozen.com"),
    ClientsList(clientId: 122, clientName: "vip.luhxe.com"),
    ClientsList(clientId: 123, clientName: "Holistic Hercules Shop"),
    ClientsList(clientId: 124, clientName: "offer.avalaine.com"),
    ClientsList(clientId: 125, clientName: "shop.allurescent.co"),
    ClientsList(clientId: 126, clientName: "ella-jade.com"),
    ClientsList(clientId: 127, clientName: "torpedodeals.com"),
    ClientsList(clientId: 128, clientName: "astariaboutique.com"),
    ClientsList(clientId: 129, clientName: "offer.merraci.com"),
    ClientsList(clientId: 130, clientName: "Cartice LLC"),
    ClientsList(clientId: 131, clientName: "Performance Media Operational Company LLC"),
    ClientsList(clientId: 132, clientName: "Rockefell Commerce LLC"),
    ClientsList(clientId: 133, clientName: "Patriot P Market Group LLC"),
    ClientsList(clientId: 134, clientName: "New Agency LLC"),
    ClientsList(clientId: 66, clientName: "Pixel Ventures"),
    ClientsList(clientId: 45, clientName: "AS Publishing"),
    ClientsList(clientId: 24, clientName: "Bleame"),
    ClientsList(clientId: 60, clientName: "Bless Earth LLC"),
    ClientsList(clientId: 46, clientName: "Brandon   Andreas"),
    ClientsList(clientId: 44, clientName: "BUCCS3"),
    ClientsList(clientId: 43, clientName: "Cinque Rhythm Inc"),
    ClientsList(clientId: 83, clientName: "Clickstream LLC"),
    ClientsList(clientId: 71, clientName: "Dark Waters LLC"),
    ClientsList(clientId: 41, clientName: "Dundas LLC"),
    ClientsList(clientId: 62, clientName: "eComm1128"),
    ClientsList(clientId: 30, clientName: "eCommerceX"),
    ClientsList(clientId: 64, clientName: "Fine Score LLC"),
    ClientsList(clientId: 72, clientName: "Fleava LLC"),
    ClientsList(clientId: 52, clientName: "Globexsolutions LLC"),
    ClientsList(clientId: 57, clientName: "Hanz   Hamid"),
    ClientsList(clientId: 27, clientName: "KevinMaster"),
    ClientsList(clientId: 50, clientName: "KNT Labs LLC"),
    ClientsList(clientId: 69, clientName: "Kong Capital"),
    ClientsList(clientId: 29, clientName: "Lang"),
    ClientsList(clientId: 39, clientName: "Lang STR"),
    ClientsList(clientId: 34, clientName: "Level Up"),
    ClientsList(clientId: 74, clientName: "Maday ECom LLC"),
    ClientsList(clientId: 36, clientName: "Magniv / Tam + Gian"),
    ClientsList(clientId: 79, clientName: "Manita Ventures"),
    ClientsList(clientId: 47, clientName: "Milos Gold"),
    ClientsList(clientId: 81, clientName: "new test"),
    ClientsList(clientId: 101, clientName: "New testing"),
    ClientsList(clientId: 56, clientName: "Nexa Commerce"),
    ClientsList(clientId: 51, clientName: "Omniexpeditions"),
    ClientsList(clientId: 23, clientName: "Patriot Brands"),
    ClientsList(clientId: 77, clientName: "Phx Client"),
    ClientsList(clientId: 75, clientName: "Pocket Pharma LLC"),
    ClientsList(clientId: 58, clientName: "Popster LLC"),
    ClientsList(clientId: 61, clientName: "Qaqish Corp"),
    ClientsList(clientId: 48, clientName: "Reborne"),
    ClientsList(clientId: 59, clientName: "RPLC Holdings"),
    ClientsList(clientId: 68, clientName: "SA - Cured"),
    ClientsList(clientId: 65, clientName: "SA - Enhanced"),
    ClientsList(clientId: 67, clientName: "SA - Femina"),
    ClientsList(clientId: 70, clientName: "SA - Vegan"),
    ClientsList(clientId: 97, clientName: "Sack Consulting Inc"),
    ClientsList(clientId: 82, clientName: "Sacred Scale LLC"),
    ClientsList(clientId: 25, clientName: "Sauve"),
    ClientsList(clientId: 38, clientName: "Space Therapy Pro"),
    ClientsList(clientId: 35, clientName: "tenvirtues"),
    ClientsList(clientId: 33, clientName: "thathair"),
    ClientsList(clientId: 32, clientName: "TJ Commerce"),
    ClientsList(clientId: 26, clientName: "Trump"),
    ClientsList(clientId: 76, clientName: "Twitchecom LLC"),
    ClientsList(clientId: 40, clientName: "Unlucky LLC"),
    ClientsList(clientId: 54, clientName: "Valhallafallen ShopifyNMI"),
    ClientsList(clientId: 49, clientName: "Venteige LLC"),
    ClientsList(clientId: 28, clientName: "Venturenok"),
    ClientsList(clientId: 63, clientName: "VK Enterprises"),
    ClientsList(clientId: 53, clientName: "WNW Group"),
    ClientsList(clientId: 135, clientName: "Expand Global LLC"),
    ClientsList(clientId: 136, clientName: "Lecommerce Holdings LLC"),
  ];

}

class Permissions {
  String phoenixAgents;
  String billingSummary;
  String adminLogs;
  String userTypes;
  String users;
  String clients;
  String transactions;
  String metaConversionApi;
  String subscriptionBilling;
  String eCommerceProducts;
  String collections;
  String billingTypes;
  String billingProfile;
  String merchantAccounts;
  String disputes;
  String orders;
  String stores;
  String abandonCarts;
  String customers;
  String advancedAnalytics;
  String overview;
  String storeOverview;
  String callCenters;
  String clickFunnelProducts;
  String template;

  Permissions({
    required this.phoenixAgents,
    required this.billingSummary,
    required this.adminLogs,
    required this.userTypes,
    required this.users,
    required this.clients,
    required this.transactions,
    required this.metaConversionApi,
    required this.subscriptionBilling,
    required this.eCommerceProducts,
    required this.collections,
    required this.billingTypes,
    required this.billingProfile,
    required this.merchantAccounts,
    required this.disputes,
    required this.orders,
    required this.stores,
    required this.abandonCarts,
    required this.customers,
    required this.advancedAnalytics,
    required this.overview,
    required this.storeOverview,
    required this.callCenters,
    required this.clickFunnelProducts,
    required this.template,
  });

}

class StoresList {
  int storeId;
  String storeName;

  StoresList({
    required this.storeId,
    required this.storeName,
  });

  static final Map<String,List<StoresList>> stores = {
    "21": [
      StoresList(storeId: 3, storeName: "New Test VIP (39dbbf)"),
      StoresList(storeId: 5, storeName: "Viking Regalia"),
      StoresList(storeId: 6, storeName: "Viking Regalia VIP (7e6d48)"),
      StoresList(storeId: 7, storeName: "Shop Iced Society"),
      StoresList(storeId: 8, storeName: "Shop Iced Society VIP (0f5124)"),
      StoresList(storeId: 9, storeName: "Alpha Shade Shop"),
      StoresList(storeId: 10, storeName: "Alpha Shade Shop VIP(e80185-3)"),
      StoresList(storeId: 11, storeName: "Taiyo Apparel"),
      StoresList(storeId: 12, storeName: "Taiyo Apparel VIP (01cf10-3)"),
      StoresList(storeId: 13, storeName: "Enhanced Essence"),
      StoresList(storeId: 14, storeName: "VIP Enhanced Essence"),
      StoresList(storeId: 15, storeName: "Elliston Leather"),
      StoresList(storeId: 16, storeName: "VIP Elliston Leather"),
      StoresList(storeId: 17, storeName: "VIP Regal Shoes"),
      StoresList(storeId: 18, storeName: "Regal Shoes"),
      StoresList(storeId: 21, storeName: "Regal Stores Offer"),
      StoresList(storeId: 22, storeName: "Offer Enhanced Essence"),
      StoresList(storeId: 26, storeName: "original-essentials.com"),
      StoresList(storeId: 27, storeName: "original essentials offer"),
      StoresList(storeId: 28, storeName: "vip.original-essentials.com"),
      StoresList(storeId: 36, storeName: "Luxe Lumiere"),
      StoresList(storeId: 37, storeName: "offer.luxe-lumiere"),
      StoresList(storeId: 38, storeName: "vip.luxe-lumiere"),
      StoresList(storeId: 39, storeName: "Sale Enhanced Essence"),
      StoresList(storeId: 48, storeName: "the comfyco"),
      StoresList(storeId: 52, storeName: "ComfyCo VIP"),
      StoresList(storeId: 81, storeName: "dealdepot"),
      StoresList(storeId: 88, storeName: "dealdepot-VIP"),
      StoresList(storeId: 90, storeName: "Offer Dealdepot"),
      StoresList(storeId: 102, storeName: "bef87e-ea.myshopify.com"),
      StoresList(storeId: 103, storeName: "Seesentials"),
      StoresList(storeId: 118, storeName: "offer.lavishivy.com"),
      StoresList(storeId: 119, storeName: "stopjoinglow.orderjolie.com"),
      StoresList(storeId: 154, storeName: "vip.lavishivy.com"),
      StoresList(storeId: 318, storeName: "Alvin-test"),
      StoresList(storeId: 367, storeName: "Kalla"),
      StoresList(storeId: 395, storeName: "puviarasu-store"),
    ],
    "23": [
      StoresList(storeId: 19, storeName: "divinepatriotshop.com"),
      StoresList(storeId: 20, storeName: "vip.divinepatriotshop.com"),
      StoresList(storeId: 23, storeName: "Sparkle & gems"),
      StoresList(storeId: 24, storeName: "VIP Sparke & gems"),
      StoresList(storeId: 25, storeName: "Offer Sparke & gems"),
    ],
    "24": [
      StoresList(storeId: 29, storeName: "Bleame Offer"),
      StoresList(storeId: 30, storeName: "Bleame VIP"),
    ],
    "25": [
      StoresList(storeId: 31, storeName: "suavecologne.com"),
      StoresList(storeId: 34, storeName: "offer.sauvecologne.com"),
      StoresList(storeId: 35, storeName: "Suavecologne VIP"),
    ],
    "26": [
      StoresList(storeId: 32, storeName: "patriotprosnetwork.com (starsandstripessupply.com)"),
      StoresList(storeId: 33, storeName: "patriotprosnetwork VIP (starsandstripessupply)"),
      StoresList(storeId: 76, storeName: "beachhavenvip.boutique"),
      StoresList(storeId: 77, storeName: "Beach Heave"),
      StoresList(storeId: 110, storeName: "Click Funnel Star"),
      StoresList(storeId: 146, storeName: "aurelleandbloom.com"),
      StoresList(storeId: 182, storeName: "vip.aurelleandbloom.com"),
      StoresList(storeId: 186, storeName: "vip.aurelleandbloom.com_new"),
      StoresList(storeId: 371, storeName: "aurellevip.com"),
      StoresList(storeId: 372, storeName: "member.aurellevip.com"),
    ],
    "27": [
      StoresList(storeId: 58, storeName: "FreeportApparel_VIP"),
      StoresList(storeId: 59, storeName: "Vip buffalotrailsatchel"),
      StoresList(storeId: 70, storeName: "valhalla-traffic"),
      StoresList(storeId: 82, storeName: "shuttle-deals"),
      StoresList(storeId: 129, storeName: "shapeme.shuttledeals.com"),
      StoresList(storeId: 141, storeName: "kennedytown.myshopify.com"),
      StoresList(storeId: 142, storeName: "moymoy3.myshopify.com"),
      StoresList(storeId: 143, storeName: "Kukook4_stop.myshopify.com"),
      StoresList(storeId: 144, storeName: "kukook2.myshopify.com"),
      StoresList(storeId: 147, storeName: "woodshilltrail.myshopify.com"),
      StoresList(storeId: 148, storeName: "mockingbirdpalace.myshopify.com"),
      StoresList(storeId: 149, storeName: "hollowayplazadrive.myshopify.com"),
      StoresList(storeId: 150, storeName: "sunsetvaleavenue.myshopify.com"),
      StoresList(storeId: 151, storeName: "mountcrestroundabout.myshopify.com"),
      StoresList(storeId: 153, storeName: "myownyard-b.myshopify.com"),
      StoresList(storeId: 236, storeName: "torpedodeals.com"),
      StoresList(storeId: 263, storeName: "valhallafallen.com"),
    ],
    "28": [
      StoresList(storeId: 40, storeName: "join.vygfragrances"),
      StoresList(storeId: 41, storeName: "vygfragrances.com"),
      StoresList(storeId: 42, storeName: "vip.vygfragrances.com"),
    ],
    "29": [
      StoresList(storeId: 43, storeName: "offer ionhydro-bottle"),
      StoresList(storeId: 44, storeName: "vip ionhydro-bottle"),
      StoresList(storeId: 56, storeName: "BlessMyFaith_VIP"),
      StoresList(storeId: 57, storeName: "Offer Blessmy Faith"),
      StoresList(storeId: 61, storeName: "VIP Charm-shape"),
      StoresList(storeId: 63, storeName: "Offer Dalora"),
      StoresList(storeId: 237, storeName: "vip.ella-jade.com"),
      StoresList(storeId: 239, storeName: "theofferoasis.com"),
      StoresList(storeId: 240, storeName: "join.lavishivy.com"),
    ],
    "30": [
      StoresList(storeId: 45, storeName: "janaie"),
      StoresList(storeId: 64, storeName: "Vip Shop botanique paris"),
      StoresList(storeId: 224, storeName: "Janaie"),
    ],
    "32": [
      StoresList(storeId: 47, storeName: "therizzco"),
      StoresList(storeId: 51, storeName: "VIP Rizzsoles"),
    ],
    "33": [
      StoresList(storeId: 46, storeName: "That Hair"),
    ],
    "34": [
      StoresList(storeId: 49, storeName: "Get Orderjolie"),
      StoresList(storeId: 50, storeName: "Discounts Orderjolie"),
      StoresList(storeId: 54, storeName: "Oil Order Jolie"),
      StoresList(storeId: 65, storeName: "belico.orderjolie.com"),
      StoresList(storeId: 68, storeName: "Bear Orderjolie"),
      StoresList(storeId: 86, storeName: "Skin Orderjolie"),
      StoresList(storeId: 92, storeName: "joinglow.orderjolie.com"),
      StoresList(storeId: 104, storeName: "stopjoinglow.orderjolie.com"),
      StoresList(storeId: 108, storeName: "stopjoinskin.orderjolie.com"),
    ],
    "35": [
      StoresList(storeId: 53, storeName: "Lift Lab"),
      StoresList(storeId: 93, storeName: "shop.liftlabskin.com"),
    ],
    "36": [
      StoresList(storeId: 55, storeName: "Otterra"),
      StoresList(storeId: 62, storeName: "VIP otterra.com"),
    ],
    "37": [
      StoresList(storeId: 66, storeName: "offer.insta-shape.com"),
      StoresList(storeId: 71, storeName: "Offer Vivielleboutique"),
      StoresList(storeId: 72, storeName: "VIVIELLE VIP"),
      StoresList(storeId: 74, storeName: "Vivielle Boutique"),
      StoresList(storeId: 78, storeName: "Lunexra"),
      StoresList(storeId: 79, storeName: "Lunexra VIP"),
      StoresList(storeId: 80, storeName: "Offer Lunexra"),
      StoresList(storeId: 134, storeName: "join.lavishivy.com"),
      StoresList(storeId: 158, storeName: "sale.lavishivy.com"),
      StoresList(storeId: 161, storeName: "club.ella-jade.com"),
      StoresList(storeId: 173, storeName: "vip.duskbeautyco.com"),
      StoresList(storeId: 183, storeName: "vip.lavishivy.com"),
      StoresList(storeId: 187, storeName: "join.duskbeautyco.com"),
      StoresList(storeId: 193, storeName: "duskbeautyco.com"),
      StoresList(storeId: 198, storeName: "vulcawear.com"),
      StoresList(storeId: 204, storeName: "vip.vulcawear.com"),
      StoresList(storeId: 207, storeName: "join.vulcawear.com"),
      StoresList(storeId: 241, storeName: "vip.lavishivy.com"),
      StoresList(storeId: 242, storeName: "lavishivy.com"),
      StoresList(storeId: 243, storeName: "ella-jade.com"),
      StoresList(storeId: 244, storeName: "offer.vivielleboutique.com"),
      StoresList(storeId: 245, storeName: "vip.vivielleboutique.co"),
      StoresList(storeId: 362, storeName: "herology.theofferoasis.com"),
      StoresList(storeId: 364, storeName: "vip.theofferoasis.com"),
      StoresList(storeId: 365, storeName: "theofferoasis.com"),
      StoresList(storeId: 369, storeName: "sdfsdf"),
    ],
    "38": [
      StoresList(storeId: 69, storeName: "trypurehealth"),
      StoresList(storeId: 73, storeName: "PureHealth"),
      StoresList(storeId: 116, storeName: "NutrivaHealth"),
    ],
    "39": [
      StoresList(storeId: 83, storeName: "Dawn Stay"),
    ],
    "40": [
      StoresList(storeId: 85, storeName: "Inspiredlife"),
      StoresList(storeId: 89, storeName: "Offer.InspiredLife"),
      StoresList(storeId: 91, storeName: "vip.upliftedlife.us"),
      StoresList(storeId: 128, storeName: "upliftedlife.shop"),
      StoresList(storeId: 363, storeName: "shop.upliftedlife.us"),
    ],
    "41": [
      StoresList(storeId: 87, storeName: "Avenati"),
      StoresList(storeId: 105, storeName: "Zaar"),
      StoresList(storeId: 106, storeName: "vip.zaar.co"),
      StoresList(storeId: 107, storeName: "Vip Avenati"),
      StoresList(storeId: 221, storeName: "members.zaar.co"),
      StoresList(storeId: 222, storeName: "join.zaar.co"),
    ],
    "42": [
      StoresList(storeId: 94, storeName: "ifade.co"),
    ],
    "43": [
      StoresList(storeId: 95, storeName: "hippofinds.com"),
      StoresList(storeId: 96, storeName: "vip.hippofinds.com"),
      StoresList(storeId: 99, storeName: "shop.hippofinds.com"),
      StoresList(storeId: 113, storeName: "Hippo Funnelish"),
    ],
    "44": [
      StoresList(storeId: 97, storeName: "e3d1d4-2b.myshopify.com"),
      StoresList(storeId: 98, storeName: "Santorini"),
      StoresList(storeId: 100, storeName: "offer.luke-larry"),
      StoresList(storeId: 101, storeName: "Offer William David"),
    ],
    "45": [
      StoresList(storeId: 112, storeName: "AS Publishing CF"),
    ],
    "46": [
      StoresList(storeId: 109, storeName: "Jack And Jill Shop"),
      StoresList(storeId: 117, storeName: "vip.jackandjillshop.com"),
      StoresList(storeId: 133, storeName: "offer.myhoneyandpine.com"),
      StoresList(storeId: 212, storeName: "cedarandash.com"),
      StoresList(storeId: 213, storeName: "offer.cedarandash.com"),
      StoresList(storeId: 214, storeName: "myhoneyandpine.com"),
    ],
    "47": [
      StoresList(storeId: 111, storeName: "lndmarkclub.com"),
      StoresList(storeId: 252, storeName: "offer.lndmarkclub.com"),
    ],
    "48": [
      StoresList(storeId: 114, storeName: "Reborne Clickfunnel"),
    ],
    "49": [
      StoresList(storeId: 115, storeName: "mydogpad.com"),
    ],
    "50": [
      StoresList(storeId: 120, storeName: "Funnelish Store"),
    ],
    "51": [
      StoresList(storeId: 121, storeName: "Omni Funnelish"),
      StoresList(storeId: 124, storeName: "vip americangadgetshub"),
      StoresList(storeId: 132, storeName: "AMERICAN HEALTH CL"),
      StoresList(storeId: 195, storeName: "Nuvio Funnelish"),
      StoresList(storeId: 254, storeName: "nuviohome.com"),
      StoresList(storeId: 255, storeName: "americangadgetshub.com"),
    ],
    "52": [
      StoresList(storeId: 122, storeName: "Repellify Funnellish"),
      StoresList(storeId: 127, storeName: "vip.tryrepellify.com"),
      StoresList(storeId: 166, storeName: "upliftdeals.com (Funnelish)"),
      StoresList(storeId: 233, storeName: "tryrepellify.com"),
    ],
    "53": [
      StoresList(storeId: 123, storeName: "OzzieMozzie Funnelish"),
      StoresList(storeId: 126, storeName: "Vip Ozzimozzie"),
    ],
    "56": [
      StoresList(storeId: 135, storeName: "Nexa-Rust Remover"),
      StoresList(storeId: 137, storeName: "Nexa-US"),
      StoresList(storeId: 253, storeName: "nexa-us.com"),
    ],
    "57": [
      StoresList(storeId: 138, storeName: "Liftlabskin.com"),
      StoresList(storeId: 139, storeName: "join.quiabeauty.com"),
      StoresList(storeId: 140, storeName: "offer.thathair.co"),
      StoresList(storeId: 162, storeName: "join.liftlabskin.com"),
      StoresList(storeId: 200, storeName: "thathair.co"),
      StoresList(storeId: 203, storeName: "vip.thathair.co"),
      StoresList(storeId: 205, storeName: "join.thathair.co"),
      StoresList(storeId: 307, storeName: "vip.liftlabskin.com"),
      StoresList(storeId: 409, storeName: "offer.bleame.com"),
    ],
    "58": [
      StoresList(storeId: 145, storeName: "shopklone.com"),
      StoresList(storeId: 156, storeName: "levora.co"),
      StoresList(storeId: 260, storeName: "vip.getfrozen.com"),
    ],
    "59": [
      StoresList(storeId: 152, storeName: "shop.allurescent.co"),
      StoresList(storeId: 266, storeName: "vip.allurescent.co"),
      StoresList(storeId: 267, storeName: "allurescent.co"),
    ],
    "60": [
      StoresList(storeId: 155, storeName: "shop.herculessupps.com"),
      StoresList(storeId: 179, storeName: "powerofhercules.com"),
    ],
    "61": [
      StoresList(storeId: 170, storeName: "shop.astariaboutique.com"),
      StoresList(storeId: 261, storeName: "vip.astariaboutique.com"),
      StoresList(storeId: 262, storeName: "astariaboutique.com"),
    ],
    "62": [
      StoresList(storeId: 167, storeName: "skintura.co"),
      StoresList(storeId: 223, storeName: "vip.skintura.co"),
      StoresList(storeId: 396, storeName: "shop.tryanua.co"),
      StoresList(storeId: 398, storeName: "vip.tryanua.co"),
    ],
    "63": [
      StoresList(storeId: 164, storeName: "greatsmile.co"),
      StoresList(storeId: 178, storeName: "americansmileusa.com"),
    ],
    "64": [
      StoresList(storeId: 157, storeName: "us.stardonstore.com"),
      StoresList(storeId: 228, storeName: "vip.stardonstore.com"),
      StoresList(storeId: 229, storeName: "stardonstore.com"),
      StoresList(storeId: 336, storeName: "stardanstore.com"),
      StoresList(storeId: 370, storeName: "evelonstore.com"),
    ],
    "65": [
      StoresList(storeId: 159, storeName: "tryenhanced-scents.com"),
    ],
    "66": [
      StoresList(storeId: 160, storeName: "spirilet.com"),
    ],
    "67": [
      StoresList(storeId: 163, storeName: "shop.buyfemina.com"),
      StoresList(storeId: 352, storeName: "vip.buyfemina.com"),
    ],
    "68": [
      StoresList(storeId: 175, storeName: "startcured.com"),
    ],
    "69": [
      StoresList(storeId: 165, storeName: "officialquasi.com"),
      StoresList(storeId: 311, storeName: "vip.officialquasi.com"),
      StoresList(storeId: 355, storeName: "try.officialquasi.com"),
    ],
    "70": [
      StoresList(storeId: 168, storeName: "join.veganichairshop.com"),
    ],
    "71": [
      StoresList(storeId: 169, storeName: "offer.getvitalbalance.com"),
      StoresList(storeId: 181, storeName: "vip.getvitalbalance.com"),
      StoresList(storeId: 220, storeName: "getvitalbalance.com"),
    ],
    "72": [
      StoresList(storeId: 171, storeName: "fleava.shop"),
    ],
    "73": [
      StoresList(storeId: 174, storeName: "glossieskin.com"),
      StoresList(storeId: 191, storeName: "offer.glossiedeals.com"),
      StoresList(storeId: 209, storeName: "glossiedeals.com"),
    ],
    "74": [
      StoresList(storeId: 176, storeName: "offer.revstretch.com"),
    ],
    "75": [
      StoresList(storeId: 177, storeName: "luhxe.com"),
      StoresList(storeId: 202, storeName: "sale.luhxe.com"),
    ],
    "76": [
      StoresList(storeId: 180, storeName: "offer.merraci.com"),
      StoresList(storeId: 184, storeName: "es.merraci.com"),
      StoresList(storeId: 293, storeName: "members.merraci.com"),
    ],
    "77": [
      StoresList(storeId: 185, storeName: "shapewearbestoffers.com"),
    ],
    "78": [
      StoresList(storeId: 188, storeName: "aurelis.shop"),
      StoresList(storeId: 201, storeName: "vip.aurelis.shop"),
    ],
    "79": [
      StoresList(storeId: 246, storeName: "glossiedeals.com"),
    ],
    "81": [
      StoresList(storeId: 194, storeName: "test"),
      StoresList(storeId: 199, storeName: "testing add"),
    ],
    "82": [
      StoresList(storeId: 196, storeName: "offer.valarabeauty.com"),
      StoresList(storeId: 268, storeName: "vip.valarabeauty.com"),
      StoresList(storeId: 269, storeName: "valarabeauty.com"),
      StoresList(storeId: 312, storeName: "offer.bienbeauties.com"),
      StoresList(storeId: 313, storeName: "bienbeauties.com"),
    ],
    "83": [
      StoresList(storeId: 197, storeName: "shop.alluredeparis.com"),
      StoresList(storeId: 217, storeName: "vip.deparisallure.com"),
      StoresList(storeId: 218, storeName: "official.alluredeparis.com"),
      StoresList(storeId: 219, storeName: "deparisallure.com"),
      StoresList(storeId: 374, storeName: "offer.deparisallure.com"),
      StoresList(storeId: 410, storeName: "store.alluredeparis.com"),
    ],
    "85": [
      StoresList(storeId: 210, storeName: "orderpurenutra.com"),
      StoresList(storeId: 211, storeName: "offer.orderpurenutra.com"),
    ],
    "86": [
      StoresList(storeId: 216, storeName: "trustgoods.co"),
    ],
    "87": [
      StoresList(storeId: 225, storeName: "stop-shopvirtualessential.vip"),
      StoresList(storeId: 226, storeName: "shopvirtualessential.com"),
      StoresList(storeId: 227, storeName: "shopvitalboost.com"),
      StoresList(storeId: 368, storeName: "shopvirtualessential.vip"),
    ],
    "88": [
      StoresList(storeId: 230, storeName: "vip.glori.co"),
      StoresList(storeId: 231, storeName: "offer.glori.co"),
      StoresList(storeId: 232, storeName: "glori.co"),
    ],
    "89": [
      StoresList(storeId: 234, storeName: "vip.avalaine.com"),
      StoresList(storeId: 235, storeName: "avalaine.com"),
    ],
    "90": [
      StoresList(storeId: 247, storeName: "vip.kratosorganics.com (new)"),
      StoresList(storeId: 248, storeName: "offer.kratosorganics.com (new)"),
    ],
    "91": [
      StoresList(storeId: 249, storeName: "shop-jewelle.com"),
      StoresList(storeId: 250, storeName: "offer.shop-jewelle.com"),
      StoresList(storeId: 251, storeName: "members.shop-jewelle.com"),
    ],
    "92": [
      StoresList(storeId: 256, storeName: "vipbelluxjewels.com"),
      StoresList(storeId: 257, storeName: "loversclub.org"),
      StoresList(storeId: 258, storeName: "belluxjewels.com"),
      StoresList(storeId: 259, storeName: "ostacove.com"),
      StoresList(storeId: 304, storeName: "LOVERSCLUB.ORG - FUNNELISH"),
    ],
    "93": [
      StoresList(storeId: 264, storeName: "vip.olvari.com"),
      StoresList(storeId: 265, storeName: "westcollective.co"),
    ],
    "94": [
      StoresList(storeId: 280, storeName: "luxewear.shuttledeals.com"),
      StoresList(storeId: 281, storeName: "sleepsoft.shuttledeals.com"),
      StoresList(storeId: 282, storeName: "shapeme.shuttledeals.com"),
      StoresList(storeId: 283, storeName: "alluralace.shuttledeals.com (Old)"),
      StoresList(storeId: 284, storeName: "frosk.shuttledeals.com"),
      StoresList(storeId: 285, storeName: "filtra.shuttledeals.com (old)"),
      StoresList(storeId: 286, storeName: "alaskanparka.shuttledeals.com"),
      StoresList(storeId: 287, storeName: "buffalotrail.shuttledeals.com"),
      StoresList(storeId: 288, storeName: "glamglide.shuttledeals.com"),
      StoresList(storeId: 289, storeName: "monarc.shuttledeals.com (Old)"),
      StoresList(storeId: 290, storeName: "everfit.shuttledeals.com"),
      StoresList(storeId: 291, storeName: "primegolf.shuttledeals.com"),
      StoresList(storeId: 292, storeName: "infernowear.shuttledeals.com (Old)"),
    ],
    "95": [
      StoresList(storeId: 294, storeName: "vip.loreoli.com"),
      StoresList(storeId: 295, storeName: "offer.loreoli.com"),
      StoresList(storeId: 296, storeName: "loreoli.com"),
    ],
    "96": [
      StoresList(storeId: 297, storeName: "vylaras.com"),
      StoresList(storeId: 298, storeName: "vip.tallboosts.com"),
      StoresList(storeId: 299, storeName: "try.tallboosts.com"),
      StoresList(storeId: 300, storeName: "tallboosts.com"),
      StoresList(storeId: 301, storeName: "primegolf.shuttledeals.com"),
      StoresList(storeId: 302, storeName: "myvylaras.com"),
    ],
    "97": [
      StoresList(storeId: 208, storeName: "resilia.shop"),
      StoresList(storeId: 303, storeName: "tryresilia.com"),
      StoresList(storeId: 317, storeName: "shopresilia.com"),
      StoresList(storeId: 325, storeName: "resiliashop.com"),
    ],
    "98": [
      StoresList(storeId: 215, storeName: "offer.jackandjillshop.com"),
    ],
    "99": [
      StoresList(storeId: 270, storeName: "vip.buyfemina.com"),
      StoresList(storeId: 271, storeName: "veganichairshop.com"),
      StoresList(storeId: 272, storeName: "tryenhancedscents.com"),
      StoresList(storeId: 273, storeName: "shop.tryenhanced-scents.com"),
      StoresList(storeId: 274, storeName: "members.veganichairshop.com"),
      StoresList(storeId: 275, storeName: "members.startcured.com"),
      StoresList(storeId: 276, storeName: "members.startcured.com"),
      StoresList(storeId: 277, storeName: "vip.tryenhanced-scents.com"),
      StoresList(storeId: 278, storeName: "buyfemina.com"),
      StoresList(storeId: 279, storeName: "Vip.buyfemina.com"),
    ],
    "100": [
      StoresList(storeId: 305, storeName: "snowy-us.com"),
      StoresList(storeId: 306, storeName: "snowy.kratosorganics.com"),
      StoresList(storeId: 321, storeName: "vip.snowy-us.com"),
    ],
    "102": [
      StoresList(storeId: 308, storeName: "velana.us"),
      StoresList(storeId: 328, storeName: "vip.velanastudio.com"),
    ],
    "103": [
      StoresList(storeId: 309, storeName: "offer.zeuslabs.co"),
      StoresList(storeId: 323, storeName: "zeuslabs.co"),
      StoresList(storeId: 342, storeName: "vip.zeuslabs.co"),
    ],
    "104": [
      StoresList(storeId: 310, storeName: "shopatemporium.com"),
      StoresList(storeId: 324, storeName: "vip.shopatemporium.com"),
      StoresList(storeId: 375, storeName: "shop.shopatemporium.com"),
    ],
    "105": [
      StoresList(storeId: 315, storeName: "livegrounded.co"),
      StoresList(storeId: 316, storeName: "vip.livegrounded.co"),
    ],
    "106": [
      StoresList(storeId: 314, storeName: "thehoneypeel.com"),
      StoresList(storeId: 322, storeName: "vip.thehoneypeel.com"),
      StoresList(storeId: 344, storeName: "shop.thehoneypeel.com"),
    ],
    "107": [
      StoresList(storeId: 319, storeName: "quietbounce.com"),
    ],
    "109": [
      StoresList(storeId: 320, storeName: "purely-nutra.com"),
      StoresList(storeId: 343, storeName: "freerangesupplements.com"),
      StoresList(storeId: 354, storeName: "vip.freerangesupplements.com"),
    ],
    "110": [
      StoresList(storeId: 331, storeName: "shop.peak-footwear.com"),
      StoresList(storeId: 339, storeName: "vip.peak-footwear.com"),
    ],
    "111": [
      StoresList(storeId: 327, storeName: "vip.eternaderma.com"),
      StoresList(storeId: 329, storeName: "eternaderma.com"),
    ],
    "112": [
      StoresList(storeId: 326, storeName: "shop.johnnyco.co"),
      StoresList(storeId: 330, storeName: "vip.johnnyco.co"),
      StoresList(storeId: 382, storeName: "johnnyco.co"),
    ],
    "113": [
      StoresList(storeId: 332, storeName: "staugustine.shuttledeals.com"),
      StoresList(storeId: 335, storeName: "matterhornparka.shuttledeals.com"),
      StoresList(storeId: 346, storeName: "lyvona.shuttledeals.com"),
      StoresList(storeId: 347, storeName: "alluralace.shuttledeals.com"),
      StoresList(storeId: 348, storeName: "primegolf.shuttledeals.com"),
      StoresList(storeId: 349, storeName: "buffalotrail.shuttledeals.com"),
      StoresList(storeId: 350, storeName: "myshapeme.shuttledeals.com"),
      StoresList(storeId: 351, storeName: "beauouterwear.shuttledeals.com"),
      StoresList(storeId: 353, storeName: "glamglide.shuttledeals.com"),
      StoresList(storeId: 356, storeName: "monarc.shuttledeals.com"),
      StoresList(storeId: 357, storeName: "huggy.shuttledeals.com"),
      StoresList(storeId: 358, storeName: "infernowear.shuttledeals.com"),
      StoresList(storeId: 359, storeName: "getsilky.shuttledeals.com"),
      StoresList(storeId: 360, storeName: "filtra.shuttledeals.com"),
      StoresList(storeId: 361, storeName: "mytheraspace.shuttledeals.com"),
      StoresList(storeId: 383, storeName: "yardrhythm.shuttledeals.com"),
      StoresList(storeId: 384, storeName: "animelightbox.shuttledeals.com"),
      StoresList(storeId: 385, storeName: "nebiwear.shuttledeals.com"),
      StoresList(storeId: 411, storeName: "bjornregaliashop.shuttledeals.com"),
    ],
    "114": [
      StoresList(storeId: 333, storeName: "weelthcare.com"),
      StoresList(storeId: 334, storeName: "vip.weelthcare.com"),
      StoresList(storeId: 338, storeName: "revive-essence.com"),
      StoresList(storeId: 341, storeName: "vip.revive-essence.com"),
      StoresList(storeId: 379, storeName: "try.weelthcare.com"),
    ],
    "115": [
      StoresList(storeId: 337, storeName: "ordersonoclear.com"),
      StoresList(storeId: 340, storeName: "vip.getsonoclear.com"),
      StoresList(storeId: 345, storeName: "getsonoclear.com"),
      StoresList(storeId: 366, storeName: "SonoClear Funnelish"),
    ],
    "116": [
      StoresList(storeId: 376, storeName: "zenain.com"),
      StoresList(storeId: 391, storeName: "vip.zenain.com"),
    ],
    "117": [
      StoresList(storeId: 377, storeName: "vipsolosoothe.com"),
      StoresList(storeId: 378, storeName: "biovittarewards.com"),
      StoresList(storeId: 380, storeName: "solosootherewards.com"),
      StoresList(storeId: 399, storeName: "shopbiovittawellness.com"),
    ],
    "118": [
      StoresList(storeId: 381, storeName: "evolve77.com"),
      StoresList(storeId: 397, storeName: "membership.evolve77.com"),
    ],
    "119": [
      StoresList(storeId: 386, storeName: "getpurevitals.com"),
      StoresList(storeId: 390, storeName: "vip.getpurevitals.com"),
    ],
    "122": [
      StoresList(storeId: 387, storeName: "Luhxe Shop"),
    ],
    "123": [
      StoresList(storeId: 388, storeName: "Holistic Hercules"),
    ],
    "124": [
      StoresList(storeId: 389, storeName: "offer.avalaine.com"),
    ],
    "127": [
      StoresList(storeId: 393, storeName: "Torpedodeals Shop"),
    ],
    "130": [
      StoresList(storeId: 404, storeName: "try.carticenyc.com"),
      StoresList(storeId: 406, storeName: "vip.carticenyc.com"),
      StoresList(storeId: 408, storeName: "www.carticenyc.com"),
    ],
    "131": [
      StoresList(storeId: 405, storeName: "flashsalenetwork.com"),
    ],
    "132": [
      StoresList(storeId: 401, storeName: "biolgical.com"),
      StoresList(storeId: 403, storeName: "vip.biolgical.com"),
    ],
    "133": [
      StoresList(storeId: 400, storeName: "getlilys.com"),
      StoresList(storeId: 402, storeName: "vip.getlilys.com"),
    ],
    "134": [
      StoresList(storeId: 407, storeName: "seattlebouttique.com"),
    ],
  };
}
