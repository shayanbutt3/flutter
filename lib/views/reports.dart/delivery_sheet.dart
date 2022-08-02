import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/controllers/rider_controller.dart';
import 'package:backoffice_new/controllers/sheet_status_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card_sheets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:get/get.dart';

class DeliverySheetReport extends StatefulWidget {
  const DeliverySheetReport({Key? key}) : super(key: key);

  @override
  State<DeliverySheetReport> createState() => _DeliverySheetReportState();
}

class _DeliverySheetReportState extends State<DeliverySheetReport> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  late String currentDateString;

  ApiFetchData apiFetchData = ApiFetchData();

  final RiderController _riderController = Get.put(RiderController());
  final SheetStatusController _sheetStatusController =
      Get.put(SheetStatusController());

  List<SheetsDataDist> sheetsList = [];
  Pagination pagination = Pagination();

  bool isLoadingListView = false;
  bool hasMoreData = true;

  String? selectedRider;
  String? selectedSheetStatus;

  RiderLookupDataDist? tmpR;
  SheetStatusLookupDataDist? tmpSS;

  loadData({
    bool? needToShowLoadingDialog,
    bool? needToMakeIsLoadingListViewTrue,
    bool? needToRemovePreviousData,
  }) async {
    needToShowLoadingDialog == true ? myShowLoadingDialog(context) : null;
    needToMakeIsLoadingListViewTrue == true
        ? setState(() {
            isLoadingListView = true;
          })
        : null;
    apiFetchData
        .getSheets(
            selectedRider == null ? '' : tmpR?.riderId,
            '',
            MyVariables.sheetTypeIdDelivery,
            selectedSheetStatus == null
                ? MyVariables.sheetStatusIdsAll
                : tmpSS?.sheetStatusId,
            '',
            fromDateController.text.toString(),
            toDateController.text.toString(),
            MyVariables.paginationEnable,
            pagination.page == null ? 0 : pagination.page!,
            MyVariables.size,
            MyVariables.sortDirection)
        .then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            if (needToRemovePreviousData == true) {
              sheetsList = [];
              pagination = value.pagination!;
              sheetsList.addAll(value.dist!);
              isLoadingListView = false;
            } else {
              sheetsList.addAll(value.dist!);
              pagination = value.pagination!;
              isLoadingListView = false;
            }
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
    var now = DateTime.now();
    currentDateString = myFormatDateOnly(now.toString());

    fromDateController = TextEditingController(
      text: currentDateString,
    );
    toDateController = TextEditingController(
      text: currentDateString,
    );
    WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => loadData(needToShowLoadingDialog: true));

    // loadData();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final appBar = PreferredSize(
        child: SafeArea(
          child: AppBar(
            elevation: 0,
            backgroundColor: MyVariables.appBarBackgroundColor,
            iconTheme: MyVariables.appBarIconTheme,
            toolbarHeight: MyVariables.appbarHeight,
            title: const MyTextWidgetAppBarTitle(
              text: 'Delivery Sheet Report',
            ),
            flexibleSpace: const MyAppBarFlexibleContainer(),
          ),
        ),
        preferredSize: MyVariables.preferredSizeAppBar);

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
        child: sheetsList.isNotEmpty
            ? ListView.builder(
                itemCount: sheetsList.length,
                itemBuilder: (context, index) {
                  return MyCardSheets(
                    dist: sheetsList[index],
                  );
                })
            : Center(
                child: MyTextWidgetNormal(text: MyVariables.noDataToShowMSG),
              ));

    var myDropDownRider = MyDropDownRider(
      selectedValue: selectedRider,
      onChanged: (newValue) {
        setState(() {
          selectedRider = newValue.toString();
          tmpR = _riderController.riderLookupList
              .firstWhere((element) => element.riderName == selectedRider);
        });
      },
      listOfItems: _riderController.riderLookupList,
    );

    var myDropDownSheetStatus = MyDropDownSheetStatus(
      selectedValue: selectedSheetStatus,
      onChanged: (newValue) {
        setState(() {
          selectedSheetStatus = newValue.toString();
          tmpSS = _sheetStatusController.sheetStatusLookupList.firstWhere(
              (element) => element.sheetStatus == selectedSheetStatus);
        });
      },
      listOfItems: _sheetStatusController.sheetStatusLookupList =
          _sheetStatusController.sheetStatusLookupList
              .where((a) =>
                  a.sheetStatusId == int.parse(MyVariables.sheetStatusIdNew) ||
                  a.sheetStatusId ==
                      int.parse(MyVariables.sheetStatusIdCompleted) ||
                  a.sheetStatusId ==
                      int.parse(MyVariables.sheetStatusIdPicked) ||
                  a.sheetStatusId ==
                      int.parse(MyVariables.sheetStatusIdCancelled) ||
                  a.sheetStatusId ==
                      int.parse(MyVariables.sheetStatusIdDeliveryInProgress) ||
                  a.sheetStatusId ==
                      int.parse(MyVariables.sheetStatusIdPending) ||
                  a.sheetStatusId ==
                      int.parse(MyVariables.sheetStatusIdDispute) ||
                  a.sheetStatusId == int.parse(MyVariables.sheetStatusIdClose))
              .toList()
              .obs,
    );

    var containerDatePickers = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
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
                        initialDate: DateTime.parse(
                            fromDateController.text), //DateTime.now(),
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
                        initialDate: DateTime.parse(
                            toDateController.text), //DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2050))
                    .then((value) {
                  if (value != null) {
                    setState(() {
                      toDateController.text =
                          myFormatDateOnly(value.toString());
                    });
                  }
                });
              },
            ),
          ),
        ],
      ),
    );

    var containerDropdown = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
            child: myDropDownRider,
          ),
          const MySpaceWidth(widthSize: 2),
          Expanded(child: myDropDownSheetStatus),
        ],
      ),
    );

    var mySearchDataBtn = SizedBox(
      child: Row(
        children: [
          Expanded(
            child: ShowOrdersCount(
              listLength: sheetsList.length,
              totalElements: pagination.totalElements,
            ),
          ),
          const MySpaceWidth(widthSize: 2),
          Expanded(
              child: Container(
                  width: SizeConfig.safeScreenWidth,
                  alignment: Alignment.centerRight,
                  child: MyElevatedButton(
                    text: 'Search',
                    btnBackgroundColor: MyColors.btnColorGreen,
                    onPressed: () {
                      setState(() {
                        pagination = Pagination();
                        hasMoreData = true;
                      });
                      loadData(
                        needToShowLoadingDialog: true,
                        needToRemovePreviousData: true,
                      );
                    },
                  ))),
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffoldBackgroundColor,
      appBar: appBar,
      body: Container(
        width: SizeConfig.safeScreenWidth,
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            const MySpaceHeight(heightSize: 1),
            containerDatePickers,
            const MySpaceHeight(heightSize: 1),
            containerDropdown,
            const MySpaceHeight(heightSize: 1),
            mySearchDataBtn,
            const MySpaceHeight(heightSize: 1.5),
            Expanded(child: list),
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
}
