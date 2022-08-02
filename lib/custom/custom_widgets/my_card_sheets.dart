import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/views/sheet_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCardSheets extends StatelessWidget {
  const MyCardSheets({required this.dist, Key? key}) : super(key: key);

  final SheetsDataDist dist;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    const titleColor = Colors.black54;
    const spaceBetweenItems = MySpaceHeight(heightSize: 0.5);
    const columnCrossAxisAlignment = CrossAxisAlignment.start;

    var column = Column(
      crossAxisAlignment: columnCrossAxisAlignment,
      children: [
        MyTitleValueColumn(
          title: 'Rider',
          value: dist.riderName ?? '',
          titleColor: titleColor,
        ),
        spaceBetweenItems,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyTextWidgetCustom(
              text: 'Status',
              color: titleColor,
              sizeBlockHorizontalDigit: 3,
            ),
            const MySpaceHeight(heightSize: 0.3),
            MyTextWidgetCustom(
              text: dist.sheetStatus ?? '',
              color: dist.sheetStatus == MyVariables.sheetStatusNew
                  ? MyColors.sheetStatusIdNewColor
                  : dist.sheetStatus == MyVariables.sheetStatusPicked
                      ? MyColors.sheetStatusIdPickedColor
                      : dist.sheetStatus == MyVariables.sheetStatusCompleted
                          ? MyColors.sheetStatusIdCompletedColor
                          : dist.sheetStatus == MyVariables.sheetStatusCancelled
                              ? MyColors.sheetStatusIdCancelledColor
                              : Colors.black,
              sizeBlockHorizontalDigit: 4.5,
            ),
          ],
        ),
      ],
    );
    var column2 = Column(
      crossAxisAlignment: columnCrossAxisAlignment,
      children: [
        // MyTextWidgetCustom(
        //   text: dist.pickupAddress ?? '',
        //   color: Colors.red, //Tmp added red color
        // ),

        dist.stats?.delivered == null
            ? Container()
            : MyTitleValueRow(
                title: 'Invoice Amount',
                value: dist.stats!.totalAmount.toString(),
                titleColor: titleColor,
              ),
        spaceBetweenItems,

        dist.stats?.delivered == null
            ? Container()
            : MyTitleValueRow(
                title: 'Total Delivered',
                value: dist.stats!.delivered.toString(),
                titleColor: titleColor,
              ),
        spaceBetweenItems,
        dist.stats?.totalDeliveredAmount == null
            ? Container()
            : MyTitleValueRow(
                title: 'Received Amount',
                value: dist.stats!.totalDeliveredAmount.toString(),
                titleColor: titleColor,
              ),
        spaceBetweenItems,
        InkWell(
          onTap: () {
            Get.to(() => SheetDetail(
                  sheetId: dist.sheetId!,
                  sheetDist: dist,
                ));
          },
          child: MyTextWidgetCustom(
            text: dist.sheetNumber ?? '',
            color: MyColors.trackingNumberColor,
          ),
        ),
      ],
    );
    var column3 = Column(
      crossAxisAlignment: columnCrossAxisAlignment,
      children: [
        dist.stats?.totalOrder == null
            ? Container()
            : MyTitleValueRow(
                title: 'Total',
                value: dist.stats!.totalOrder.toString(),
                titleColor: titleColor,
              ),
        spaceBetweenItems,
        dist.stats?.picked == null
            ? Container()
            : MyTitleValueRow(
                title: 'Picked',
                value: dist.stats!.picked.toString(),
                titleColor: titleColor,
              ),
        spaceBetweenItems,
        dist.stats?.unpicked == null
            ? Container()
            : MyTitleValueRow(
                title: 'Unpicked',
                value: dist.stats!.unpicked.toString(),
                titleColor: titleColor,
              ),
      ],
    );

    return Container(
      width: SizeConfig.safeScreenWidth,
      // padding: EdgeInsets.all(SizeConfig.safeBlockSizeHorizontal * 3),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: column),
          // const MySpaceWidth(widthSize: 1.5),
          Expanded(flex: 3, child: column2),
          const MySpaceWidth(widthSize: 1.5),
          Expanded(flex: 2, child: column3),
        ],
      ),
    );
  }
}
