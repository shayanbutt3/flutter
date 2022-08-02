import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/merchant_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';

import '../../custom/custom_widgets/custom_dialogs.dart';

class MarkLost extends StatefulWidget {
  const MarkLost({Key? key}) : super(key: key);

  @override
  _MarkLostState createState() => _MarkLostState();
}

class _MarkLostState extends State<MarkLost> {
  ApiFetchData apiFetchData = ApiFetchData();
  Pagination pagination = Pagination();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  MerchantController merchantController = Get.put(MerchantController());

  List<OrdersDataDist> searchedOrdersList = [];
  List<int> selectedRecords = [];

  String? selectedMerchant;
  MerchantLookupDataDist? tmpM;
  late String currentDate;
  String orderTrackingNumber = '';
  bool isLoadingListView = false;
  bool hasMoreData = true;

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
        .getOrders(
            tmpM == null ? '' : tmpM!.merchantId,
            '',
            '',
            MyVariables.orderStatusIdsToMarkLost,
            '',
            '',
            fromDateController.text,
            toDateController.text,
            '',
            MyVariables.paginationEnable,
            pagination.page == null ? 0 : pagination.page!,
            MyVariables.size,
            MyVariables.sortDirection,
            settled: false)
        .then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            if (value.dist!.isNotEmpty) {
              if (needToRemovePreviousData == true) {
                searchedOrdersList = [];
                searchedOrdersList.addAll(value.dist!);
                pagination = value.pagination!;
              } else {
                searchedOrdersList.addAll(value.dist!);
                pagination = value.pagination!;
              }
            } else {
              myToastSuccess(MyVariables.notFoundErrorMSG);
            }
          });
          setState(() {
            isLoadingListView = false;
          });
          Get.isDialogOpen! ? tryToPop(context) : null;
        }
      }
    });
  }

  removeDataLocally(OrdersDataDist dist) {
    setState(() {
      searchedOrdersList.removeWhere(
          (element) => element.transactionId == dist.transactionId);
      pagination.totalElements = pagination.totalElements! - 1;
    });
  }

  myMarkLostDialogMethod(OrdersDataDist dist) {
    Get.dialog(
            MarkLostDialog(
              transactionIds: [dist.transactionId!],
            ),
            barrierDismissible: false)
        .then((value) {
      if (value == true) {
        setState(() {
          removeDataLocally(dist);
        });
      }
    });
  }

  reloadData() {
    setState(() {
      selectedRecords = [];
      searchedOrdersList = [];
      pagination.page = 0;
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
    var now = DateTime.now();
    currentDate = myFormatDateOnly(now.toString());
    fromDateController = TextEditingController(text: currentDate);
    toDateController = TextEditingController(text: currentDate);
  }

  Future scanQR() async {
    try {
      await FlutterBarcodeScanner.scanBarcode(
              'green', 'Cancel', true, ScanMode.QR)
          .then((value) {
        if (value != '-1' && value.isNotEmpty) {
          setState(() {
            var records = searchedOrdersList.firstWhere(
                (element) => element.trackingNumber == value.toString(),
                orElse: () => OrdersDataDist());
            if (records.trackingNumber != null) {
              var data = selectedRecords
                  .where((element) => element == records.transactionId);
              if (data.isNotEmpty) {
                setState(() {
                  myToastError("Already Selected");
                });
              } else {
                selectedRecords.add(records.transactionId!);
                myToastSuccess('Selected Successfully');
                myMarkLostDialogMethod(records);
                FlutterBeep.beep(false);
              }
            } else if (records.transactionId == null) {
              myToastError(MyVariables.scanningWrongOrderMSG);
            }
          });
        }
      });
    } catch (e) {
      myToastError('Exception: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var appBar = PreferredSize(
        child: SafeArea(
            child: AppBar(
          title: const MyTextWidgetAppBarTitle(text: 'Mark Lost'),
          elevation: 0,
          toolbarHeight: MyVariables.appbarHeight,
          backgroundColor: MyVariables.appBarBackgroundColor,
          actions: [
            IconButton(
              onPressed: () {
                scanQR();
              },
              icon: const Icon(Icons.qr_code_scanner),
              iconSize: SizeConfig.blockSizeHorizontal * 8,
            )
          ],
          flexibleSpace: const MyAppBarFlexibleContainer(),
        )),
        preferredSize: MyVariables.preferredSizeAppBar);

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
                      setState(() {
                        fromDateController.text =
                            myFormatDateOnly(value.toString());
                      });
                    }
                  },
                );
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
          )
        ],
      ),
    );

    var merchantDropDownAndSearchBtn = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
            child: MyDropDownMerchant(
                selectedValue: selectedMerchant,
                onChanged: (s) {
                  setState(
                    () {
                      selectedMerchant = s;
                      tmpM = merchantController.merchantLookupList.firstWhere(
                          (element) =>
                              element.merchantName == selectedMerchant);
                    },
                  );
                },
                listOfItems: merchantController.merchantLookupList),
          ),
          const MySpaceWidth(widthSize: 2),
          Expanded(
            child: Container(
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
                setState(
                  () {
                    if (pagination.page! == pagination.totalPages) {
                      isLoadingListView = false;
                      hasMoreData = false;
                    } else {
                      pagination.page = pagination.page! + 1;
                      loadData(needToMakeIsLoadingListViewTrue: true);
                    }
                  },
                );
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

    var showOrdersCount = ShowOrdersCount(
      listLength: searchedOrdersList.length,
      totalElements: pagination.totalElements,
      alignment: Alignment.centerRight,
    );

    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.scaffoldBackgroundColor,
      body: Padding(
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            const MySpaceHeight(heightSize: 1),
            dateDropDown,
            const MySpaceHeight(heightSize: 1),
            merchantDropDownAndSearchBtn,
            const MySpaceHeight(heightSize: 1),
            showOrdersCount,
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
            hasMoreData == false ? const MyNoMoreDataContainer() : Container()
          ],
        ),
      ),
    );
  }

  Widget myCard(OrdersDataDist dist) {
    return GestureDetector(
      onLongPress: () {
        myShowBottomSheet(
          context,
          [
            MyListTileBottomSheetMenuItem(
              titleTxt: 'Mark Lost',
              icon: Icons.local_library_outlined,
              onTap: () {
                tryToPopTrue(context);
                myMarkLostDialogMethod(dist);
              },
            ),
          ],
        );
      },
      child: MyCard(
        dist: dist,
        needToHideCheckBox: true,
        needToHideDeleteIcon: true,
        isSelected: selectedRecords.contains(dist.transactionId),
      ),
    );
  }
}
