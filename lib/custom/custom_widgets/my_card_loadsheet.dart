import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:flutter/material.dart';

class MyCardLoadSheet extends StatelessWidget {
  const MyCardLoadSheet({required this.dist, Key? key}) : super(key: key);

  final LoadSheetDataDist dist;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    const titleColor = Colors.black54;
    const spaceBetweenItems = MySpaceHeight(heightSize: 0.5);
    const columnCrossAxisAlignment = CrossAxisAlignment.start;

    var column = Column(
      crossAxisAlignment: columnCrossAxisAlignment,
      children: [
        MyTextWidgetCustom(
          text: myFormatDateTime(dist.loadSheetDate!) ?? '',
          maxLines: 2,
        ),
      ],
    );
    var column2 = Column(
      crossAxisAlignment: columnCrossAxisAlignment,
      children: [
        MyTextWidgetCustom(
          text: dist.merchantName ?? '',
          fontWeight: FontWeight.w500,
        ),
        spaceBetweenItems,
        MyTextWidgetCustom(
          text: dist.pickupAddress ?? '',
          color: Colors.red, //Tmp added red color
        ),
        spaceBetweenItems,
        MyTextWidgetCustom(
          text: dist.loadSheetName ?? '',
          color: MyColors.trackingNumberColor,
        ),
      ],
    );
    var column3 = Column(
      crossAxisAlignment: columnCrossAxisAlignment,
      children: [
        MyTitleValueColumn(
          title: 'Booked Orders',
          value: dist.booked.toString(),
          titleColor: titleColor,
        ),
        spaceBetweenItems,
        MyTitleValueColumn(
          title: 'Rider',
          value: dist.riderName ?? '',
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
