import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/views/mu_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCardMU extends StatelessWidget {
  const MyCardMU(
      {required this.dist,
      this.needToHideCheckBox,
      this.isSelected,
      this.onChangedCheckBox,
      Key? key})
      : super(key: key);
  final MasterUnitDataDist dist;
  final bool? isSelected;
  final bool? needToHideCheckBox;
  final Function(bool?)? onChangedCheckBox;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var titleColor = Colors.black54;

    var col1 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTitleValueColumn(
          title: 'Master Unit Tag',
          value: dist.masterUnitTag ?? '',
          titleColor: titleColor,
          valueColor: Colors.brown,
        ),
        const MySpaceHeight(heightSize: 1),
        InkWell(
          onTap: () {
            Get.to(() =>
                MuDetails(masterUnitNumber: dist.masterUnitNumber, dist: dist));
          },
          child: MyTitleValueColumn(
            title: 'MU-Number',
            value: dist.masterUnitNumber ?? '',
            valueColor: MyColors.trackingNumberColor,
            titleColor: titleColor,
          ),
        ),
      ],
    );

    var col2 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTitleValueColumn(
          title: 'MU Status',
          value: dist.masterUnitStatus ?? '',
          titleColor: titleColor,
        ),
        const MySpaceHeight(heightSize: 1),
        MyTitleValueColumn(
          title: 'WareHouse Name',
          value: dist.wareHouseName ?? '',
          titleColor: titleColor,
          valueColor: Colors.black,
        ),
      ],
    );
    var row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [col1, col2],
    );
    return Container(
      width: SizeConfig.safeScreenWidth,
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockSizeHorizontal * 2,
          vertical: SizeConfig.safeBlockSizeVertical * 0.6),
      margin: EdgeInsets.only(bottom: SizeConfig.safeBlockSizeVertical * 0.6),
      decoration: BoxDecoration(
          color: isSelected == true ? Colors.white38 : Colors.white,
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.safeBlockSizeHorizontal * 2))),
      child: row,
    );
  }
}
