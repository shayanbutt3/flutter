import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/merchant_controller.dart';
import 'package:backoffice_new/controllers/rider_controller.dart';
import 'package:backoffice_new/controllers/warehouse_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';
import '../custom/custom_widgets/custom_widgets.dart';

class MarkDeliveryReschdule extends StatefulWidget {
  const MarkDeliveryReschdule({Key? key}) : super(key: key);

  @override
  _MarkDeliveryReschduleState createState() => _MarkDeliveryReschduleState();
}

class _MarkDeliveryReschduleState extends State<MarkDeliveryReschdule> {
  ApiFetchData apiFetchData = ApiFetchData();

  MerchantController merchantController = Get.put(MerchantController());
  WareHouseController wareHouseController = Get.put(WareHouseController());
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

  String trackingNumber = '';
  final tabLength = 2;
  late String currentDate;

  loadData() {
    myShowLoadingDialog(context);
    apiFetchData
        .getSheetDetail(
      tmpR!.riderId,
      MyVariables.orderStatusIdAttempted,
      '',
      MyVariables.sheetTypeIdDelivery,
      '',
      '',
      fromDateController.text,
      toDateController.text,
      MyVariables.paginationDisable,
      0,
      MyVariables.size,
      MyVariables.sortDirection,
      orderPhysicalStatusIds:
          MyVariables.orderPhysicalStatusInPostMasterForDelivery,
      linkOrderStatusAndPhysicalStatusIds: true,
      merchantId: tmpM == null ? '' : tmpM!.merchantId,
      sheetOrderStatusIds: MyVariables.orderStatusIdAttempted,
    )
        .then((value) {
      if (value != null) {
        if (mounted) {
          if (value.dist!.isNotEmpty) {
            setState(() {
              pendingScannedList.addAll(value.dist!);
            });
          } else {
            myToastError(MyVariables.notFoundErrorMSG);
          }
        }
      }
      Get.isDialogOpen! ? Get.back() : null;
    });
  }

  Future scanQR() async {
    if (pendingScannedList.isNotEmpty) {
      try {
        FlutterBarcodeScanner.getBarcodeStreamReceiver(
                'green', 'cancel', true, ScanMode.QR)!
            .listen((value) {
          if (value != '-1' && value.toString().isNotEmpty) {
            if (!mounted) return;
            setState(() {
              trackingNumber = value.toString().trim();

              var record = pendingScannedList.firstWhere(
                  (element) =>
                      element.transaction!.trackingNumber ==
                      trackingNumber.toString(),
                  orElse: () => SheetDetailDataDist());
              if (record.transaction != null &&
                  record.transaction!.trackingNumber != null &&
                  record.transaction!.trackingNumber!.isNotEmpty) {
                var scanned = selectedRecords.where(
                    (element) => element == record.transaction!.transactionId);
                if (scanned.isNotEmpty) {
                  myToastError('Already exits');
                  setState(() {
                    trackingNumber = '';
                  });
                } else {
                  setState(() {
                    scannedList.insert(0, record);
                    FlutterBeep.beep(false);
                    selectedRecords.add(record.transaction!.transactionId!);
                    pendingScannedList.remove(record);
                    myToastSuccess(MyVariables.addedSuccessfullyMSG);
                    trackingNumber = '';
                  });
                }
              } else {
                myToastError(MyVariables.scanningWrongOrderMSG);
                setState(() {
                  trackingNumber = '';
                });
              }
            });
          }
        });
      } on PlatformException {
        throw Exception('Failed to Load Data');
      }
    } else {
      myToastError('Search order to scan');
    }
  }

  removeDataFromList(List<int> records) {
    setState(() {
      for (int i = 0; i < records.length; i++) {
        scannedList.removeWhere(
            (element) => element.transaction!.transactionId == records[i]);
      }
    });
  }

  removeDataLocally() {
    removeDataFromList(selectedRecords);
    setState(() {
      selectedRecords = [];
    });
  }

  removeAndInsertInList(SheetDetailDataDist sheetDetailDist) {
    setState(() {
      scannedList.removeWhere((element) =>
          element.transaction!.transactionId ==
          sheetDetailDist.transaction!.transactionId);

      pendingScannedList.insert(0, sheetDetailDist);

      selectedRecords.removeWhere(
          (element) => element == sheetDetailDist.transaction!.transactionId);
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

    var dateDropDownOnSearchTab = Row(
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

    var appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBarWithBottom,
      child: SafeArea(
        child: AppBar(
          title: const MyTextWidgetAppBarTitle(text: 'Reschedule Delivery'),
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
              onPressed: scanQR,
              icon: const Icon(Icons.qr_code_scanner),
              iconSize: SizeConfig.blockSizeHorizontal * 8,
            )
          ],
        ),
      ),
    );

    var merchantDropDown = MyDropDownMerchant(
      selectedValue: selectedMerchant,
      onChanged: (s) {
        setState(() {
          selectedMerchant = s.toString();
          tmpM = merchantController.merchantLookupList.firstWhere(
              (element) => element.merchantName == selectedMerchant);
        });
      },
      listOfItems: merchantController.merchantLookupList,
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

    var merchantDropDownAndRiderDropDown = Row(
      children: [
        Expanded(
            child: MyDropDownRider(
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
                listOfItems: riderController.riderLookupList)),
        const MySpaceWidth(widthSize: 2),
        Expanded(child: merchantDropDown),
      ],
    );

    var searchAndCounter = SizedBox(
        width: SizeConfig.screenWidth,
        child: Row(
          children: [
            ShowOrdersCount(
              listLength: pendingScannedList.length,
              totalElements: pendingScannedList.length,
              alignment: Alignment.centerRight,
            ),
            const MySpaceWidth(widthSize: 2),
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
                      pendingScannedList = [];
                      selectedRecords = [];
                      scannedList = [];
                    });
                    loadData();
                  } else {
                    myToastError('Please select rider');
                  }
                },
              ),
            )),
          ],
        ));

    var counterForScan = ShowOrdersCount(
      text: 'Scanned',
      listLength: scannedList.length,
      alignment: Alignment.centerRight,
    );

    var counterAndWareHouseDropDown = Row(
      children: [
        Expanded(child: wareHouseDropDown),
        Expanded(child: counterForScan)
      ],
    );

    var listOfPendingScanned = ListView.builder(
        itemCount: pendingScannedList.length,
        itemBuilder: (BuildContext contex, index) {
          return MyCard(
            dist: pendingScannedList[index].transaction!,
            needToHideCheckBox: true,
            needToHideDeleteIcon: true,
            needToShowRiderRemarks: true,
          );
        });

    var listOfScannedOrders = ListView.builder(
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

    var rescheduleDeliveryBtn = MyElevatedButton(
      text: 'Reschedule Delivery',
      btnBackgroundColor: MyColors.btnColorGreen,
      onPressed: () {
        if (selectedRecords.isNotEmpty) {
          if (selectedWareHouse != null &&
              selectedWareHouse!.isNotEmpty &&
              selectedWareHouse != MyVariables.wareHouseDropdownSelectAllText &&
              tmpW?.wareHouseId != null) {
            Get.dialog(MyDeliveryRescheduleDialog(
              transactionIds: selectedRecords,
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
        } else {
          myToastError('Please scan order');
        }
      },
    );

    var colOfTab1 = Column(
      children: [
        const MySpaceHeight(heightSize: 1),
        dateDropDownOnSearchTab,
        const MySpaceHeight(heightSize: 1),
        merchantDropDownAndRiderDropDown,
        const MySpaceHeight(heightSize: 1),
        searchAndCounter,
        const MySpaceHeight(heightSize: 1),
        Expanded(
            child: pendingScannedList.isEmpty
                ? const MyNoDataToShowWidget()
                : listOfPendingScanned),
      ],
    );

    var colOfTab2 = Column(
      children: [
        const MySpaceHeight(heightSize: 1),
        counterAndWareHouseDropDown,
        const MySpaceHeight(heightSize: 1),
        Expanded(
            child: scannedList.isEmpty
                ? const MyNoDataToShowWidget()
                : listOfScannedOrders),
        rescheduleDeliveryBtn,
      ],
    );

    return DefaultTabController(
      length: tabLength,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.scaffoldBackgroundColor,
        appBar: appBar,
        body: Padding(
          padding: MyVariables.scaffoldBodyPadding,
          child: TabBarView(
            children: [
              /////////////************ Pending Scan ***********//////////////
              colOfTab1,
              /////////////************ Scanned ***********//////////////
              colOfTab2
            ],
          ),
        ),
      ),
    );
  }
}
