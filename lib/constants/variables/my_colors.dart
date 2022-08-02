import 'package:backoffice_new/constants/size_config.dart';
import 'package:flutter/material.dart';

class MyColors {
  // static var scaffoldBackgroundColor = Colors.grey[300];
  static var scaffoldBackgroundColor = const Color(0xffe8e8e8);
  // static var scaffoldBackgroundColor = Colors.grey[200];
  static var headerTextBlueShadeColor = const Color(0XFF342d6e);

  static var textColorGreen = Colors.green;
  static var btnColorGreen = Colors.green;

  static var tetxFieldIconsColor = Colors.black54;
  static var textFieldFillColor = Colors.grey[300];

  static var trackingNumberColor = Colors.blue;

  static var yellow800Color = Colors.yellow[800];
  static var yellow600Color = Colors.yellow[600];
  static var purpleColor = Colors.purple;
  static var greenColor = Colors.green;
  static var orangeColor = Colors.orange;
  static var redColor = Colors.red;
  static var brownColor = Colors.brown;

  static var unbookedColor = yellow800Color;
  static var bookedColor = purpleColor;
  static var pickedOrderColor = greenColor;
  static var postExReceivedColor = yellow800Color;
  static var deliveryEnRouteColor = greenColor;
  static var deliveryRescheduledColor = greenColor;
  static var deliveredColor = greenColor;
  static var returnColor = orangeColor;
  static var returnInTransitColor = orangeColor;
  static var cancelledColor = redColor;
  static var expiredColor = redColor;
  static var underVerificationColor = yellow800Color;
  static var attemptedColor = yellow800Color;
  static var returnRequestedColor = orangeColor;
  static var customerRefusedColor = orangeColor;
  static var dispatchedColor = yellow800Color;
  static var readyToDispatchColor = yellow600Color;
  static var riderAssignedToDeliverColor = greenColor;
  static var riderAssignedToReturnColor = orangeColor;
  static var readyToReturnBackColor = orangeColor;
  static var transferredColor = yellow800Color;
  static var returnToOriginColor = orangeColor;
  static var arrivedAtOriginColor = greenColor;
  static var arrivedAtDestinationColor = greenColor;
  static var transitHubColor = yellow600Color;
  static var returnRescheduledColor = orangeColor;
  static var lostColor = brownColor;
  static var misrouteColor = brownColor;
  static var retryColor = yellow800Color;
  static var elseDefaultColor = Colors.black87;

  static var bottomSheetBackgroundColor = Colors.white;
  static var bottomSheetLineColor = Colors.black54;
  static var bottomSheetTextColor = Colors.black;
  static var bottomSheetIconColor = Colors.black;
  static var bottomSheetBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(SizeConfig.safeBlockSizeHorizontal * 3),
    topRight: Radius.circular(SizeConfig.safeBlockSizeHorizontal * 3),
  );

  static var sheetStatusIdNewColor = Colors.yellow[800];
  static var sheetStatusIdPickedColor = Colors.purple;
  static var sheetStatusIdCompletedColor = Colors.green;
  static var sheetStatusIdCancelledColor = Colors.orange;
}
