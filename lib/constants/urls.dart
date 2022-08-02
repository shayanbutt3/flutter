class Urls {
  // static String QA_URL =
  //     "https://qa-api-backoffice.postex.pk/backoffice-service";
  // static String STG_URL =
  //     "https://stg-api-backoffice.postex.pk/backoffice-service";
  // static String PROD_URL =
  //     "https://api-backoffice.postex.pk/backoffice-service";

//////***** Updated All Urls ******//////

  static String DEV_URL =
      "https://dev-backoffice-api.postex.pk/backoffice-service";
  static String QA_URL = "https://qa-api.postex.pk/services/backoffice/api";
  static String STG_URL = "https://stg-api.postex.pk/services/backoffice/api";
  static String PROD_URL = "https://api.postex.pk/services/backoffice/api";

  static String tmpPROD_URL =
      "http://15.185.78.79:8765/services/backoffice/api";

  static String tmpPROD_URL2 =
      "http://15.184.68.122:8765/services/backoffice/api";

// Need to Hide auto filled login credentials at login screen initstate().
  static String BASE_URL = QA_URL;

  static String loginUrl() {
    return "$BASE_URL/user/login";
  }

  static String logoutUrl() {
    return "$BASE_URL/user/logout";
  }

  static String getUserMenuUrl() {
    return "$BASE_URL/permission/";
  }

  static String getRoleWiseMenuUrl() {
    return "$BASE_URL/menu";
  }

  static String getRiderLookupUrl() {
    return "$BASE_URL/rider/lookup";
  }

  static String getMerchantLookupUrl() {
    return "$BASE_URL/lookup/merchant";
  }

  static String getMerchantCityLookupUrl(var merchantId) {
    return "$BASE_URL/merchant/$merchantId/operational-city";
  }

  static String getMerchantPickupAddressLookupUrl(var merchantId, var cityId) {
    return "$BASE_URL/merchant/$merchantId/address?cityId=$cityId";
  }

  static String getOrdersUrl(
    var merchantId,
    var riderId,
    var riderAssigned,
    var orderStatusIds,
    var orderPhysicalStatusIds,
    var linkOrderStatusAndPhysicalStatusIds,
    var wareHouseIds,
    var trackingNumber,
    var fromDate,
    var toDate,
    var fromDateTime,
    var toDateTime,
    var inStock,
    var settled,
    var paginationEnDis,
    int page,
    int size,
    var sortDirection,
    var filterDateType,
  ) {
    return "$BASE_URL/order?merchantId=$merchantId&riderId=$riderId&riderAssigned=$riderAssigned&orderStatusIds=$orderStatusIds&orderPhysicalStatusIds=$orderPhysicalStatusIds&linkOrderStatusAndPhysicalStatusIds=$linkOrderStatusAndPhysicalStatusIds&wareHouseIds=$wareHouseIds&trackingNumber=$trackingNumber&fromDate=$fromDate&toDate=$toDate&fromDateTime=$fromDateTime&toDateTime=$toDateTime&filterDateType=$filterDateType&inStock=$inStock&settled=$settled&pagination=$paginationEnDis&page=$page&size=$size&sort=createDatetime&direction=$sortDirection";
  }

  static String getMarkStockInUrl() {
    return "$BASE_URL/order/status/stock-in";
  }

  static String getWareHouseLookupUrl(var lookupOption) {
    return "$BASE_URL/warehouse/lookup?lookupOption=$lookupOption";
  }

  static String getMarkDeliveryEnRouteUrl() {
    return "$BASE_URL/order/status/delivery-enroute";
  }

  static String getMarkReturnInTransitUrl() {
    return "$BASE_URL/order/status/return-in-transit";
  }

  static String getGenerateDeliverySheetUrl() {
    return "$BASE_URL/sheet/sheetType/delivery";
  }

  static String getGenerateReturnSheetUrl() {
    return "$BASE_URL/sheet/sheetType/return";
  }

  static String getGenerateTransferSheetUrl() {
    return "$BASE_URL/sheet/sheetType/transfer";
  }

  static String getSheetsUrl(
      var riderId,
      var wareHouseId,
      var sheetTypeId,
      var sheetStatusIds,
      var sheetNumber,
      var sheetTag,
      var fromDate,
      var toDate,
      var paginationEnDis,
      int page,
      int size,
      var sortDirection) {
    return "$BASE_URL/sheet?riderId=$riderId&wareHouseId=$wareHouseId&sheetTypeId=$sheetTypeId&sheetStatusIds=$sheetStatusIds&sheetNumber=$sheetNumber"
        "${sheetTag == null || sheetTag.toString().trim().isEmpty ? '' : "&sheetTag=$sheetTag"}"
        "&fromDate=$fromDate&toDate=$toDate&pagination=$paginationEnDis&page=$page&size=$size&sort=createDatetime&direction=$sortDirection";
  }

  static String getSheetDetailUrl(
      var riderId,
      var merchantId,
      var orderStatusIds,
      var orderPhysicalStatusIds,
      var linkOrderStatusAndPhysicalStatusIds,
      var sheetOrderStatusIds,
      var notInSheetOrderStatusIds,
      var trackingNumber,
      var sheetTypeId,
      var sheetStatusIds,
      var sheetNumber,
      var wareHouseIds,
      var sheetTag,
      var fromDate,
      var toDate,
      var paginationEnDis,
      int page,
      int size,
      var sortDirection) {
    // return "$BASE_URL/sheet/detail?riderId=$riderId&merchantId=$merchantId&orderStatusIds=$orderStatusIds&orderPhysicalStatusIds=$orderPhysicalStatusIds&linkOrderStatusAndPhysicalStatusIds=$linkOrderStatusAndPhysicalStatusIds&sheetOrderStatusIds=$sheetOrderStatusIds&notInSheetOrderStatusIds=$notInSheetOrderStatusIds&trackingNumber=$trackingNumber&sheetTypeId=$sheetTypeId&sheetStatusIds=$sheetStatusIds&sheetNumber=$sheetNumber&wareHouseIds=$wareHouseIds&sheetTag=$sheetTag&fromDate=$fromDate&toDate=$toDate&pagination=$paginationEnDis&page=$page&size=$size&sort=createDatetime&direction=$sortDirection";
    return "$BASE_URL/sheet/detail?riderId=$riderId&merchantId=$merchantId&orderStatusIds=$orderStatusIds&orderPhysicalStatusIds=$orderPhysicalStatusIds&linkOrderStatusAndPhysicalStatusIds=$linkOrderStatusAndPhysicalStatusIds&sheetOrderStatusIds=$sheetOrderStatusIds&notInSheetOrderStatusIds=$notInSheetOrderStatusIds&trackingNumber=$trackingNumber&sheetTypeId=$sheetTypeId&sheetStatusIds=$sheetStatusIds&sheetNumber=$sheetNumber&wareHouseIds=$wareHouseIds"
        "${sheetTag == null || sheetTag.toString().trim().isEmpty ? '' : "&sheetTag=$sheetTag"}"
        "&fromDate=$fromDate&toDate=$toDate&pagination=$paginationEnDis&page=$page&size=$size&sort=createDatetime&direction=$sortDirection";
  }

  static String getSheetDetailByIdUrl(int sheetId) {
    return "$BASE_URL/sheet/$sheetId/detail";
  }

  static String getMarkDeliveryUnderReviewUrl() {
    return "$BASE_URL/order/status/delivery-under-review";
  }

  static String getMarkRetryUrl() {
    return "$BASE_URL/order/status/retry";
  }

  static String getLoadSheetsUrl(
      var loadSheetStatusIds,
      var riderAssigned,
      var fromDate,
      var toDate,
      var paginationEnDis,
      int page,
      int size,
      var sortDirection) {
    return "$BASE_URL/load-sheet/history?loadSheetStatusIds=$loadSheetStatusIds&riderAssigned=$riderAssigned&fromDate=$fromDate&toDate=$toDate&pagination=$paginationEnDis&page=$page&size=$size&sort=createDatetime&direction=$sortDirection";
  }

  static String getMarkReturnRequestUrl() {
    return "$BASE_URL/order/status/return-request";
  }

  static String getMarkPickedUrl() {
    return "$BASE_URL/order/status/shipment-picked";
  }

  static String getMarkAttemptedUrl() {
    return "$BASE_URL/order/status/attempted";
  }

  static String getMarkDeliveredUrl() {
    return "$BASE_URL/order/status/delivered";
  }

  static String getMarkReturnedUrl() {
    return "$BASE_URL/order/status/returned";
  }

  static String getLoadSheetOrdersUrl(
      var laodSheetMasterId, var loadSheetOrderStatusOption) {
    return "$BASE_URL/load-sheet/$laodSheetMasterId/order?orderStatusOption=$loadSheetOrderStatusOption";
  }

  static String getLoadSheetOrdersByCriteriaUrl(
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
      var sortDirection) {
    return "$BASE_URL/load-sheet/details?riderId=$riderId&merchantId=$merchantId&orderStatusIds=$orderStatusIds&loadSheetOrderStatusIds=$loadSheetOrderStatusIds&loadSheetStatusIds=$loadsheetStatusIds&fromDate=$fromDate&toDate=$toDate&pagination=$paginationEnDis&page=$page&size=$size&sort=createDatetime&direction=$sortDirection";
  }

  static String getGenerateLoadSheetUrl() {
    return "$BASE_URL/load-sheet";
  }

  static String getAssignLoadSheetUrl() {
    return "$BASE_URL/load-sheet/assign";
  }

  static String getSheetStatusLookupUrl() {
    return "$BASE_URL/sheet/status/lookup";
  }

  static String getSystemLogsUrl(int transactionId) {
    return "$BASE_URL/order/management/logs?transactionId=$transactionId";
  }

  static String getOrderStatsUrl(var wareHouseId, var orderStatusIds,
      var fromDateTime, var toDateTime, var filterDateType) {
    // return "$BASE_URL/dashboard/warehouse/order/stats?wareHouseId=$wareHouseId&fromDateTime=$fromDate&toDateTime=$toDate&filterDateType=orderStatusChangedDate";
    return "$BASE_URL/dashboard/warehouse/order/stats?wareHouseId=$wareHouseId&orderStatusIds=$orderStatusIds&fromDateTime=$fromDateTime&toDateTime=$toDateTime&filterDateType=$filterDateType";
  }

  static String getOrderRatesUrl(var wareHouseId) {
    return "$BASE_URL/dashboard/order/rates?wareHouseId=$wareHouseId";
  }

  static String getOrderStatusCODLookupUrl() {
    return "$BASE_URL/lookup/order/cod/status";
  }

  static String getOrderRemarksUrl(int transactionId, var paginationEnDis,
      int page, int size, var sortDirection) {
    return "$BASE_URL/remarks/transaction/$transactionId/remark?pagination=$paginationEnDis&page=$page&size=$size&sort=createDatetime&direction=$sortDirection";
  }

  static String getOperationalCityUrl() {
    return "$BASE_URL/lookup/operational/city?active=true";
  }

  static String getOrderTypeUrl() {
    return "$BASE_URL/lookup/order/types";
  }

  static String getCreateOrderUrl() {
    return "$BASE_URL/order";
  }

  static String getUpdateOrderUrl(var transactionId) {
    return "$BASE_URL/order/$transactionId/update";
  }

  static String getOrdersCountDashboardUrl(var wareHouseId) {
    return "$BASE_URL/dashboard/order/counts?wareHouseId=$wareHouseId";
  }

  static String getRevertOrderUrl() {
    return "$BASE_URL/order/status/revert/en-route";
  }

  static String getRevertPickedOrderUrl() {
    return "$BASE_URL/order/status/unbooked";
  }

  static String getRevertSheetUrl() {
    return "$BASE_URL/sheet/revert";
  }

  static String getDeManifestMasterUnitUrl() {
    return "$BASE_URL/master-unit/de-manifest";
  }

  static String getCreateMuUrl() {
    return "$BASE_URL/master-unit";
  }

  static String getDispatchTransferSheetUrl() {
    return "$BASE_URL/sheet/dispatch";
  }

  static String getMarkMisrouteUrl() {
    return "$BASE_URL/order/status/misroute";
  }

  static String getRescheduleReturnUrl() {
    return "$BASE_URL/order/status/return-rescheduled";
  }

  static String getMarkCustomerRefusedUrl() {
    return "$BASE_URL/order/status/customer-refused";
  }

  static String getMarkLostUrl() {
    return "$BASE_URL/order/status/lost";
  }

  static String getPickUpInboundUrl() {
    return "$BASE_URL/order/status/postex-received";
  }

  static String getTransferInboundUrl() {
    return "$BASE_URL/order/transfer-inbound";
  }

  static String getMasterUnitUrl(
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
  ) {
    return "$BASE_URL/master-unit?wareHouseIds=$wareHouseIds&fromTeamIds=$fromTeamIds&toTeamIds=$toTeamIds&masterUnitStatusIds=$masterUnitStatusIds&masterUnitNumber=$masterUnitNumber&masterUnitTag=$masterUnitTag&fromDate=$fromDate&toDate=$toDate&pagination=$paginationEnDis&page=$page&size=$size&sort=createDatetime&direction=$sortDirection";
  }

  static String getMasterUnitDetailUrl(
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
      var sortDirection) {
    return "$BASE_URL/master-unit/detail?merchantId=$merchantId&transactionTypeId=$transactionTypeId&orderStatusIds=$orderStatusIds&customerName=$customerName&customerPhone=$customerPhone&cityName=$cityName&orderReferenceNumber=$orderReferenceNumber&trackingNumber=$trackingNumber&masterUnitStatusIds=$masterUnitStatusIds&masterUnitNumber=$masterUnitNumber&wareHouseIds=$wareHouseIds"
        "${masterUnitTag == null || masterUnitTag.toString().trim().isEmpty ? '' : "&masterUnitTag=$masterUnitTag"}"
        "&fromDate=$fromDate&toDate=$toDate&pagination=$paginationEnDis&page=$page&size=$size&sort=createDatetime&direction=$sortDirection";
  }

  static String getHandoverUrl() {
    return "$BASE_URL/master-unit/handover";
  }

  static String getUserRolesLookupUrl(var accessLevel, var active) {
    return "$BASE_URL/lookup/user/roles?accessLevel=$accessLevel&active=$active";
  }

  static String getRolesLookupUrl(var accessLevel, var active) {
    return "$BASE_URL/lookup/roles?accessLevel=$accessLevel&active=$active";
  }

  static String getDeliveryRescheduleUrl() {
    return "$BASE_URL/order/status/delivery-reschedule";
  }

  static String getEmployeeProfileUrl() {
    return "$BASE_URL/employee/profile";
  }

  static String getTransitHubUrl() {
    return "$BASE_URL/order/status/transit-hub";
  }

  static String getwaitingForTransferDeManifestOrderUrl() {
    return "$BASE_URL/order/physical-status/waiting-for-transfer-de-manifest";
  }

  static String getAttemptReasonUrl() {
    return "$BASE_URL/lookup/attempt-reason";
  }

  static String getDeManifestTransferSheetUrl() {
    return "$BASE_URL/sheet/transfer-sheet/de-manifest";
  }

  static String getValidateGenerateSheetUrl(
    var riderId,
    var sheetTypeId,
  ) {
    return "$BASE_URL/sheet/validate/rider/$riderId?sheetTypeId=$sheetTypeId";
  }

  static String getHandoverTransferSheetUrl() {
    return "$BASE_URL/sheet/transfer-sheet/handover";
  }
}
