import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/rider_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card_return_sheet.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class RevertReturnSheet extends StatefulWidget {
  const RevertReturnSheet({Key? key}) : super(key: key);

  @override
  _RevertReturnSheetState createState() => _RevertReturnSheetState();
}

class _RevertReturnSheetState extends State<RevertReturnSheet> {
  ApiFetchData apiFetchData = ApiFetchData();

  RiderController riderController = Get.put(RiderController());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController sheetNumberController = TextEditingController();

  RevertSheetRequestData requestData = RevertSheetRequestData();

  RiderLookupDataDist? tmpR;
  String? selectedRider;

  List<SheetsDataDist> sheetsList = [];
  Pagination pagination = Pagination();

  late String currentDateString;
  bool isLoadingListView = false;
  bool hasMoreData = true;

  loadData(
      {bool? needToShowLoadingDialog,
      bool? needToMakeIsLoadingListViewTrue,
      bool? needToRemovePreviousData}) async {
    needToShowLoadingDialog == true ? myShowLoadingDialog(context) : null;
    needToMakeIsLoadingListViewTrue == true
        ? setState(() {
            isLoadingListView = true;
          })
        : null;
    apiFetchData
        .getSheets(
            tmpR == null ? '' : tmpR!.riderId,
            '',
            MyVariables.sheetTypeIdReturn,
            MyVariables.sheetStatusIdNew,
            sheetNumberController.text,
            fromDateController.text,
            toDateController.text,
            MyVariables.paginationEnable,
            pagination.page == null ? 0 : pagination.page!,
            MyVariables.size,
            MyVariables.sortDirection)
        .then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            if (value.dist!.isNotEmpty) {
              if (needToRemovePreviousData == true) {
                sheetsList = [];
                sheetsList.addAll(value.dist!);
                pagination = value.pagination!;
              } else {
                sheetsList.addAll(value.dist!);
                pagination = value.pagination!;
              }
            } else {
              myToastSuccess(MyVariables.notFoundErrorMSG);
            }
          });
          setState(() {
            isLoadingListView = false;
          });
        }
        Get.isDialogOpen! ? tryToPop(context) : null;
      }
    });
  }

  void removeDataLocally(SheetsDataDist dist) {
    setState(() {
      sheetsList.removeWhere((element) => element.sheetId == dist.sheetId);
      pagination.totalElements = pagination.totalElements! - 1;
    });
  }

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    currentDateString = myFormatDateOnly(now.toString());
    fromDateController = TextEditingController(text: currentDateString);
    toDateController = TextEditingController(text: currentDateString);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      loadData(needToShowLoadingDialog: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var spaceBetweenFieldsInColumn = const MySpaceHeight(heightSize: 1);

    var myAppBar = AppBar(
      flexibleSpace: const MyAppBarFlexibleContainer(),
      backgroundColor: MyVariables.appBarBackgroundColor,
      title: const MyTextWidgetAppBarTitle(
        text: 'Revert Return Sheet',
      ),
      iconTheme: MyVariables.appBarIconTheme,
      toolbarHeight: MyVariables.appbarHeight,
    );

    var row1 = Row(
      children: [
        Expanded(
          child: MyTextFieldDatePicker(
            text: 'From Date',
            controller: fromDateController,
            onChanged: (s) {
              setState(() {});
            },
            iconButtonOnPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(fromDateController.text),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2050))
                  .then((value) {
                if (value != null) {
                  setState(() {
                    fromDateController.text =
                        myFormatDateOnly(value.toString());
                  });
                }
              });
            },
          ),
        ),
        const MySpaceWidth(widthSize: 2),
        Expanded(
          child: MyTextFieldDatePicker(
            text: 'To Date',
            controller: toDateController,
            onChanged: (s) {
              setState(() {});
            },
            iconButtonOnPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(toDateController.text),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2050))
                  .then((value) {
                if (value != null) {
                  setState(() {
                    toDateController.text = myFormatDateOnly(value.toString());
                  });
                }
              });
            },
          ),
        ),
      ],
    );
    var row2 = Row(
      children: [
        Expanded(
          child: MyDropDownRider(
            selectedValue: selectedRider,
            onChanged: (newValue) {
              setState(() {
                selectedRider = newValue.toString();
                tmpR = riderController.riderLookupList.firstWhere(
                    (element) => element.riderName == selectedRider);
              });
            },
            listOfItems: riderController.riderLookupList,
          ),
        ),
        const MySpaceWidth(widthSize: 2),
        Expanded(
          child: MyTextFieldCustom(
            controller: sheetNumberController,
            needToHideIcon: true,
            hintText: 'Sheet Number',
            labelText: 'Sheet Number',
            onChanged: (a) {
              setState(() {});
            },
          ),
        )
      ],
    );

    var row3 = Row(
      children: [
        Expanded(
          child: ShowOrdersCount(
            listLength: sheetsList.length,
            totalElements: pagination.totalElements,
          ),
        ),
        MyElevatedButton(
          text: 'Search',
          btnBackgroundColor: MyColors.btnColorGreen,
          onPressed: () {
            FocusManager.instance.primaryFocus!.unfocus();
            sheetsList = [];
            pagination = Pagination();
            setState(() {
              hasMoreData = true;
              loadData(
                  needToShowLoadingDialog: true,
                  needToRemovePreviousData: true);
            });
          },
        )
      ],
    );
    var list = NotificationListener(
      onNotification: sheetsList.isEmpty
          ? null
          : (ScrollNotification scrollInfo) {
              var metrics = scrollInfo.metrics;
              var pixels = metrics.pixels;
              if (!isLoadingListView &&
                  pixels == metrics.maxScrollExtent &&
                  pixels != metrics.minScrollExtent) {
                setState(() {
                  if (pagination.page! == pagination.totalPages!) {
                    isLoadingListView = false;
                    hasMoreData = false;
                  } else {
                    pagination.page = pagination.page! + 1;
                    loadData(needToMakeIsLoadingListViewTrue: true);
                  }
                });
                return true;
              }
              return false;
            },
      child: ListView.builder(
          itemCount: sheetsList.length,
          itemBuilder: (BuildContext context, index) {
            return myCard(sheetsList[index]);
          }),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.scaffoldBackgroundColor,
        appBar: myAppBar,
        body: Container(
          width: SizeConfig.safeScreenWidth,
          padding: MyVariables.scaffoldBodyPadding,
          child: Column(
            children: [
              spaceBetweenFieldsInColumn,
              row1,
              spaceBetweenFieldsInColumn,
              row2,
              spaceBetweenFieldsInColumn,
              row3,
              spaceBetweenFieldsInColumn,
              Expanded(
                  child:
                      sheetsList.isEmpty ? const MyNoDataToShowWidget() : list),
              isLoadingListView == true
                  ? const MyLoadingIndicator(
                      centerIt: true,
                    )
                  : Container(),
              hasMoreData == false ? const MyNoMoreDataContainer() : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget myCard(SheetsDataDist dist) {
    return GestureDetector(
        onLongPress: () {
          myShowBottomSheet(context, [
            MyListTileBottomSheetMenuItem(
                titleTxt: 'Revert Return Sheet',
                icon: Icons.subdirectory_arrow_left,
                onTap: () {
                  requestData = RevertSheetRequestData(
                    sheetMasterIds: [dist.sheetId!],
                    sheetTypeId: dist.sheetTypeId,
                  );
                  tryToPop(context);
                  Get.dialog(
                    RevertSheetConfirmationDialog(requestData: requestData),
                    barrierDismissible: false,
                  ).then((value) {
                    if (value == true) {
                      removeDataLocally(dist);
                    }
                  });
                }),
          ]);
        },
        child: MyCardReturnSheet(
          dist: dist,
        ));
  }
}
