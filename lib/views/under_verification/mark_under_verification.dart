import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/merchant_controller.dart';
import 'package:backoffice_new/controllers/rider_controller.dart';
import 'package:backoffice_new/controllers/warehouse_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';

class MarkUnderVerification extends StatefulWidget {
  const MarkUnderVerification({Key? key}) : super(key: key);

  @override
  _MarkUnderVerificationState createState() => _MarkUnderVerificationState();
}

class _MarkUnderVerificationState extends State<MarkUnderVerification> {
  ApiFetchData apiFetchData = ApiFetchData();

  TextEditingController trackingNumberController = TextEditingController();
  final MerchantController merchantController = Get.put(MerchantController());
  final WareHouseController wareHouseController =
      Get.put(WareHouseController());
  RiderController riderController = Get.put(RiderController());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  List<int> selectedRecords = [];
  List<SheetDetailDataDist> pendingScannedList = [];
  List<SheetDetailDataDist> scannedList = [];

  String? selectedRider;
  RiderLookupDataDist? tmpR;

  String? selectedMerchant;
  MerchantLookupDataDist? tmpM;

  String? selectedWareHouse;
  WareHouseDataDist? tmpW;

  final tablength = 2;
  late String currentDate;

  // int page = 0;
  // bool isLoadingListView = false;
  // bool hasMoreData = true;

  // List<OrdersDataDist> ordersList = [];
  // Pagination pagination = Pagination();

  String orderTrackingNumber = '';

  loadData() async {
    myShowLoadingDialog(context);
    apiFetchData
        .getSheetDetail(
            tmpR!.riderId,
            MyVariables.ordersStatusIdsToMarkUnderVerification,
            trackingNumberController.text,
            MyVariables.sheetTypeIdDelivery,
            '',
            '',
            fromDateController.text,
            toDateController.text,
            MyVariables.paginationEnable,
            0,
            MyVariables.size,
            MyVariables.sortDirection,
            orderPhysicalStatusIds:
                MyVariables.orderPhysicalStatusInPostMasterForDelivery,
            linkOrderStatusAndPhysicalStatusIds: true,
            merchantId: tmpM == null ? '' : tmpM!.merchantId,
            sheetOrderStatusIds:
                MyVariables.ordersStatusIdsToMarkUnderVerification)
        .then((value) {
      if (value != null) {
        if (mounted) {
          if (value.dist!.isNotEmpty) {
            setState(() {
              pendingScannedList.addAll(value.dist!);
            });
          } else {
            myToastSuccess(MyVariables.notFoundErrorMSG);
          }
        }
        Get.isDialogOpen! ? Get.back() : null;
      }
    });
  }

  // needToRefreshList() {
  //   setState(() {
  //     pagination.page = 0;
  //     selectedMerchant = null;
  //     trackingNumberController.text = '';
  //     ordersList = [];
  //     loadData(
  //       merchantId: tmpM == null ? '' : tmpM?.merchantId,
  //       trackingNumber: trackingNumberController.text.trim(),
  //       needToShowLoadingDialog: true,
  //       needToRemovePreviousData: true,
  //     );
  //   });
  // }

  // removeFromList(int transactionId) {
  //   setState(() {
  //     ordersList
  //         .removeWhere((element) => element.transactionId == transactionId);
  //     pagination.totalElements = pagination.totalElements! - 1;
  //   });
  // }

  removeFromList(List<int> records) {
    setState(() {
      for (int i = 0; i < records.length; i++) {
        scannedList.removeWhere(
            (element) => element.transaction!.transactionId == records[i]);
      }
    });
  }

  removeDataLocally() {
    removeFromList(selectedRecords);
    setState(() {
      selectedRecords = [];
    });
  }

  Future scanQR() async {
    if (pendingScannedList.isNotEmpty) {
      try {
        FlutterBarcodeScanner.getBarcodeStreamReceiver(
          '#ff6666',
          'Cancel',
          true,
          ScanMode.QR,
        )!
            .listen((value) {
          if (value != '-1' && value.toString().isNotEmpty) {
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
      myToastError('Search order to scan');
    }
  }

  addToScannedList() {
    var data = pendingScannedList.firstWhere(
        (element) => element.transaction!.trackingNumber == orderTrackingNumber,
        orElse: () => SheetDetailDataDist());

    if (data.transaction?.trackingNumber == null) {
      var dist = scannedList.where((element) =>
          element.transaction!.trackingNumber == orderTrackingNumber);

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
        scannedList.insert(0, data);
        myToastSuccess(MyVariables.addedSuccessfullyMSG);
        selectedRecords.add(data.transaction!.transactionId!);
        pendingScannedList.remove(data);
        orderTrackingNumber = '';
        FlutterBeep.beep(false);
      });
    }
  }

  removeAndInsertInList(SheetDetailDataDist dist) {
    setState(() {
      scannedList.removeWhere((element) =>
          element.transaction!.transactionId ==
          dist.transaction!.transactionId);

      pendingScannedList.insert(0, dist);

      selectedRecords
          .removeWhere((element) => element == dist.transaction!.transactionId);
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var dateDropDownOnPendingScanned = Row(
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

    final _appBar = PreferredSize(
        preferredSize: MyVariables.preferredSizeAppBarWithBottom,
        child: SafeArea(
          child: AppBar(
            title: const MyTextWidgetAppBarTitle(
                text: 'Mark Delivery Under Review'),
            toolbarHeight: MyVariables.appbarHeight,
            iconTheme: MyVariables.appBarIconTheme,
            backgroundColor: MyVariables.appBarBackgroundColor,
            flexibleSpace: const MyAppBarFlexibleContainer(),
            elevation: 0,
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
                onPressed: () {
                  scanQR();
                },
                icon: const Icon(Icons.qr_code_scanner),
                iconSize: SizeConfig.blockSizeHorizontal * 8,
              )
            ],
          ),
        ));

    // final list = NotificationListener(
    //   onNotification: ordersList.isEmpty
    //       ? null
    //       : (ScrollNotification scrollInfo) {
    //           var metrics = scrollInfo.metrics;
    //           var pixels = metrics.pixels;
    //           if (!isLoadingListView
    //               // != true
    //               &&
    //               pixels == metrics.maxScrollExtent &&
    //               pixels != metrics.minScrollExtent) {
    //             setState(() {
    //               if (
    //                   // page == pagination.totalPages
    //                   pagination.page! == pagination.totalPages!
    //                   // && page == pagination.page
    //                   ) {
    //                 isLoadingListView = false;
    //                 hasMoreData = false;
    //               } else {
    //                 // page++;
    //                 pagination.page = pagination.page! + 1;
    //                 loadData(needToMakeIsLoadingListViewTrue: true);
    //               }
    //             });
    //           }
    //           return true;
    //         },
    //   child:
    //       // ListView(
    //       //   shrinkWrap: true,
    //       //   children: [
    //       //     Column(
    //       //       children: [
    //       //         for (var dist in ordersList) myCard(context, dist),
    //       //         isLoadingListView == true
    //       //             ? const MyLoadingIndicator(centerIt: true)
    //       //             : Container(),
    //       //         hasMoreData == false
    //       //             ? const MyNoMoreDataContainer()
    //       //             : Container(),
    //       //       ],
    //       //     )
    //       //   ],
    //       // ),
    //       ListView.builder(
    //           itemCount: ordersList.length,
    //           itemBuilder: (context, index) {
    //             return myCard(context, ordersList[index]);
    //           }),
    // );

    final container = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
              child: MyDropDownRider(
                  selectedValue: selectedRider,
                  onChanged: (s) {
                    setState(() {
                      selectedRider = s.toString();
                      tmpR = riderController.riderLookupList.firstWhere(
                          (element) => element.riderName == selectedRider,
                          orElse: () => RiderLookupDataDist());
                    });
                  },
                  listOfItems: riderController.riderLookupList)),
          const MySpaceWidth(widthSize: 2),
          Expanded(
              child: MyDropDownMerchant(
            selectedValue: selectedMerchant,
            onChanged: (val) {
              setState(() {
                selectedMerchant = val.toString();
                // // page = 0;
                // pagination.page = 0;
                tmpM = merchantController.merchantLookupList.firstWhere(
                    (element) => element.merchantName == selectedMerchant);
              });
            },
            listOfItems: merchantController.merchantLookupList,
          )),
        ],
      ),
    );

    var wareHouseDropDown = MyDropDownWareHouse(
        selectedValue: selectedWareHouse,
        onChanged: (w) {
          setState(() {
            selectedWareHouse = w.toString();
            tmpW = wareHouseController.wareHouseLookupList.firstWhere(
                (element) => element.wareHouseName == selectedWareHouse);
          });
        },
        listOfItems: wareHouseController.wareHouseLookupList);

    final searchBtn = SizedBox(
        width: SizeConfig.safeScreenWidth,
        child: Row(
          children: [
            Expanded(
                child: MyTextFieldCustom(
              controller: trackingNumberController,
              needToHideIcon: true,
              labelText: 'Tracking Number',
              onChanged: (a) {
                setState(() {});
              },
            )),
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: MyElevatedButton(
                  text: 'Search',
                  btnBackgroundColor: MyColors.btnColorGreen,
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    if (selectedRider != null && selectedRider!.isNotEmpty) {
                      setState(() {
                        selectedRecords = [];
                        pendingScannedList = [];
                        scannedList = [];
                      });
                      loadData();
                    } else {
                      myToastError('Please select rider');
                    }
                  },
                ),
              ),
            ),
          ],
        ));

    var listOfPendingScanned = ListView.builder(
        itemCount: pendingScannedList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCard(
            dist: pendingScannedList[index].transaction!,
            needToHideCheckBox: true,
            needToHideDeleteIcon: true,
            needToShowRiderRemarks: true,
          );
        });

    var listOfScanned = ListView.builder(
        itemCount: scannedList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCard(
            dist: scannedList[index].transaction!,
            needToHideCheckBox: true,
            needToShowRiderRemarks: true,
            deleteOnPressed: () {
              removeAndInsertInList(scannedList[index]);
            },
          );
        });

    final counter = SizedBox(
        width: SizeConfig.screenWidth,
        child: Row(
          children: [
            Expanded(
              child: ShowOrdersCount(
                alignment: Alignment.centerRight,
                listLength: pendingScannedList.length,
              ),
            ),
          ],
        ));

    var deliveryUnderReviewBtn = MyElevatedButton(
      text: 'Mark Delivery Under Review',
      btnBackgroundColor: MyColors.btnColorGreen,
      onPressed: () {
        if (selectedWareHouse != null &&
            selectedWareHouse!.isNotEmpty &&
            selectedWareHouse != MyVariables.wareHouseDropdownSelectAllText &&
            tmpW?.wareHouseId != null) {
          if (selectedRecords.isNotEmpty) {
            Get.dialog(
                    MyUnderVerificationDialog(
                      transactionId: selectedRecords,
                      wareHouseId: tmpW!.wareHouseId!,
                    ),
                    barrierDismissible: false)
                .then((value) {
              if (value == true) {
                // needToRefreshList();
                removeDataLocally();
              }
            });
          } else {
            myToastError('Please select order');
          }
        } else {
          myToastError('Please select WareHouse');
        }
      },
    );

    var colOfTab1 = Column(
      children: [
        const MySpaceHeight(heightSize: 1),
        dateDropDownOnPendingScanned,
        const MySpaceHeight(heightSize: 1),
        container,
        const MySpaceHeight(heightSize: 1),
        searchBtn,
        const MySpaceHeight(heightSize: 1),
        counter,
        const MySpaceHeight(heightSize: 1),
        Expanded(
            child: pendingScannedList.isEmpty
                ? const MyNoDataToShowWidget()
                : listOfPendingScanned),
        // isLoadingListView == true ? const MyLoadingIndicator() : Container(),
        // hasMoreData == false ? const MyNoMoreDataContainer() : Container(),
      ],
    );

    var colOfTab2 = Column(
      children: [
        Row(
          children: [
            Expanded(child: wareHouseDropDown),
            Expanded(
              child: ShowOrdersCount(
                alignment: Alignment.centerRight,
                listLength: scannedList.length,
              ),
            ),
          ],
        ),
        Expanded(child: listOfScanned),
        deliveryUnderReviewBtn
      ],
    );

    return DefaultTabController(
      length: tablength,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.scaffoldBackgroundColor,
        appBar: _appBar,
        body: Container(
            width: SizeConfig.safeScreenWidth,
            padding: MyVariables.scaffoldBodyPadding,
            child: TabBarView(children: [
              /////////////************ Via Pending Scan ***********//////////////
              colOfTab1,
              /////////////************ Via Scanned ***********//////////////
              colOfTab2
            ])),
      ),
    );
  }
}
