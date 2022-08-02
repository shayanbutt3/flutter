import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/merchant_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
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

class MarkReturnRequest extends StatefulWidget {
  const MarkReturnRequest({Key? key}) : super(key: key);

  @override
  _MarkReturnRequestState createState() => _MarkReturnRequestState();
}

class _MarkReturnRequestState extends State<MarkReturnRequest> {
  ApiFetchData apiFetchData = ApiFetchData();

  TextEditingController trackingNumberController = TextEditingController();
  final MerchantController merchantController = Get.put(MerchantController());

  String? selectedMerchant;
  MerchantLookupDataDist? tmpM;

  bool isLoadingListView = false;
  bool hasMoreData = true;

  List<int> selectedRecords = [];
  List<OrdersDataDist> searchedOrdersList = [];
  List<OrdersDataDist> scannedOrdersList = [];
  Pagination pagination = Pagination();

  String orderTrackingNumber = '';
  final _tabslength = 2;

  loadData({
    var merchantId,
    var trackingNumber,
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
            merchantId ?? '',
            '',
            '',
            MyVariables.ordersStatusIdsToMarkReturnRequest,
            '',
            trackingNumber ?? '',
            '',
            '',
            '',
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
                searchedOrdersList = [];
                searchedOrdersList.addAll(value.dist!);
                pagination = value.pagination!;
              } else {
                searchedOrdersList.addAll(value.dist!);
                pagination = value.pagination!;
              }
            } else {
              if (pagination.page != null && pagination.page! > 0) {
              } else {
                searchedOrdersList = [];
                pagination = Pagination();
              }
              myToastSuccess(MyVariables.notFoundErrorMSG);
            }
          });
          setState(() {
            isLoadingListView = false;
          });
          needToShowLoadingDialog == true ? tryToPop(context) : null;
        }
      }
    });
  }

  addToScannedList() {
    var data = searchedOrdersList.firstWhere(
        (element) => element.trackingNumber == orderTrackingNumber,
        orElse: () => OrdersDataDist());

    if (data.trackingNumber == null) {
      var dist = scannedOrdersList
          .where((element) => element.trackingNumber == orderTrackingNumber);
      if (dist.isNotEmpty) {
        myToastError('Already Exist');
        setState(() {
          orderTrackingNumber = '';
        });
      } else {
        myToastError(MyVariables.scanningWrongOrderMSG);
        setState(() {
          orderTrackingNumber = '';
        });
      }
    } else {
      setState(() {
        scannedOrdersList.insert(0, data);
        myToastSuccess(MyVariables.addedSuccessfullyMSG);
        selectedRecords.add(data.transactionId!);
        searchedOrdersList.remove(data);
        pagination.totalElements = pagination.totalElements! - 1;
        orderTrackingNumber = '';
        FlutterBeep.beep(false);
      });
    }
  }

  Future scanQR() async {
    if (searchedOrdersList.isNotEmpty) {
      try {
        FlutterBarcodeScanner.getBarcodeStreamReceiver(
          '#ff6666',
          'Cancel',
          true,
          ScanMode.QR,
        )!
            .listen((value) {
          if (value != '-1' && value.isNotEmpty) {
            if (!mounted) return;
            setState(() {
              orderTrackingNumber = value.toString().trim();
            });
            addToScannedList();
          }
        });
      } catch (e) {
        myToastError('exception: $e');
      }
    } else {
      myToastError('Please Search Orders to Scan');
    }
  }

  // needToRefreshList() {
  //   setState(() {
  //     pagination.page = 0;
  //     selectedMerchant = null;
  //     trackingNumberController.text = '';
  //     searchedOrdersList = [];
  //     loadData(
  //       merchantId: tmpM == null ? '' : tmpM?.merchantId,
  //       trackingNumber: trackingNumberController.text.trim(),
  //       needToShowLoadingDialog: true,
  //       needToRemovePreviousData: true,
  //     );
  //   });
  // }

  removeAndInsertInList(OrdersDataDist ordersDataDist) {
    setState(() {
      scannedOrdersList.removeWhere(
          (element) => element.transactionId == ordersDataDist.transactionId);
      searchedOrdersList.insert(0, ordersDataDist);
      selectedRecords
          .removeWhere((element) => element == ordersDataDist.transactionId);
      pagination.totalElements = pagination.totalElements! + 1;
    });
  }

  // removeFromList(List<int> records) {
  //   for (int i = 0; i < records.length; i++) {
  //     setState(() {
  //       searchedOrdersList
  //           .removeWhere((element) => element.transactionId == records[i]);
  //       pagination.totalElements = pagination.totalElements! - 1;
  //     });
  //   }
  // }

  removeDataLocally() {
    setState(() {
      scannedOrdersList = [];
      selectedRecords = [];
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData(
        needToShowLoadingDialog: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBarWithBottom,
      child: SafeArea(
          child: AppBar(
        elevation: 0,
        backgroundColor: MyVariables.appBarBackgroundColor,
        iconTheme: MyVariables.appBarIconTheme,
        toolbarHeight: MyVariables.appbarHeight,
        title: const MyTextWidgetAppBarTitle(text: 'Mark Return Request'),
        flexibleSpace: const MyAppBarFlexibleContainer(),
        bottom: TabBar(tabs: [
          Tab(
            child: Text(
              'Pending Scan',
              style: MyVariables.tabBarTextStyle,
            ),
          ),
          Tab(
            child: Text(
              'Scanned',
              style: MyVariables.tabBarTextStyle,
            ),
          )
        ]),
        actions: [
          IconButton(
              tooltip: 'Scan QR',
              onPressed: () {
                scanQR();
              },
              icon: Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: SizeConfig.blockSizeHorizontal * 8,
              )),
        ],
      )),
    );

    var searchOrdersDataList = NotificationListener(
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
                    loadData(
                        merchantId: tmpM == null ? '' : tmpM?.merchantId,
                        trackingNumber: trackingNumberController.text.trim(),
                        needToMakeIsLoadingListViewTrue: true);
                  }
                });
              }
              return true;
            },
      child: ListView.builder(
          itemCount: searchedOrdersList.length,
          itemBuilder: (BuildContext context, index) {
            return MyCard(
              dist: searchedOrdersList[index],
              needToHideCheckBox: true,
              needToHideDeleteIcon: true,
            );
          }),
    );

    var merchantDropDown = MyDropDownMerchant(
        selectedValue: selectedMerchant,
        onChanged: (value) {
          setState(
            () {
              selectedMerchant = value.toString();
              tmpM = merchantController.merchantLookupList.firstWhere(
                  (element) => element.merchantName == selectedMerchant);
            },
          );
        },
        listOfItems: merchantController.merchantLookupList);

    var trackingNyumberField = MyTextFieldCustom(
      controller: trackingNumberController,
      needToHideIcon: true,
      labelText: 'Tracking Number',
      onChanged: (a) {
        setState(() {});
      },
    );

    var searchedCounter = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: ShowOrdersCount(
        text: 'Showing',
        alignment: Alignment.centerLeft,
        listLength: searchedOrdersList.length,
        totalElements: pagination.totalElements,
      ),
    );

    var scannedCounter = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: ShowOrdersCount(
        text: 'Scanned',
        alignment: Alignment.centerRight,
        listLength: scannedOrdersList.length,
      ),
    );

    var searchBtn = SizedBox(
        width: SizeConfig.safeScreenWidth,
        child: Row(
          children: [
            Expanded(child: searchedCounter),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                width: SizeConfig.safeScreenWidth,
                child: MyElevatedButton(
                  text: 'Search',
                  btnBackgroundColor: MyColors.btnColorGreen,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    searchedOrdersList = [];
                    scannedOrdersList = [];
                    selectedRecords = [];
                    pagination.totalElements = 0;
                    setState(() {
                      hasMoreData = true;
                      loadData(
                          merchantId: tmpM == null ? '' : tmpM?.merchantId,
                          trackingNumber: trackingNumberController.text.trim(),
                          needToRemovePreviousData: true,
                          needToShowLoadingDialog: true);
                    });
                  },
                ),
              ),
            ),
          ],
        ));

    final scannedOrdersDataList = ListView.builder(
      itemCount: scannedOrdersList.length,
      itemBuilder: (BuildContext context, index) {
        return MyCard(
          dist: scannedOrdersList[index],
          needToHideDeleteIcon: false,
          needToHideCheckBox: true,
          deleteOnPressed: () {
            removeAndInsertInList(scannedOrdersList[index]);
          },
        );
      },
    );

    var markReturnRequestBtn = Container(
        width: SizeConfig.safeScreenWidth,
        alignment: Alignment.center,
        child: MyElevatedButton(
            text: 'Mark Return Request',
            btnBackgroundColor: MyColors.btnColorGreen,
            onPressed: () {
              if (selectedRecords.isNotEmpty) {
                Get.dialog(
                        MyMarkReturnRequestDialog(
                            transactionIds: selectedRecords),
                        barrierDismissible: false)
                    .then((value) {
                  if (value == true) {
                    setState(() {
                      removeDataLocally();
                    });
                  }
                });
              } else {
                myToastError('Please scan orders to Mark Return Request');
              }
            }));

    return DefaultTabController(
      length: _tabslength,
      child: Scaffold(
          appBar: appBar,
          body: TabBarView(
            children: [
              //////// Pending Scan //////

              Padding(
                padding: MyVariables.scaffoldBodyPadding,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const MySpaceHeight(heightSize: 1),
                        Expanded(child: merchantDropDown),
                        const MySpaceWidth(widthSize: 2),
                        Expanded(child: trackingNyumberField),
                      ],
                    ),
                    const MySpaceHeight(heightSize: 1),
                    searchBtn,
                    const MySpaceHeight(heightSize: 1),
                    Expanded(
                      child: searchedOrdersList.isEmpty
                          ? const MyNoDataToShowWidget()
                          : searchOrdersDataList,
                    ),
                    isLoadingListView == true
                        ? const MyLoadingIndicator(
                            centerIt: true,
                          )
                        : Container(),
                    hasMoreData == false
                        ? const MyNoMoreDataContainer()
                        : Container(),
                  ],
                ),
              ),

              /////// Scanned ///////

              Padding(
                padding: MyVariables.scaffoldBodyPadding,
                child: Column(
                  children: [
                    const MySpaceHeight(heightSize: 1),
                    scannedCounter,
                    orderTrackingNumber.isNotEmpty
                        ? const MyLoadingIndicator()
                        : Container(),
                    const MySpaceHeight(heightSize: 1),
                    Expanded(child: scannedOrdersDataList),
                    const MySpaceHeight(heightSize: 1),
                    markReturnRequestBtn,
                  ],
                ),
              )
            ],
          )),
    );
  }

  // Widget myCard(BuildContext context, OrdersDataDist dist) {
  //   return InkWell(
  //     onLongPress: () {
  //       myShowBottomSheet(context, [
  //         MyListTileBottomSheetMenuItem(
  //           titleTxt: 'Mark Return Request',
  //           // icon: Icons.info_outline,
  //           icon: Icons.delete_outline,
  //           onTap: () {
  //             tryToPop(context);
  //             Get.dialog(
  //                     MyMarkReturnRequestDialog(transactionId: selectedRecords),
  //                     barrierDismissible: false)
  //                 .then((value) {
  //               if (value == true) {
  //                 removeFromList(dist.transactionId!);
  //               }
  //             });
  //           },
  //         ),
  //       ]);
  //     },
  //     child: MyCard(
  //       dist: dist,
  //       needToHideCheckBox: true,
  //       needToHideDeleteIcon: true,
  //     ),
  //   );
  // }
}
