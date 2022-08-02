import 'package:backoffice_new/constants/http_methods.dart';
import 'package:backoffice_new/constants/urls.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/models/city_lead_model.dart';
import 'package:backoffice_new/models/response_model.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/models/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiFetchData {
  SharedPreferences? localStorage;

  Future<OrdersData?> getOrders(
    var merchantId,
    var riderId,
    var riderAssigned,
    var orderStatusIds,
    var wareHouseIds,
    var trackingNumber,
    var fromDate,
    var toDate,
    var inStock,
    var paginationEnDis,
    int page,
    int size,
    var sortDirection, {
    var filterDateType,
    var fromDateTime,
    var toDateTime,
    var settled,
    var orderPhysicalStatusIds,
  }) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');

    String url = Urls.getOrdersUrl(
      merchantId,
      riderId,
      riderAssigned,
      orderStatusIds,
      orderPhysicalStatusIds ?? '',
      (orderStatusIds != null && orderStatusIds.toString().isNotEmpty) &&
              (orderPhysicalStatusIds != null &&
                  orderPhysicalStatusIds.toString().isNotEmpty)
          ? true
          : false,
      wareHouseIds,
      trackingNumber,
      fromDate,
      toDate,
      fromDateTime ?? '',
      toDateTime ?? '',
      inStock,
      settled ?? '',
      paginationEnDis,
      page,
      size,
      sortDirection,
      filterDateType ?? '',
    );

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      return OrdersData.fromJson(model);
    }
  }

  Future<RiderLookupData?> getRiderLookup() async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getRiderLookupUrl();

    ResponseModel? response = await HTTPMethod.getR(url, token!);

    if (response == null) {
      return null;
    } else {
      return RiderLookupData.fromJson(response.dist);
    }
  }

  Future<MerchantLookupData?> getMerchantLookup() async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getMerchantLookupUrl();

    ResponseModel? response = await HTTPMethod.getR(url, token!);

    if (response == null) {
      return null;
    } else {
      return MerchantLookupData.fromJson(response.dist);
    }
  }

  Future<WareHouseData?> getWareHouseLookup({var lookupOption}) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getWareHouseLookupUrl(
      lookupOption ?? MyVariables.warehouseLookupOptionEmployeeWareHouse,
    );

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      return WareHouseData.fromJson(model);
    }
  }

  Future<SheetsData?> getSheets(
    var riderId,
    var wareHouseId,
    var sheetTypeId,
    var sheetStatusIds,
    var sheetNumber,
    var fromDate,
    var toDate,
    var paginationEnDis,
    var page,
    var size,
    var sortDirection, {
    var sheetTag,
  }) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');

    String url = Urls.getSheetsUrl(
        riderId,
        wareHouseId,
        sheetTypeId,
        sheetStatusIds,
        sheetNumber,
        sheetTag,
        fromDate,
        toDate,
        paginationEnDis,
        page,
        size,
        sortDirection);

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      return SheetsData.fromJson(model);
    }
  }

  Future<SheetDetailData?> getSheetDetail(
    var riderId,
    var orderStatusIds,
    var trackingNumber,
    var sheetTypeId,
    var sheetStatusIds,
    var sheetNumber,
    var fromDate,
    var toDate,
    var paginationEnDis,
    var page,
    var size,
    var sortDirection, {
    var sheetTag,
    var merchantId,
    var sheetOrderStatusIds,
    var notInSheetOrderStatusIds,
    var orderPhysicalStatusIds,
    var linkOrderStatusAndPhysicalStatusIds,
    var wareHouseIds,
  }) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');

    String url = Urls.getSheetDetailUrl(
        riderId,
        merchantId ?? '',
        orderStatusIds,
        orderPhysicalStatusIds ?? '',
        linkOrderStatusAndPhysicalStatusIds ?? '',
        sheetOrderStatusIds ?? '',
        notInSheetOrderStatusIds ?? '',
        trackingNumber,
        sheetTypeId,
        sheetStatusIds,
        sheetNumber,
        wareHouseIds ?? '',
        sheetTag ?? '',
        fromDate,
        toDate,
        paginationEnDis,
        page,
        size,
        sortDirection);

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      return SheetDetailData.fromJson(model);
    }
  }

  Future<SheetDetailData?> getSheetDetailById(int sheetId) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');

    String url = Urls.getSheetDetailByIdUrl(sheetId);

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      return SheetDetailData.fromJson(model);
    }
  }

  Future<LoadSheetData?> getLoadSheets(
      var loadSheetStatusIds,
      var riderAssigned,
      var fromDate,
      var toDate,
      var paginationEnDis,
      int page,
      int size,
      var sortDirection) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getLoadSheetsUrl(loadSheetStatusIds, riderAssigned,
        fromDate, toDate, paginationEnDis, page, size, sortDirection);

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      LoadSheetData data = LoadSheetData.fromJson(model);
      return data;
    }
  }

  Future<MerchantCityLookupData?> getMerchantCityLookup(
    var merchantId,
  ) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getMerchantCityLookupUrl(merchantId);

    ResponseModel? response = await HTTPMethod.getR(url, token!);

    if (response == null) {
      return null;
    } else {
      return MerchantCityLookupData.fromJson(response.dist);
    }
  }

  Future<MerchantPickupAddressLookupData?> getMerchantPickupAddressLookup(
    var merchantId,
    cityId,
  ) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getMerchantPickupAddressLookupUrl(merchantId, cityId);

    ResponseModel? response = await HTTPMethod.getR(url, token!);

    if (response == null) {
      return null;
    } else {
      return MerchantPickupAddressLookupData.fromJson(response.dist);
    }
  }

  Future<OrdersData?> getLoadSheetOrders(
    var loadSheetMasterId,
    var loadSheetOrderStatusOption,
  ) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getLoadSheetOrdersUrl(
        loadSheetMasterId, loadSheetOrderStatusOption);

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      OrdersData data = OrdersData.fromJson(model);
      return data;
    }
  }

  Future<LoadSheetOrdersByCriteriaData?> getLoadSheetOrdersByCriteria(
    var riderId,
    var merchantId,
    var orderStatusIds,
    var loadSheetOrderStatusIds,
    var loadsheetStatusIds,
    var fromDate,
    var toDate,
    var paginationEnDis,
    var page,
    var size,
    var sortDirection,
  ) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getLoadSheetOrdersByCriteriaUrl(
        riderId,
        merchantId,
        orderStatusIds,
        loadSheetOrderStatusIds,
        loadsheetStatusIds,
        fromDate,
        toDate,
        paginationEnDis,
        page,
        size,
        sortDirection);

    ResponseModel? model = await HTTPMethod.getR(url, token!);
    if (model == null) {
      return null;
    } else {
      LoadSheetOrdersByCriteriaData data =
          LoadSheetOrdersByCriteriaData.fromJson(model);
      return data;
    }
  }

  Future<MenuData?> getUserMenu() async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    // String url = Urls.getUserMenuUrl();
    String url = Urls.getRoleWiseMenuUrl();

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      MenuData data = MenuData.fromJson(model);
      return data;
    }
  }

  Future<SheetStatusLookupData?> getSheetStatusLookup() async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getSheetStatusLookupUrl();

    ResponseModel? response = await HTTPMethod.getR(url, token!);

    if (response == null) {
      return null;
    } else {
      return SheetStatusLookupData.fromJson(response.dist);
    }
  }

  Future<SystemLogsData?> getSystemLogs(int transactionId) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getSystemLogsUrl(transactionId);
    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      return SystemLogsData.fromJson(model);
    }
  }

  Future<OrderStatsDataDist?> getOrderStats(
      var wareHouseId, var fromDate, var toDate,
      {var orderStatusIds, var filterDateType}) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getOrderStatsUrl(
        wareHouseId,
        orderStatusIds ?? '',
        fromDate,
        toDate,
        filterDateType ??
            FilterDateType.orderStatusChangedDate.name.toString());

    ResponseModel? model = await HTTPMethod.getR(url, token!);
    if (model == null) {
      return null;
    } else {
      OrderStatsDataDist dist = OrderStatsDataDist.fromJson(model.dist);
      return dist;
    }
  }

  Future<OrderRatesDataDist?> getOrderRate(var wareHouseId) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getOrderRatesUrl(wareHouseId);

    ResponseModel? model = await HTTPMethod.getR(url, token!);
    if (model == null) {
      return null;
    } else {
      OrderRatesDataDist dist = OrderRatesDataDist.fromJson(model.dist);
      return dist;
    }
  }

  Future<OrderStatusLookupData?> getOrderStatusCOD() async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getOrderStatusCODLookupUrl();

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      return OrderStatusLookupData.fromJson(model);
    }
  }

  Future<OrderRemarksData?> getOrderRemarks(
    int transactionId,
    var paginationEnDis,
    int page,
    int size,
    var sortDirection,
  ) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getOrderRemarksUrl(
        transactionId, paginationEnDis, page, size, sortDirection);

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      return OrderRemarksData.fromJson(model);
    }
  }

  Future<OrderTypeData?> getOrderType() async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getOrderTypeUrl();

    ResponseModel? response = await HTTPMethod.getR(url, token!);
    if (response == null) {
      return null;
    } else {
      return OrderTypeData.fromJson(response.dist);
    }
  }

  Future<OperationalCityData?> getOperationalCityLookup() async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getOperationalCityUrl();

    ResponseModel? response = await HTTPMethod.getR(url, token!);
    if (response == null) {
      return null;
    } else {
      return OperationalCityData.fromJson(response.dist);
    }
  }

  Future<OrdersCountData?> getOrdersCount(var wareHouseId) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getOrdersCountDashboardUrl(wareHouseId);

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      return OrdersCountData.fromJson(model);
    }
  }

  Future<MasterUnitData?> getMasterUnits({
    var wareHouseIds,
    var fromTeamIds,
    var toTeamIds,
    var masterUnitStatusIds,
    var masterUnitNumber,
    var masterUnitTag,
    var fromDate,
    var toDate,
    var paginationEnDis,
    var page,
    var size,
    var sortDirection,
  }) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getMasterUnitUrl(
        wareHouseIds ?? '',
        fromTeamIds ?? '',
        toTeamIds ?? '',
        masterUnitStatusIds ?? '',
        masterUnitNumber ?? '',
        masterUnitTag ?? '',
        fromDate ?? '',
        toDate ?? '',
        paginationEnDis ?? MyVariables.paginationDisable,
        page ?? 0,
        size ?? MyVariables.size,
        sortDirection ?? MyVariables.sortDirection);

    ResponseModel? model = await HTTPMethod.getR(url, token!);
    if (model == null) {
      return null;
    } else {
      return MasterUnitData.fromJson(model);
    }
  }

  Future<MasterUnitDetailData?> getMasterUnitDetailData({
    var merchantId,
    var transactionTypeId,
    var orderStatusIds,
    var customerName,
    var customerPhone,
    var cityName,
    var orderReferenceNumber,
    var trackingNumber,
    var masterUnitStatusIds,
    var masterUnitNumber,
    var wareHouseIds,
    var masterUnitTag,
    var fromDate,
    var toDate,
    var paginationEnDis,
    var page,
    var size,
    var sortDirection,
  }) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getMasterUnitDetailUrl(
        merchantId ?? '',
        transactionTypeId ?? '',
        orderStatusIds ?? '',
        customerName ?? '',
        customerPhone ?? '',
        cityName ?? '',
        orderReferenceNumber ?? '',
        trackingNumber ?? '',
        masterUnitStatusIds ?? '',
        masterUnitNumber ?? '',
        wareHouseIds ?? '',
        masterUnitTag ?? '',
        fromDate ?? '',
        toDate ?? '',
        paginationEnDis ?? MyVariables.paginationDisable,
        page ?? 0,
        size ?? MyVariables.size,
        sortDirection ?? MyVariables.sortDirection);

    ResponseModel? model = await HTTPMethod.getR(url, token!);
    if (model == null) {
      return null;
    } else {
      return MasterUnitDetailData.fromJson(model);
    }
  }

  Future<UserRolesLookupData?> getUserRolesLookup(
      var accessLevel, var active) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getUserRolesLookupUrl(accessLevel, active);

    ResponseModel? model = await HTTPMethod.getR(url, token!);
    if (model == null) {
      return null;
    } else {
      return UserRolesLookupData.fromJson(model);
    }
  }

  Future<RolesLookupData?> getRolesLookup(var accessLevel, var active) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getRolesLookupUrl(accessLevel, active);

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      return RolesLookupData.fromJson(model);
    }
  }

  Future<EmployeeProfileData?> getEmployeeProfile() async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getEmployeeProfileUrl();

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      return EmployeeProfileData.fromJson(model);
    }
  }

  Future<AttemptReasonData?> getAttemptReason() async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getAttemptReasonUrl();

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      return AttemptReasonData.fromJson(model);
    }
  }

  Future<ValidateGenerateSheetData?> getValidateGenerateSheet(
      var riderId, var sheetTypeId) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getValidateGenerateSheetUrl(riderId, sheetTypeId);

    ResponseModel? model = await HTTPMethod.getR(url, token!);

    if (model == null) {
      return null;
    } else {
      return ValidateGenerateSheetData.fromJson(model.dist);
    }
  }
}
