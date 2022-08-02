import 'package:auto_size_text/auto_size_text.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';
import '../constants/size_config.dart';
import '../custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/views/order_detail.dart';
import 'package:backoffice_new/views/sheet_detail.dart';
import 'package:get/get.dart';

class MyCardMisRoute extends StatefulWidget {
  const MyCardMisRoute({required this.dist, Key? key}) : super(key: key);

  final SheetDetailDataDist dist;

  @override
  _MyCardMisRouteState createState() => _MyCardMisRouteState();
}

class _MyCardMisRouteState extends State<MyCardMisRoute> {
  ApiFetchData apiFetchData = ApiFetchData();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var tsTitle = TextStyle(
      color: Colors.black45,
      fontSize: SizeConfig.blockSizeHorizontal * 0.2,
    );

    var tsMerchantName = TextStyle(
        color: Colors.black,
        fontSize: SizeConfig.blockSizeHorizontal * 3,
        fontWeight: FontWeight.bold);

    var tsTrackingNumber = TextStyle(
        color: MyColors.trackingNumberColor,
        fontSize: SizeConfig.blockSizeHorizontal * 4);

    var firstColumn = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          'Ref#',
          style: tsTitle,
        ),
        MyTextWidgetNormal(text: widget.dist.transaction!.orderRefNumber ?? ''),
        const MySpaceHeight(heightSize: 0.5),
        AutoSizeText(
          'Date',
          style: tsTitle,
        ),
        FittedBox(
          child: MyTextWidgetNormal(
              text: myFormatDateOnly(
                  widget.dist.transaction!.transactionDate ?? '')),
        ),
        const MySpaceHeight(heightSize: 0.5),
        AutoSizeText(
          'Merchant Name',
          style: tsTitle,
        ),
        const MySpaceHeight(heightSize: 0.5),
        AutoSizeText(
          widget.dist.transaction!.merchantName ?? '',
          style: tsMerchantName,
        ),
      ],
    );

    var secondColumn = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          'Tracking Number',
          style: tsTitle,
        ),
        InkWell(
          onTap: () {
            Get.to(() => OrderDetail(
                trackingNumber: widget.dist.transaction!.trackingNumber ?? ''));
          },
          child: AutoSizeText(
            widget.dist.transaction!.trackingNumber ?? ''.toString(),
            style: tsTrackingNumber,
          ),
        ),
        const MySpaceHeight(heightSize: 0.5),
        AutoSizeText(
          'Transfer Sheet Number',
          style: tsTitle,
        ),
        InkWell(
          onTap: () {
            Get.to(() => SheetDetail(
                  sheetId: widget.dist.sheetId!,
                  sheetDist: SheetsDataDist(
                    sheetNumber: widget.dist.sheetNumber,
                    sheetId: widget.dist.sheetId,
                  ),
                ));
          },
          child: AutoSizeText(
            widget.dist.sheetNumber ?? '',
            style: tsTrackingNumber,
          ),
        ),
        const MySpaceHeight(heightSize: 0.5),
        AutoSizeText(
          'Status',
          style: tsTitle,
        ),
        MyTextWidgetNormal(
            text: widget.dist.transaction!.transactionStatus ?? ''),
      ],
    );

    var thirdColumn = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          'Amount',
          style: tsTitle,
        ),
        MyTextWidgetNormal(text: widget.dist.transaction!.invoicePayment ?? ''),
        const MySpaceHeight(heightSize: 0.5),
        AutoSizeText(
          'Origin City',
          style: tsTitle,
        ),
        MyTextWidgetNormal(text: widget.dist.transaction!.originCity ?? ''),
        const MySpaceHeight(heightSize: 0.8),
        AutoSizeText(
          'Destination City',
          style: tsTitle,
        ),
        MyTextWidgetNormal(text: widget.dist.transaction!.cityName ?? ''),
      ],
    );
    return Container(
        width: SizeConfig.safeScreenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockSizeHorizontal * 2,
          vertical: SizeConfig.safeBlockSizeVertical * 0.6,
        ),
        margin: EdgeInsets.only(bottom: SizeConfig.safeBlockSizeVertical * 0.6),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.safeBlockSizeHorizontal * 2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: firstColumn),
            const MySpaceWidth(widthSize: 2),
            Expanded(flex: 4, child: secondColumn),
            Expanded(flex: 2, child: thirdColumn)
          ],
        ));
  }
}
