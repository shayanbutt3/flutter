import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/views/sheet_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class MyCardReturnSheet extends StatelessWidget {
  const MyCardReturnSheet({required this.dist, Key? key}) : super(key: key);
  final SheetsDataDist dist;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var sheetNumberColor = MyColors.trackingNumberColor;
    var row1 = MyTitleValueColumn(
        title: 'Rider', value: dist.riderName!, titleColor: Colors.black45);
    var col = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        MyTextWidgetCustom(
          text: dist.sheetStatus ?? '',
          color: MyColors.sheetStatusIdNewColor,
        )
      ],
    );
    var row2 = InkWell(
      onTap: () {
        Get.to(() => SheetDetail(sheetId: dist.sheetId!, sheetDist: dist));
      },
      child: MyTextWidgetCustom(
        text: dist.sheetNumber ?? '',
        color: sheetNumberColor,
        fontWeight: FontWeight.w500,
      ),
    );

    return Container(
      width: SizeConfig.safeScreenWidth,
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockSizeHorizontal * 2,
          vertical: SizeConfig.safeBlockSizeVertical * 0.6),
      margin: EdgeInsets.only(bottom: SizeConfig.safeBlockSizeVertical * 0.6),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.safeBlockSizeHorizontal * 2))),
      child: Column(
        children: [
          const MySpaceHeight(heightSize: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [row1, col],
          ),
          const MySpaceHeight(heightSize: 0.5),
          Center(
            child: row2,
          ),
          const MySpaceHeight(heightSize: 1)
        ],
      ),
    );
  }
}
