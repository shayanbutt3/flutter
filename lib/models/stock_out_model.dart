import 'package:backoffice_new/models/stock_in_model.dart';

class SheetsData {
  List<SheetsDataDist>? dist;
  Pagination? pagination;

  SheetsData({this.dist, this.pagination});

  factory SheetsData.fromJson(json) {
    return SheetsData(
      dist: SheetsData.parseDist(json.dist),
      pagination: Pagination.fromJson(json.pagination),
    );
  }

  static List<SheetsDataDist> parseDist(distJson) {
    var list = distJson as List;

    List<SheetsDataDist> distList =
        list.map((e) => SheetsDataDist.fromJson(e)).toList();
    return distList;
  }
}

class SheetsDataDist {
  String? sheetNumber;
  String? sheetTag;
  int? sheetStatusId;
  String? sheetStatus;
  int? sheetTypeId;
  String? sheetType;
  String? riderName;
  int? riderId;
  SheetStats? stats;
  int? sheetId;
  int? originWareHouseId;

  SheetsDataDist({
    this.sheetNumber,
    this.sheetTag,
    this.sheetStatusId,
    this.sheetStatus,
    this.sheetTypeId,
    this.sheetType,
    this.riderName,
    this.riderId,
    this.stats,
    this.sheetId,
    this.originWareHouseId,
  });

  factory SheetsDataDist.fromJson(Map<String, dynamic> json) {
    return SheetsDataDist(
        sheetNumber: json['sheetNumber'],
        sheetTag: json['sheetTag'] ?? '',
        sheetStatusId: json['sheetStatusId'],
        sheetStatus: json['sheetStatus'],
        sheetTypeId: json['sheetTypeId'],
        sheetType: json['sheetType'],
        riderName: json['riderName'],
        riderId: json['riderId'],
        stats: json['stats'] == null
            ? SheetStats()
            : SheetStats.fromJson(json['stats']),
        sheetId: json['sheetId'],
        originWareHouseId: json['originWareHouseId']);
  }
}

class SheetStats {
  int? picked;
  dynamic totalPickedAmount;
  int? unpicked;
  dynamic totalUnPickedAmount;
  int? delivered;
  dynamic totalDeliveredAmount;
  int? totalOrder;
  dynamic totalAmount;

  SheetStats(
      {this.picked,
      this.totalPickedAmount,
      this.unpicked,
      this.totalUnPickedAmount,
      this.delivered,
      this.totalDeliveredAmount,
      this.totalOrder,
      this.totalAmount});

  factory SheetStats.fromJson(Map<String, dynamic> json) {
    return SheetStats(
      picked: json['picked'],
      totalPickedAmount: json['totalPickedAmount'],
      unpicked: json['unpicked'],
      totalUnPickedAmount: json['totalUnPickedAmount'],
      delivered: json['delivered'],
      totalDeliveredAmount: json['totalDeliveredAmount'],
      totalOrder: json['totalOrder'],
      totalAmount: json['totalAmount'],
    );
  }
}

class SheetDetailData {
  List<SheetDetailDataDist>? dist;
  Pagination? pagination;

  SheetDetailData({this.dist, this.pagination});

  factory SheetDetailData.fromJson(json) {
    return SheetDetailData(
      dist: SheetDetailData.parseDist(json.dist),
      pagination: json.pagination == null
          ? Pagination()
          : Pagination.fromJson(json.pagination),
    );
  }

  static List<SheetDetailDataDist> parseDist(distJson) {
    var list = distJson as List;

    List<SheetDetailDataDist> distList =
        list.map((e) => SheetDetailDataDist.fromJson(e)).toList();
    return distList;
  }
}

class SheetDetailDataDist {
  int? sheetStatusId;
  String? sheetStatus;
  int? sheetTypeId;
  String? sheetType;
  int? sheetDetailId;
  String? sheetNumber;
  int? sheetTransactionStatusId;
  String? sheetTransactionStatus;
  OrdersDataDist? transaction;
  String? riderName;
  int? riderId;
  int? sheetId;

  SheetDetailDataDist(
      {this.sheetStatusId,
      this.sheetStatus,
      this.sheetTypeId,
      this.sheetType,
      this.sheetDetailId,
      this.sheetNumber,
      this.sheetTransactionStatusId,
      this.sheetTransactionStatus,
      this.transaction,
      this.riderName,
      this.riderId,
      this.sheetId});

  factory SheetDetailDataDist.fromJson(Map<String, dynamic> json) {
    return SheetDetailDataDist(
      sheetStatusId: json['sheetStatusId'],
      sheetStatus: json['sheetStatus'],
      sheetTypeId: json['sheetTypeId'],
      sheetType: json['sheetType'],
      sheetDetailId: json['sheetDetailId'],
      sheetNumber: json['sheetNumber'],
      sheetTransactionStatusId: json['sheetTransactionStatusId'],
      sheetTransactionStatus: json['sheetTransactionStatus'],
      transaction: json['transaction'] != null
          ? OrdersDataDist.fromJson(json['transaction'])
          : null,
      riderName: json['riderName'],
      riderId: json['riderId'],
      sheetId: json['sheetId'],
    );
  }
}

class MarkDeliveryEnRouteRequestData {
  List<int>? transactionIds;

  MarkDeliveryEnRouteRequestData({this.transactionIds});

  Map toJson() {
    return {
      "transactionIds": transactionIds,
    };
  }
}

class MarkReturnInTransitRequestData {
  List<int>? transactionIds;

  MarkReturnInTransitRequestData({this.transactionIds});

  Map toJson() {
    return {
      "transactionIds": transactionIds,
    };
  }
}

class GenerateDeliverySheetRequestData {
  int? riderId;
  List<int>? transactionIds;
  int? warehouseId;

  GenerateDeliverySheetRequestData(
      {this.riderId, this.transactionIds, this.warehouseId});

  Map toJson() {
    return {
      "riderId": riderId,
      "transactionIds": transactionIds,
      "warehouseId": warehouseId,
    };
  }
}

class GenerateReturnSheetRequestData {
  int? riderId;
  List<int>? transactionIds;
  int? warehouseId;

  GenerateReturnSheetRequestData(
      {this.riderId, this.transactionIds, this.warehouseId});

  Map toJson() {
    return {
      "riderId": riderId,
      "transactionIds": transactionIds,
      "warehouseId": warehouseId,
    };
  }
}

class GenerateTransferSheetRequestData {
  String? sheetTag;
  List<int>? transactionIds;
  int? wareHouseId;

  GenerateTransferSheetRequestData(
      {this.sheetTag, this.transactionIds, this.wareHouseId});

  Map toJson() {
    return {
      "sheetTag": sheetTag,
      "transactionIds": transactionIds,
      "wareHouseId": wareHouseId,
    };
  }
}

// class MarkUnderVerificationRequestData {
//   String? remarks;
//   List<int>? transactionIds;
//   MarkUnderVerificationRequestData({this.remarks, this.transactionIds});
//   Map toJson() {
//     return {
//       "remarks": remarks,
//       "transactionIds": transactionIds,
//     };
//   }
// }

class RemarksAndListTransactionIdsRequestData {
  String? remarks;
  List<int>? transactionIds;

  RemarksAndListTransactionIdsRequestData({this.remarks, this.transactionIds});

  Map toJson() {
    return {
      "remarks": remarks ?? '',
      "transactionIds": transactionIds,
    };
  }
}

class MarkDeliveryUnderReviewRequestData {
  String? remarks;
  List<int>? transactionIds;
  int? wareHouseId;

  MarkDeliveryUnderReviewRequestData(
      {this.remarks, this.transactionIds, this.wareHouseId});

  Map toJson() {
    return {
      "remarks": remarks ?? '',
      "transactionIds": transactionIds,
      "wareHouseId": wareHouseId,
    };
  }
}

class MarkPickedRequestData {
  int? merchantAddressId;
  int? merchantId;
  int? riderId;
  List<int>? transactionIds;

  MarkPickedRequestData(
      {this.merchantAddressId,
      this.merchantId,
      this.riderId,
      this.transactionIds});

  Map toJson() {
    return {
      "merchantAddressId": merchantAddressId,
      "merchantId": merchantId,
      "riderId": riderId,
      "transactionIds": transactionIds,
    };
  }
}

class MarkDeliveredRequestData {
  String? latitudeLongitude;
  String? proofOfDeliveredImage;
  double? receivedAmount;
  int? transactionId;
  String? transactionRemark;

  MarkDeliveredRequestData(
      {this.latitudeLongitude,
      this.proofOfDeliveredImage,
      this.receivedAmount,
      this.transactionId,
      this.transactionRemark});

  Map toJson() {
    return {
      "latitudeLongitude": latitudeLongitude,
      "proofOfDeliveredImage": proofOfDeliveredImage,
      "receivedAmount": receivedAmount,
      "transactionId": transactionId,
      "orderRemark": transactionRemark,
    };
  }
}

class GenerateLoadSheetRequestData {
  int? merchantAddressId;
  int? merchantId;
  List<int>? transactionId;

  GenerateLoadSheetRequestData({
    this.merchantAddressId,
    this.merchantId,
    this.transactionId,
  });

  Map toJson() {
    return {
      "merchantAddressId": merchantAddressId,
      "merchantId": merchantId,
      "transactionId": transactionId,
    };
  }
}

class MarkRetryReAttemptRequestData {
  String? remarks;
  List<int>? transactionId;

  MarkRetryReAttemptRequestData({this.remarks, this.transactionId});

  Map toJson() {
    return {
      "remarks": remarks,
      "transactionId": transactionId,
    };
  }
}

class AssignLoadSheetRequestData {
  List<int>? loadSheetIds;
  int? riderId;

  AssignLoadSheetRequestData({this.loadSheetIds, this.riderId});

  Map toJson() {
    return {
      "loadSheetIds": loadSheetIds,
      "riderId": riderId,
    };
  }
}

class CreateOrderRequestData {
  String? cityName;
  String? customerName;
  String? customerPhone;
  String? deliveryAddress;
  int? invoiceDivision;
  int? invoicePayment;
  int? items;
  int? merchantId;
  String? orderDetail;
  String? orderRefNumber;
  int? orderTypeId;
  String? remarks;
  String? transactionNotes;
  CreateOrderRequestData(
      {this.cityName,
      this.customerName,
      this.customerPhone,
      this.deliveryAddress,
      this.invoiceDivision,
      this.invoicePayment,
      this.items,
      this.merchantId,
      this.orderDetail,
      this.orderRefNumber,
      this.orderTypeId,
      this.remarks,
      this.transactionNotes});
  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress,
      'invoiceDivision': invoiceDivision,
      'invoicePayment': invoicePayment,
      'items': items,
      'merchantId': merchantId,
      'orderDetail': orderDetail,
      'orderRefNumber': orderRefNumber,
      'orderTypeId': orderTypeId,
      'remarks': remarks,
      'transactionNotes': transactionNotes,
    };
  }
}

class UpdateOrderRequestData {
  String? cityName;
  int? customerId;
  String? customerName;
  String? customerPhone;
  String? deliveryAddress;
  int? invoiceDivison;
  double? invoicePayment;
  int? items;
  String? notes;
  String? orderDetail;
  String? orderRefNumber;
  int? orderTypeId;
  UpdateOrderRequestData(
      {this.cityName,
      this.customerId,
      this.customerName,
      this.customerPhone,
      this.deliveryAddress,
      this.invoiceDivison,
      this.invoicePayment,
      this.items,
      this.notes,
      this.orderDetail,
      this.orderRefNumber,
      this.orderTypeId});
  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress,
      'invoiceDivision': invoiceDivison,
      'invoicePayment': invoicePayment,
      'items': items,
      'notes': notes,
      'orderDetail': orderDetail,
      'orderRefNumber': orderRefNumber,
      'ordertypeId': orderTypeId
    };
  }
}

class RevertOrderRequestData {
  List<int>? transactionIds;

  RevertOrderRequestData({this.transactionIds});

  Map toJson() {
    return {'transactionIds': transactionIds};
  }
}

class RevertPickedOrderRequestData {
  List<int>? transactionIds;

  RevertPickedOrderRequestData({this.transactionIds});

  Map toJson() {
    return {
      "transactionIds": transactionIds,
    };
  }
}

class RevertSheetRequestData {
  List<int>? sheetMasterIds;
  int? sheetTypeId;

  RevertSheetRequestData({this.sheetMasterIds, this.sheetTypeId});

  Map toJson() {
    return {
      "sheetMasterIds": sheetMasterIds,
      "sheetTypeId": sheetTypeId,
    };
  }
}

class DeManifestRequestData {
  int? masterUnitId;
  List<int>? transactionIds;

  DeManifestRequestData({this.masterUnitId, this.transactionIds});

  Map toJson() {
    return {
      "masterUnitId": masterUnitId,
      "transactionIds": transactionIds,
    };
  }
}

class CreateMURequestData {
  int? fromTeamId;
  String? masterUnitTag;
  int? toTeamId;
  List<int>? transactionIds;
  int? wareHouseId;

  CreateMURequestData({
    this.fromTeamId,
    this.masterUnitTag,
    this.toTeamId,
    this.transactionIds,
    this.wareHouseId,
  });

  Map toJson() {
    return {
      "fromTeamId": fromTeamId,
      "masterUnitTag": masterUnitTag,
      "toTeamId": toTeamId,
      "transactionIds": transactionIds,
      "wareHouseId": wareHouseId,
    };
  }
}

class DispatchTransferSheetRequestData {
  List<int>? sheetMasterIds;
  DispatchTransferSheetRequestData({this.sheetMasterIds});

  Map toJson() {
    return {
      'sheetMasterIds': sheetMasterIds,
    };
  }
}

class MarkMisrouteRequestData {
  String? remarks;
  List<int>? transactionIds;

  MarkMisrouteRequestData({this.remarks, this.transactionIds});

  Map toJson() {
    return {
      "remarks": remarks ?? '',
      "transactionIds": transactionIds,
    };
  }
}

class RescheduleReturnRequestData {
  String? remarks;
  List<int>? transactionIds;

  RescheduleReturnRequestData({this.transactionIds, this.remarks});

  Map toJson() {
    return {
      "remarks": remarks,
      "transactionIds": transactionIds,
    };
  }
}

class MarkCustomerRefusedRequestData {
  String? remarks;
  List<int>? transactionIds;
  MarkCustomerRefusedRequestData({this.remarks, this.transactionIds});

  Map toJson() {
    return {
      "remarks": remarks,
      "transactionIds": transactionIds,
    };
  }
}

class MarkLostRequestData {
  String? remarks;
  List<int>? transactionIds;

  MarkLostRequestData({this.remarks, this.transactionIds});

  Map toJson() {
    return {
      "remarks": remarks,
      "transactionIds": transactionIds,
    };
  }
}

class PickUpInboundRequestData {
  List<int>? transactionIds;
  int? wareHouseId;

  PickUpInboundRequestData({this.transactionIds, this.wareHouseId});

  Map toJson() {
    return {
      "transactionIds": transactionIds,
      "wareHouseId": wareHouseId,
    };
  }
}

class HandoverMasterUnitRequestData {
  List<int>? masterUnitIds;
  HandoverMasterUnitRequestData({this.masterUnitIds});

  Map toJson() {
    return {
      "masterUnitIds": masterUnitIds,
    };
  }
}

class DeliveryRescheduleRequestData {
  String? remarks;
  List<int>? transactionIds;
  int? wareHouseId;

  DeliveryRescheduleRequestData({
    this.remarks,
    this.transactionIds,
    this.wareHouseId,
  });

  Map toJson() {
    return {
      "remarks": remarks,
      "transactionIds": transactionIds,
      "wareHouseId": wareHouseId,
    };
  }
}

class TransferInboundRequestData {
  List<int>? transactionIds;

  TransferInboundRequestData({this.transactionIds});

  Map toJson() {
    return {
      "transactionIds": transactionIds,
    };
  }
}

class TransitHubRequestData {
  int? sheetId;

  TransitHubRequestData({this.sheetId});

  Map toJson() {
    return {
      "sheetId": sheetId,
    };
  }
}

class DeManifestTransferSheetRequestData {
  int? sheetMasterId;
  List<int>? transactionIds;

  DeManifestTransferSheetRequestData({this.sheetMasterId, this.transactionIds});

  Map toJson() {
    return {
      "sheetMasterId": sheetMasterId,
      "transactionIds": transactionIds,
    };
  }
}

class WaitingForTransferDeManifestOrderRequestData {
  int? sheetId;

  WaitingForTransferDeManifestOrderRequestData({this.sheetId});

  Map toJson() {
    return {
      "sheetId": sheetId,
    };
  }
}

class HandoverTransferSheetRequestData {
  List<int>? sheetMasterIds;

  HandoverTransferSheetRequestData({this.sheetMasterIds});

  Map toJson() {
    return {
      "sheetMasterIds": sheetMasterIds,
    };
  }
}
