import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/rider_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card_sheets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RevertDeliverySheet extends StatefulWidget {
  const RevertDeliverySheet({Key? key}) : super(key: key);

  @override
  _RevertDeliverySheetState createState() => _RevertDeliverySheetState();
}

class _RevertDeliverySheetState extends State<RevertDeliverySheet> {
  final RiderController _riderController = Get.put(RiderController());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController sheetNumberController = TextEditingController();

  RevertSheetRequestData requestData = RevertSheetRequestData();

  ApiFetchData apiFetchData = ApiFetchData();

  String? selectedRider;
  RiderLookupDataDist? tmpR;

  List<SheetsDataDist> sheetsList = [];
  Pagination pagination = Pagination();

  bool isLoadingListView = false;
  bool hasMoreData = true;

  void loadData({
    bool? needToShowLoadingDialog,
    bool? needToMakeIsLoadingListViewTrue,
    bool? needToRemovePreviousData,
  }) {
    needToShowLoadingDialog == true ? myShowLoadingDialog(context) : null;
    needToMakeIsLoadingListViewTrue == true
        ? setState(() {
            isLoadingListView = true;
          })
        : null;

    apiFetchData
        .getSheets(
            tmpR == null ? '' : tmpR?.riderId,
            '',
            MyVariables.sheetTypeIdDelivery,
            MyVariables.sheetStatusIdNew,
            sheetNumberController.text.toString().trim(),
            fromDateController.text,
            toDateController.text,
            MyVariables.paginationEnable,
            pagination.page ?? 0,
            MyVariables.size,
            MyVariables.sortDirection)
        .then((value) {
      if (value != null) {
        if (mounted) {
          if (value.dist != null && value.dist!.isNotEmpty) {
            setState(() {
              if (needToRemovePreviousData == true) {
                sheetsList = [];
                sheetsList.addAll(value.dist!);
                pagination = value.pagination!;
                isLoadingListView = false;
              } else {
                sheetsList.addAll(value.dist!);
                pagination = value.pagination!;
                isLoadingListView = false;
              }
            });
          } else {
            myToastSuccess(MyVariables.notFoundErrorMSG);
          }
          Get.isDialogOpen! ? tryToPop(context) : null;
        }
      } else {}
    });
  }

  void removeDataLocally(SheetsDataDist dist) {
    setState(() {
      sheetsList.removeWhere((element) => element.sheetId == dist.sheetId);
      pagination.totalElements = pagination.totalElements! - 1;
    });
  }

  void reloadData() {
    setState(() {
      sheetsList = [];
      pagination = Pagination();
      hasMoreData = true;
    });
    loadData(
      needToShowLoadingDialog: true,
      needToRemovePreviousData: true,
    );
  }

  @override
  void initState() {
    super.initState();
    fromDateController.text = myFormatDateOnly(myGetDateTime().toString());
    toDateController.text = myFormatDateOnly(myGetDateTime().toString());
    WidgetsBinding.instance
        .addPostFrameCallback((_) => loadData(needToShowLoadingDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    const spaceBetweenRowItems = MySpaceWidth(widthSize: 2);
    const spaceBetweenColumnRows = MySpaceHeight(heightSize: 1);

    var appBar = PreferredSize(
      child: SafeArea(
        child: AppBar(
          backgroundColor: MyVariables.appBarBackgroundColor,
          title: const MyTextWidgetAppBarTitle(text: 'Revert Delivery Sheet'),
          flexibleSpace: const MyAppBarFlexibleContainer(),
          toolbarHeight: MyVariables.appbarHeight,
        ),
      ),
      preferredSize: MyVariables.preferredSizeAppBar,
    );

    var row1 = Row(
      children: [
        Expanded(
            child: MyTextFieldDatePicker(
                text: 'From Date',
                controller: fromDateController,
                iconButtonOnPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(fromDateController.text),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2050),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        fromDateController.text =
                            myFormatDateOnly(value.toString());
                      });
                    }
                  });
                })),
        spaceBetweenRowItems,
        Expanded(
            child: MyTextFieldDatePicker(
                text: 'To Date',
                controller: toDateController,
                iconButtonOnPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(toDateController.text),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2050),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        toDateController.text =
                            myFormatDateOnly(value.toString());
                      });
                    }
                  });
                })),
      ],
    );
    var row2 = Row(
      children: [
        Expanded(
          child: MyDropDownRider(
            selectedValue: selectedRider,
            isExpanded: true,
            onChanged: (newVal) {
              var data = _riderController.riderLookupList
                  .firstWhere((element) => element.riderName == newVal);
              setState(() {
                tmpR = data;
              });
            },
            listOfItems: _riderController.riderLookupList,
          ),
        ),
        spaceBetweenRowItems,
        Expanded(
          child: MyTextFieldCustom(
            controller: sheetNumberController,
            onChanged: (a) {
              setState(() {});
            },
            needToHideIcon: true,
            labelText: 'Sheet Number',
          ),
        ),
      ],
    );
    var row3 = Row(
      children: [
        Expanded(
            child: ShowOrdersCount(
          listLength: sheetsList.length,
          totalElements: pagination.totalElements,
        )),
        spaceBetweenRowItems,
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: MyElevatedButton(
              text: 'Search',
              btnBackgroundColor: MyColors.btnColorGreen,
              onPressed: () {
                FocusScope.of(context).unfocus();
                reloadData();
              },
            ),
          ),
        ),
      ],
    );

    var dataList = NotificationListener(
        onNotification: sheetsList.isEmpty
            ? null
            : (ScrollNotification scrollInfo) {
                var metrics = scrollInfo.metrics;
                var pixels = metrics.pixels;
                if (!isLoadingListView &&
                    pixels == metrics.maxScrollExtent &&
                    pixels != metrics.minScrollExtent) {
                  if (pagination.page! == pagination.totalPages) {
                    setState(() {
                      isLoadingListView = false;
                      hasMoreData = false;
                    });
                  } else {
                    pagination.page = pagination.page! + 1;
                    loadData(
                      needToMakeIsLoadingListViewTrue: true,
                    );
                  }
                  return true;
                }
                return false;
              },
        child: ListView.builder(
            itemCount: sheetsList.length,
            itemBuilder: ((context, index) {
              return myCardSheets(sheetsList[index]);
            })));
    return Scaffold(
      backgroundColor: MyColors.scaffoldBackgroundColor,
      appBar: appBar,
      body: Padding(
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            const MySpaceHeight(heightSize: 2),
            row1,
            spaceBetweenColumnRows,
            row2,
            spaceBetweenColumnRows,
            row3,
            spaceBetweenColumnRows,
            Expanded(
              child:
                  sheetsList.isEmpty ? const MyNoDataToShowWidget() : dataList,
            ),
            isLoadingListView == true
                ? const MyLoadingIndicator(
                    centerIt: true,
                  )
                : Container(),
            hasMoreData == false ? const MyNoMoreDataContainer() : Container(),
          ],
        ),
      ),
    );
  }

  Widget myCardSheets(SheetsDataDist dist) {
    return GestureDetector(
        onLongPress: () {
          myShowBottomSheet(context, [
            MyListTileBottomSheetMenuItem(
                titleTxt: 'Revert Delivery Sheet',
                icon: Icons.subdirectory_arrow_left,
                onTap: () {
                  requestData = RevertSheetRequestData(
                      sheetMasterIds: [dist.sheetId!],
                      sheetTypeId: dist.sheetTypeId!);
                  tryToPop(context);
                  Get.dialog(
                    RevertSheetConfirmationDialog(requestData: requestData),
                    useSafeArea: true,
                    barrierDismissible: false,
                  ).then((value) {
                    if (value == true) {
                      removeDataLocally(dist);
                    }
                  });
                }),
          ]);
        },
        child: MyCardSheets(dist: dist));
  }
}
