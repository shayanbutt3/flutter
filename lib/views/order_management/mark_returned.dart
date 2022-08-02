import 'package:backoffice_new/controllers/merchant_controller.dart';
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

import '../../custom/custom_widgets/show_response_dialog.dart';

//// This will change transaction status to Returned ////

class MarkReturned extends StatefulWidget {
  const MarkReturned({Key? key}) : super(key: key);

  @override
  _MarkReturnedState createState() => _MarkReturnedState();
}

class _MarkReturnedState extends State<MarkReturned> {
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

  RemarksAndListTransactionIdsRequestData requestData =
      RemarksAndListTransactionIdsRequestData();

  int page = 0;

  loadData() async {
    // if (selectedRider != null) {
    myShowLoadingDialog(context);
    apiFetchData
        // .getOrders(
        //     '',
        //     tmpR.riderId,
        //     '',
        //     MyVariables.ordersStatusIdsToMarkReturned,
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
      MyVariables.ordersStatusIdsToMarkReturned,
      '',
      MyVariables.sheetTypeIdReturn,
      MyVariables.sheetStatusIdsPickedAndReturnInProgress,
      '',
      fromDateController.text,
      toDateController.text,
      MyVariables.paginationDisable,
      page,
      MyVariables.size,
      MyVariables.sortDirection,
      merchantId: tmpM == null ? '' : tmpM!.merchantId,
      sheetOrderStatusIds: MyVariables.ordersStatusIdsToMarkReturned,
    )
        .then((value) {
      if (value != null) {
        if (mounted) {
          Get.isDialogOpen! ? tryToPop(context) : null;
          if (value.dist!.isNotEmpty) {
            setState(() {
              clearAllData();
              searchedOrdersList.addAll(value.dist!);
            });
          } else {
            clearAllData();
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

  clearAllData() {
    setState(() {
      selectedRecords = [];
      scannedOrdersList = [];
      searchedOrdersList = [];
    });
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

  onSelected(bool selected, SheetDetailDataDist sheetDataDist) {
    setState(() {
      if (selectedRecords.contains(sheetDataDist.transaction!.transactionId)) {
        selectedRecords.remove(sheetDataDist.transaction!.transactionId);
        scannedOrdersList.removeWhere((element) =>
            element.transaction!.trackingNumber ==
            sheetDataDist.transaction!.trackingNumber);
      } else if (selected) {
        selectedRecords.add(sheetDataDist.transaction!.transactionId!);
        scannedOrdersList.insert(0, sheetDataDist);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    orderTrackingNumber != null && orderTrackingNumber!.isNotEmpty
        ? apiFetchData
            // .getOrders(
            //     '',
            //     tmpR.riderId,
            //     '',
            //     MyVariables.ordersStatusIdsToMarkReturned,
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
            MyVariables.ordersStatusIdsToMarkReturned,
            orderTrackingNumber,
            MyVariables.sheetTypeIdReturn,
            MyVariables.sheetStatusIdsPickedAndReturnInProgress,
            '',
            '',
            '',
            MyVariables.paginationDisable,
            page,
            MyVariables.size,
            MyVariables.sortDirection,
            merchantId: tmpM == null ? '' : tmpM!.merchantId,
            sheetOrderStatusIds: MyVariables.ordersStatusIdsToMarkReturned,
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
                      scannedOrdersList.insert(0, dist);
                      selectedRecords.add(dist.transaction!.transactionId!);
                      orderTrackingNumber = '';
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
            text: 'Mark Returned',
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
          onPressed: loadData,
        ));

    var containerMerchantRider = SizedBox(
      width: SizeConfig.screenWidth,
      child: Row(
        children: [
          Expanded(child: myDropDownMerchant),
          const MySpaceWidth(widthSize: 2),
          Expanded(child: myDropDownRider),
        ],
      ),
    );

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

    var containerCounterSearch = SizedBox(
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
          Expanded(child: mySearchDataBtn),
        ],
      ),
    );

    final scannedOrdersDataList = ListView.builder(
        itemCount: scannedOrdersList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCard(
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
          return MyCard(
            dist: searchedOrdersList[index].transaction!,
            needToHideDeleteIcon: true,
            isSelected: selectedRecords
                .contains(searchedOrdersList[index].transaction!.transactionId),
            onChangedCheckBox: (b) {
              onSelected(b!, searchedOrdersList[index]);
            },
          );
        });

    var markReturnedButton = MyElevatedButton(
      text: 'Mark Returned',
      btnBackgroundColor: MyColors.btnColorGreen,
      btnPaddingHorizontalSize: 8,
      onPressed: () {
        if (selectedRider != null && selectedRider!.isNotEmpty) {
          if (selectedRecords.isNotEmpty) {
            myShowLoadingDialog(context);
            requestData = RemarksAndListTransactionIdsRequestData(
              transactionIds: selectedRecords,
            );

            apiPostData.patchMarkReturned(requestData).then((value) {
              if (value != null) {
                if (mounted) {
                  // Fluttertoast.showToast(msg: value.statusMessage!);
                  // clearAllData();
                  removeDataLocally();
                  Get.isDialogOpen! ? tryToPop(context) : null;
                  myShowSuccessMSGDialog(
                    description: 'Orders marked as returned successfully',
                  );
                }
              } else {
                // Get.isDialogOpen! ? tryToPop(context) : null;
              }
            });
          } else {
            myToastError('Please scan orders');
          }
        } else {
          myToastError('Please select Rider');
        }
      },
    );

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
                  containerMerchantRider,
                  const MySpaceHeight(heightSize: 1.5),
                  containerCounterScan,
                  const MySpaceHeight(heightSize: 1.5),
                  Expanded(child: scannedOrdersDataList),
                  markReturnedButton,
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
                  containerMerchantRider,
                  const MySpaceHeight(heightSize: 1),
                  containerCounterSearch,
                  const MySpaceHeight(heightSize: 1.5),
                  Expanded(child: searchedOrdersDataList),
                  markReturnedButton,
                ],
              ),
            ),
          ]),
        ));
  }
}
