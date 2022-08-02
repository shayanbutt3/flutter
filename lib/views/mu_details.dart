import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/variables/my_variables.dart';
import '../custom/custom_widgets/custom_text_and_text_fields.dart';

class MuDetails extends StatefulWidget {
  const MuDetails(
      {required this.masterUnitNumber, required this.dist, Key? key})
      : super(key: key);

  final String? masterUnitNumber;
  final MasterUnitDataDist dist;

  @override
  _MuDetailsState createState() => _MuDetailsState();
}

class _MuDetailsState extends State<MuDetails> {
  ApiFetchData apiFetchData = ApiFetchData();
  List<MasterUnitDetailDataDist> muList = [];

  loadData() {
    myShowLoadingDialog(context);
    apiFetchData
        .getMasterUnitDetailData(
            masterUnitNumber: widget.masterUnitNumber.toString())
        .then((value) {
      if (value != null) {
        if (mounted) {
          if (value.dist!.isNotEmpty) {
            setState(() {
              muList.addAll(value.dist!);
            });
          }
        }
      }
      Get.isDialogOpen! ? tryToPop(context) : null;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var appBar = PreferredSize(
        child: SafeArea(
            child: AppBar(
          elevation: 0,
          title: const MyTextWidgetAppBarTitle(text: 'Master Unit Details'),
          toolbarHeight: MyVariables.appbarHeight,
          backgroundColor: MyVariables.appBarBackgroundColor,
          flexibleSpace: const MyAppBarFlexibleContainer(),
        )),
        preferredSize: MyVariables.preferredSizeAppBar);

    var list = ListView.builder(
        itemCount: muList.length,
        itemBuilder: ((context, index) {
          return MyCard(
            dist: muList[index].transaction!,
            needToHideCheckBox: true,
            needToHideDeleteIcon: true,
          );
        }));

    return Scaffold(
      backgroundColor: MyColors.scaffoldBackgroundColor,
      appBar: appBar,
      body: SizedBox(
        width: SizeConfig.safeScreenWidth,
        child: Column(
          children: [
            const MySpaceHeight(heightSize: 1),
            ShowOrdersCount(
              listLength: muList.length,
              alignment: Alignment.centerRight,
            ),
            const MySpaceHeight(heightSize: 1),
            Expanded(child: list)
          ],
        ),
      ),
    );
  }
}
