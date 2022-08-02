import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/merchant_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/views/my_cards_misroute.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';

class MarkMisroute extends StatefulWidget {
  const MarkMisroute({Key? key}) : super(key: key);

  @override
  _MarkMisrouteState createState() => _MarkMisrouteState();
}

class _MarkMisrouteState extends State<MarkMisroute> {
  ApiFetchData apiFetchData = ApiFetchData();
  Pagination pagination = Pagination();

  TextEditingController trackingNumberController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  MerchantController merchantController = Get.put(MerchantController());
  List<SheetDetailDataDist> searchedOrdersList = [];

  String? selectedMerchant;
  MerchantLookupDataDist? tmpM;
  late String? currentDate;

  bool isLoadingListView = false;
  bool hasMoreData = true;

  loadData(
      {bool? needToShowLoadingDialog,
      bool? needToMakeIsLoadingListViewTrue,
      bool? needToRemovePreviousData}) {
    needToShowLoadingDialog == true ? myShowLoadingDialog(context) : null;
    needToMakeIsLoadingListViewTrue == true
        ? setState(
            () {
              isLoadingListView = true;
            },
          )
        : null;
    apiFetchData
        .getSheetDetail(
            '',
            MyVariables.ordersStatusIdsToMarkMisroute,
            trackingNumberController.text,
            '',
            '',
            '',
            fromDateController.text,
            toDateController.text,
            MyVariables.paginationEnable,
            pagination.page == null ? 0 : pagination.page!,
            MyVariables.size,
            MyVariables.sortDirection,
            merchantId: tmpM == null ? '' : tmpM!.merchantId)
        .then((value) {
      if (value != null) {
        if (mounted) {
          if (value.dist!.isNotEmpty) {
            setState(() {
              if (needToRemovePreviousData == true) {
                searchedOrdersList = [];
                searchedOrdersList.addAll(value.dist!);
                pagination = value.pagination!;
              } else {
                searchedOrdersList.addAll(value.dist!);
                pagination = value.pagination!;
              }
            });
          } else {
            myToastSuccess(MyVariables.notFoundErrorMSG);
          }
        }
        setState(() {
          isLoadingListView = false;
        });
      }
      Get.isDialogOpen! ? tryToPop(context) : null;
    });
  }

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    currentDate = myFormatDateOnly(now.toString());
    fromDateController = TextEditingController(text: currentDate);
    toDateController = TextEditingController(text: currentDate);
  }

  Future scanQr() async {
    try {
      await FlutterBarcodeScanner.scanBarcode(
              'green', 'Cancel', true, ScanMode.QR)
          .then((value) {
        if (value != '-1' && value.isNotEmpty) {
          setState(() {
            searchedOrdersList = [];
            pagination.totalElements = 0;
            trackingNumberController.text = value.trim().toString();
            FlutterBeep.beep(false);
          });
          loadData(
            needToShowLoadingDialog: true,
          );
        }
      });
    } catch (e) {
      myToastError('Exception $e');
      rethrow;
    }
  }

  removeDataLocally(SheetDetailDataDist sheetDist) {
    setState(() {
      searchedOrdersList.removeWhere((element) =>
          element.transaction!.transactionId ==
          sheetDist.transaction!.transactionId);
      pagination.totalElements = pagination.totalElements! - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var appBar = PreferredSize(
        child: SafeArea(
            child: AppBar(
          title: const MyTextWidgetAppBarTitle(text: 'Mark Misroute'),
          backgroundColor: MyVariables.appBarBackgroundColor,
          toolbarHeight: MyVariables.appbarHeight,
          iconTheme: MyVariables.appBarIconTheme,
          flexibleSpace: const MyAppBarFlexibleContainer(),
          actions: [
            IconButton(
              onPressed: () {
                scanQr();
              },
              icon: Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: SizeConfig.blockSizeHorizontal * 8,
              ),
            )
          ],
        )),
        preferredSize: MyVariables.preferredSizeAppBar);

    var merchantAndTrackingNumberField = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
            child: MyDropDownMerchant(
                selectedValue: selectedMerchant,
                onChanged: (s) {
                  setState(() {
                    selectedMerchant = s.toString();
                    tmpM = merchantController.merchantLookupList.firstWhere(
                        (element) => element.merchantName == selectedMerchant);
                  });
                },
                listOfItems: merchantController.merchantLookupList),
          ),
          const MySpaceWidth(widthSize: 2),
          Expanded(
            child: MyTextFieldCustom(
              needToHideIcon: true,
              controller: trackingNumberController,
              labelText: 'Tracking Number',
              onChanged: (s) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );

    var dateDropDown = SizedBox(
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
                        initialDate: DateTime.parse(fromDateController.text),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2050))
                    .then(
                  (value) {
                    if (value != null) {
                      setState(
                        () {
                          fromDateController.text =
                              myFormatDateOnly(value.toString());
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
          const MySpaceWidth(widthSize: 2),
          Expanded(
            child: MyTextFieldDatePicker(
              text: 'To Date ',
              controller: toDateController,
              iconButtonOnPressed: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.parse(fromDateController.text),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2050))
                    .then(
                  (value) {
                    if (value != null) {
                      setState(
                        () {
                          toDateController.text =
                              myFormatDateOnly(value.toString());
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );

    var searchBtn = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
              child: ShowOrdersCount(
            listLength: searchedOrdersList.length,
            totalElements: pagination.totalElements,
          )),
          const MySpaceWidth(widthSize: 0.5),
          MyElevatedButton(
            text: 'Search',
            btnBackgroundColor: MyColors.btnColorGreen,
            onPressed: () {
              FocusScope.of(context).unfocus();
              setState(() {
                pagination.page = 0;
                hasMoreData = true;
              });
              loadData(
                  needToShowLoadingDialog: true,
                  needToRemovePreviousData: true);
            },
          )
        ],
      ),
    );

    var searchedOrdersDataList = NotificationListener(
      onNotification: searchedOrdersList.isEmpty
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
              }
              return true;
            },
      child: ListView.builder(
        itemCount: searchedOrdersList.length,
        itemBuilder: (BuildContext context, index) {
          return myCard(searchedOrdersList[index]);
        },
      ),
    );

    return Scaffold(
      backgroundColor: MyColors.scaffoldBackgroundColor,
      appBar: appBar,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            const MySpaceHeight(heightSize: 1),
            dateDropDown,
            const MySpaceHeight(heightSize: 1),
            merchantAndTrackingNumberField,
            const MySpaceHeight(heightSize: 1),
            searchBtn,
            const MySpaceHeight(heightSize: 1),
            Expanded(
                child: searchedOrdersList.isEmpty
                    ? const MyNoDataToShowWidget()
                    : searchedOrdersDataList),
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

  Widget myCard(SheetDetailDataDist sheetDist) {
    return GestureDetector(
      onLongPress: (() {
        myShowBottomSheet(
          context,
          [
            MyListTileBottomSheetMenuItem(
              titleTxt: 'Mark Misroute',
              icon: Icons.route,
              onTap: () {
                tryToPop(context);
                Get.dialog(
                  MyMarkMisrouteDialog(
                    transactionIds: [sheetDist.transaction!.transactionId!],
                  ),
                  barrierDismissible: false,
                ).then(
                  (value) {
                    if (value == true) {
                      setState(() {
                        removeDataLocally(sheetDist);
                      });
                    }
                  },
                );
              },
            )
          ],
        );
      }),
      child: MyCardMisRoute(dist: sheetDist),
    );
  }
}
