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
import 'package:backoffice_new/custom/custom_widgets/show_confirmation_dialog.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/custom/custom_widgets/show_response_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';

class StockInOthers extends StatefulWidget {
  const StockInOthers({Key? key}) : super(key: key);

  @override
  State<StockInOthers> createState() => _StockInOthersState();
}

class _StockInOthersState extends State<StockInOthers> {
  final MerchantController merchantController = Get.put(MerchantController());
  final RiderController riderController = Get.put(RiderController());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  DeliveryRescheduleRequestData requestData = DeliveryRescheduleRequestData();
  TextEditingController remarksController = TextEditingController();
  final WareHouseController wareHouseController =
      Get.put(WareHouseController());

  String? selectedMerchent;
  MerchantLookupDataDist? tmpM;

  String? selectedRider;
  RiderLookupDataDist? tmpR;

  String? selectedWareHouse;
  WareHouseDataDist? tmpW;

  final _tabslength = 2;
  List<int> selectedRecords = [];

  List<SheetDetailDataDist> searchedOrdersList = [];
  List<SheetDetailDataDist> scannedOrdersList = [];

  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  String orderTrackingNumber = '';
  late String currentDateString;

  loadData() async {
    myShowLoadingDialog(context);
    apiFetchData
        .getSheetDetail(
      tmpR!.riderId,
      MyVariables.ordersStatusIdsToMakeOrdersInStockOthers,
      '',
      '',
      '',
      '',
      fromDateController.text,
      toDateController.text,
      MyVariables.paginationDisable,
      0,
      MyVariables.size,
      MyVariables.sortDirection,
      merchantId: tmpM == null ? '' : tmpM!.merchantId,
      linkOrderStatusAndPhysicalStatusIds: false,
      sheetOrderStatusIds: MyVariables.ordersStatusIdsToMakeOrdersInStockOthers,
    )
        .then((value) {
      if (value != null) {
        if (mounted) {
          if (value.dist!.isNotEmpty) {
            setState(() {
              searchedOrdersList.addAll(value.dist!);
            });
          } else {
            myToastError(MyVariables.notFoundErrorMSG);
          }
          Get.isDialogOpen! ? tryToPop(context) : null;
        }
      }
    });
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
      myToastError('Please Search Order to Scan');
    }
  }

  addToScannedList() {
    var data = searchedOrdersList.firstWhere(
        (element) => element.transaction!.trackingNumber == orderTrackingNumber,
        orElse: () => SheetDetailDataDist());

    if (data.transaction?.trackingNumber == null) {
      var dist = scannedOrdersList.where((element) =>
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
        scannedOrdersList.insert(0, data);
        myToastSuccess(MyVariables.addedSuccessfullyMSG);
        selectedRecords.add(data.transaction!.transactionId!);
        searchedOrdersList.remove(data);
        orderTrackingNumber = '';
        FlutterBeep.beep(false);
      });
    }
  }

  clearData() {
    setState(() {
      scannedOrdersList = [];
      selectedRecords = [];
      searchedOrdersList = [];
    });
  }

  removeFromList(List<int> records) {
    for (int i = 0; i < records.length; i++) {
      setState(() {
        scannedOrdersList.removeWhere(
            (element) => element.transaction!.transactionId == records[i]);
      });
    }
  }

  removeAndInsertInList(SheetDetailDataDist sheetDetailDataDist) {
    setState(() {
      scannedOrdersList.removeWhere((element) =>
          element.transaction!.transactionId ==
          sheetDetailDataDist.transaction!.transactionId);

      searchedOrdersList.insert(0, sheetDetailDataDist);

      selectedRecords.removeWhere((element) =>
          element == sheetDetailDataDist.transaction!.transactionId);
    });
  }

  removeDataLocally() {
    removeFromList(selectedRecords);
    setState(() {
      selectedRecords = [];
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

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

    var myDropDownMerchant = MyDropDownMerchant(
      selectedValue: selectedMerchent,
      onChanged: (val) {
        setState(() {
          selectedMerchent = val.toString();
          tmpM = merchantController.merchantLookupList.firstWhere(
              (element) => element.merchantName == selectedMerchent);
        });
      },
      listOfItems: merchantController.merchantLookupList,
    );

    var myDropDownRider = MyDropDownRider(
        selectedValue: selectedRider,
        onChanged: (s) {
          setState(() {
            selectedRider = s.toString();

            tmpR = riderController.riderLookupList.firstWhere(
              (element) => element.riderName == selectedRider,
              orElse: () => RiderLookupDataDist(),
            );
          });
        },
        listOfItems: riderController.riderLookupList);

    var myDropDownWareHouse = Container(
      alignment: Alignment.centerLeft,
      child: MyDropDownWareHouse(
        selectedValue: selectedWareHouse,
        isExpanded: true,
        onChanged: (val) {
          setState(() {
            selectedWareHouse = val.toString();
            tmpW = wareHouseController.wareHouseLookupList.firstWhere(
                (element) => element.wareHouseName == selectedWareHouse,
                orElse: () => WareHouseDataDist());
          });
        },
        listOfItems: wareHouseController.wareHouseLookupList,
      ),
    );

    var mySearchDataBtn = Container(
        width: SizeConfig.safeScreenWidth,
        alignment: Alignment.centerRight,
        child: MyElevatedButton(
            text: 'Search',
            btnBackgroundColor: MyColors.btnColorGreen,
            onPressed: () {
              if (selectedRider != null &&
                  selectedRider!.isNotEmpty &&
                  tmpR != null) {
                clearData();
                loadData();
              } else {
                myToastError('Please Select Rider to Search');
              }
            }));

    var searchedCounter = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: ShowOrdersCount(
        text: 'Showing',
        alignment: Alignment.centerLeft,
        listLength: searchedOrdersList.length,
      ),
    );

    final searchedOrdersDataList = ListView.builder(
      itemCount: searchedOrdersList.length,
      itemBuilder: (BuildContext context, index) {
        return MyCard(
          dist: searchedOrdersList[index].transaction!,
          needToHideDeleteIcon: true,
          needToHideCheckBox: true,
          needToShowRiderRemarks: true,
        );
      },
    );

    var scanningCounter = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: ShowOrdersCount(
          text: 'Scanned',
          alignment: Alignment.centerRight,
          listLength: selectedRecords.length),
    );

    final scannedordersDatalist = ListView.builder(
      itemCount: scannedOrdersList.length,
      itemBuilder: (BuildContext context, index) {
        return myCard(
          scannedOrdersList[index],
        );
      },
    );

    var deliveryRescheduleBtn = MyElevatedButton(
        text: 'Reschedule Delivery',
        btnBackgroundColor: MyColors.btnColorGreen,
        btnPaddingHorizontalSize: 8,
        onPressed: () {
          // if (selectedWareHouse != null && selectedWareHouse!.isNotEmpty) {
          if (selectedRecords.isNotEmpty) {
            if (selectedWareHouse != null &&
                selectedWareHouse!.isNotEmpty &&
                selectedWareHouse !=
                    MyVariables.wareHouseDropdownSelectAllText &&
                tmpW?.wareHouseId != null) {
              myShowConfirmationDialog(
                  title: 'Reschedule Delivery',
                  description:
                      'Are you sure you want to make these orders as Inbound?',
                  onSavePressed: () {
                    myShowLoadingDialog(context);

                    // var data = wareHouseController.wareHouseLookupList.firstWhere(
                    //     (element) => element.wareHouseName == selectedWareHouse);

                    requestData = DeliveryRescheduleRequestData(
                        remarks: remarksController.text,
                        transactionIds: selectedRecords,
                        wareHouseId: tmpW!.wareHouseId!);

                    apiPostData
                        .patchDeliveryReschedule(requestData)
                        .then((value) {
                      if (value != null) {
                        if (mounted) {
                          removeDataLocally();
                          Get.isDialogOpen! ? tryToPop(context) : null;
                          myShowSuccessMSGDialog(
                              description:
                                  'Orders delivery reschedule successfully',
                              customOnPressedOK: () {
                                Get.isDialogOpen == true
                                    ? tryToPop(context)
                                    : null;
                                tryToPopTrue(context);
                              });
                        }
                      }
                    });
                  });
            } else {
              myToastError('Please select WareHouse');
            }
          } else {
            myToastError('Please scan orders to Reschedule Delivery');
          }
          // } else {
          //   myToastError('Please select WareHouse');
          // }
        });

    var appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBarWithBottom,
      child: SafeArea(
        child: AppBar(
          elevation: 0,
          backgroundColor: MyVariables.appBarBackgroundColor,
          iconTheme: MyVariables.appBarIconTheme,
          toolbarHeight: MyVariables.appbarHeight,
          title: const MyTextWidgetAppBarTitle(
            text: 'Sheet Clearance Inbound',
          ),
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
            ),
          ]),
          actions: [
            IconButton(
              icon: Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: SizeConfig.blockSizeHorizontal * 8,
              ),
              tooltip: 'Scan QR',
              onPressed: scanQR,
            ),
          ],
        ),
      ),
    );

    return DefaultTabController(
        length: _tabslength,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: MyColors.scaffoldBackgroundColor,
          appBar: appBar,
          body: TabBarView(children: [
            ///////Pending Scan//////
            Padding(
              padding: MyVariables.scaffoldBodyPadding,
              child: Column(
                children: [
                  const MySpaceHeight(heightSize: 1.5),
                  containerDatePickers,
                  const MySpaceHeight(heightSize: 1),
                  Row(
                    children: [
                      Expanded(child: myDropDownMerchant),
                      const MySpaceWidth(widthSize: 2),
                      Expanded(child: myDropDownRider),
                    ],
                  ),
                  const MySpaceHeight(heightSize: 1),
                  Row(
                    children: [
                      Expanded(child: searchedCounter),
                      Expanded(child: mySearchDataBtn)
                    ],
                  ),
                  const MySpaceHeight(heightSize: 1.5),
                  Expanded(
                    child: searchedOrdersDataList,
                  ),
                ],
              ),
            ),

            ////////Scanned////////
            Padding(
              padding: MyVariables.scaffoldBodyPadding,
              child: Column(
                children: [
                  const MySpaceHeight(heightSize: 1.5),
                  Row(
                    children: [
                      Expanded(child: myDropDownWareHouse),
                      Expanded(child: scanningCounter),
                    ],
                  ),
                  const MySpaceHeight(heightSize: 1.5),
                  Expanded(child: scannedordersDatalist),
                  deliveryRescheduleBtn,
                ],
              ),
            ),
          ]),
        ));
  }

  Widget myCard(SheetDetailDataDist dist) {
    return GestureDetector(
      onLongPress: () {
        myShowBottomSheet(context, [
          MyListTileBottomSheetMenuItem(
              titleTxt: 'Delivery Under Review',
              icon: Icons.keyboard_return_sharp,
              onTap: () {
                if (selectedWareHouse != null &&
                    selectedWareHouse!.isNotEmpty &&
                    selectedWareHouse !=
                        MyVariables.wareHouseDropdownSelectAllText &&
                    tmpW?.wareHouseId != null) {
                  tryToPop(context);
                  Get.dialog(MyUnderVerificationDialog(
                    transactionId: [dist.transaction!.transactionId!],
                    wareHouseId: tmpW!.wareHouseId!,
                  )).then((value) {
                    if (value == true) {
                      setState(() {
                        removeDataLocally();
                      });
                    }
                  });
                } else {
                  myToastError('Please select WareHouse');
                }
              }),
        ]);
      },
      child: MyCard(
        dist: dist.transaction!,
        isSelected: selectedRecords.contains(dist.transaction!.transactionId),
        needToHideCheckBox: true,
        needToHideDeleteIcon: false,
        needToShowRiderRemarks: true,
        deleteOnPressed: () {
          removeAndInsertInList(dist);
        },
      ),
    );
  }
}
