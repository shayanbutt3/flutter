import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SheetDetail extends StatefulWidget {
  const SheetDetail({
    required this.sheetId,
    required this.sheetDist,
    Key? key,
  }) : super(key: key);
  final int sheetId;
  final SheetsDataDist sheetDist;
  @override
  _SheetDetailState createState() => _SheetDetailState();
}

class _SheetDetailState extends State<SheetDetail> {
  ApiFetchData apiFetchData = ApiFetchData();
  List<SheetDetailDataDist> ordersList = [];
  Pagination pagination = Pagination();

  SheetsDataDist sheetDist = SheetsDataDist();

  loadData() async {
    myShowLoadingDialog(context);
    apiFetchData.getSheetDetailById(widget.sheetId).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            ordersList = [];
            ordersList.addAll(value.dist!);
            pagination = value.pagination!;
          });
          Get.isDialogOpen! ? tryToPop(context) : null;
        }
      } else {
        // Get.isDialogOpen! ? tryToPop(context) : null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    sheetDist = widget.sheetDist;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var hcTitleColor = Colors.black54;
    var spaceBetweenColumnItems = const MySpaceHeight(heightSize: 1);

    final _appBar = PreferredSize(
        preferredSize: MyVariables.preferredSizeAppBar,
        child: SafeArea(
          child: AppBar(
            toolbarHeight: MyVariables.appbarHeight,
            backgroundColor: MyVariables.appBarBackgroundColor,
            elevation: 0,
            title: const MyTextWidgetAppBarTitle(
              text: 'Sheet Detail',
            ),
            flexibleSpace: const MyAppBarFlexibleContainer(),
          ),
        ));

    var headerContainerDelivery = Container(
      width: SizeConfig.safeScreenWidth,
      padding: EdgeInsets.all(SizeConfig.safeBlockSizeHorizontal * 2),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.all(
            Radius.circular(SizeConfig.safeBlockSizeHorizontal * 2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTitleValueColumn(
                    titleColor: hcTitleColor,
                    title: 'Sheet Number',
                    value: sheetDist.sheetNumber ?? ''),
                spaceBetweenColumnItems,
                MyTitleValueColumn(
                  titleColor: hcTitleColor,
                  title: 'Total Delivered',
                  value: sheetDist.stats == null
                      ? ''
                      : sheetDist.stats!.delivered == null
                          ? ''
                          : sheetDist.stats!.delivered.toString(),
                ),
                spaceBetweenColumnItems,
                MyTitleValueColumn(
                    titleColor: hcTitleColor,
                    title: 'Total Received Amount',
                    value: sheetDist.stats == null
                        ? ''
                        : sheetDist.stats!.totalDeliveredAmount == null
                            ? ''
                            : sheetDist.stats!.totalDeliveredAmount.toString()),
              ],
            ),
          ),
          const MySpaceWidth(widthSize: 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTitleValueColumn(
                    titleColor: hcTitleColor,
                    title: 'Total Orders',
                    value: sheetDist.stats == null
                        ? ''
                        : sheetDist.stats!.totalOrder == null
                            ? ''
                            : sheetDist.stats!.totalOrder.toString()),
                spaceBetweenColumnItems,
                MyTitleValueColumn(
                  titleColor: hcTitleColor,
                  title: 'Total Invoice Amount',
                  value: sheetDist.stats == null
                      ? ''
                      : sheetDist.stats!.totalAmount == null
                          ? ''
                          : sheetDist.stats!.totalAmount.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final list = ListView.builder(
        itemCount: ordersList.length,
        itemBuilder: (context, index) {
          return MyCard(
            dist: ordersList[index].transaction!,
            needToHideCheckBox: true,
            needToHideDeleteIcon: true,
            needToShowOrderType: true,
          );
        });

    final myCounter = ShowOrdersCount(
      listLength: ordersList.length,
      totalElements: pagination.totalElements,
      alignment: Alignment.centerRight,
    );

    var headerContainerReturnAndTransfer = Container(
      width: SizeConfig.safeScreenWidth,
      padding: EdgeInsets.all(SizeConfig.safeBlockSizeHorizontal * 2),
      decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.safeBlockSizeHorizontal * 2))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyTitleValueColumn(
            title: 'Sheet Number',
            value: sheetDist.sheetNumber ?? '',
            titleColor: Colors.black45,
          ),
          ShowOrdersCount(
            totalElements: pagination.totalElements,
            listLength: ordersList.length,
          )
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffoldBackgroundColor,
      appBar: _appBar,
      body: Container(
        width: SizeConfig.safeScreenWidth,
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            const MySpaceHeight(heightSize: 1),
            sheetDist.sheetTypeId == int.parse(MyVariables.sheetTypeIdDelivery)
                ? headerContainerDelivery
                : headerContainerReturnAndTransfer,
            const MySpaceHeight(heightSize: 1),
            sheetDist.sheetTypeId == int.parse(MyVariables.sheetTypeIdDelivery)
                ? myCounter
                : Container(),
            const MySpaceHeight(heightSize: 1.5),
            Expanded(
                child:
                    ordersList.isEmpty ? const MyNoDataToShowWidget() : list),
          ],
        ),
      ),
    );
  }
}
