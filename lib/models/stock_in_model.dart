// class RiderLookupData {
//   List<RiderLookupData>? dist;

//   RiderLookupData({this.dist});

//   factory RiderLookupData.fromJson(json) {
//     return RiderLookupData(
//         dist: RiderLookupData.parseDist(json));
//   }

//   static List<RiderLookupDataDist> parseDist(distJson) {
//     var list = distJson as List;
//     List<RiderLookupDataDist> distList =
//         list.map((e) => RiderLookupDataDist.fromJson(e)).toList();
//     return distList;
//   }
// }

class OrdersData {
  List<OrdersDataDist>? dist;
  Pagination? pagination;
  OrdersData({this.dist, this.pagination});

  factory OrdersData.fromJson(json) {
    return OrdersData(
      dist: OrdersData.parseDist(json.dist),
      pagination: json.pagination == null
          ? Pagination()
          : Pagination.fromJson(json.pagination),
    );
  }

  static List<OrdersDataDist> parseDist(dist) {
    var list = dist as List;
    List<OrdersDataDist> distList =
        list.map((e) => OrdersDataDist.fromJson(e)).toList();
    return distList;
  }
}

class OrdersDataDist {
  int? transactionId;
  String? balancePayment;
  String? customerName;
  String? customerPhone;
  String? deliveryAddress;
  bool? disputeInd;
  String? invoicePayment;
  String? orderDeliveryDate;
  String? orderDetail;
  String? orderPickupDate;
  String? orderRefNumber;
  String? paidToMerchant;
  String? receivedAmount;
  String? receivedPaymentDate;
  String? transactionTax;
  String? transactionFee;
  String? reservePayment;
  String? reservePaymentDate;
  String? reversalDate;
  String? settlementDate;
  String? trackingNumber;
  String? transactionDate;
  String? upfrontPayment;
  String? upfrontPaymentDate;
  int? customerId;
  int? merchantId;
  String? merchantName;
  String? merchantEmail1;
  String? merchantEmail2;
  String? merchantPhone1;
  String? merchantPhone2;
  String? merchantAddress1;
  String? merchantAddress2;
  String? merchantCityName;
  int? riderId;
  String? riderName;
  String? riderPhone1;
  String? riderPhone2;
  int? transactionTypeId;
  String? transactionType;
  int? transactionStatusId;
  String? transactionStatus;
  int? transactionPhysicalStatusId;
  String? transactionPhysicalStatus;
  int? orderTypeId;
  String? orderType;
  bool? settled;
  String? reversalTax;
  String? reversalFee;
  int? retryAttemptCount;
  bool? retryAttempt;
  bool? specialRequest;
  bool? cprLevel1;
  bool? cprLevel2;
  bool? cprLevel1Approved;
  bool? cprLevel2Approved;
  int? transactionChannelId;
  String? cityName;
  bool? returnRequested;
  int? wareHouseId;
  String? wareHouseCityName;
  bool? inStock;
  String? transactionNotes;
  int? invoiceDivision;
  int? items;
  String? pickupAddress;
  String? originCity;
  String? riderRemarks;

  OrdersDataDist({
    this.transactionId,
    this.balancePayment,
    this.customerName,
    this.customerPhone,
    this.deliveryAddress,
    this.disputeInd,
    this.invoicePayment,
    this.orderDeliveryDate,
    this.orderDetail,
    this.orderPickupDate,
    this.orderRefNumber,
    this.paidToMerchant,
    this.receivedAmount,
    this.receivedPaymentDate,
    this.transactionTax,
    this.transactionFee,
    this.reservePayment,
    this.reservePaymentDate,
    this.reversalDate,
    this.settlementDate,
    this.trackingNumber,
    this.transactionDate,
    this.upfrontPayment,
    this.upfrontPaymentDate,
    this.customerId,
    this.merchantId,
    this.merchantName,
    this.merchantEmail1,
    this.merchantEmail2,
    this.merchantPhone1,
    this.merchantPhone2,
    this.merchantAddress1,
    this.merchantAddress2,
    this.merchantCityName,
    this.riderId,
    this.riderName,
    this.riderPhone1,
    this.riderPhone2,
    this.transactionTypeId,
    this.transactionType,
    this.transactionStatusId,
    this.transactionStatus,
    this.transactionPhysicalStatusId,
    this.transactionPhysicalStatus,
    this.orderTypeId,
    this.orderType,
    this.settled,
    this.reversalTax,
    this.reversalFee,
    this.retryAttemptCount,
    this.retryAttempt,
    this.specialRequest,
    this.cprLevel1,
    this.cprLevel2,
    this.cprLevel1Approved,
    this.cprLevel2Approved,
    this.transactionChannelId,
    this.cityName,
    this.returnRequested,
    this.wareHouseId,
    this.wareHouseCityName,
    this.inStock,
    this.transactionNotes,
    this.invoiceDivision,
    this.items,
    this.pickupAddress,
    this.originCity,
    this.riderRemarks,
  });

  factory OrdersDataDist.fromJson(Map<String, dynamic> json) {
    return OrdersDataDist(
      transactionId: json['transactionId'],
      balancePayment: json['balancePayment'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      deliveryAddress: json['deliveryAddress'],
      disputeInd: json['disputeInd'],
      invoicePayment: json['invoicePayment'],
      orderDeliveryDate: json['orderDeliveryDate'],
      orderDetail: json['orderDetail'],
      orderPickupDate: json['orderPickupDate'],
      orderRefNumber: json['orderRefNumber'],
      paidToMerchant: json['paidToMerchant'],
      receivedAmount: json['receivedAmount'],
      receivedPaymentDate: json['receivedPaymentDate'],
      transactionTax: json['transactionTax'],
      transactionFee: json['transactionFee'],
      reservePayment: json['reservePayment'],
      reservePaymentDate: json['reservePaymentDate'],
      reversalDate: json['reversalDate'],
      settlementDate: json['settlementDate'],
      trackingNumber: json['trackingNumber'],
      transactionDate: json['transactionDate'],
      upfrontPayment: json['upfrontPayment'],
      upfrontPaymentDate: json['upfrontPaymentDate'],
      customerId: json['customerId'],
      merchantId: json['merchantId'],
      merchantName: json['merchantName'],
      merchantEmail1: json['merchantEmail1'],
      merchantEmail2: json['merchantEmail2'],
      merchantPhone1: json['merchantPhone1'],
      merchantPhone2: json['merchantPhone2'],
      merchantAddress1: json['merchantAddress1'],
      merchantAddress2: json['merchantAddress2'],
      merchantCityName: json['merchantCityName'],
      riderId: json['riderId'],
      riderName: json['riderName'],
      riderPhone1: json['riderPhone1'],
      riderPhone2: json['riderPhone2'],
      transactionTypeId: json['transactionTypeId'],
      transactionType: json['transactionType'],
      transactionStatusId: json['transactionStatusId'],
      transactionStatus: json['transactionStatus'],
      transactionPhysicalStatusId: json['transactionPhysicalStatusId'],
      transactionPhysicalStatus: json['transactionPhysicalStatus'],
      orderTypeId: json['orderTypeId'],
      orderType: json['orderType'],
      settled: json['settled'],
      reversalTax: json['reversalTax'],
      reversalFee: json['reversalFee'],
      retryAttemptCount: json['retryAttemptCount'],
      retryAttempt: json['retryAttempt'],
      specialRequest: json['specialRequest'],
      cprLevel1: json['cprLevel1'],
      cprLevel2: json['cprLevel2'],
      cprLevel1Approved: json['cprLevel1Approved'],
      cprLevel2Approved: json['cprLevel2Approved'],
      transactionChannelId: json['transactionChannelId'],
      cityName: json['cityName'],
      returnRequested: json['returnRequested'],
      wareHouseId: json['wareHouseId'],
      wareHouseCityName: json['wareHouseCityName'],
      inStock: json['inStock'],
      transactionNotes: json['transactionNotes'],
      invoiceDivision: json['invoiceDivision'],
      items: json['items'],
      pickupAddress: json['pickupAddress'],
      originCity: json['originCity'],
      riderRemarks: json['riderRemarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "transactionId": transactionId,
      "balancePayment": balancePayment,
      "customerName": customerName,
      "customerPhone": customerPhone,
      "disputeInd": disputeInd,
      "invoicePayment": invoicePayment,
      "orderDeliveryDate": orderDeliveryDate,
      "orderDetail": orderDetail,
      "orderPickupDate": orderPickupDate,
      "orderRefNumber": orderRefNumber,
      "paidToMerchant": paidToMerchant,
      "receivedAmount": receivedAmount,
      "receivedPaymentDate": receivedPaymentDate,
      "transactionTax": transactionTax,
      "transactionFee": transactionFee,
      "reservePayment": reservePayment,
      "reservePaymentDate": reservePaymentDate,
      "reversalDate": reversalDate,
      "settlementDate": settlementDate,
      "trackingNumber": trackingNumber,
      "transactionDate": transactionDate,
      "upfrontPayment": upfrontPayment,
      "upfrontPaymentDate": upfrontPaymentDate,
      "customerId": customerId,
      "merchantId": merchantId,
      "merchantName": merchantName,
      "merchantEmail1": merchantEmail1,
      "merchantEmail2": merchantEmail2,
      "merchantPhone1": merchantPhone1,
      "merchantPhone2": merchantPhone2,
      "merchantAddress1": merchantAddress1,
      "merchantAddress2": merchantAddress2,
      "merchantCityName": merchantCityName,
      "riderId": riderId,
      "riderName": riderName,
      "riderPhone1": riderPhone1,
      "riderPhone2": riderPhone2,
      "transactionTypeId": transactionTypeId,
      "transactionType": transactionType,
      "transactionStatusId": transactionStatusId,
      "transactionStatus": transactionStatus,
      "orderTypeId": orderTypeId,
      "orderType": orderType,
      "settled": settled,
      "reversalTax": reversalTax,
      "reversalFee": reversalFee,
      "retryAttemptCount": retryAttemptCount,
      "retryAttempt": retryAttempt,
      "specialRequest": specialRequest,
      "cprLevel1": cprLevel1,
      "cprLevel2": cprLevel2,
      "cprLevel1Approved": cprLevel1Approved,
      "cprLevel2Approved": cprLevel2Approved,
      "transactionChannelId": transactionChannelId,
      "cityName": cityName,
      "returnRequested": returnRequested,
      "wareHouseId": wareHouseId,
      "wareHouseCityName": wareHouseCityName,
      "inStock": inStock,
      "transactionNotes": transactionNotes,
      "invoiceDivision": invoiceDivision,
      "items": items,
      "pickupAddress": pickupAddress,
      "originCity": originCity,
      "riderRemarks": riderRemarks,
    };
  }
}

class Pagination {
  int? page;
  int? size;
  int? totalElements;
  int? numberOfElements;
  int? totalPages;

  Pagination(
      {this.page,
      this.size,
      this.totalElements,
      this.numberOfElements,
      this.totalPages});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      size: json['size'],
      totalElements: json['totalElements'],
      numberOfElements: json['numberOfElements'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "size": size,
      "totalElements": totalElements,
      "numberOfElements": numberOfElements,
      "totalPages": totalPages,
    };
  }
}

class RiderLookupData {
  List<RiderLookupDataDist>? dist;
  RiderLookupData({this.dist});
  factory RiderLookupData.fromJson(json) {
    return RiderLookupData(dist: RiderLookupData.parseDist(json));
  }
  static List<RiderLookupDataDist> parseDist(distJson) {
    var list = distJson as List;
    List<RiderLookupDataDist> distList =
        list.map((e) => RiderLookupDataDist.fromJson(e)).toList();
    return distList;
  }
}

class RiderLookupDataDist {
  int? riderId;
  String? riderName;

  RiderLookupDataDist({this.riderId, this.riderName});

  factory RiderLookupDataDist.fromJson(Map<String, dynamic> json) {
    return RiderLookupDataDist(
      riderId: json['riderId'],
      riderName: json['riderName'],
    );
  }
}

class MerchantLookupData {
  List<MerchantLookupDataDist>? dist;
  MerchantLookupData({this.dist});
  factory MerchantLookupData.fromJson(json) {
    return MerchantLookupData(dist: MerchantLookupData.parseDist(json));
  }
  static List<MerchantLookupDataDist> parseDist(distJson) {
    var list = distJson as List;
    List<MerchantLookupDataDist> distList =
        list.map((e) => MerchantLookupDataDist.fromJson(e)).toList();
    return distList;
  }
}

class MerchantLookupDataDist {
  int? merchantId;
  String? merchantName;

  MerchantLookupDataDist({this.merchantId, this.merchantName});

  factory MerchantLookupDataDist.fromJson(Map<String, dynamic> json) {
    return MerchantLookupDataDist(
      merchantId: json['merchantId'],
      merchantName: json['merchantName'],
    );
  }
}

class WareHouseData {
  List<WareHouseDataDist>? dist;

  WareHouseData({this.dist});

  factory WareHouseData.fromJson(json) {
    return WareHouseData(
      dist: WareHouseData.parseDist(json.dist),
    );
  }

  static List<WareHouseDataDist> parseDist(dist) {
    var list = dist as List;
    List<WareHouseDataDist> distList =
        list.map((e) => WareHouseDataDist.fromJson(e)).toList();
    return distList;
  }
}

class WareHouseDataDist {
  int? wareHouseId;
  String? wareHouseName;

  WareHouseDataDist({this.wareHouseId, this.wareHouseName});

  factory WareHouseDataDist.fromJson(Map<String, dynamic> distjson) {
    return WareHouseDataDist(
      wareHouseId: distjson['wareHouseId'],
      wareHouseName: distjson['wareHouseName'],
    );
  }
}

class MarkStockInRequestData {
  List<int>? transactionIds;
  int? wareHouseId;

  MarkStockInRequestData({this.transactionIds, this.wareHouseId});

  Map toJson() {
    return {
      "transactionIds": transactionIds,
      "wareHouseId": wareHouseId,
    };
  }
}

class LoadSheetData {
  List<LoadSheetDataDist>? dist;
  Pagination? pagination;

  LoadSheetData({this.dist, this.pagination});

  factory LoadSheetData.fromJson(json) {
    return LoadSheetData(
      dist: LoadSheetData.parseDist(json.dist),
      pagination: Pagination.fromJson(json.pagination),
    );
  }

  static List<LoadSheetDataDist> parseDist(dist) {
    var list = dist as List;
    List<LoadSheetDataDist> distList =
        list.map((e) => LoadSheetDataDist.fromJson(e)).toList();
    return distList;
  }
}

class LoadSheetDataDist {
  int? loadSheetMasterId;
  String? loadSheetName;
  int? riderId;
  String? riderName;
  int? merchantId;
  String? merchantName;
  int? loadSheetStatusId;
  String? loadSheetStatus;
  int? booked;
  int? picked;
  int? unpicked;
  String? pickupAddress;
  String? loadSheetDate;

  LoadSheetDataDist({
    this.loadSheetMasterId,
    this.loadSheetName,
    this.riderId,
    this.riderName,
    this.merchantId,
    this.merchantName,
    this.loadSheetStatusId,
    this.loadSheetStatus,
    this.booked,
    this.picked,
    this.unpicked,
    this.pickupAddress,
    this.loadSheetDate,
  });

  factory LoadSheetDataDist.fromJson(Map<String, dynamic> jsonDist) {
    return LoadSheetDataDist(
      loadSheetMasterId: jsonDist['loadSheetMasterId'],
      loadSheetName: jsonDist['loadSheetName'],
      riderId: jsonDist['riderId'],
      riderName: jsonDist['riderName'],
      merchantId: jsonDist['merchantId'],
      merchantName: jsonDist['merchantName'],
      loadSheetStatusId: jsonDist['loadSheetStatusId'],
      loadSheetStatus: jsonDist['loadSheetStatus'],
      booked: jsonDist['booked'],
      picked: jsonDist['picked'],
      unpicked: jsonDist['unpicked'],
      pickupAddress: jsonDist['pickupAddress'],
      loadSheetDate: jsonDist['loadSheetDate'],
    );
  }
}

class MerchantCityLookupData {
  List<MerchantCityLookupDataDist>? dist;
  MerchantCityLookupData({this.dist});
  factory MerchantCityLookupData.fromJson(json) {
    return MerchantCityLookupData(dist: MerchantCityLookupData.parseDist(json));
  }
  static List<MerchantCityLookupDataDist> parseDist(distJson) {
    var list = distJson as List;
    List<MerchantCityLookupDataDist> distList =
        list.map((e) => MerchantCityLookupDataDist.fromJson(e)).toList();
    return distList;
  }
}

class MerchantCityLookupDataDist {
  int? cityId;
  String? cityName;

  MerchantCityLookupDataDist({this.cityId, this.cityName});

  factory MerchantCityLookupDataDist.fromJson(Map<String, dynamic> json) {
    return MerchantCityLookupDataDist(
      cityId: json['cityId'],
      cityName: json['cityName'],
    );
  }
}

class MerchantPickupAddressLookupData {
  List<MerchantPickupAddressLookupDataDist>? dist;
  MerchantPickupAddressLookupData({this.dist});
  factory MerchantPickupAddressLookupData.fromJson(json) {
    return MerchantPickupAddressLookupData(
        dist: MerchantPickupAddressLookupData.parseDist(json));
  }
  static List<MerchantPickupAddressLookupDataDist> parseDist(distJson) {
    var list = distJson as List;
    List<MerchantPickupAddressLookupDataDist> distList = list
        .map((e) => MerchantPickupAddressLookupDataDist.fromJson(e))
        .toList();
    return distList;
  }
}

class MerchantPickupAddressLookupDataDist {
  int? merchantAddressId;
  String? phone1;
  String? phone2;
  String? contactPersonName;
  int? merchantId;
  int? cityId;
  String? cityName;
  String? address;

  MerchantPickupAddressLookupDataDist(
      {this.merchantAddressId,
      this.phone1,
      this.phone2,
      this.contactPersonName,
      this.merchantId,
      this.cityId,
      this.cityName,
      this.address});

  factory MerchantPickupAddressLookupDataDist.fromJson(
      Map<String, dynamic> json) {
    return MerchantPickupAddressLookupDataDist(
      merchantAddressId: json['merchantAddressId'],
      phone1: json['phone1'],
      phone2: json['phone2'],
      contactPersonName: json['contactPersonName'],
      merchantId: json['merchantId'],
      cityId: json['cityId'],
      cityName: json['cityName'],
      address: json['address'],
    );
  }
}

class SheetStatusLookupData {
  List<SheetStatusLookupDataDist>? dist;
  SheetStatusLookupData({this.dist});
  factory SheetStatusLookupData.fromJson(json) {
    return SheetStatusLookupData(dist: SheetStatusLookupData.parseDist(json));
  }
  static List<SheetStatusLookupDataDist> parseDist(distJson) {
    var list = distJson as List;
    List<SheetStatusLookupDataDist> distList =
        list.map((e) => SheetStatusLookupDataDist.fromJson(e)).toList();
    return distList;
  }
}

class SheetStatusLookupDataDist {
  int? sheetStatusId;
  String? sheetStatus;

  SheetStatusLookupDataDist({this.sheetStatusId, this.sheetStatus});

  factory SheetStatusLookupDataDist.fromJson(Map<String, dynamic> json) {
    return SheetStatusLookupDataDist(
      sheetStatusId: json['sheetStatusId'],
      sheetStatus: json['sheetStatus'],
    );
  }
}

class LoadSheetOrdersByCriteriaData {
  List<LoadSheetOrdersByCriteriaDataDist>? lsOrdersDist;
  Pagination? pagination;

  LoadSheetOrdersByCriteriaData({this.lsOrdersDist, this.pagination});

  factory LoadSheetOrdersByCriteriaData.fromJson(json) {
    return LoadSheetOrdersByCriteriaData(
      lsOrdersDist: LoadSheetOrdersByCriteriaData.parsedJson(json.dist),
      pagination: json.pagination == null
          ? Pagination()
          : Pagination.fromJson(json.pagination),
    );
  }

  static List<LoadSheetOrdersByCriteriaDataDist> parsedJson(distJson) {
    var list = distJson as List;

    List<LoadSheetOrdersByCriteriaDataDist> distList =
        list.map((e) => LoadSheetOrdersByCriteriaDataDist.fromJson(e)).toList();
    return distList;
  }
}

class LoadSheetOrdersByCriteriaDataDist {
  LoadSheetDataDist? loadsheet;
  OrdersDataDist? transaction;

  LoadSheetOrdersByCriteriaDataDist({this.loadsheet, this.transaction});

  factory LoadSheetOrdersByCriteriaDataDist.fromJson(dist) {
    return LoadSheetOrdersByCriteriaDataDist(
      loadsheet: LoadSheetDataDist.fromJson(dist['loadSheet']),
      transaction: OrdersDataDist.fromJson(dist['transaction']),
    );
  }
}

class SystemLogsData {
  List<SystemLogsDataDist>? dist;

  SystemLogsData({this.dist});

  factory SystemLogsData.fromJson(json) {
    return SystemLogsData(dist: parsedJson(json.dist));
  }

  static List<SystemLogsDataDist> parsedJson(jsonList) {
    var list = jsonList as List;
    List<SystemLogsDataDist> distList =
        list.map((e) => SystemLogsDataDist.fromJson(e)).toList();
    return distList;
  }
}

class SystemLogsDataDist {
  int? transactionLogId;
  int? transactionId;
  int? transactionStatusId;
  String? userName;
  String? logDetail;
  String? createDatetime;
  String? applicationType;

  SystemLogsDataDist({
    this.transactionLogId,
    this.transactionId,
    this.transactionStatusId,
    this.userName,
    this.logDetail,
    this.createDatetime,
    this.applicationType,
  });

  factory SystemLogsDataDist.fromJson(Map<String, dynamic> distJson) {
    return SystemLogsDataDist(
      transactionLogId: distJson['transactionLogId'],
      transactionId: distJson['transactionId'],
      transactionStatusId: distJson['transactionStatusId'],
      userName: distJson['userName'],
      logDetail: distJson['logDetail'],
      createDatetime: distJson['createDatetime'],
      applicationType: distJson['applicationType'],
    );
  }
}

class OrderStatusLookupData {
  List<OrderStatusLookupDataDist>? dist;

  OrderStatusLookupData({this.dist});

  factory OrderStatusLookupData.fromJson(distJson) {
    return OrderStatusLookupData(
      dist: OrderStatusLookupData.parsedJson(distJson.dist),
    );
  }

  static List<OrderStatusLookupDataDist> parsedJson(json) {
    var list = json as List;
    List<OrderStatusLookupDataDist> distList =
        list.map((e) => OrderStatusLookupDataDist.fromJson(e)).toList();
    return distList;
  }
}

class OrderStatusLookupDataDist {
  int? transactionTypeId;
  int? transactionStatusId;
  String? transactionStatus;

  OrderStatusLookupDataDist({
    this.transactionTypeId,
    this.transactionStatusId,
    this.transactionStatus,
  });

  factory OrderStatusLookupDataDist.fromJson(Map<String, dynamic> json) {
    return OrderStatusLookupDataDist(
      transactionTypeId: json['transactionTypeId'],
      transactionStatusId: json['transactionStatusId'],
      transactionStatus: json['transactionStatus'],
    );
  }
}

class OrderRemarksData {
  List<OrderRemarksDataDist>? dist;
  Pagination? pagination;

  OrderRemarksData({this.dist, this.pagination});

  factory OrderRemarksData.fromJson(json) {
    return OrderRemarksData(
      dist: OrderRemarksData.parsedJson(json.dist),
      pagination: Pagination.fromJson(json.pagination),
    );
  }

  static List<OrderRemarksDataDist> parsedJson(distData) {
    var list = distData as List;
    List<OrderRemarksDataDist> distList =
        list.map((e) => OrderRemarksDataDist.fromJson(e)).toList();
    return distList;
  }
}

class OrderRemarksDataDist {
  int? transactionRemarksId;
  String? remarks;
  int? transactionId;
  String? username;
  String? createDatetime;
  int? createdBy;

  OrderRemarksDataDist(
      {this.transactionRemarksId,
      this.remarks,
      this.transactionId,
      this.username,
      this.createDatetime,
      this.createdBy});

  factory OrderRemarksDataDist.fromJson(Map<String, dynamic> json) {
    return OrderRemarksDataDist(
      transactionRemarksId: json['transactionRemarksId'],
      remarks: json['remarks'],
      transactionId: json['transactionId'],
      username: json['username'],
      createDatetime: json['createDatetime'],
      createdBy: json['createdBy'],
    );
  }
}

class OperationalCityData {
  List<OperationalCityDataDist>? dist;
  OperationalCityData({this.dist});
  factory OperationalCityData.fromJson(parsedJson) {
    var list = parsedJson as List;
    return OperationalCityData(
        dist: list.map((e) => OperationalCityDataDist.fromJson(e)).toList());
  }
}

class OperationalCityDataDist {
  int? cityId;
  String? name;
  bool? active;
  OperationalCityDataDist({this.cityId, this.name, this.active});
  factory OperationalCityDataDist.fromJson(Map<String, dynamic> json) {
    return OperationalCityDataDist(
        cityId: json['cityId'], name: json['name'], active: json['active']);
  }
}

class OrderTypeData {
  List<OrderTypeDataDist>? dist;
  OrderTypeData({this.dist});
  factory OrderTypeData.fromJson(parsedJson) {
    var list = parsedJson as List;
    return OrderTypeData(
        dist: list.map((e) => OrderTypeDataDist.fromJson(e)).toList());
  }
}

class OrderTypeDataDist {
  int? orderTypeId;
  String? orderType;
  OrderTypeDataDist({this.orderTypeId, this.orderType});
  factory OrderTypeDataDist.fromJson(Map<String, dynamic> json) {
    return OrderTypeDataDist(
        orderTypeId: json['orderTypeId'], orderType: json['orderType']);
  }
}

class MasterUnitLookupData {
  List<MasterUnitDataDist>? dist;
  MasterUnitLookupData({this.dist});
  factory MasterUnitLookupData.fromJson(json) {
    return MasterUnitLookupData(
        dist: MasterUnitLookupData.parseDist(json.dist));
  }

  static List<MasterUnitDataDist> parseDist(dist) {
    var list = dist as List;
    List<MasterUnitDataDist> distList =
        list.map((e) => MasterUnitDataDist.fromJson(e)).toList();
    return distList;
  }
}

class MasterUnitData {
  List<MasterUnitDataDist>? dist;
  Pagination? pagination;
  MasterUnitData({this.dist, this.pagination});

  factory MasterUnitData.fromJson(json) {
    return MasterUnitData(
        dist: MasterUnitData.parseDist(json.dist),
        pagination: json.pagination == null
            ? Pagination()
            : Pagination.fromJson(json.pagination));
  }
  static List<MasterUnitDataDist> parseDist(dist) {
    var list = dist as List;
    List<MasterUnitDataDist> distList =
        list.map((e) => MasterUnitDataDist.fromJson(e)).toList();
    return distList;
  }
}

class MasterUnitDataDist {
  int? masterUnitId;
  int? wareHouseId;
  String? wareHouseName;
  int? masterUnitStatusId;
  String? masterUnitStatus;
  String? masterUnitNumber;
  String? masterUnitTag;
  int? toTeamId;
  String? toTeam;
  int? fromTeamId;
  String? fromTeam;

  MasterUnitDataDist(
      {this.masterUnitId,
      this.masterUnitNumber,
      this.masterUnitStatus,
      this.masterUnitStatusId,
      this.masterUnitTag,
      this.wareHouseId,
      this.wareHouseName,
      this.toTeamId,
      this.toTeam,
      this.fromTeamId,
      this.fromTeam});

  factory MasterUnitDataDist.fromJson(Map<String, dynamic> json) {
    return MasterUnitDataDist(
      masterUnitId: json['masterUnitId'],
      masterUnitNumber: json['masterUnitNumber'],
      masterUnitStatus: json['masterUnitStatus'],
      masterUnitStatusId: json['masterUnitStatusId'],
      masterUnitTag: json['masterUnitTag'],
      wareHouseId: json['wareHouseId'],
      wareHouseName: json['wareHouseName'],
      toTeamId: json['toTeamId'],
      toTeam: json['toTeam'],
      fromTeamId: json['fromTeamId'],
      fromTeam: json['fromTeam'],
    );
  }
}

class MasterUnitDetailData {
  List<MasterUnitDetailDataDist>? dist;
  Pagination? pagination;
  MasterUnitDetailData({this.dist, this.pagination});

  factory MasterUnitDetailData.fromJson(json) {
    return MasterUnitDetailData(
      dist: MasterUnitDetailData.parseDist(json.dist),
      pagination: Pagination.fromJson(json.pagination),
    );
  }

  static List<MasterUnitDetailDataDist> parseDist(distJson) {
    var list = distJson as List;

    List<MasterUnitDetailDataDist> distList =
        list.map((e) => MasterUnitDetailDataDist.fromJson(e)).toList();
    return distList;
  }
}

class MasterUnitDetailDataDist {
  int? masterUnitDetailId;
  int? masterUnitId;
  String? masterUnitNumber;
  String? masterUnitTag;
  int? masterUnitStatusId;
  String? masterUnitStatus;
  int? wareHouseId;
  String? wareHouseName;
  OrdersDataDist? transaction;

  MasterUnitDetailDataDist(
      {this.masterUnitDetailId,
      this.masterUnitId,
      this.masterUnitNumber,
      this.masterUnitStatus,
      this.masterUnitStatusId,
      this.masterUnitTag,
      this.transaction,
      this.wareHouseId,
      this.wareHouseName});

  factory MasterUnitDetailDataDist.fromJson(Map<String, dynamic> json) {
    return MasterUnitDetailDataDist(
      masterUnitDetailId: json['masterUnitDetailId'],
      masterUnitId: json['masterUnitId'],
      masterUnitNumber: json['masterUnitNumber'],
      masterUnitStatus: json['masterUnitStatus'],
      masterUnitStatusId: json['masterUnitStatusId'],
      masterUnitTag: json['masterUnitTag'],
      transaction: json['transaction'] != null
          ? OrdersDataDist.fromJson(json['transaction'])
          : null,
      wareHouseId: json['wareHouseId'],
      wareHouseName: json['wareHouseName'],
    );
  }
}

class UserRolesLookupData {
  List<UserRolesLookupDataDist>? dist;
  UserRolesLookupData({this.dist});

  factory UserRolesLookupData.fromJson(json) {
    return UserRolesLookupData(dist: UserRolesLookupData.parseDist(json.dist));
  }
  static List<UserRolesLookupDataDist> parseDist(dist) {
    var list = dist as List;
    List<UserRolesLookupDataDist> distList =
        list.map((e) => UserRolesLookupDataDist.fromJson(e)).toList();
    return distList;
  }
}

class UserRolesLookupDataDist {
  int? roleId;
  String? roleName;
  String? roleCode;
  bool? active;
  int? accessLevel;
  int? parentRoleId;
  String? parentRoleName;

  UserRolesLookupDataDist(
      {this.roleId,
      this.roleName,
      this.roleCode,
      this.active,
      this.accessLevel,
      this.parentRoleId,
      this.parentRoleName});

  factory UserRolesLookupDataDist.fromJson(Map<String, dynamic> json) {
    return UserRolesLookupDataDist(
        roleId: json['roleId'],
        roleName: json['roleName'],
        roleCode: json['roleCode'],
        active: json['active'],
        accessLevel: json['accessLevel'],
        parentRoleId: json['parentRoleId'],
        parentRoleName: json['parentRoleName']);
  }
}

class RolesLookupData {
  List<RolesLookupDataDist>? dist;

  RolesLookupData({this.dist});
  factory RolesLookupData.fromJson(json) {
    return RolesLookupData(dist: RolesLookupData.parseDist(json.dist));
  }
  static List<RolesLookupDataDist> parseDist(dist) {
    var list = dist as List;
    List<RolesLookupDataDist> distList =
        list.map((e) => RolesLookupDataDist.formJson(e)).toList();
    return distList;
  }
}

class RolesLookupDataDist {
  int? roleId;
  String? roleName;
  String? roleCode;
  bool? active;
  int? accessLevel;
  int? parentRoleId;
  String? parentRoleName;

  RolesLookupDataDist(
      {this.roleId,
      this.roleName,
      this.roleCode,
      this.active,
      this.accessLevel,
      this.parentRoleId,
      this.parentRoleName});

  factory RolesLookupDataDist.formJson(Map<String, dynamic> json) {
    return RolesLookupDataDist(
        roleId: json['roleId'],
        roleName: json['roleName'],
        roleCode: json['roleCode'],
        active: json['active'],
        accessLevel: json['accessLevel'],
        parentRoleId: json['parentRoleId'],
        parentRoleName: json['parentRoleName']);
  }
}

class EmployeeProfileData {
  EmployeeProfileDataDist? dist;

  EmployeeProfileData({this.dist});

  factory EmployeeProfileData.fromJson(json) {
    return EmployeeProfileData(
      dist: json.dist != null
          ? EmployeeProfileDataDist.fromJson(json.dist)
          : null,
    );
  }
}

class EmployeeProfileDataDist {
  int? employeeId;
  String? employeeCode;
  String? firstName;
  String? lastName;
  String? joiningDate;
  String? email1;
  String? presentAddress;
  String? permanentAddress;
  String? phone1;
  String? phone2;
  String? nationalIdNumber;
  String? nationalTaxNumber;
  int? age;
  String? gender;
  String? dob;
  String? maritalStatus;
  String? emergencyContact;
  bool? onlineAccess;
  bool? holdPayments;
  int? managerId;
  bool? isManager;
  int? designationId;
  String? designationName;
  int? departmentId;
  String? departmentName;
  int? cityId;
  String? cityName;
  int? employeeStatusId;
  String? employeeStatus;
  List<EmployeeWareHouses>? employeeWareHouses;

  EmployeeProfileDataDist(
      {this.employeeId,
      this.employeeCode,
      this.firstName,
      this.lastName,
      this.joiningDate,
      this.email1,
      this.presentAddress,
      this.permanentAddress,
      this.phone1,
      this.phone2,
      this.nationalIdNumber,
      this.nationalTaxNumber,
      this.age,
      this.gender,
      this.dob,
      this.maritalStatus,
      this.emergencyContact,
      this.onlineAccess,
      this.holdPayments,
      this.managerId,
      this.isManager,
      this.designationId,
      this.designationName,
      this.departmentId,
      this.departmentName,
      this.cityId,
      this.cityName,
      this.employeeStatusId,
      this.employeeStatus,
      this.employeeWareHouses});

  factory EmployeeProfileDataDist.fromJson(Map<String, dynamic> json) {
    var list = json['employeeWareHouses'] as List;
    return EmployeeProfileDataDist(
      employeeId: json['employeeId'],
      employeeCode: json['employeeCode'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      joiningDate: json['joiningDate'],
      email1: json['email1'],
      presentAddress: json['presentAddress'],
      permanentAddress: json['permanentAddress'],
      phone1: json['phone1'],
      phone2: json['phone2'],
      nationalIdNumber: json['nationalIdNumber'],
      nationalTaxNumber: json['nationalTaxNumber'],
      age: json['age'],
      gender: json['gender'],
      dob: json['dob'],
      maritalStatus: json['maritalStatus'],
      emergencyContact: json['emergencyContact'],
      onlineAccess: json['onlineAccess'],
      holdPayments: json['holdPayments'],
      managerId: json['managerId'],
      isManager: json['isManager'],
      designationId: json['designationId'],
      designationName: json['designationName'],
      departmentId: json['departmentId'],
      departmentName: json['departmentName'],
      cityId: json['cityId'],
      cityName: json['cityName'],
      employeeStatusId: json['employeeStatusId'],
      employeeStatus: json['employeeStatus'],
      employeeWareHouses:
          list.map((e) => EmployeeWareHouses.fromJson(e)).toList(),
    );
  }
}

class EmployeeWareHouses {
  int? employeeWareHouseId;
  int? wareHouseId;
  String? wareHouseName;

  EmployeeWareHouses(
      {this.employeeWareHouseId, this.wareHouseId, this.wareHouseName});

  factory EmployeeWareHouses.fromJson(Map<String, dynamic> json) {
    return EmployeeWareHouses(
      employeeWareHouseId: json['employeeWareHouseId'],
      wareHouseId: json['wareHouseId'],
      wareHouseName: json['wareHouseName'],
    );
  }
}

class AttemptReasonData {
  List<AttemptReasonDataDist>? dist;
  AttemptReasonData({this.dist});
  factory AttemptReasonData.fromJson(json) {
    return AttemptReasonData(dist: AttemptReasonData.parseDist(json.dist));
  }

  static List<AttemptReasonDataDist> parseDist(dist) {
    var list = dist as List;
    List<AttemptReasonDataDist> distList =
        list.map((e) => AttemptReasonDataDist.fromJson(e)).toList();
    return distList;
  }
}

class AttemptReasonDataDist {
  int? attemptReasonId;
  String? attemptReason;
  int? sequenceNo;
  bool? active;
  AttemptReasonDataDist(
      {this.attemptReasonId, this.attemptReason, this.sequenceNo, this.active});

  factory AttemptReasonDataDist.fromJson(Map<String, dynamic> json) {
    return AttemptReasonDataDist(
      attemptReasonId: json['attemptReasonId'],
      attemptReason: json['attemptReason'],
      sequenceNo: json['sequenceNo'],
      active: json['active'],
    );
  }
}

class ValidateGenerateSheetData {
  bool? isRiderHasAnyPendingSheet;

  ValidateGenerateSheetData({this.isRiderHasAnyPendingSheet});

  factory ValidateGenerateSheetData.fromJson(json) {
    return ValidateGenerateSheetData(
      isRiderHasAnyPendingSheet: json['isRiderHasAnyPendingSheet'],
    );
  }
}
