import 'dart:async';

import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/warehouse_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/city_lead_model.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/views/order_management/selected_grid_orders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CityLeadDashboard extends StatefulWidget {
  const CityLeadDashboard({Key? key}) : super(key: key);

  @override
  _CityLeadDashboardState createState() => _CityLeadDashboardState();
}

class _CityLeadDashboardState extends State<CityLeadDashboard> {
  ApiFetchData apiFetchData = ApiFetchData();
  final WareHouseControllerHintText wareHouseController =
      Get.put(WareHouseControllerHintText());
  WareHouseDataDist? wareHouseDataDist;
  String? selectedWarehouse;

  // bool isAdmin = false;

  String hoursText12 = '12 Hours';
  String hoursText24 = '24 Hours';
  String hoursText48 = '48 Hours';
  String hoursText72 = '72 Hours';
  String monthsText3 = '3 Months';

  String selectedHours = '12 Hours';

  late String fromDateTime;
  late String toDateTime;

  dynamic totalAttemptedRate;
  dynamic totalDeliveryRate;
  dynamic totalDeliveryEnRouteRate;

  OrdersCountDataDist countDist = OrdersCountDataDist();

  int? totalOrdersStats;
  OrderStats pendingPickupsStats = OrderStats();
  OrderStats pickedStats = OrderStats();
  OrderStats stockInStats = OrderStats();
  OrderStats transferredStats = OrderStats();
  OrderStats underVerificationStats = OrderStats();
  OrderStats deliveryEnrouteStats = OrderStats();
  OrderStats attemptedStats = OrderStats();
  OrderStats returnInTransitStats = OrderStats();
  OrderStats deliveredStats = OrderStats();
  OrderStats returnedStats = OrderStats();

  String orderStatusIds = '';

  double gridNestedContainerWidth = SizeConfig.blockSizeHorizontal * 30;
  double gridNestedContainerHeight = SizeConfig.blockSizeVertical * 15;

  final counterMaxLine = 1;

  double gridTextSize = 3;
  final gridTextColor = MyColors.headerTextBlueShadeColor;
  final gridItemsAlign = TextAlign.center;

  double gridValueSize = 6;
  final gridValueColor = Colors.black;
  final gridValueFontWeight = FontWeight.w500;

  double gridPercentageSize = 4;
  final gridPercentageColor = Colors.grey[700];

  final animationDurationMS = 1500;

  double ratesTextSize = 4;
  // final ratesTextColor = MyColors.headerTextBlueShadeColor;
  final ratesTextColor = MyColors.textColorGreen;
  // final ratesTextColor = Colors.white;
  final ordersContainerTextColor = Colors.white;
  final ordersContainerValueColor = Colors.white;

  double ratesPercentageSize = 6;
  final ratesPercentageWeight = FontWeight.w500;
  final ratesPercentageColor = Colors.black;

  waveDash(var value) {
    return value ~/ 1;
  }

  bool isTappedTotalOrders = false;
  bool isTappedPendingPickups = false;
  bool isTappedPickedOrders = false;
  bool isTappedStockInOrders = false;
  bool isTappedTransferredOrders = false;
  bool isTappedUnderVerification = false;
  bool isTappedDeliveryEnroute = false;
  bool isTappedAttemptedOrders = false;
  bool isTappedReturnInTransit = false;
  bool isTappedDeliveredOrders = false;
  bool isTappedReturnedOrders = false;

  late Timer timer;

  // checkIsAdmin() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String? userTypeId = sharedPreferences.getString('userTypeId');
  //   if (userTypeId != null) {
  //     if (int.parse(userTypeId) == MyVariables.userTypeIdAdmin) {
  //       isAdmin = true;
  //     } else {
  //       isAdmin = false;
  //     }
  //   }
  // }

  void getDateTime() {
    int? tmptoDateTimeDurationHours;
    int? tmpFromDateTimeDurationHours;
    int? tmpFromDateTimeMonths;
    if (selectedHours == hoursText12) {
      tmpFromDateTimeDurationHours = 12;
    } else if (selectedHours == hoursText24) {
      // setState(() {
      //   toDateTime =
      //       myFormatDateTimeISOandUTCwithSubtraction(const Duration(hours: 12));
      //   fromDateTime =
      //       myFormatDateTimeISOandUTCwithSubtraction(const Duration(hours: 24));
      // });
      // reloadStatsData();
      tmptoDateTimeDurationHours = 12;
      tmpFromDateTimeDurationHours = 24;
    } else if (selectedHours == hoursText48) {
      tmptoDateTimeDurationHours = 24;
      tmpFromDateTimeDurationHours = 48;
    } else if (selectedHours == hoursText72) {
      tmptoDateTimeDurationHours = 48;
      tmpFromDateTimeDurationHours = 72;
    } else if (selectedHours == monthsText3) {
      tmptoDateTimeDurationHours = 72;
      tmpFromDateTimeMonths = 3;
    }

    setState(() {
      toDateTime = tmptoDateTimeDurationHours == null
          ? myFormatDateTimeISOandUTC()
          : myFormatDateTimeISOandUTCwithSubtraction(
              Duration(hours: tmptoDateTimeDurationHours));
      fromDateTime = tmpFromDateTimeMonths == null
          ? myFormatDateTimeISOandUTCwithSubtraction(
              Duration(hours: tmpFromDateTimeDurationHours!))
          : myFormatDateTimeISOandUTCwithSubtractionMonth(
              months: tmpFromDateTimeMonths);
    });
    reloadStatsData();
  }

  void loadDataStats() {
    if (selectedHours == hoursText12 || selectedHours == hoursText24) {
      setState(() {
        orderStatusIds =
            '${MyVariables.orderStatusIdBooked},${MyVariables.orderStatusIdPicked},${MyVariables.orderStatusIdPostExReceived},${MyVariables.orderStatusIdDispatched},${MyVariables.orderStatusIdUnderVerification},${MyVariables.orderStatusIdDeliveryEnroute},${MyVariables.orderStatusIdAttempted},${MyVariables.orderStatusIdReturnInTransit},${MyVariables.orderStatusIdDelivered},${MyVariables.orderStatusIdReturned}';
      });
    } else {
      setState(() {
        orderStatusIds =
            '${MyVariables.orderStatusIdBooked},${MyVariables.orderStatusIdPicked},${MyVariables.orderStatusIdPostExReceived},${MyVariables.orderStatusIdDispatched},${MyVariables.orderStatusIdUnderVerification},${MyVariables.orderStatusIdDeliveryEnroute},${MyVariables.orderStatusIdAttempted},${MyVariables.orderStatusIdReturnInTransit}';
      });
    }
    myShowLoadingDialog(context);
    apiFetchData
        .getOrderStats(
      wareHouseDataDist == null ? '' : wareHouseDataDist!.wareHouseId,
      fromDateTime,
      toDateTime,
      orderStatusIds: orderStatusIds,
      filterDateType: FilterDateType.orderStatusChangedDate.name.toString(),
    )
        .then((value) {
      if (value != null) {
        if (mounted) {
          Get.isDialogOpen == true ? Get.back() : null;
          setState(() {
            totalOrdersStats = value.total;
            pendingPickupsStats = value.orderStats!.firstWhere((element) =>
                element.transactionStatusId ==
                int.parse(MyVariables.orderStatusIdBooked));
            pickedStats = value.orderStats!.firstWhere((element) =>
                element.transactionStatusId ==
                int.parse(MyVariables.orderStatusIdPicked));
            stockInStats = value.orderStats!.firstWhere((element) =>
                element.transactionStatusId ==
                int.parse(MyVariables.orderStatusIdPostExReceived));
            transferredStats = value.orderStats!.firstWhere((element) =>
                element.transactionStatusId ==
                int.parse(MyVariables.orderStatusIdDispatched));
            underVerificationStats = value.orderStats!.firstWhere((element) =>
                element.transactionStatusId ==
                int.parse(MyVariables.orderStatusIdUnderVerification));
            deliveryEnrouteStats = value.orderStats!.firstWhere((element) =>
                element.transactionStatusId ==
                int.parse(MyVariables.orderStatusIdDeliveryEnroute));
            attemptedStats = value.orderStats!.firstWhere((element) =>
                element.transactionStatusId ==
                int.parse(MyVariables.orderStatusIdAttempted));
            returnInTransitStats = value.orderStats!.firstWhere((element) =>
                element.transactionStatusId ==
                int.parse(MyVariables.orderStatusIdReturnInTransit));
            deliveredStats = value.orderStats!.firstWhere(
                (element) =>
                    element.transactionStatusId ==
                    int.parse(MyVariables.orderStatusIdDelivered),
                orElse: () => OrderStats());
            returnedStats = value.orderStats!.firstWhere(
                (element) =>
                    element.transactionStatusId ==
                    int.parse(MyVariables.orderStatusIdReturned),
                orElse: () => OrderStats());
          });
        }
      }
    });
  }

  void loadDataRate() {
    myShowLoadingDialog(context);
    apiFetchData
        .getOrderRate(
      wareHouseDataDist == null ? '' : wareHouseDataDist!.wareHouseId,
    )
        .then((value) {
      if (value != null) {
        if (mounted) {
          Get.isDialogOpen == true ? Get.back() : null;
          setState(() {
            totalAttemptedRate = value.totalAttemptedRate;
            totalDeliveryRate = value.totalDeliveryRate;
            totalDeliveryEnRouteRate = value.totalDeliveryEnRouteRate;
          });
        }
      }
    });
  }

  void loadOrdersCount() {
    apiFetchData
        .getOrdersCount(
      wareHouseDataDist == null ? '' : wareHouseDataDist!.wareHouseId,
    )
        .then((value) {
      if (value != null && value.dist != null) {
        if (mounted) {
          setState(() {
            countDist = value.dist!;
          });
        }
      }
    });
  }

  void reloadStatsData() {
    setState(() {
      totalOrdersStats = null;
      pendingPickupsStats = OrderStats();
      pickedStats = OrderStats();
      stockInStats = OrderStats();
      transferredStats = OrderStats();
      underVerificationStats = OrderStats();
      deliveryEnrouteStats = OrderStats();
      attemptedStats = OrderStats();
      returnInTransitStats = OrderStats();
      deliveredStats = OrderStats();
      returnedStats = OrderStats();
    });
    loadDataStats();
  }

  void reloadStatsRatesAndCountsData() {
    setState(() {
      totalOrdersStats = null;
      pendingPickupsStats = OrderStats();
      pickedStats = OrderStats();
      stockInStats = OrderStats();
      transferredStats = OrderStats();
      underVerificationStats = OrderStats();
      deliveryEnrouteStats = OrderStats();
      attemptedStats = OrderStats();
      returnInTransitStats = OrderStats();
      deliveredStats = OrderStats();
      returnedStats = OrderStats();

      totalAttemptedRate = null;
      totalDeliveryRate = null;
      totalDeliveryEnRouteRate = null;

      countDist = OrdersCountDataDist();
    });
    getDateTime();
    loadDataRate();
    loadOrdersCount();
  }

  @override
  void initState() {
    super.initState();
    // checkIsAdmin();
    WidgetsBinding.instance.addPostFrameCallback((_) => getDateTime());
    WidgetsBinding.instance.addPostFrameCallback((c) => loadDataRate());
    WidgetsBinding.instance.addPostFrameCallback((c) => loadOrdersCount());
    timer = Timer.periodic(
        const Duration(minutes: 5), (Timer t) => handleTimeComletion());
  }

  handleTimeComletion() {
    if (mounted) {
      reloadStatsRatesAndCountsData();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    wareHouseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final borderRadiusForContainers = BorderRadius.all(
        Radius.circular(SizeConfig.safeBlockSizeHorizontal * 2));
    var dropDownContainerColor = Colors.white;
    var ratingRowContainerColor = Colors.white;
    var ordersContainerColor = Colors.green;
    // var gridContainerColor = Colors.grey[400];
    var gridContainerColor = Colors.transparent;
    final containersPadding = EdgeInsets.symmetric(
        vertical: SizeConfig.safeBlockSizeVertical * 1,
        horizontal: SizeConfig.safeBlockSizeHorizontal * 1);
    final containerWidth = SizeConfig.safeBlockSizeHorizontal * 40;
    final containerHeight = SizeConfig.safeBlockSizeVertical * 11;

    final gridRowWidth = SizeConfig.screenWidth;
    final gridRowHeight = selectedHours == hoursText48 ||
            selectedHours == hoursText72 ||
            selectedHours == monthsText3
        ? SizeConfig.safeBlockSizeVertical * 15
        : SizeConfig.safeBlockSizeVertical * 12;

    const spaceBetweenContainerWidth = MySpaceWidth(widthSize: 2);
    const spaceBetweenValuesInsideContainerWidth = MySpaceWidth(widthSize: 1);
    const spaceNestedContainersItemsHeight = MySpaceHeight(heightSize: 0.8);
    var spaceBetweenRows = MySpaceHeight(
        heightSize: selectedHours == hoursText48 ||
                selectedHours == hoursText72 ||
                selectedHours == monthsText3
            ? 2.5
            : 1.5);
    // const spaceBetweenDecorationAndColumnWidth = MySpaceWidth(widthSize: 1);

    // Color pendingPickupsColor = Colors.blue;
    // Color pickedOrdersColor = Colors.blue;
    // Color stockInOrdersColor = Colors.purple;
    // Color transferredColor = Colors.purple;
    // Color underVerificationOrders = Colors.orange;
    // Color deliveryEnrouteColor = Colors.blue;
    // Color attemptedOrdersColor = Colors.cyan;
    // Color returnInTransitOrdersColor = Colors.blue;
    // Color deliveredOrdersColor = Colors.green;
    // Color returnedOrdersColor = Colors.red;

    var gridNestedContainerPadding = EdgeInsets.symmetric(
        vertical: SizeConfig.blockSizeVertical * 1,
        horizontal: SizeConfig.blockSizeHorizontal * 2);
    var gridNestedContainerBorderRadius =
        BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 2));
    var gridNestedContainerAlignment = Alignment.center;

    // var unselectedBoxColor = Colors.grey[300];
    var unselectedBoxColor = Colors.white;
    var selectedBoxColor = MyColors.btnColorGreen;

    var selectedBoxTextColor = Colors.white;

    var columnCrossAxisAlignment = CrossAxisAlignment.center;
    var columnMainAxisSize = MainAxisSize.min;
    var boxFit = BoxFit.scaleDown;

    var appBar = AppBar(
      title: const MyTextWidgetAppBarTitle(text: 'City Lead Dashboard'),
      backgroundColor: Colors.black,
      toolbarHeight: MyVariables.appbarHeight,
      elevation: 0,
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const CityLeadDashboard()));
            },
            icon: Icon(
              Icons.refresh_outlined,
              size: SizeConfig.safeBlockSizeHorizontal * 8,
            )),
        const MySpaceWidth(widthSize: 2),
      ],
    );

    var ratingRow = Row(
      children: [
        Expanded(
            child: Container(
          width: containerWidth,
          height: containerHeight,
          padding: containersPadding,
          decoration: BoxDecoration(
            borderRadius: borderRadiusForContainers,
            color: ratingRowContainerColor,
          ),
          child: FittedBox(
            fit: boxFit,
            child: Center(
              child: Column(
                crossAxisAlignment: columnCrossAxisAlignment,
                mainAxisSize: columnMainAxisSize,
                children: [
                  SizedBox(
                    width: SizeConfig.safeBlockSizeHorizontal * 35,
                    child: _renderStatsGridTextWidget(
                      text: 'Delivery Enroute Rate',
                      textColor: ratesTextColor,
                      textSize: ratesTextSize,
                      maxLines: 2,
                    ),
                  ),
                  spaceNestedContainersItemsHeight,
                  _renderStatsGridPercentageWidget(
                    percentage: totalDeliveryEnRouteRate,
                    color: ratesPercentageColor,
                    size: ratesPercentageSize,
                    fontWeight: ratesPercentageWeight,
                  ),
                ],
              ),
            ),
          ),
        )),
        spaceBetweenContainerWidth,
        Expanded(
            child: Container(
          width: containerWidth,
          height: containerHeight,
          padding: containersPadding,
          decoration: BoxDecoration(
            borderRadius: borderRadiusForContainers,
            color: ratingRowContainerColor,
          ),
          child: FittedBox(
            fit: boxFit,
            child: Center(
              child: Column(
                crossAxisAlignment: columnCrossAxisAlignment,
                mainAxisSize: columnMainAxisSize,
                children: [
                  // MyTextWidgetCustom(
                  //   text: 'Attempt Rate',
                  //   color: MyColors.headerTextBlueShadeColor,
                  //   sizeBlockHorizontalDigit: 4,
                  //   maxLines: counterMaxLine,
                  // ),
                  _renderStatsGridTextWidget(
                    text: 'Attempt Rate',
                    textColor: ratesTextColor,
                    textSize: ratesTextSize,
                    maxLines: counterMaxLine,
                  ),
                  spaceNestedContainersItemsHeight,
                  // MyTextWidgetCustom(
                  //   text: totalAttemptedRate == null
                  //       ? '...'
                  //       : totalAttemptedRate!.toStringAsFixed(2) + ' ' + '%',
                  //   color: Colors.black,
                  //   sizeBlockHorizontalDigit: 6,
                  //   fontWeight: FontWeight.w500,
                  //   maxLines: counterMaxLine,
                  // ),
                  _renderStatsGridPercentageWidget(
                    percentage: totalAttemptedRate,
                    color: ratesPercentageColor,
                    size: ratesPercentageSize,
                    fontWeight: ratesPercentageWeight,
                  ),
                  // const LastComparisonRow(
                  //   value: '40',
                  // ),
                ],
              ),
            ),
          ),
        )),
        spaceBetweenContainerWidth,
        Expanded(
            child: Container(
          width: containerWidth,
          height: containerHeight,
          padding: containersPadding,
          decoration: BoxDecoration(
            borderRadius: borderRadiusForContainers,
            color: ratingRowContainerColor,
          ),
          child: FittedBox(
            fit: boxFit,
            child: Center(
              child: Column(
                crossAxisAlignment: columnCrossAxisAlignment,
                mainAxisSize: columnMainAxisSize,
                children: [
                  _renderStatsGridTextWidget(
                    text: 'Delivery Rate',
                    textColor: ratesTextColor,
                    textSize: ratesTextSize,
                    maxLines: counterMaxLine,
                  ),
                  spaceNestedContainersItemsHeight,
                  _renderStatsGridPercentageWidget(
                    percentage: totalDeliveryRate,
                    color: ratesPercentageColor,
                    size: ratesPercentageSize,
                    fontWeight: ratesPercentageWeight,
                  ),
                  // const LastComparisonRow(value: '60'),
                ],
              ),
            ),
          ),
        )),
      ],
    );

    var ordersContainer = Container(
      width: SizeConfig.screenWidth,
      height: containerHeight,
      padding: containersPadding,
      decoration: BoxDecoration(
          borderRadius: borderRadiusForContainers, color: ordersContainerColor),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FittedBox(
              fit: BoxFit.scaleDown,
              child: MyTextWidgetCustom(
                text: 'Last Month:',
                sizeBlockHorizontalDigit: 1,
                color: Colors.black,
              ),
            ),
            const MySpaceHeight(heightSize: 0.5),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: boxFit,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: columnCrossAxisAlignment,
                          mainAxisSize: columnMainAxisSize,
                          children: [
                            _renderStatsGridTextWidget(
                              text: 'Picked',
                              maxLines: counterMaxLine,
                              textSize: ratesTextSize,
                              textColor: ordersContainerTextColor,
                            ),
                            spaceNestedContainersItemsHeight,
                            _renderStatsGridCounterValueWidget(
                              value: countDist.totalPicked,
                              color: ordersContainerValueColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  spaceBetweenValuesInsideContainerWidth,
                  Expanded(
                    child: FittedBox(
                      fit: boxFit,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: columnCrossAxisAlignment,
                          mainAxisSize: columnMainAxisSize,
                          children: [
                            _renderStatsGridTextWidget(
                              text: 'Delivered',
                              maxLines: counterMaxLine,
                              textSize: ratesTextSize,
                              textColor: ordersContainerTextColor,
                            ),
                            spaceNestedContainersItemsHeight,
                            _renderStatsGridCounterValueWidget(
                              value: countDist.totalDelivered,
                              color: ordersContainerValueColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  spaceBetweenValuesInsideContainerWidth,
                  Expanded(
                    child: FittedBox(
                      fit: boxFit,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: columnCrossAxisAlignment,
                          mainAxisSize: columnMainAxisSize,
                          children: [
                            _renderStatsGridTextWidget(
                              text: 'Returned',
                              textColor: ordersContainerTextColor,
                              textSize: ratesTextSize,
                              maxLines: counterMaxLine,
                            ),
                            spaceNestedContainersItemsHeight,
                            _renderStatsGridCounterValueWidget(
                              value: countDist.totalReturned,
                              color: ordersContainerValueColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    var wareHosueDropdown = Row(children: [
      Expanded(
        child: Container(
            height: SizeConfig.safeBlockSizeVertical * 6,
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.safeBlockSizeVertical * 1,
                horizontal: SizeConfig.safeBlockSizeHorizontal * 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.safeBlockSizeHorizontal * 10)),
              color: dropDownContainerColor,
            ),
            alignment: Alignment.centerRight,
            child: MyDropDownWareHouse(
              isExpanded: true,
              selectedValue: selectedWarehouse,
              needToHideUnderline: true,
              onChanged: (val) {
                if (val == MyVariables.wareHouseDropdownSelectAllText) {
                  setState(() {
                    selectedWarehouse = val.toString();
                    wareHouseDataDist = null;
                  });
                  reloadStatsRatesAndCountsData();
                } else {
                  setState(() {
                    selectedWarehouse = val.toString();
                    wareHouseDataDist = wareHouseController
                        .wareHouseLookupListHintText
                        .firstWhere((element) => element.wareHouseName == val);
                  });
                  reloadStatsRatesAndCountsData();
                }
              },
              listOfItems: wareHouseController.wareHouseLookupListHintText,
            )),
      ),
    ]);

    var hoursContainer = FittedBox(
      child: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.safeBlockSizeVertical * 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: FittedBox(
                child: MyElevatedButton(
                  text: hoursText12,
                  btnTextColor: selectedHours == hoursText12
                      ? Colors.white
                      : Colors.black,
                  btnBackgroundColor: selectedHours == hoursText12
                      ? MyColors.btnColorGreen
                      : Colors.grey[200],
                  btnTextSizeBlock: 4,
                  btnPaddingHorizontalSize: 8,
                  btnPaddingVerticalSize: 1.5,
                  btnRadiusBlockSize: 200,
                  onPressed: () {
                    setState(() {
                      selectedHours = hoursText12;
                    });
                    getDateTime();
                  },
                ),
              ),
            ),
            spaceBetweenValuesInsideContainerWidth,
            Expanded(
              child: FittedBox(
                child: MyElevatedButton(
                  text: hoursText24,
                  btnTextColor: selectedHours == hoursText24
                      ? Colors.white
                      : Colors.black,
                  btnBackgroundColor: selectedHours == hoursText24
                      ? MyColors.btnColorGreen
                      : Colors.grey[200],
                  btnTextSizeBlock: 4,
                  btnPaddingHorizontalSize: 8,
                  btnPaddingVerticalSize: 1.5,
                  btnRadiusBlockSize: 200,
                  onPressed: () {
                    setState(() {
                      selectedHours = hoursText24;
                    });
                    getDateTime();
                  },
                ),
              ),
            ),
            spaceBetweenValuesInsideContainerWidth,
            Expanded(
              child: FittedBox(
                child: MyElevatedButton(
                  text: hoursText48,
                  btnTextColor: selectedHours == hoursText48
                      ? Colors.white
                      : Colors.black,
                  btnBackgroundColor: selectedHours == hoursText48
                      ? MyColors.btnColorGreen
                      : Colors.grey[200],
                  btnTextSizeBlock: 4,
                  btnPaddingHorizontalSize: 8,
                  btnPaddingVerticalSize: 1.5,
                  btnRadiusBlockSize: 200,
                  onPressed: () {
                    setState(() {
                      selectedHours = hoursText48;
                    });
                    getDateTime();
                  },
                ),
              ),
            ),
            spaceBetweenValuesInsideContainerWidth,
            Expanded(
              child: FittedBox(
                child: MyElevatedButton(
                  text: hoursText72,
                  btnTextColor: selectedHours == hoursText72
                      ? Colors.white
                      : Colors.black,
                  btnBackgroundColor: selectedHours == hoursText72
                      ? MyColors.btnColorGreen
                      : Colors.grey[200],
                  btnTextSizeBlock: 4,
                  btnPaddingHorizontalSize: 8,
                  btnPaddingVerticalSize: 1.5,
                  btnRadiusBlockSize: 200,
                  onPressed: () {
                    setState(() {
                      selectedHours = hoursText72;
                    });
                    getDateTime();
                  },
                ),
              ),
            ),
            // isAdmin == true
            //     ?
            spaceBetweenValuesInsideContainerWidth,

            //     : Container(),
            // isAdmin == true
            //     ?
            Expanded(
              child: FittedBox(
                child: MyElevatedButton(
                  text: monthsText3,
                  btnTextColor: selectedHours == monthsText3
                      ? Colors.white
                      : Colors.black,
                  btnBackgroundColor: selectedHours == monthsText3
                      ? MyColors.btnColorGreen
                      : Colors.grey[200],
                  btnTextSizeBlock: 4,
                  btnPaddingHorizontalSize: 8,
                  btnPaddingVerticalSize: 1.5,
                  btnRadiusBlockSize: 200,
                  onPressed: () {
                    setState(() {
                      selectedHours = monthsText3;
                    });
                    getDateTime();
                  },
                ),
              ),
            )
            // : Container(),
          ],
        ),
      ),
    );

    var gridRow1 = FittedBox(
      child: SizedBox(
        width: gridRowWidth,
        height: gridRowHeight,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isTappedTotalOrders = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isTappedTotalOrders = false;
                  });
                  Get.to(() => SelectedGridOrders(
                        appBarTitleText: 'Total',
                        wareHouseId: wareHouseDataDist == null
                            ? null
                            : wareHouseDataDist!.wareHouseId,
                        fromDateTime: fromDateTime,
                        toDateTime: toDateTime,
                        transactionStatusId: null,
                        transactionStatusIdsTotal: orderStatusIds,
                      ));
                },
                onTapCancel: () {
                  setState(() {
                    isTappedTotalOrders = false;
                  });
                },
                child: Container(
                  width: gridNestedContainerWidth,
                  height: gridNestedContainerHeight,
                  padding: gridNestedContainerPadding,
                  alignment: gridNestedContainerAlignment,
                  decoration: BoxDecoration(
                    color: isTappedTotalOrders == true
                        ? selectedBoxColor
                        : unselectedBoxColor,
                    borderRadius: gridNestedContainerBorderRadius,
                  ),
                  child: FittedBox(
                    fit: boxFit,
                    child: Column(
                      crossAxisAlignment: columnCrossAxisAlignment,
                      mainAxisSize: columnMainAxisSize,
                      children: [
                        // MyTextWidgetCustom(
                        //   text: totalOrdersStats == null
                        //       ? '...'
                        //       : totalOrdersStats.toString(),
                        //   color: gridValueColor,
                        //   sizeBlockHorizontalDigit: gridValueSize,
                        //   fontWeight: gridValueFontWeight,
                        //   textAlign: gridItemsAlign,
                        // ),
                        _renderStatsGridCounterValueWidget(
                            value: totalOrdersStats,
                            color: isTappedTotalOrders == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        // MyTextWidgetCustom(
                        //   text: 'Total',
                        //   color: gridTextColor,
                        //   sizeBlockHorizontalDigit: gridTextSize,
                        //   textAlign: gridItemsAlign,
                        // ),
                        _renderStatsGridTextWidget(
                            text: 'Total',
                            textColor: isTappedTotalOrders == true
                                ? selectedBoxTextColor
                                : null),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            spaceBetweenValuesInsideContainerWidth,
            Expanded(
              // child: Row(
              //   children: [
              //     myDecorationLine(deliveryEnrouteColor),
              //     spaceBetweenDecorationAndColumnWidth,
              //     Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isTappedPendingPickups = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isTappedPendingPickups = false;
                  });
                  Get.to(() => SelectedGridOrders(
                        appBarTitleText: 'Pending Pickup',
                        wareHouseId: wareHouseDataDist == null
                            ? null
                            : wareHouseDataDist!.wareHouseId,
                        fromDateTime: fromDateTime,
                        toDateTime: toDateTime,
                        transactionStatusId:
                            int.parse(MyVariables.orderStatusIdBooked),
                      ));
                },
                onTapCancel: () {
                  setState(() {
                    isTappedPendingPickups = false;
                  });
                },
                child: Container(
                  width: gridNestedContainerWidth,
                  height: gridNestedContainerHeight,
                  padding: gridNestedContainerPadding,
                  alignment: gridNestedContainerAlignment,
                  decoration: BoxDecoration(
                    color: isTappedPendingPickups == true
                        ? selectedBoxColor
                        : unselectedBoxColor,
                    borderRadius: gridNestedContainerBorderRadius,
                  ),
                  child: FittedBox(
                    fit: boxFit,
                    child: Column(
                      children: [
                        _renderStatsGridCounterValueWidget(
                            value: pendingPickupsStats.total,
                            color: isTappedPendingPickups == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridTextWidget(
                            text: 'Pending Pickup',
                            textColor: isTappedPendingPickups == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridPercentageWidget(
                            percentage: pendingPickupsStats.percentage,
                            color: isTappedPendingPickups == true
                                ? selectedBoxTextColor
                                : null),
                      ],
                    ),
                  ),
                  //     ),
                  //   ],
                ),
              ),
            ),
            spaceBetweenValuesInsideContainerWidth,
            Expanded(
              // child: Row(
              //   children: [
              //     myDecorationLine(pendingPickupsColor),
              //     spaceBetweenDecorationAndColumnWidth,
              //     Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isTappedPickedOrders = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isTappedPickedOrders = false;
                  });
                  Get.to(() => SelectedGridOrders(
                        appBarTitleText: 'Picked',
                        wareHouseId: wareHouseDataDist == null
                            ? null
                            : wareHouseDataDist!.wareHouseId,
                        fromDateTime: fromDateTime,
                        toDateTime: toDateTime,
                        transactionStatusId:
                            int.parse(MyVariables.orderStatusIdPicked),
                      ));
                },
                onTapCancel: () {
                  setState(() {
                    isTappedPickedOrders = false;
                  });
                },
                child: Container(
                  width: gridNestedContainerWidth,
                  height: gridNestedContainerHeight,
                  padding: gridNestedContainerPadding,
                  alignment: gridNestedContainerAlignment,
                  decoration: BoxDecoration(
                    color: isTappedPickedOrders == true
                        ? selectedBoxColor
                        : unselectedBoxColor,
                    borderRadius: gridNestedContainerBorderRadius,
                  ),
                  child: FittedBox(
                    fit: boxFit,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _renderStatsGridCounterValueWidget(
                            value: pickedStats.total,
                            color: isTappedPickedOrders == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridTextWidget(
                            text: 'Picked',
                            textColor: isTappedPickedOrders == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridPercentageWidget(
                            percentage: pickedStats.percentage,
                            color: isTappedPickedOrders == true
                                ? selectedBoxTextColor
                                : null),
                      ],
                    ),
                  ),
                  //   ),
                  // ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    var gridRow2 = FittedBox(
      child: SizedBox(
        width: gridRowWidth,
        height: gridRowHeight,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isTappedStockInOrders = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isTappedStockInOrders = false;
                  });
                  Get.to(() => SelectedGridOrders(
                        appBarTitleText: 'Stock In',
                        wareHouseId: wareHouseDataDist == null
                            ? null
                            : wareHouseDataDist!.wareHouseId,
                        fromDateTime: fromDateTime,
                        toDateTime: toDateTime,
                        transactionStatusId:
                            int.parse(MyVariables.orderStatusIdPostExReceived),
                      ));
                },
                onTapCancel: () {
                  setState(() {
                    isTappedStockInOrders = false;
                  });
                },
                child: Container(
                  width: gridNestedContainerWidth,
                  height: gridNestedContainerHeight,
                  padding: gridNestedContainerPadding,
                  alignment: gridNestedContainerAlignment,
                  decoration: BoxDecoration(
                    color: isTappedStockInOrders == true
                        ? selectedBoxColor
                        : unselectedBoxColor,
                    borderRadius: gridNestedContainerBorderRadius,
                  ),
                  child: FittedBox(
                    fit: boxFit,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _renderStatsGridCounterValueWidget(
                            value: stockInStats.total,
                            color: isTappedStockInOrders == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridTextWidget(
                            text: 'Stock In',
                            textColor: isTappedStockInOrders == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridPercentageWidget(
                            percentage: stockInStats.percentage,
                            color: isTappedStockInOrders == true
                                ? selectedBoxTextColor
                                : null),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            spaceBetweenValuesInsideContainerWidth,
            Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isTappedTransferredOrders = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isTappedTransferredOrders = false;
                  });
                  Get.to(() => SelectedGridOrders(
                        appBarTitleText: 'Transferred',
                        wareHouseId: wareHouseDataDist == null
                            ? null
                            : wareHouseDataDist!.wareHouseId,
                        fromDateTime: fromDateTime,
                        toDateTime: toDateTime,
                        transactionStatusId:
                            int.parse(MyVariables.orderStatusIdDispatched),
                      ));
                },
                onTapCancel: () {
                  setState(() {
                    isTappedTransferredOrders = false;
                  });
                },
                child: Container(
                  width: gridNestedContainerWidth,
                  height: gridNestedContainerHeight,
                  padding: gridNestedContainerPadding,
                  alignment: gridNestedContainerAlignment,
                  decoration: BoxDecoration(
                    color: isTappedTransferredOrders == true
                        ? selectedBoxColor
                        : unselectedBoxColor,
                    borderRadius: gridNestedContainerBorderRadius,
                  ),
                  child: FittedBox(
                    fit: boxFit,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _renderStatsGridCounterValueWidget(
                            value: transferredStats.total,
                            color: isTappedTransferredOrders == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridTextWidget(
                            text: 'Transferred',
                            textColor: isTappedTransferredOrders == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridPercentageWidget(
                            percentage: transferredStats.percentage,
                            color: isTappedTransferredOrders == true
                                ? selectedBoxTextColor
                                : null),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            spaceBetweenValuesInsideContainerWidth,
            Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isTappedUnderVerification = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isTappedUnderVerification = false;
                  });
                  Get.to(() => SelectedGridOrders(
                        appBarTitleText: 'Under Verification',
                        wareHouseId: wareHouseDataDist == null
                            ? null
                            : wareHouseDataDist!.wareHouseId,
                        fromDateTime: fromDateTime,
                        toDateTime: toDateTime,
                        transactionStatusId: int.parse(
                            MyVariables.orderStatusIdUnderVerification),
                      ));
                },
                onTapCancel: () {
                  setState(() {
                    isTappedUnderVerification = false;
                  });
                },
                child: Container(
                  width: gridNestedContainerWidth,
                  height: gridNestedContainerHeight,
                  padding: gridNestedContainerPadding,
                  alignment: gridNestedContainerAlignment,
                  decoration: BoxDecoration(
                    color: isTappedUnderVerification == true
                        ? selectedBoxColor
                        : unselectedBoxColor,
                    borderRadius: gridNestedContainerBorderRadius,
                  ),
                  child: FittedBox(
                    fit: boxFit,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _renderStatsGridCounterValueWidget(
                            value: underVerificationStats.total,
                            color: isTappedUnderVerification == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridTextWidget(
                            text: 'Under Verification',
                            textColor: isTappedUnderVerification == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridPercentageWidget(
                            percentage: underVerificationStats.percentage,
                            color: isTappedUnderVerification == true
                                ? selectedBoxTextColor
                                : null),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    var gridRow3 = FittedBox(
      child: SizedBox(
        width: gridRowWidth,
        height: gridRowHeight,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isTappedDeliveryEnroute = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isTappedDeliveryEnroute = false;
                  });
                  Get.to(() => SelectedGridOrders(
                        appBarTitleText: 'Delivery Enroute',
                        wareHouseId: wareHouseDataDist == null
                            ? null
                            : wareHouseDataDist!.wareHouseId,
                        fromDateTime: fromDateTime,
                        toDateTime: toDateTime,
                        transactionStatusId:
                            int.parse(MyVariables.orderStatusIdDeliveryEnroute),
                      ));
                },
                onTapCancel: () {
                  setState(() {
                    isTappedDeliveryEnroute = false;
                  });
                },
                child: Container(
                  width: gridNestedContainerWidth,
                  height: gridNestedContainerHeight,
                  padding: gridNestedContainerPadding,
                  alignment: gridNestedContainerAlignment,
                  decoration: BoxDecoration(
                    color: isTappedDeliveryEnroute == true
                        ? selectedBoxColor
                        : unselectedBoxColor,
                    borderRadius: gridNestedContainerBorderRadius,
                  ),
                  child: FittedBox(
                    fit: boxFit,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _renderStatsGridCounterValueWidget(
                            value: deliveryEnrouteStats.total,
                            color: isTappedDeliveryEnroute == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridTextWidget(
                            text: 'Delivery Enroute',
                            textColor: isTappedDeliveryEnroute == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridPercentageWidget(
                            percentage: deliveryEnrouteStats.percentage,
                            color: isTappedDeliveryEnroute == true
                                ? selectedBoxTextColor
                                : null),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            spaceBetweenValuesInsideContainerWidth,
            Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isTappedAttemptedOrders = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isTappedAttemptedOrders = false;
                  });
                  Get.to(() => SelectedGridOrders(
                        appBarTitleText: 'Attempted',
                        wareHouseId: wareHouseDataDist == null
                            ? null
                            : wareHouseDataDist!.wareHouseId,
                        fromDateTime: fromDateTime,
                        toDateTime: toDateTime,
                        transactionStatusId:
                            int.parse(MyVariables.orderStatusIdAttempted),
                      ));
                },
                onTapCancel: () {
                  setState(() {
                    isTappedAttemptedOrders = false;
                  });
                },
                child: Container(
                  width: gridNestedContainerWidth,
                  height: gridNestedContainerHeight,
                  padding: gridNestedContainerPadding,
                  alignment: gridNestedContainerAlignment,
                  decoration: BoxDecoration(
                    color: isTappedAttemptedOrders == true
                        ? selectedBoxColor
                        : unselectedBoxColor,
                    borderRadius: gridNestedContainerBorderRadius,
                  ),
                  child: FittedBox(
                    fit: boxFit,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _renderStatsGridCounterValueWidget(
                            value: attemptedStats.total,
                            color: isTappedAttemptedOrders == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridTextWidget(
                            text: 'Attempted',
                            textColor: isTappedAttemptedOrders == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridPercentageWidget(
                            percentage: attemptedStats.percentage,
                            color: isTappedAttemptedOrders == true
                                ? selectedBoxTextColor
                                : null),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            spaceBetweenValuesInsideContainerWidth,
            Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isTappedReturnInTransit = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isTappedReturnInTransit = false;
                  });
                  Get.to(() => SelectedGridOrders(
                        appBarTitleText: 'Return InTransit',
                        wareHouseId: wareHouseDataDist == null
                            ? null
                            : wareHouseDataDist!.wareHouseId,
                        fromDateTime: fromDateTime,
                        toDateTime: toDateTime,
                        transactionStatusId:
                            int.parse(MyVariables.orderStatusIdReturnInTransit),
                      ));
                },
                onTapCancel: () {
                  setState(() {
                    isTappedReturnInTransit = false;
                  });
                },
                child: Container(
                  width: gridNestedContainerWidth,
                  height: gridNestedContainerHeight,
                  padding: gridNestedContainerPadding,
                  alignment: gridNestedContainerAlignment,
                  decoration: BoxDecoration(
                    color: isTappedReturnInTransit == true
                        ? selectedBoxColor
                        : unselectedBoxColor,
                    borderRadius: gridNestedContainerBorderRadius,
                  ),
                  child: FittedBox(
                    fit: boxFit,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _renderStatsGridCounterValueWidget(
                            value: returnInTransitStats.total,
                            color: isTappedReturnInTransit == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridTextWidget(
                            text: 'Return InTransit',
                            textColor: isTappedReturnInTransit == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridPercentageWidget(
                            percentage: returnInTransitStats.percentage,
                            color: isTappedReturnInTransit == true
                                ? selectedBoxTextColor
                                : null),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    var gridRow4 = FittedBox(
      child: SizedBox(
        width: gridRowWidth,
        height: gridRowHeight,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isTappedDeliveredOrders = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isTappedDeliveredOrders = false;
                  });
                  Get.to(() => SelectedGridOrders(
                        appBarTitleText: 'Delivered',
                        wareHouseId: wareHouseDataDist == null
                            ? null
                            : wareHouseDataDist!.wareHouseId,
                        fromDateTime: fromDateTime,
                        toDateTime: toDateTime,
                        transactionStatusId:
                            int.parse(MyVariables.orderStatusIdDelivered),
                      ));
                },
                onTapCancel: () {
                  setState(() {
                    isTappedDeliveredOrders = false;
                  });
                },
                child: Container(
                  width: gridNestedContainerWidth,
                  height: gridNestedContainerHeight,
                  padding: gridNestedContainerPadding,
                  alignment: gridNestedContainerAlignment,
                  decoration: BoxDecoration(
                    color: isTappedDeliveredOrders == true
                        ? selectedBoxColor
                        : unselectedBoxColor,
                    borderRadius: gridNestedContainerBorderRadius,
                  ),
                  child: FittedBox(
                    fit: boxFit,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _renderStatsGridCounterValueWidget(
                            value: deliveredStats.total,
                            color: isTappedDeliveredOrders == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridTextWidget(
                            text: 'Delivered',
                            textColor: isTappedDeliveredOrders == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridPercentageWidget(
                            percentage: deliveredStats.percentage,
                            color: isTappedDeliveredOrders == true
                                ? selectedBoxTextColor
                                : null),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            spaceBetweenValuesInsideContainerWidth,
            Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isTappedReturnedOrders = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isTappedReturnedOrders = false;
                  });
                  Get.to(() => SelectedGridOrders(
                        appBarTitleText: 'Returned',
                        wareHouseId: wareHouseDataDist == null
                            ? null
                            : wareHouseDataDist!.wareHouseId,
                        fromDateTime: fromDateTime,
                        toDateTime: toDateTime,
                        transactionStatusId:
                            int.parse(MyVariables.orderStatusIdReturned),
                      ));
                },
                onTapCancel: () {
                  setState(() {
                    isTappedReturnedOrders = false;
                  });
                },
                child: Container(
                  width: gridNestedContainerWidth,
                  height: gridNestedContainerHeight,
                  padding: gridNestedContainerPadding,
                  alignment: gridNestedContainerAlignment,
                  decoration: BoxDecoration(
                    color: isTappedReturnedOrders == true
                        ? selectedBoxColor
                        : unselectedBoxColor,
                    borderRadius: gridNestedContainerBorderRadius,
                  ),
                  child: FittedBox(
                    fit: boxFit,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _renderStatsGridCounterValueWidget(
                            value: returnedStats.total,
                            color: isTappedReturnedOrders == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridTextWidget(
                            text: 'Returned',
                            textColor: isTappedReturnedOrders == true
                                ? selectedBoxTextColor
                                : null),
                        spaceNestedContainersItemsHeight,
                        _renderStatsGridPercentageWidget(
                            percentage: returnedStats.percentage,
                            color: isTappedReturnedOrders == true
                                ? selectedBoxTextColor
                                : null),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            spaceBetweenValuesInsideContainerWidth,
            // Expanded(child: Container()),
          ],
        ),
      ),
    );

    var ordersGridContainer = Expanded(
      child: Container(
        width: SizeConfig.screenWidth,
        padding: containersPadding,
        decoration: BoxDecoration(
          borderRadius: borderRadiusForContainers,
          color: gridContainerColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              gridRow1,
              spaceBetweenRows,
              gridRow2,
              spaceBetweenRows,
              gridRow3,
              selectedHours == hoursText48 ||
                      selectedHours == hoursText72 ||
                      selectedHours == monthsText3
                  ? Container()
                  : spaceBetweenRows,
              selectedHours == hoursText48 ||
                      selectedHours == hoursText72 ||
                      selectedHours == monthsText3
                  ? Container()
                  : gridRow4,
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      // backgroundColor: MyColors.scaffoldBackgroundColor,
      backgroundColor: Colors.black87,
      appBar: appBar,
      body: Container(
        width: SizeConfig.screenWidth,
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            wareHosueDropdown,
            const MySpaceHeight(heightSize: 1),
            ordersContainer,
            const MySpaceHeight(heightSize: 1),
            const Align(
              alignment: Alignment.centerLeft,
              child: MyTextWidgetCustom(
                text: 'Current Day:',
                sizeBlockHorizontalDigit: 1,
                color: Colors.white,
              ),
            ),
            const MySpaceHeight(heightSize: 0.3),
            ratingRow,
            const MySpaceHeight(heightSize: 0.5),
            hoursContainer,
            const MySpaceHeight(heightSize: 0.5),
            ordersGridContainer,
          ],
        ),
      ),
    );
  }

  Widget _renderStatsGridCounterValueWidget(
      {int? value,
      Color? color,
      double? size,
      FontWeight? weight,
      TextAlign? align,
      int? maxLines}) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: animationDurationMS),
      tween: Tween<num>(begin: 0, end: value ?? 0),
      builder: (context, val, child) {
        return MyTextWidgetCustom(
          text: value == null ? '...' : waveDash(val).toString(),
          color: color ?? gridValueColor,
          sizeBlockHorizontalDigit: size ?? gridValueSize,
          fontWeight: weight ?? gridValueFontWeight,
          textAlign: align ?? gridItemsAlign,
          maxLines: maxLines ?? counterMaxLine,
        );
      },
    );
  }

  Widget _renderStatsGridTextWidget(
      {required String text,
      Color? textColor,
      double? textSize,
      TextAlign? textAlign,
      int? maxLines}) {
    return MyTextWidgetCustom(
      text: text,
      color: textColor ?? gridTextColor,
      sizeBlockHorizontalDigit: textSize ?? gridTextSize,
      textAlign: textAlign ?? gridItemsAlign,
      maxLines: maxLines ?? counterMaxLine,
    );
  }

  Widget _renderStatsGridPercentageWidget(
      {dynamic percentage,
      Color? color,
      double? size,
      FontWeight? fontWeight,
      TextAlign? align,
      int? maxLines}) {
    return TweenAnimationBuilder(
        duration: Duration(milliseconds: animationDurationMS),
        tween: Tween<dynamic>(begin: 0, end: percentage ?? 0),
        builder: (context, val, child) {
          return MyTextWidgetCustom(
            text: percentage == null
                ? '...'
                // : double.parse(val.toString()).toStringAsFixed(2) + '' + '%',
                // : double.parse(val.toString()).toString() + '' + '%',
                : val == percentage
                    ? val.toString() + '' + '%'
                    : double.parse(val.toString()).toStringAsFixed(0) +
                        '' +
                        '%',
            color: color ?? gridPercentageColor,
            sizeBlockHorizontalDigit: size ?? gridPercentageSize,
            fontWeight: fontWeight,
            textAlign: align ?? gridItemsAlign,
            maxLines: maxLines ?? counterMaxLine,
          );
        });
  }

  // Widget myDecorationLine(Color color) {
  //   return Container(
  //     color: color,
  //     width: SizeConfig.safeBlockSizeHorizontal,
  //     height: SizeConfig.safeBlockSizeVertical * 5,
  //   );
  // }
}

// class LastComparisonRow extends StatelessWidget {
//   const LastComparisonRow({
//     required this.value,
//     Key? key,
//   }) : super(key: key);

//   final String value;

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     const spaceBetweenLowerTextIcon = MySpaceWidth(widthSize: 0.5);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         Flexible(
//           child: MyTextWidgetCustom(
//             text: value + ' ' + '%',
//             color: Colors.red,
//             sizeBlockHorizontalDigit: 3.5,
//             fontWeight: FontWeight.w500,
//             maxLines: 1,
//           ),
//         ),
//         spaceBetweenLowerTextIcon,
//         Icon(
//           Icons.arrow_downward,
//           color: Colors.red,
//           size: SizeConfig.safeBlockSizeHorizontal * 4,
//         ),
//         spaceBetweenLowerTextIcon,
//         const Flexible(
//           child: MyTextWidgetCustom(
//             text: 'Than last day',
//             color: Colors.black,
//             sizeBlockHorizontalDigit: 3,
//             maxLines: 1,
//           ),
//         ),
//       ],
//     );
//   }
// }
