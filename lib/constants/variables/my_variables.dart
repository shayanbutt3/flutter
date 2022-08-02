import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:backoffice_new/constants/size_config.dart';

enum FilterDateType {
  orderStatusChangedDate,
  transactionDate,
  orderPickupDate,
  orderDeliveryDate,
}

class MyVariables {
  static var size = 25;
  static var sortDirection = 'desc';
  static var sortDirectionAscending = 'asc';
  static var paginationEnable = 'enable';
  static var paginationDisable = 'disable';
  static final formatAmount = NumberFormat("##,##0.00", "en_US");

//////////////// User //////////////////
  static var userTypeIdAdmin = 1;
  static var userTypeIdStaff = 2;

//////////////// DropDowns //////////////////
  static var dropDownHeight = SizeConfig.safeBlockSizeVertical * 40;

  static var wareHouseDropdownHintText = 'Select WareHouse';
  static var riderDropdownHintText = 'Select Rider';
  static var merchantDropdownHintText = 'Select Merchant';
  static var merchantCityDropdownHintText = 'Select City';
  static var merchantPickupAddressDropdownHintText = 'Select Pickup Address';
  static var loadSheetDropdownHintText = 'Select LoadSheet';
  static var sheetStatusDropdownHintText = 'Select Sheet Status';
  static var sheetNumberDropdownHintText = 'Select Sheet';
  static var orderStatusDropdownHintText = 'Select Status';
  static var dateFilterDropdownHintText = 'Select Date Filter';
  static var operationalCityDropdownHintText = 'Select City';
  static var orderTypeDropdownHintText = 'Select Order Type';
  static var muTagDropdownHintText = 'Select MU';
  static var receivingFromTeamDropDownHintText = 'From Team';
  static var receivingToTeamDropDownHintText = 'To Team';
  static var receivingTeamAccessLevel = '2';
  static var receivingTeamActive = 'true';
  static var firstMileRoleId = 10001;
  static var midMileRoleId = 10002;
  static var lastMileRoleId = 10003;
  static var generalManagerOperationsRoleId = 10004;
  static var managerNetworkOperationsRoleId = 10005;
  static var cityLeadRoleId = 10006;
  static var assistantManagerOperationsRoleId = 10007;
  static var operationOfficerRoleId = 10008;
  static var returnTeamRoleId = 10009;
  static var debriefingTeamRoleId = 10010;

  static var wareHouseDropdownSelectAllText = 'All';
  static var masterUnitNumberDropdownHintText = 'Select MU Number';
  static var hintTextSelectFromTeam = 'Select From Team';
  static var hintTextSelectToTeam = 'Select To Team';

  static var warehouseLookupOptionAll = 'all';
  static var warehouseLookupOptionEmployeeWareHouse = 'employeeWareHouse';

  static List<String> dateFilterList = [
    "transactionDate",
    "orderPickupDate",
    "orderDeliveryDate",
  ];

  static var textFormFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(
        Radius.circular(SizeConfig.safeBlockSizeHorizontal * 1)),
  );

  static var scaffoldBodyPadding = EdgeInsets.symmetric(
      // horizontal: SizeConfig.safeBlockSizeHorizontal * 3,
      horizontal: SizeConfig.safeBlockSizeHorizontal * 1,
      vertical: SizeConfig.safeBlockSizeVertical * 0.5);

//////////////// App Bar //////////////////
  static var appBarBackgroundColor = Colors.transparent; //Colors.black;
  static var appBarFlexibleConatinerColor = Colors.black;
  static var appBarIconTheme = const IconThemeData(
    color: Colors.white,
  );

  static var preferredSizeAppBar =
      Size.fromHeight(SizeConfig.safeBlockSizeVertical * 8);
  static var preferredSizeAppBarWithBottom =
      Size.fromHeight(SizeConfig.safeBlockSizeVertical * 14);

  static var appbarHeight = SizeConfig.safeBlockSizeVertical * 8;
  static var appbarHeightWithBottom = SizeConfig.safeBlockSizeVertical * 10;

//////////////// Tab Bar /////////////////
  static var tabBarTextStyle = TextStyle(
      color: Colors.black87, fontSize: SizeConfig.blockSizeHorizontal * 4);

//////////////// Order Status /////////////////

  // static var ordersStatusIdsToMakeOrdersInStock = '15,9,17,18,16'; // Old implementation, now splitting into three screens.
  static var ordersStatusIdsToMakeOrdersInStockPicked = '15';
  static var ordersStatusIdsToMakeOrdersInStockOthers = '17,16';
  // static var ordersStatusIdsToMakeOrdersDeliveryEnRoute = '3,17';
  static var ordersStatusIdsToMakeOrdersReturnInTransit = '3,17,9';
  static var ordersStatusIdsToMarkUnderVerification = '17'; //Attempted
  static var ordersStatusIdsToMarkReturnRequest = '9'; // DeliveryUnderReview
  static var ordersStatusIdsToMarkAttempted = '4';
  static var ordersStatusIdsToMarkPicked = '1,2';
  static var ordersStatusIdsToMarkDelivered = '4';
  static var ordersStatusIdsToMarkReturned = '16';
  static var orderStatusIdsToRevertReturnProcess =
      '22,23,31'; //ReturnRequest, CustomerRefused, ReturnReschedule
  static var orderStatusIdsToTransferInbound =
      '18,28'; //Dispatched, ReturnToOrigin
  static var ordersStatusIdsToMarkMisroute =
      '18,28'; //Dispatched, ReturnToOrigin,TransitHub

  static var ordersStatusIdsToGenerateReturnSheet =
      '22,22,23,23,31'; // Return Request, Customer Refused, Reschedule Return //

  static var ordersPhysicalStatusIdsToGenerateDeliverySheet =
      '6'; //WaitingForDelivery
  static var ordersPhysicalStatusIdsToGenerateReturnSheet =
      '17,21,17,21,25'; //WaitingForFineSort, waiting for return, at return desk
  static var ordersPhysicalStatusIdsToGenerateTransferSheet =
      '14,17'; // waitingForTransit, waitingForFineSort
  static var ordersPhysicalStatusIdsToMarkUnderVerification =
      '8'; //AtDebriefingDesk

  static var orderStatusIdsAll = '';
  static var orderStatusIdUnbooked = '1';
  static var orderStatusIdBooked = '2';
  static var orderStatusIdPostExReceived = '3';
  static var orderStatusIdDeliveryEnroute = '4';
  static var orderStatusIdDelivered = '5';
  static var orderStatusIdReturned = '6';
  static var orderStatusIdCancelled = '7';
  static var orderStatusIdExpired = '8';
  static var orderStatusIdUnderVerification = '9';
  static var orderStatusIdPicked = '15';
  static var orderStatusIdReturnInTransit = '16';
  static var orderStatusIdAttempted = '17';
  static var orderStatusIdDispatched = '18';
  static var orderStatusIdRiderAssignedToDeliver = '19';
  static var orderStatusIdDeliveryRescheduled = '20';
  static var orderStatusIdRetry = '21';
  static var orderStatusIdReturnRequested = '22';
  static var orderStatusIdCustomerRefused = '23';
  static var orderStatusIdRiderAssignedToReturn = '24';
  static var orderStatusIdReadyToDispatch = '25';
  static var orderStatusIdArrivedAtDestination = '26';
  static var orderStatusIdReadyToReturnBack = '27';
  static var orderStatusIdReturnToOrigin = '28';
  static var orderStatusIdArrivedAtOrigin = '29';
  static var orderStatusIdTransitHub = '30';
  static var orderStatusIdReturnRescheduled = '31';
  static var orderStatusIdMisroute = '32';
  static var orderStatusIdLost = '33';

//////////////// Order Physical Status /////////////////

  static var orderPhysicalStatusAtMerchantWareHouse = '1';
  static var orderPhysicalStatusInPostMasterBagAfterPickup = '2';
  static var orderPhysicalStatusWaitingForLastMileHandover = '3';
  static var orderPhysicalStatusReadyForLastMile = '4';
  static var orderePhysicalStatusLastMileReceived = '5';
  static var orderPhysicalStatusWaitingForDelivery = '6';
  static var orderPhysicalStatusReadyForDelivery = '7';
  static var orderPhysicalStatusInPostMasterForDelivery = '8';
  static var orderPhysicalStatusDeliveredToCustomer = '9';
  static var orderPhysicalStatusAtDebriefingDesk = '10';
  static var orderPhysicalStatusWaitingForMidMile = '11';
  static var orderPhysicalStatusReadyForMidMile = '12';
  static var orderPhysicalStatusMidMileReceived = '13';
  static var orderPhysicalStatusWaitingForTransit = '14';
  static var orderPhysicalStatusReadyForTransit = '15';
  static var orderPhysicalStatusInTransit = '16';
  static var orderPhysicalStatusWaitingForFineSort = '17';
  static var orderPhysicalStatusWaitingForReturnTeam = '18';
  static var orderPhysicalStatusReadyForReturnTeam = '19';
  static var orderPhysicalStatusReturnTeamReceived = '20';
  static var orderPhysicalStatusWaitingForReturn = '21';
  static var orderPhysicalStatusReadyForReturn = '22';
  static var orderPhysicalStatusInPostMaterBagForReturn = '23';
  static var orderPhysicalStatusReturnedToShipper = '24';
  static var orderPhysicalStatusAtReturnDesk = '25';
  static var orderPhysicalStatusWaitingForReturnLineHaul = '26';
  static var orderPhysicalStatusReadyForReturnLineHaul = '27';
  static var orderPhysicalStatusReturnLineHaulReceived = '28';

///////////////// Master Unit Status ////////////////////

  static var masterUnitStatusIdNew = '1';
  static var masterUnitStatusIdReceived = '2';
  static var masterUnitStatusIdComplete = '3';
  static var masterUnitStatusIdClose = '4';
  static var orderStatusIdsToCreateMu = '3,20,22,23';

  static var orderStatusIdsDeliveredAndReturned = '5,6';
  static var orderStatusIdsRescheduleReturn = '16';
  static var orderStatusIdsToMarkLost =
      '3,4,9,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32';

  static var orderStatusIdsAllDP = '11,12,14';
  static var orderStatusIdPendingDP = '10';
  static var orderStatusIdPaidDP = '11';
  static var orderStatusIdFailedDP = '12';
  static var orderStatusIdDroppedDP = '13';
  static var orderStatusIdRefundDP = '14';

  static var sheetTypeIdDelivery = '1'; //Delivery Sheet Id
  static var sheetTypeIdTransfer = '2'; //Transfer Sheet Id
  static var sheetTypeIdReturn = '3'; //Delivery Sheet Id

  static var sheetStatusIdsAll = '';
  static var sheetStatusIdNew = '1';
  static var sheetStatusIdCompleted = '2';
  static var sheetStatusIdCancelled = '3';
  static var sheetStatusIdPicked = '4';
  static var sheetStatusIdDeliveryInProgress = '5';
  static var sheetStatusIdReturnInProgress = '6';
  static var sheetStatusIdDispatched = '7';
  static var sheetStatusIdStockInInProgress = '8';
  static var sheetStatusIdPending = '9';
  static var sheetStatusIdDispute = '10';
  static var sheetStatusIdClose = '11';
  static var sheetStatusIdReceived = '12';
  static var sheetStatusIdHandedover = '13';

  static var sheetStatusIdsNewAndPicked = '1,4';
  static var sheetStatusIdsNewAndPickedAndDeliveryInProgress = '1,4,5';
  static var sheetStatusIdsNewAndPickedAndReturnInProgress = '1,4,6';
  static var sheetStatusIdsPickedAndDeliveryInProgress = '4,5';
  static var sheetStatusIdsPickedAndReturnInProgress = '4,6';
  static var sheetStatusIdsDispatchedAndStockInProgress = '7,8';

  static var sheetStatusNew = 'New';
  static var sheetStatusPicked = 'Picked';
  static var sheetStatusCompleted = 'Completed';
  static var sheetStatusCancelled = 'Cancelled';

  //////////////*********** Roles Ids  **************///////////////////
  static var roleIdFirstMile = 10001;
  static var roleIdMidMile = 10002;
  static var roleIdLastMile = 10003;
  static var roleIdGeneralManagerOperations = 10004;
  static var roleIdManagerNetworkOperations = 10005;
  static var roleIdCityLead = 10006;
  static var roleIdAssistantManagerOperations = 10007;
  static var roleIdOperationOfficer = 10008;
  static var roleIdReturnTeam = 10009;
  static var roleIdDebrefingTeam = 10010;

  static var accessLevel = "2";
  static bool active = true;

  //////////////************* Transaction Status Names for making Hard Coded conditions *************///////////////
  static var transactionStatusUnbooked = 'Unbooked';
  static var transactionStatusBooked = 'Booked';
  static var transactionStatusCancelled = 'Cancelled';
  static var transactionStatusInStock = 'In Stock';
  static var transactionStatusPicked = 'Picked';
  static var transactionStatusReturnInTransit = 'Return In-Transit';
  static var transactionStatusDeliveryEnRoute = 'Delivery En-Route';
  static var transactionStatusUnderVerification = 'Under Verification';
  static var transactionStatusDelivered = 'Delivered';
  static var transactionStatusReturn = 'Return';
  static var transactionStatusExpired = 'Expired';
  static var transactionStatusAttempted = 'Attempted';
  static var transactionStatusTransferred = 'Transferred';

//////////////// LoadSheet Status IDs /////////////////
  static var loadSheetStatusIdNew = '1';
  static var loadSheetStatusIdPicked = '2';
  static var loadSheetStatusIdComplete = '3';
  static var loadSheetStatusIdCancelled = '4';
  static var loadSheetStatusIdNewAndPicked = '1,2';
  static var loadSheetStatusIdPickedAndComplete = '2,3';

  static var loadSheetStatusIdForPendingPickups = '1';

  static var loadSheetOrderStatusOptionBooked = 'booked';
  static var loadSheetOrderStatusOptionPicked = 'picked';
  static var loadSheetOrderStatusOptionUnpicked = 'unpicked';

// //////////////// Menu module IDs /////////////////
//   static var parentMenuModuleIdOrderManagement = 9;
//   static var parentMenuModuleIdUnderVerification = 60;
//   static var parentMenuModuleIdWarehouse = 64;
//   static var parentMenuModuleIdRiderManagement = 72;
//   static var parentMenuModuleIdLoadSheetManagement = 73;
//   static var parentMenuModuleIdReports = 75;

//   static const childMenuModuleIdStockIn = 66;
//   static const childMenuModuleIdStockInPicked = 113;
//   static const childMenuModuleIdStockInTransferred = 114;
//   static const childMenuModuleIdStockInOther = 115;
//   static const childMenuModuleIdStockOutReturn = 116;
//   static const childMenuModuleIdStockOutTransferred = 117;
//   static const childMenuModuleIdStockOutDeliver = 118;
//   // static const childMenuModuleIdAssignDelivery = 16;
//   static const childMenuModuleIdMarkReturn = 63; //Mark Return Request
//   static const childMenuModuleIdMarkUnderVerification = 61;
//   static const childMenuModuleIdVerificationList = 27;
//   static const childMenuModuleIdMarkRetryReAttempt = 62;
//   static const childMenuModuleIdGenerateDeliverySheet = 77;
//   static const childMenuModuleIdGenerateReturnSheet = 88;
//   // static const childMenuModuleIdGenerateTransferSheet = 85;
//   static const childMenuModuleIdGenerateLoadSheet = 28;
//   static const childMenuModuleIdAssignPickup = 24;
//   static const childMenuModuleIdMarkDelivered = 84; // Mark Delivered
//   static const childMenuModuleIdMarkPicked = 68; // Pick Order
//   static const childMenuModuleIdMarkAttempted = 69; // Order Attempt
//   static const childMenuModuleIdMarkReturned = 119; //Mark returned
//   // static const childMenuModuleIdAssignReturn = 116; //As assign me return
//   static const childMenuModuleIdManageOrder = 29;
//   static const childMenuModuleIdRevertReturnSheet = 126;
//   static const childMenuModuleIdRevertDeliverySheet = 125;
//   static const childMenuModuleIdRevertPickedOrder = 121;
// //// Reports Menu ////
//   static const childMenuModuleIdDeliverySheet = 80;
//   static const childMenuModuleIdCreateOrder = 10;
//   static const childMenuModuleIdRevertOrder = 111;
//   static const childMenuModuleIdRevertReturnRequest = 120;
// //// New Menu Modules ////
//   static const childMenuModuleIdCreateMU = 20428;
//   static const childMenuModuleIdHandover = 20435;
//   static const childMenuModuleIdDeManifest = 20429;
//   static const childMenuModuleIdRescheduleDelivery = 20432;
//   static const childMenuModuleIdRescheduleReturn = 20437;
//   static const childMenuModuleIdMarkCustomerRefused = 20433;
//   static const childMenuModuleIdMarkMisroute = 20434;
//   static const childMenuModuleIdMarkLost = 20436;
//   static const childMenuModuleIdGenerateTransferSheet = 20430;
//   static const childMenuModuleIdDispatchTransferSheet = 20431;

//////////////// Menu module IDs /////////////////
  static var parentMenuIdOrderManagement = 1;
  static var parentMenuIdPickupManagement = 7;
  static var parentMenuIdTransfersManagement = 14;
  static var parentMenuIdDeliveryManagement = 20;
  static var parentMenuIdDeBriefing = 27;
  static var parentMenuIdReturnManagement = 33;
  static var parentMenuIdMuManagement = 41;
  static var parentMenuIdReports = 46;

//// Order Management 1
  static const childMenuIdCreateOrder = 2;
  static const childMenuIdBulkUpload = 3;
  static const childMenuIdCancelBooking = 4;
  static const childMenuIdMarkLost = 5;
  static const childMenuIdRevertOrder = 6;
  static const childMenuIdOrderLogs = 59;

//// Pickup Management 7
  static const childMenuIdGenerateLoadSheet = 8;
  static const childMenuIdAssignPickup = 9;
  static const childMenuIdMarkPicked = 10;
  static const childMenuIdRevertPicked = 11;
  static const childMenuIdPickupInbound = 12;
  static const childMenuIdLoadSheetLogs = 13;

//// Transfers Management 14
  static const childMenuIdGenerateTransferSheet = 15;
  static const childMenuIdDispatchTransferSheet = 16;
  static const childMenuIdTransferInbound = 17;
  static const childMenuIdTransferSheetLogs = 18;
  static const childMenuIdMarkMisroute = 19;

//// Delivery Manegement 20
  static const childMenuIdGenerateDeliverySheet = 21;
  static const childMenuIdAssignDeliveries = 22;
  static const childMenuIdMarkDelivered = 23;
  static const childMenuIdMarkAttempt = 24;
  static const childMenuIdDeliverySheetLogs = 25;
  static const childMenuIdRevertDeliverySheet = 26;

//// DeBriefing 27
  static const childMenuIdMarkDeliveryReschedule = 28;
  static const childMenuIdMarkDeliveryUnderReview = 29;
  static const childMenuIdMarkCustomerRefused = 30;
  static const childMenuIdMarkReturnRequest = 31;
  static const childMenuIdMarkRetry = 32;
  static const childMenuIdSheetClearanceInbound = 77;

//// Return Management 33
  static const childMenuIdGenerateReturnSheet = 34;
  static const childMenuIdAssignReturn = 35;
  static const childMenuIdMarkReturn = 36;
  static const childMenuIdMarkReturnReschedule = 37;
  static const childMenuIdRevertReturnSheet = 38;
  static const childMenuIdRevertReturnProcess = 39;
  static const childMenuIdReturnSheetLogs = 40;

//// MU Management 41
  static const childMenuIdCreateMU = 42;
  static const childMenuIdHandoverMU = 43;
  static const childMenuIdDeManifestMU = 44;
  static const childMenuIdMULogs = 45;

//// Reports 46
  static const childMenuIdLoadSheetHistory = 47;
  static const childMenuIdMerchantLastPickup = 48;
  static const childMenuIdPrintAirways = 49;
  static const childMenuIdPendingPickups = 50;
  static const childMenuIdTransferSheetHistory = 51;
  static const childMenuIdDeliverySheetHistory = 52;
  static const childMenuIdReturnSheetHistory = 53;
  static const childMenuIdPendingVerifications = 54;
  static const childMenuIdSpecialRequestesList = 55;
  static const childMenuIdDeliveriesNotOnRoute = 56;
  static const childMenuIdOrderRemarks = 57;
  static const childMenuIdStagnantOrders = 58;

//////////////// Messages /////////////////
  static var serverErrorMSG = 'Server Error';
  static var tokenExpiredMSG = 'Session Expired please login again';
  static var notFoundErrorMSG = 'Record not found';
  static var badRequestErrorMSG = 'Bad Request';
  static var nullValueErrorMSG = 'error occurred';
  static var scanningWrongOrderMSG = 'You are scanning a wrong order';
  static var addedSuccessfullyMSG = 'Added Successfully';
  static var noMoreDataMSG = 'No more data';
  static var noDataToShowMSG = 'No data to show';
  static var scanningWrongQRMSG = 'You are scanning a wrong QR';

  /////// Order Status Ids for Create MU /////////

  static var orderStatusIdsToLoadForMidMileLastMile =
      '3,3,26,26'; //  PostExReceived , ArrivedAtDestination //
  static var orderStatusIdsToLoadForMidMileReturnTeam =
      '29,29'; //  ArrivedAtOrigin  //
  static var orderStatusIdsToLoadForDebrieferTeamReturnTeam =
      '23,22'; //  CustomerRefused , ReturnRequest  //
  static var orderStatusIdsToLoadForDebrieferTeamLastMile =
      '21,20'; //  Retry , DeliveryRescheduled  //
  static var orderStatusIdsToLoadForReturnTeamMidMile =
      '23,22,23,22'; //  CustomerRefused , ReturnRequest  //
  static var orderStatusIdsToLoadForReturnTeamLastMile = '21'; //   Retry //

  /////// Order Physical Status Ids for Create MU /////////

  static var orderPhysicalStatusIdsToLoadForMidMileLastMile =
      '3,17,17,3'; //  WaitingForLastMileHandover , WaitingForFineSort  //
  static var orderPhysicalStatusIdsToLoadForMidMileReturnTeam =
      '18,17'; //  WaitingForFineSort , WaitingForReturnTeam  //
  static var orderPhysicalStatusIdsToLoadForDebrieferTeamReturnTeam =
      '18,18'; //  WaitingForReturnTeam  //
  static var orderPhysicalStatusIdsToLoadForDebrieferTeamLastMile =
      '3,10'; //  WaitingForLastMileHandover , AtDebriefingDesk  //
  static var orderPhysicalStatusIdsToLoadForReturnTeamMidMile =
      '20,20,26,26'; //  ReturnTeamReceived , WaitingForReturnLineHaul  //
  static var orderPhysicalStatusIdsToLoadForReturnTeamLastMile =
      '3'; // WaitingForLastMileHandover  //
}
