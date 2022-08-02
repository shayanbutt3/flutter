class OrderStatsDataDist {
  List<OrderStats>? orderStats;
  int? total;
  OrderStatsDataDist({this.orderStats, this.total});

  factory OrderStatsDataDist.fromJson(distJson) {
    return OrderStatsDataDist(
      orderStats: parsedList(distJson['orderStatsDtoList']),
      total: distJson['total'],
    );
  }

  static List<OrderStats> parsedList(dist) {
    var list = dist as List;
    List<OrderStats> distList =
        list.map((e) => OrderStats.fromJson(e)).toList();
    return distList;
  }
}

class OrderStats {
  int? transactionStatusId;
  String? transactionStatus;
  int? total;
  dynamic percentage;
  OrderStats(
      {this.transactionStatusId,
      this.transactionStatus,
      this.total,
      this.percentage});

  factory OrderStats.fromJson(Map<String, dynamic> json) {
    return OrderStats(
      transactionStatusId: json['transactionStatusId'],
      transactionStatus: json['transactionStatus'],
      total: json['total'],
      percentage: json['percentage'] == "NaN" ? null : json['percentage'],
    );
  }
}

class OrderRatesDataDist {
  int? totalOrdersInDeliverySheet;
  int? totalDeliveryEnRoute;
  dynamic totalAttemptedRate;
  List<OrderRateGraph>? attemptRateGraph;
  dynamic totalSuccessRate;
  List<OrderRateGraph>? successRateGraph;
  dynamic totalDeliveryRate;
  List<OrderRateGraph>? deliveryRateGraph;
  dynamic totalDeliveryEnRouteRate;
  List<OrderRateGraph>? deliveryEnRouteRateGraph;

  OrderRatesDataDist({
    this.totalOrdersInDeliverySheet,
    this.totalDeliveryEnRoute,
    this.totalAttemptedRate,
    this.attemptRateGraph,
    this.totalSuccessRate,
    this.successRateGraph,
    this.totalDeliveryRate,
    this.deliveryRateGraph,
    this.totalDeliveryEnRouteRate,
    this.deliveryEnRouteRateGraph,
  });

  factory OrderRatesDataDist.fromJson(distJson) {
    var attemptGraphList = distJson['attemptRateGraph'] == null
        ? []
        : distJson['attemptRateGraph'] as List;
    var successGraphList = distJson['successRateGraph'] == null
        ? []
        : distJson['successRateGraph'] as List;
    var deliveryGraphList = distJson['deliveryRateGraph'] == null
        ? []
        : distJson['deliveryRateGraph'] as List;
    var deliveryEnrouteGraphList = distJson['deliveryEnRouteRateGraph'] == null
        ? []
        : distJson['deliveryEnRouteRateGraph'] as List;
    return OrderRatesDataDist(
      totalOrdersInDeliverySheet: distJson['totalOrdersInDeliverySheet'],
      totalDeliveryEnRoute: distJson['totalDeliveryEnRoute'],
      totalAttemptedRate: distJson['totalAttemptedRate'],
      attemptRateGraph:
          attemptGraphList.map((e) => OrderRateGraph.fromJson(e)).toList(),
      totalSuccessRate: distJson['totalSuccessRate'],
      successRateGraph:
          successGraphList.map((r) => OrderRateGraph.fromJson(r)).toList(),
      totalDeliveryRate: distJson['totalDeliveryRate'],
      deliveryRateGraph:
          deliveryGraphList.map((e) => OrderRateGraph.fromJson(e)).toList(),
      totalDeliveryEnRouteRate: distJson['totalDeliveryEnRouteRate'],
      deliveryEnRouteRateGraph: deliveryEnrouteGraphList
          .map((e) => OrderRateGraph.fromJson(e))
          .toList(),
    );
  }
}

class OrderRateGraph {
  String? date;
  dynamic percentage;

  OrderRateGraph({this.date, this.percentage});

  factory OrderRateGraph.fromJson(Map<String, dynamic> json) {
    return OrderRateGraph(
      date: json['date'],
      percentage: json['percentage'] == "Infinity" ? 0 : json['percentage'],
    );
  }
}

class OrdersCountData {
  OrdersCountDataDist? dist;

  OrdersCountData({this.dist});

  factory OrdersCountData.fromJson(json) {
    return OrdersCountData(
      dist: OrdersCountDataDist.fromJson(json.dist),
    );
  }
}

class OrdersCountDataDist {
  int? totalDelivered;
  List<OrdersCountGraph>? deliveredCountGraph;
  int? totalPicked;
  List<OrdersCountGraph>? pickedCountGraph;
  int? totalReturned;
  List<OrdersCountGraph>? returnedCountGraph;

  OrdersCountDataDist(
      {this.totalDelivered,
      this.deliveredCountGraph,
      this.totalPicked,
      this.pickedCountGraph,
      this.totalReturned,
      this.returnedCountGraph});

  factory OrdersCountDataDist.fromJson(Map<String, dynamic> distJson) {
    List deliveredGraphList = distJson['deliveredCountGraph'] as List;
    List pickedGraphList = distJson['pickedCountGraph'] as List;
    List returnedGraphList = distJson['returnedCountGraph'] as List;
    return OrdersCountDataDist(
      totalDelivered: distJson['totalDelivered'],
      deliveredCountGraph:
          deliveredGraphList.map((e) => OrdersCountGraph.fromJson(e)).toList(),
      totalPicked: distJson['totalPicked'],
      pickedCountGraph:
          pickedGraphList.map((a) => OrdersCountGraph.fromJson(a)).toList(),
      totalReturned: distJson['totalReturned'],
      returnedCountGraph:
          returnedGraphList.map((s) => OrdersCountGraph.fromJson(s)).toList(),
    );
  }
}

class OrdersCountGraph {
  String? date;
  int? total;
  int? cumulativeTotal;

  OrdersCountGraph({this.date, this.total, this.cumulativeTotal});

  factory OrdersCountGraph.fromJson(Map<String, dynamic> graphDist) {
    return OrdersCountGraph(
      date: graphDist['date'],
      total: graphDist['total'],
      cumulativeTotal: graphDist['cumulativeTotal'],
    );
  }
}
