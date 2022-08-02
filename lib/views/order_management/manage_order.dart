import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/merchant_controller.dart';
import 'package:backoffice_new/controllers/order_status_controller.dart';
import 'package:backoffice_new/controllers/rider_controller.dart';
import 'package:backoffice_new/controllers/warehouse_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/views/order_detail.dart';
import 'package:backoffice_new/views/order_management/view_remarks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';

class ManageOrder extends StatefulWidget {
  const ManageOrder({Key? key}) : super(key: key);
  @override
  _ManageOrderState createState() => _ManageOrderState();
}

class _ManageOrderState extends State<ManageOrder> {
  ApiFetchData apiFetchData = ApiFetchData();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController trackingNumberController = TextEditingController();

  RiderController riderController = Get.put(RiderController());
  MerchantController merchantController = Get.put(MerchantController());
  WareHouseController wareHouseController = Get.put(WareHouseController());
  OrderStatusController orderStatusController =
      Get.put(OrderStatusController());

  String? selectedRider;
  String? selectedMerchant;
  String? selectedWareHouse;
  String? selectedStatus;
  String? selectedDateFilter;

  RiderLookupDataDist? tmpR;
  MerchantLookupDataDist? tmpM;
  WareHouseDataDist? tmpW;
  OrderStatusLookupDataDist? tmpS;

  List<OrdersDataDist> ordersList = [];
  Pagination pagination = Pagination();

  bool isLoadingListView = false;
  bool hasMoreData = true;

  void loadData({
    bool? needToShowLoadingDialog,
    bool? needToMakeIsLoadingListViewTrue,
    bool? needToRemovePreviousData,
  }) {
    needToShowLoadingDialog == true ? myShowLoadingDialog(context) : null;
    if (needToMakeIsLoadingListViewTrue == true) {
      setState(() {
        isLoadingListView = true;
      });
    }
    apiFetchData
        .getOrders(
            tmpM == null ? '' : tmpM!.merchantId,
            tmpR == null ? '' : tmpR!.riderId,
            '',
            tmpS == null ? '' : tmpS!.transactionStatusId,
            tmpW == null ? '' : tmpW!.wareHouseId,
            trackingNumberController.text,
            fromDateController.text,
            toDateController.text,
            '',
            MyVariables.paginationEnable,
            pagination.page == null ? 0 : pagination.page!,
            MyVariables.size,
            MyVariables.sortDirection,
            filterDateType: selectedDateFilter)
        .then((value) {
      if (value != null) {
        if (mounted) {
          Get.isDialogOpen == true ? Get.back() : null;
          if (value.dist!.isNotEmpty) {
            if (needToRemovePreviousData == true) {
              setState(() {
                ordersList = [];
                ordersList.addAll(value.dist!);
                pagination = value.pagination!;
              });
            } else {
              setState(() {
                ordersList.addAll(value.dist!);
                pagination = value.pagination!;
              });
            }
          } else {
            if (pagination.page != null && pagination.page! > 0) {
            } else {
              setState(() {
                ordersList = [];
                pagination = Pagination();
              });
            }
            myToastSuccess(MyVariables.notFoundErrorMSG);
          }
          setState(() {
            isLoadingListView = false;
          });
        }
      }
    });
  }

  void reloadData() {
    setState(() {
      ordersList = [];
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
    fromDateController = TextEditingController(
        text: myFormatDateOnly(myGetDateTime().toString()));
    toDateController = TextEditingController(
        text: myFormatDateOnly(myGetDateTime().toString()));
    selectedDateFilter = MyVariables.dateFilterList[0];
  }

  @override
  void dispose() {
    super.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    riderController.dispose();
    merchantController.dispose();
    wareHouseController.dispose();
    orderStatusController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    const spaceBetweenBodyItemsRow = MySpaceHeight(heightSize: 1);
    var appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBar,
      child: SafeArea(
        child: AppBar(
          elevation: 0,
          backgroundColor: MyVariables.appBarBackgroundColor,
          toolbarHeight: MyVariables.appbarHeight,
          title: const MyTextWidgetAppBarTitle(text: 'Manage Order'),
          flexibleSpace: const MyAppBarFlexibleContainer(),
          actions: [
            IconButton(
              icon: Icon(
                Icons.qr_code_scanner,
                size: SizeConfig.safeBlockSizeHorizontal * 8,
              ),
              onPressed: _scanQR,
            ),
          ],
        ),
      ),
    );

    var row1 = SizedBox(
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

    var myDropDownRider = MyDropDownRider(
      selectedValue: selectedRider,
      onChanged: (newValue) {
        setState(() {
          selectedRider = newValue.toString();
          tmpR = riderController.riderLookupList
              .firstWhere((element) => element.riderName == selectedRider);
        });
      },
      listOfItems: riderController.riderLookupList,
    );

    var myDropDownMerchant = MyDropDownMerchant(
      selectedValue: selectedMerchant,
      onChanged: (val) {
        setState(() {
          selectedMerchant = val.toString();
          tmpM = merchantController.merchantLookupList.firstWhere(
              (element) => element.merchantName == selectedMerchant);
        });
      },
      listOfItems: merchantController.merchantLookupList,
    );

    var myDropDownWarehouse = MyDropDownWareHouse(
        selectedValue: selectedWareHouse,
        onChanged: (val) {
          if (val == MyVariables.wareHouseDropdownSelectAllText) {
            setState(() {
              selectedWareHouse = val.toString();
              tmpW = null;
            });
          } else {
            setState(() {
              selectedWareHouse = val.toString();
              tmpW = wareHouseController.wareHouseLookupList
                  .firstWhere((element) => element.wareHouseName == val);
            });
          }
        },
        listOfItems: wareHouseController.wareHouseLookupList);

    var row2 = Row(
      children: [
        Expanded(child: myDropDownMerchant),
        const MySpaceWidth(widthSize: 2),
        Expanded(child: myDropDownRider),
      ],
    );

    var myDropDownOrderStatus = MyDropDownOrderStatus(
        selectedValue: selectedStatus,
        onChanged: (a) {
          setState(() {
            selectedStatus = a.toString();
            tmpS = orderStatusController.orderStatusLookupList
                .firstWhere((element) => element.transactionStatus == a);
          });
        },
        listOfItems: orderStatusController.orderStatusLookupList);

    var myDropDownDateFilter = MyDropDownDateFilter(
        selectedValue: selectedDateFilter,
        onChanged: (a) {
          setState(() {
            selectedDateFilter = a.toString();
          });
        },
        listOfItems: MyVariables.dateFilterList);

    var row3 = Row(
      children: [
        Expanded(child: myDropDownDateFilter),
        const MySpaceWidth(widthSize: 2),
        Expanded(child: myDropDownOrderStatus),
      ],
    );

    var trackingNumberField = MyTextFieldCustom(
      controller: trackingNumberController,
      onChanged: (a) {
        setState(() {});
      },
      needToHideIcon: true,
      labelText: 'Tracking Number',
    );

    var searchButton = MyElevatedButton(
      text: 'Search',
      btnBackgroundColor: MyColors.btnColorGreen,
      onPressed: () {
        FocusScope.of(context).unfocus();
        reloadData();
      },
    );

    var row4 = Row(
      children: [
        Expanded(child: myDropDownWarehouse),
        const MySpaceWidth(widthSize: 2),
        Expanded(child: trackingNumberField)
      ],
    );

    var row5 = Row(children: [
      Expanded(
        child: ShowOrdersCount(
          listLength: ordersList.length,
          totalElements: pagination.totalElements,
        ),
      ),
      const MySpaceWidth(widthSize: 2),
      Flexible(
          child: Align(alignment: Alignment.centerRight, child: searchButton)),
    ]);

    var listView = NotificationListener(
      onNotification: ordersList.isEmpty
          ? null
          : (ScrollNotification scrollNotification) {
              var metrics = scrollNotification.metrics;
              var pixels = metrics.pixels;
              if (isLoadingListView != true &&
                  (pixels == metrics.maxScrollExtent &&
                      pixels != metrics.minScrollExtent)) {
                if (pagination.page == pagination.totalPages) {
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
              } else {
                return false;
              }
            },
      child: ListView.builder(
          itemCount: ordersList.length,
          itemBuilder: (BuildContext context, index) {
            return myCard(ordersList[index]);
          }),
    );

    return Scaffold(
      backgroundColor: MyColors.scaffoldBackgroundColor,
      appBar: appBar,
      body: Padding(
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            spaceBetweenBodyItemsRow,
            row1,
            spaceBetweenBodyItemsRow,
            row2,
            spaceBetweenBodyItemsRow,
            row3,
            spaceBetweenBodyItemsRow,
            row4,
            spaceBetweenBodyItemsRow,
            row5,
            spaceBetweenBodyItemsRow,
            Expanded(child: listView),
            isLoadingListView == true
                ? const MyLoadingIndicator(
                    centerIt: true,
                  )
                : Container(),
            hasMoreData == false ? const MyNoDataToShowWidget() : Container(),
          ],
        ),
      ),
    );
  }

  Future _scanQR() async {
    FlutterBarcodeScanner.scanBarcode('green', 'Cancel', true, ScanMode.QR)
        .then((value) {
      if (value != '-1' && value.isNotEmpty) {
        FlutterBeep.beep(false);
        setState(() {
          trackingNumberController.text = value;
        });
        reloadData();
      }
    });
  }

  Widget myCard(OrdersDataDist dist) {
    return GestureDetector(
        onLongPress: () {
          myShowBottomSheet(context, [
            MyListTileBottomSheetMenuItem(
              icon: Icons.comment,
              titleTxt: 'View Remarks',
              onTap: () {
                tryToPop(context);
                Get.dialog(Dialog(
                  backgroundColor: Colors.transparent,
                  child: ViewRemarks(
                    transactionId: dist.transactionId!,
                    transactionStatus: dist.transactionStatus!,
                  ),
                ));
              },
            ),
            MyListTileBottomSheetMenuItem(
              icon: Icons.remove_red_eye_outlined,
              titleTxt: 'View System Logs',
              onTap: () {
                tryToPop(context);
                Get.to(() => OrderDetail(
                      trackingNumber: dist.trackingNumber!,
                      initialTabIndex: 1,
                    ));
              },
            ),
            // MyListTileBottomSheetMenuItem(
            //   icon: Icons.edit,
            //   titleTxt: 'Edit',
            //   onTap: () {
            //     tryToPop(context);
            //     Get.dialog(
            //             Dialog(
            //               insetPadding: EdgeInsets.all(
            //                   SizeConfig.blockSizeHorizontal * 2),
            //               child: EditOrder(dist: dist),
            //             ),
            //             barrierDismissible: false)
            //         .then((value) {
            //       if (value == true) {
            //         reloadData();
            //       }
            //     });
            //   },
            // ),
          ]);
        },
        child: MyCard(
          dist: dist,
          needToHideCheckBox: true,
          needToHideDeleteIcon: true,
          needToShowOrderType: true,
          needToShowStockInFlag: true,
        ));
  }
}
