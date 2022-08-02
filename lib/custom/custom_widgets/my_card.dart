import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/views/order_detail.dart';

class MyCard extends StatelessWidget {
  const MyCard(
      {this.needToHideCheckBox,
      this.needToShowSelectionTick,
      required this.dist,
      this.isSelected,
      this.onChangedCheckBox,
      this.needToHideDeleteIcon,
      this.deleteOnPressed,
      this.needToShowOrderType,
      this.needToShowStockInFlag,
      this.needToShowRiderRemarks,
      // this.needToShowReturnRequestFlag,
      Key? key})
      : super(key: key);

  final bool? needToHideCheckBox;
  final bool? needToShowSelectionTick;
  final OrdersDataDist dist;
  final bool? isSelected;
  final Function(bool?)? onChangedCheckBox;
  final bool? needToHideDeleteIcon;
  final void Function()? deleteOnPressed;
  final bool? needToShowOrderType;
  final bool? needToShowStockInFlag;
  final bool? needToShowRiderRemarks;
  // final bool? needToShowReturnRequestFlag;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var tsTitle = TextStyle(
      color: Colors.black54,
      fontSize: SizeConfig.safeBlockSizeHorizontal * 2,
    );

    var tsBlackBold = TextStyle(
      color: Colors.black,
      fontSize: SizeConfig.safeBlockSizeHorizontal * 4,
      fontWeight: FontWeight.bold,
    );

    var tsMerchantName = TextStyle(
      color: Colors.black,
      fontSize: SizeConfig.safeBlockSizeHorizontal * 3,
      fontWeight: FontWeight.bold,
    );

    var tsRiderRemarks = TextStyle(
      color: Colors.black45,
      fontSize: SizeConfig.safeBlockSizeHorizontal * 3,
    );

    var tsTrackingNumber = TextStyle(
      color: MyColors.trackingNumberColor,
      fontSize: SizeConfig.safeBlockSizeHorizontal * 4,
    );

    var tsOrderType = TextStyle(
      color: Colors.black54,
      fontSize: SizeConfig.safeBlockSizeHorizontal * 3,
    );

    // var tsReturnRequest = TextStyle(
    //   color: Colors.redAccent,
    //   fontSize: SizeConfig.safeBlockSizeHorizontal * 3,
    // );

    var tsStatus = TextStyle(
      color: dist.transactionStatusId ==
              int.parse(MyVariables.orderStatusIdUnbooked)
          ? MyColors.unbookedColor
          : dist.transactionStatusId ==
                  int.parse(MyVariables.orderStatusIdBooked)
              ? MyColors.bookedColor
              : dist.transactionStatusId ==
                      int.parse(MyVariables.orderStatusIdPicked)
                  ? MyColors.pickedOrderColor
                  : dist.transactionStatusId ==
                          int.parse(MyVariables.orderStatusIdPostExReceived)
                      ? MyColors.postExReceivedColor
                      : dist.transactionStatusId ==
                              int.parse(
                                  MyVariables.orderStatusIdDeliveryEnroute)
                          ? MyColors.deliveryEnRouteColor
                          : dist.transactionStatusId ==
                                  int.parse(MyVariables
                                      .orderStatusIdDeliveryRescheduled)
                              ? MyColors.deliveryRescheduledColor
                              : dist.transactionStatusId ==
                                      int.parse(
                                          MyVariables.orderStatusIdDelivered)
                                  ? MyColors.deliveredColor
                                  : dist.transactionStatusId ==
                                          int.parse(
                                              MyVariables.orderStatusIdReturned)
                                      ? MyColors.returnColor
                                      : dist.transactionStatusId ==
                                              int.parse(MyVariables
                                                  .orderStatusIdReturnInTransit)
                                          ? MyColors.returnInTransitColor
                                          : dist.transactionStatusId ==
                                                  int.parse(MyVariables
                                                      .orderStatusIdCancelled)
                                              ? MyColors.cancelledColor
                                              : dist.transactionStatusId ==
                                                      int.parse(MyVariables
                                                          .orderStatusIdExpired)
                                                  ? MyColors.expiredColor
                                                  : dist.transactionStatusId ==
                                                          int.parse(MyVariables
                                                              .orderStatusIdUnderVerification)
                                                      ? MyColors
                                                          .underVerificationColor
                                                      : dist.transactionStatusId ==
                                                              int.parse(MyVariables.orderStatusIdAttempted)
                                                          ? MyColors.attemptedColor
                                                          : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdReturnRequested)
                                                              ? MyColors.returnRequestedColor
                                                              : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdCustomerRefused)
                                                                  ? MyColors.customerRefusedColor
                                                                  : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdDispatched)
                                                                      ? MyColors.dispatchedColor
                                                                      : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdReadyToDispatch)
                                                                          ? MyColors.readyToDispatchColor
                                                                          : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdRiderAssignedToDeliver)
                                                                              ? MyColors.riderAssignedToDeliverColor
                                                                              : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdRiderAssignedToReturn)
                                                                                  ? MyColors.riderAssignedToReturnColor
                                                                                  : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdReadyToReturnBack)
                                                                                      ? MyColors.readyToReturnBackColor
                                                                                      : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdReturnToOrigin)
                                                                                          ? MyColors.returnToOriginColor
                                                                                          : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdArrivedAtOrigin)
                                                                                              ? MyColors.arrivedAtOriginColor
                                                                                              : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdArrivedAtDestination)
                                                                                                  ? MyColors.arrivedAtDestinationColor
                                                                                                  : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdTransitHub)
                                                                                                      ? MyColors.transitHubColor
                                                                                                      : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdReturnRescheduled)
                                                                                                          ? MyColors.returnRescheduledColor
                                                                                                          : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdLost)
                                                                                                              ? MyColors.lostColor
                                                                                                              : dist.transactionStatusId == int.parse(MyVariables.orderStatusIdMisroute)
                                                                                                                  ? MyColors.misrouteColor
                                                                                                                  : MyColors.elseDefaultColor,
    );

    var tsPhysicalStatus = const TextStyle(
      color: Colors.green,
    );

    var firstColumn = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          'Ref#',
          style: tsTitle,
        ),
        MyTextWidgetNormal(text: dist.orderRefNumber ?? ''),
        const MySpaceHeight(heightSize: 0.5),
        FittedBox(
          child: MyTextWidgetNormal(
              text: myFormatDateOnly(dist.transactionDate ?? '')),
        ),
        const MySpaceHeight(heightSize: 0.5),
        AutoSizeText(
          'Merchant',
          style: tsTitle,
        ),
        AutoSizeText(
          dist.merchantName ?? '',
          // style: tsBlackBold,
          style: tsMerchantName,
        ),
        const MySpaceHeight(heightSize: 0.5),
        needToShowStockInFlag == true
            ? AutoSizeText(
                (dist.inStock == null
                    ? ''
                    : 'Stock In: ' + (dist.inStock == true ? 'Yes' : '-')),
                style: tsOrderType,
              )
            : Container(),
      ],
    );
    var secondColumn = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          dist.customerName ?? '',
          style: tsBlackBold,
        ),
        MyTextWidgetNormal(text: dist.customerPhone ?? ''),
        MyTextWidgetCustom(
          text: dist.deliveryAddress ?? '',
          maxLines: 3,
        ),
        const MySpaceHeight(heightSize: 1),
        dist.trackingNumber == null
            ? AutoSizeText(
                '',
                style: tsTrackingNumber,
              )
            : InkWell(
                onTap: () {
                  Get.to(() => OrderDetail(
                        trackingNumber: dist.trackingNumber!,
                      ));
                },
                child: AutoSizeText(
                  dist.trackingNumber.toString(),
                  style: tsTrackingNumber,
                ),
              ),
        const MySpaceHeight(heightSize: 1),
        needToShowRiderRemarks == true
            ? AutoSizeText(
                dist.riderRemarks ?? '',
                style: tsRiderRemarks,
              )
            : Container(),
        // const MySpaceHeight(heightSize: 0.5),
        // needToShowReturnRequestFlag == true && dist.returnRequested == true
        //     ? AutoSizeText(
        //         ('Return Request: ' +
        //             (dist.returnRequested == true ? 'Yes' : '-')),
        //         style: tsReturnRequest,
        //       )
        //     : Container(),
      ],
    );
    var thirdColumn = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          myAmountFormatter(dist.invoicePayment ?? ''),
          style: tsBlackBold,
          maxLines: 1,
        ),
        const MySpaceHeight(heightSize: 1),
        AutoSizeText(
          dist.transactionStatus ?? '',
          style: tsStatus,
          maxLines: 2,
        ),
        const MySpaceHeight(heightSize: 0.5),
        AutoSizeText(
          'Retry: ${dist.retryAttemptCount ?? ''}',
          style: tsTitle,
        ),
        const MySpaceHeight(heightSize: 0.5),
        AutoSizeText(
          // dist.merchantCityName ?? '',
          dist.cityName == null ? '' : dist.cityName!,
          style: tsBlackBold,
          maxLines: 1,
        ),
        needToShowOrderType == true
            ? const MySpaceHeight(heightSize: 0.5)
            : Container(),
        needToShowOrderType == true
            ? AutoSizeText(
                (dist.orderType == null ? '' : 'Type: ' + dist.orderType!),
                style: tsOrderType,
              )
            : Container(),
        needToHideDeleteIcon == true
            ? Container()
            : InkWell(
                onTap: deleteOnPressed,
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
        const MySpaceHeight(heightSize: 0.5),
        dist.transactionPhysicalStatus == null
            ? Container()
            : AutoSizeText(
                'Physical:',
                style: tsTitle,
                maxLines: 1,
              ),
        AutoSizeText(
          dist.transactionPhysicalStatus ?? '',
          style: tsPhysicalStatus,
          maxLines: 2,
        ),
      ],
    );

    var row = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: firstColumn,
        ),
        const MySpaceWidth(widthSize: 1),
        Expanded(
          flex: 4,
          child: secondColumn,
        ),
        const MySpaceWidth(widthSize: 1),
        Expanded(
          flex: 2,
          child: thirdColumn,
        ),
      ],
    );

    return Stack(
      children: [
        Container(
          width: SizeConfig.safeScreenWidth,
          // padding: EdgeInsets.all(SizeConfig.safeBlockSizeHorizontal * 3),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockSizeHorizontal * 2,
            vertical: SizeConfig.safeBlockSizeVertical * 0.6,
          ),
          margin:
              EdgeInsets.only(bottom: SizeConfig.safeBlockSizeVertical * 0.6),
          decoration: BoxDecoration(
              color:
                  // isSelected == null
                  //     ? Colors.white
                  // :
                  isSelected == true ? Colors.white38 : Colors.white,
              borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.safeBlockSizeHorizontal * 2))),
          child: needToHideCheckBox == true
              ? row
              : Row(
                  children: [
                    Expanded(
                        child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      // tileColor: Colors.amber,
                      // selectedTileColor: Colors.green,
                      // dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: isSelected ?? false,
                      onChanged: onChangedCheckBox ?? (a) {},
                      title: row,
                    )),
                  ],
                ),
        ),
        needToShowSelectionTick == true && isSelected == true
            ? const Positioned(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                top: 0,
                right: 0,
              )
            : Container(),
      ],
    );
  }
}
