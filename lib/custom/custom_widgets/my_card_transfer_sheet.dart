import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/views/sheet_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCardTransferSheet extends StatelessWidget {
  const MyCardTransferSheet(
      {this.needToHideCheckBox,
      this.isSelected,
      this.needToShowSelectionTick,
      this.onChangedCheckBox,
      required this.sheetDist,
      Key? key})
      : super(key: key);
  final SheetsDataDist sheetDist;

  final bool? needToHideCheckBox;
  final bool? needToShowSelectionTick;
  final bool? isSelected;
  final Function(bool?)? onChangedCheckBox;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myTextWidgetSheetType = MyTextWidgetCustom(
      text: sheetDist.sheetTag ?? '',
      color: Colors.brown,
    );

    var mySheetNumber = InkWell(
      onTap: () {
        Get.to(() =>
            SheetDetail(sheetId: sheetDist.sheetId!, sheetDist: sheetDist));
      },
      child: MyTextWidgetCustom(
        text: sheetDist.sheetNumber ?? '',
        color: MyColors.trackingNumberColor,
      ),
    );

    var mySheetTransactionStatus = MyTextWidgetCustom(
      text: sheetDist.sheetStatus ?? '',
      color: MyColors.sheetStatusIdNewColor,
    );
    var col = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: myTextWidgetSheetType),
            Padding(
                padding:
                    EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 2),
                child: mySheetTransactionStatus),
          ],
        ),
        const MySpaceHeight(heightSize: 1),
        Center(
          child: mySheetNumber,
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: SizeConfig.safeScreenWidth,
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockSizeHorizontal * 2,
            vertical: SizeConfig.safeBlockSizeVertical * 0.6),
        margin: EdgeInsets.only(bottom: SizeConfig.safeBlockSizeVertical * 0.6),
        decoration: BoxDecoration(
            color: isSelected == true ? Colors.white38 : Colors.white,
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.safeBlockSizeHorizontal * 2))),
        child: needToHideCheckBox == true
            ? col
            : Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: isSelected ?? false,
                      onChanged: onChangedCheckBox ?? (a) {},
                      title: col,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
