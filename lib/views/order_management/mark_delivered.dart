import 'package:backoffice_new/controllers/merchant_controller.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/rider_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/services/api_post_data.dart';

//// This will change transaction status to Delivered ////

class MarkDelivered extends StatefulWidget {
  const MarkDelivered({Key? key}) : super(key: key);

  @override
  _MarkDeliveredState createState() => _MarkDeliveredState();
}

class _MarkDeliveredState extends State<MarkDelivered> {
  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  final _tabsLength = 2;

  final RiderController riderController = Get.put(RiderController());
  final MerchantController merchantController = Get.put(MerchantController());

  List<int> selectedRecords = [];
  // List<OrdersDataDist> scannedOrdersList = [];
  // List<OrdersDataDist> searchedOrdersList = [];

  List<SheetDetailDataDist> scannedOrdersList = [];
  List<SheetDetailDataDist> searchedOrdersList = [];

  String? selectedRider;
  RiderLookupDataDist? tmpR;

  String? selectedMerchant;
  MerchantLookupDataDist? tmpM;

  String? orderTrackingNumber = '';

  MarkDeliveredRequestData requestData = MarkDeliveredRequestData();

  int page = 0;

  loadData() async {
    // if (selectedRider != null) {
    myShowLoadingDialog(context);
    apiFetchData
        // .getOrders(
        //     '',
        //     tmpR.riderId,
        //     '',
        //     MyVariables.ordersStatusIdsToMarkDelivered,
        //     '',
        //     orderTrackingNumber,
        //     fromDateController.text,
        //     toDateController.text,
        //     '',
        //     MyVariables.paginationDisable,
        //     page,
        //     MyVariables.size,
        //     MyVariables.sortDirection)
        .getSheetDetail(
      tmpR == null ? '' : tmpR!.riderId,
      MyVariables.ordersStatusIdsToMarkDelivered,
      '',
      MyVariables.sheetTypeIdDelivery,
      MyVariables.sheetStatusIdsPickedAndDeliveryInProgress,
      '',
      fromDateController.text,
      toDateController.text,
      MyVariables.paginationDisable,
      page,
      MyVariables.size,
      MyVariables.sortDirection,
      merchantId: tmpM == null ? '' : tmpM!.merchantId,
      sheetOrderStatusIds: MyVariables.ordersStatusIdsToMarkDelivered,
    )
        .then((value) {
      if (value != null) {
        if (mounted) {
          Get.isDialogOpen! ? tryToPop(context) : null;
          if (value.dist!.isNotEmpty) {
            setState(() {
              searchedOrdersList = [];
              searchedOrdersList.addAll(value.dist!);
            });
          } else {
            myToastSuccess(MyVariables.notFoundErrorMSG);
          }
        }
      } else {
        // Get.isDialogOpen! ? tryToPop(context) : null;
      }
    });
    // } else {
    //   myToastError('Please select Rider to search');
    // }
  }

  removeFromList(List<int> records) {
    for (int i = 0; i < records.length; i++) {
      setState(() {
        searchedOrdersList.removeWhere(
            (element) => element.transaction!.transactionId == records[i]);
      });
    }
  }

  removeDataLocally() {
    removeFromList(selectedRecords);
    setState(() {
      selectedRecords = [];
      scannedOrdersList = [];
    });
  }

  // needToRefreshList() {
  //   setState(() {
  //     selectedRecords = [];
  //     scannedOrdersList = [];
  //     loadData();
  //   });
  // }

  @override
  void initState() {
    fromDateController.text = myFormatDateOnly(myGetDateTime().toString());
    toDateController.text = myFormatDateOnly(myGetDateTime().toString());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => loadData());
    super.initState();
  }

  Future _scanQR() async {
    // if (selectedRider != null && selectedRider!.isNotEmpty) {
    try {
      await FlutterBarcodeScanner.scanBarcode(
              'green', 'Cancel', true, ScanMode.QR)
          .then((value) {
        if (value != '-1' && value.isNotEmpty) {
          setState(() {
            orderTrackingNumber = value.trim();
            FlutterBeep.beep(false);
          });
        }
      });
    } catch (e) {
      myToastError('Exception: $e');
      rethrow;
    }
    // } else {
    //   myToastError('Please select Rider to scan');
    // }
  }

  // onSelected(bool selected, OrdersDataDist ordersDataDist) {
  //   setState(() {
  //     if (selectedRecords.contains(ordersDataDist.transactionId)) {
  //       selectedRecords.remove(ordersDataDist.transactionId);
  //       scannedOrdersList.removeWhere((element) =>
  //           element.trackingNumber == ordersDataDist.trackingNumber);
  //     } else if (selected) {
  //       selectedRecords.add(ordersDataDist.transactionId!);
  //       scannedOrdersList.insert(0, ordersDataDist);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    orderTrackingNumber != null && orderTrackingNumber!.isNotEmpty
        ? apiFetchData
            // .getOrders(
            //     '',
            //     tmpR.riderId,
            //     '',
            //     MyVariables.ordersStatusIdsToMarkDelivered,
            //     '',
            //     orderTrackingNumber,
            //     '',
            //     '',
            //     '',
            //     MyVariables.paginationDisable,
            //     page,
            //     MyVariables.size,
            //     MyVariables.sortDirection)
            .getSheetDetail(
            tmpR == null ? '' : tmpR!.riderId,
            MyVariables.ordersStatusIdsToMarkDelivered,
            orderTrackingNumber,
            MyVariables.sheetTypeIdDelivery,
            MyVariables.sheetStatusIdsPickedAndDeliveryInProgress,
            '',
            '',
            '',
            MyVariables.paginationDisable,
            page,
            MyVariables.size,
            MyVariables.sortDirection,
            merchantId: tmpM == null ? '' : tmpM!.merchantId,
            sheetOrderStatusIds: MyVariables.ordersStatusIdsToMarkDelivered,
          )
            .then((value) {
            if (value != null) {
              if (mounted) {
                if (value.dist!.isNotEmpty) {
                  var dist = value.dist![0];
                  var data = scannedOrdersList.where((element) =>
                      element.transaction!.trackingNumber ==
                      dist.transaction!.trackingNumber);
                  if (data.isNotEmpty) {
                    myToastError('Already Exists');
                    setState(() {
                      orderTrackingNumber = '';
                    });
                  } else {
                    setState(() {
                      // scannedOrdersList.insert(0, dist);
                      // selectedRecords.add(dist.transactionId!);
                      // scannedOrdersList = value.dist!;
                      scannedOrdersList = [dist];
                      selectedRecords = [dist.transaction!.transactionId!];
                      orderTrackingNumber = '';
                      Get.dialog(
                              MyMarkDeliveredRequestDialog(
                                  invoiceAmount:
                                      dist.transaction!.invoicePayment!,
                                  transactionId:
                                      dist.transaction!.transactionId!),
                              barrierDismissible: false)
                          .then((value) {
                        if (value == true) {
                          removeDataLocally();
                        }
                      });
                    });
                    myToastSuccess(MyVariables.addedSuccessfullyMSG);
                  }
                } else {
                  setState(() {
                    orderTrackingNumber = '';
                  });
                  myToastError(MyVariables.scanningWrongOrderMSG);
                }
              }
            }
          })
        : null;

    var appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBarWithBottom,
      child: SafeArea(
        child: AppBar(
          elevation: 0,
          backgroundColor: MyVariables.appBarBackgroundColor,
          iconTheme: MyVariables.appBarIconTheme,
          toolbarHeight: MyVariables.appbarHeight,
          title: const MyTextWidgetAppBarTitle(
            text: 'Mark Delivered',
          ),
          flexibleSpace: const MyAppBarFlexibleContainer(),
          bottom: TabBar(
              // controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    'Via Scan',
                    style: MyVariables.tabBarTextStyle,
                  ),
                ),
                Tab(
                  child: Text(
                    'Via Search',
                    style: MyVariables.tabBarTextStyle,
                  ),
                ),
              ]),
          actions: [
            IconButton(
              icon: Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: SizeConfig.blockSizeHorizontal * 8,
              ),
              onPressed: _scanQR,
            ),
          ],
        ),
      ),
    );

    var dateRow = Row(
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
                          lastDate: DateTime(2050))
                      .then((value) {
                    if (value != null) {
                      setState(() {
                        fromDateController.text =
                            myFormatDateOnly(value.toString());
                      });
                    }
                  });
                })),
        const MySpaceWidth(widthSize: 2),
        Expanded(
            child: MyTextFieldDatePicker(
                text: 'To Date',
                controller: toDateController,
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
                })),
      ],
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

    var mySearchDataBtn = Container(
        width: SizeConfig.safeScreenWidth,
        alignment: Alignment.centerRight,
        child: MyElevatedButton(
          text: 'Search',
          btnBackgroundColor: MyColors.btnColorGreen,
          // onPressed: () async {
          //   if (selectedRider != null) {
          //     myShowLoadingDialog(context);
          //     apiFetchData
          //         .getOrders(
          //             '',
          //             tmpR.riderId,
          //             MyVariables.ordersStatusIdsToMarkDelivered,
          //             orderTrackingNumber,
          //             '',
          //             '',
          //             '',
          //             '',
          //             MyVariables.paginationDisable,
          //             page,
          //             MyVariables.size,
          //             MyVariables.sortDirection)
          //         .then((value) {
          //       if (value != null) {
          //         if (mounted) {
          //           Get.isDialogOpen! ? tryToPop(context) : null;
          //           if (value.dist!.isNotEmpty) {
          //             setState(() {
          //               searchedOrdersList = [];
          //               searchedOrdersList.addAll(value.dist!);
          //             });
          //           } else {
          //             Fluttertoast.showToast(msg: MyVariables.notFoundErrorMSG);
          //           }
          //         }
          //       } else {
          //         Get.isDialogOpen! ? tryToPop(context) : null;
          //       }
          //     });
          //   } else {
          //     myToastError('Please select Rider to search');
          //   }
          // },
          onPressed: loadData,
        ));

    var containerCounterScan = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(child: Container()),
          orderTrackingNumber!.isNotEmpty
              ? const MyLoadingIndicator()
              : Container(),
          Expanded(
              child: ShowOrdersCount(
            text: 'Scanned',
            alignment: Alignment.centerRight,
            listLength: selectedRecords.length,
          )),
        ],
      ),
    );

    var containerDropdownsMerchantRider = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
            child: myDropDownMerchant,
          ),
          const MySpaceWidth(widthSize: 2),
          Expanded(
            child: myDropDownRider,
          ),
        ],
      ),
    );

    var containerCounterAndSearchSearch = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
              child: ShowOrdersCount(
            text: selectedRecords.isNotEmpty ? 'Selected' : null,
            // alignment: Alignment.centerRight,
            listLength: selectedRecords.isNotEmpty
                ? selectedRecords.length
                : searchedOrdersList.length,
            totalElements: searchedOrdersList.length,
          )),
          const MySpaceWidth(widthSize: 2),
          Expanded(child: mySearchDataBtn),
        ],
      ),
    );

    final scannedOrdersDataList = ListView.builder(
        itemCount: scannedOrdersList.length,
        itemBuilder: (BuildContext context, index) {
          return myCard(
            context: context,
            dist: scannedOrdersList[index].transaction!,
            needToHideCheckBox: true,
            deleteOnPressed: () {
              setState(() {
                selectedRecords.remove(
                    scannedOrdersList[index].transaction!.transactionId);
                scannedOrdersList.removeWhere((element) =>
                    element.transaction!.trackingNumber ==
                    scannedOrdersList[index].transaction!.trackingNumber);
              });
            },
          );
        });

    final searchedOrdersDataList = ListView.builder(
        itemCount: searchedOrdersList.length,
        itemBuilder: (BuildContext context, index) {
          return myCard(
            context: context,
            dist: searchedOrdersList[index].transaction!,
            needToHideDeleteIcon: true,
            needToHideCheckBox: true,
            isSelected: selectedRecords
                .contains(searchedOrdersList[index].transaction!.transactionId),

            // onChangedCheckBox: (b) {
            //   onSelected(b!, searchedOrdersList[index]);
            // },
          );
        });

    // var markDeliveredButton = MyElevatedButton(
    //   text: 'Mark Delivered',
    //   btnBackgroundColor: MyColors.btnColorGreen,
    //   btnPaddingHorizontalSize: 8,
    //   onPressed: () {
    //     if (selectedRider != null && selectedRider!.isNotEmpty) {
    //       if (selectedRecords.isNotEmpty) {
    //         myShowLoadingDialog(context);
    //         requestData = MarkDeliveredRequestData(
    //           transactionIds: selectedRecords,
    //         );
    //         apiPostData.patchMarkDelivered(requestData).then((value) {
    //           if (value != null) {
    //             if (mounted) {
    //               Fluttertoast.showToast(msg: value.statusMessage!);
    //               clearAllData();
    //               Get.isDialogOpen! ? tryToPop(context) : null;
    //             }
    //           } else {
    //             Get.isDialogOpen! ? tryToPop(context) : null;
    //           }
    //         });
    //       } else {
    //         myToastError('Please select/scan orders');
    //       }
    //     } else {
    //       myToastError('Please select Rider');
    //     }
    //   },
    // );

    return DefaultTabController(
        length: _tabsLength,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: MyColors.scaffoldBackgroundColor,
          appBar: appBar,
          // drawer: MyAppDrawer(),
          body: TabBarView(children: [
            /////////////************ Via Scan ***********//////////////
            Padding(
              padding: MyVariables.scaffoldBodyPadding,
              child: Column(
                children: [
                  const MySpaceHeight(heightSize: 1.5),
                  containerDropdownsMerchantRider,
                  const MySpaceHeight(heightSize: 1.5),
                  containerCounterScan,
                  const MySpaceHeight(heightSize: 1.5),
                  Expanded(child: scannedOrdersDataList),
                  // markDeliveredButton,
                ],
              ),
            ),

            /////////////************ Via Search ***********//////////////
            Padding(
              padding: MyVariables.scaffoldBodyPadding,
              child: Column(
                children: [
                  const MySpaceHeight(heightSize: 1.5),
                  dateRow,
                  const MySpaceHeight(heightSize: 1),
                  containerDropdownsMerchantRider,
                  const MySpaceHeight(heightSize: 1),
                  containerCounterAndSearchSearch,
                  const MySpaceHeight(heightSize: 1.5),
                  Expanded(child: searchedOrdersDataList),
                  // markDeliveredButton,
                ],
              ),
            ),
          ]),
        ));
  }

  Widget myCard({
    required BuildContext context,
    required OrdersDataDist dist,
    bool? needToHideCheckBox,
    bool? isSelected,
    dynamic Function(bool?)? onChangedCheckBox,
    bool? needToHideDeleteIcon,
    void Function()? deleteOnPressed,
  }) {
    return InkWell(
      onLongPress: () {
        myShowBottomSheet(context, [
          MyListTileBottomSheetMenuItem(
            titleTxt: 'Mark Delivered',
            icon: Icons.done_outline,
            onTap: () {
              tryToPop(context);
              Get.dialog(
                      MyMarkDeliveredRequestDialog(
                          invoiceAmount: dist.invoicePayment!,
                          transactionId: dist.transactionId!),
                      barrierDismissible: false)
                  .then((value) {
                if (value == true) {
                  setState(() {
                    selectedRecords = [dist.transactionId!];
                  });
                  removeDataLocally();
                }
              });
            },
          ),
        ]);
      },
      child: MyCard(
        dist: dist,
        deleteOnPressed: deleteOnPressed,
        isSelected: isSelected,
        needToHideCheckBox: needToHideCheckBox,
        needToHideDeleteIcon: needToHideDeleteIcon,
        onChangedCheckBox: onChangedCheckBox,
      ),
    );
  }
}
