import 'package:backoffice_new/controllers/warehouse_controller.dart';
import 'package:backoffice_new/custom/custom_widgets/show_confirmation_dialog.dart';
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

class GenerateReturnSheet extends StatefulWidget {
  const GenerateReturnSheet({Key? key}) : super(key: key);

  @override
  _GenerateReturnSheetState createState() => _GenerateReturnSheetState();
}

class _GenerateReturnSheetState extends State<GenerateReturnSheet>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  final _tabsLength = 2;

  final RiderController riderController = Get.put(RiderController());
  final WareHouseAllController wareHouseController =
      Get.put(WareHouseAllController());

  List<int> selectedRecords = [];
  List<OrdersDataDist> scannedOrdersList = [];
  List<OrdersDataDist> searchedOrdersList = [];

  String? selectedRider;
  RiderLookupDataDist? tmpR;
  String? selectedWareHouse;
  WareHouseDataDist? tmpW;

  String? orderTrackingNumber = '';

  GenerateReturnSheetRequestData requestData = GenerateReturnSheetRequestData();
  ValidateGenerateSheetData generateSheet = ValidateGenerateSheetData();

  int page = 0;

  late String currentDateString;

  loadData() async {
    myShowLoadingDialog(context);
    apiFetchData
        .getOrders(
      '',
      '',
      false,
      MyVariables.ordersStatusIdsToGenerateReturnSheet,
      '',
      '',
      fromDateController.text,
      toDateController.text,
      true,
      MyVariables.paginationDisable,
      page,
      MyVariables.size,
      MyVariables.sortDirection,
      orderPhysicalStatusIds:
          MyVariables.ordersPhysicalStatusIdsToGenerateReturnSheet,
    )
        .then((value) {
      if (value != null) {
        if (mounted) {
          Get.isDialogOpen! ? tryToPop(context) : null;
          if (value.dist!.isNotEmpty) {
            setState(() {
              // searchedOrdersList = [];
              // for (var element in value.dist!) {
              //   if (element.returnRequested == true) {
              //     searchedOrdersList.add(element);
              //   } else {
              //     debugPrint(
              //         'Not Added because this ${element.trackingNumber} have return requested == false');
              //   }
              // }
              clearAllData();
              searchedOrdersList.addAll(value.dist!);
            });
          } else {
            setState(() {
              selectedRecords = [];
              scannedOrdersList = [];
              searchedOrdersList = [];
            });
            myToastSuccess(MyVariables.notFoundErrorMSG);
          }
        }
      } else {
        // Get.isDialogOpen! ? tryToPop(context) : null;
      }
    });
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
        searchedOrdersList
            .removeWhere((element) => element.transactionId == records[i]);
      });
    }
  }

  removeDataLocally() {
    removeFromList(selectedRecords);
    setState(() {
      selectedRider = null;
      selectedRecords = [];
      scannedOrdersList = [];
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

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => loadData());
    // _tabController = TabController(length: _tabsLength, vsync: this);
  }

  Future _scanQR() async {
    if (selectedRider != null) {
      try {
        await FlutterBarcodeScanner.scanBarcode(
                'green', 'Cancel', true, ScanMode.QR)
            .then((value) {
          if (value != '-1' && value.isNotEmpty) {
            setState(() {
              orderTrackingNumber = value.trim();
            });
          }
        });
      } catch (e) {
        myToastError('Exception: $e');
        rethrow;
      }
    } else {
      myToastError('Please Select Rider to Scan');
    }
  }

  onSelected(bool selected, OrdersDataDist ordersDataDist) {
    setState(() {
      if (selectedRecords.contains(ordersDataDist.transactionId)) {
        selectedRecords.remove(ordersDataDist.transactionId);
        scannedOrdersList.removeWhere((element) =>
            element.trackingNumber == ordersDataDist.trackingNumber);
      } else if (selected) {
        selectedRecords.add(ordersDataDist.transactionId!);
        scannedOrdersList.insert(0, ordersDataDist);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    orderTrackingNumber != null && orderTrackingNumber!.isNotEmpty
        ? apiFetchData
            .getOrders(
                '',
                '',
                false,
                '',
                '',
                orderTrackingNumber,
                '',
                '',
                true,
                MyVariables.paginationDisable,
                page,
                MyVariables.size,
                MyVariables.sortDirection,
                orderPhysicalStatusIds:
                    MyVariables.ordersPhysicalStatusIdsToGenerateReturnSheet)
            .then((value) {
            if (value != null) {
              if (mounted) {
                if (value.dist!.isNotEmpty) {
                  var dist = value.dist![0];
                  var data = scannedOrdersList.where((element) =>
                      element.trackingNumber == dist.trackingNumber);

                  if (data.isNotEmpty) {
                    myToastError('Already Exists');
                    setState(() {
                      orderTrackingNumber = '';
                    });
                  } else {
                    setState(() {
                      scannedOrdersList.insert(0, dist);
                      selectedRecords.add(dist.transactionId!);
                      FlutterBeep.beep(false);
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
        : debugPrint('');

    var appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBarWithBottom,
      child: SafeArea(
        child: AppBar(
          elevation: 0,
          backgroundColor: MyVariables.appBarBackgroundColor,
          iconTheme: MyVariables.appBarIconTheme,
          toolbarHeight: MyVariables.appbarHeight,
          title: const MyTextWidgetAppBarTitle(
            text: 'Generate Return Sheet',
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

    var myDropDownRiderAndWareHouse = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: MyDropDownRider(
            selectedValue: selectedRider,
            onChanged: (newValue) {
              setState(() {
                selectedRider = newValue.toString();
                tmpR = riderController.riderLookupList.firstWhere(
                    (element) => element.riderName == selectedRider);
                myShowLoadingDialog(context);
                apiFetchData
                    .getValidateGenerateSheet(
                        tmpR?.riderId, MyVariables.sheetTypeIdReturn)
                    .then((value) {
                  if (value != null) {
                    Get.isDialogOpen! ? Get.back() : null;
                    if (mounted) {
                      setState(() {
                        if (value.isRiderHasAnyPendingSheet == true) {
                          myShowErrorMSGDialog(
                              description:
                                  'Rider\'s previous sheets are not closed, please close previous sheets to generate new sheet',
                              customOnPressedOK: () {
                                setState(() {
                                  selectedRider = null;
                                  tmpR = null;
                                });
                                Get.isDialogOpen! == true
                                    ? tryToPop(context)
                                    : null;
                              });
                        }
                      });
                    }
                  }
                });
              });
            },
            listOfItems:
                //  riderLookupList,
                riderController.riderLookupList,
          ),
        ),
        const MySpaceWidth(widthSize: 2),
        Expanded(
            child: MyDropDownWareHouse(
                selectedValue: selectedWareHouse,
                onChanged: (s) {
                  setState(() {
                    selectedWareHouse = s.toString();
                    tmpW =
                        wareHouseController.wareHouseLookupAllList.firstWhere(
                      (element) => element.wareHouseName == selectedWareHouse,
                      orElse: () => WareHouseDataDist(),
                    );
                  });
                },
                listOfItems: wareHouseController.wareHouseLookupAllList))
      ]),
    );

    var containerDropdownScan = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
            child: myDropDownRiderAndWareHouse,
          ),
          orderTrackingNumber!.isNotEmpty
              ? const MyLoadingIndicator()
              : Container(),
        ],
      ),
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

    var containerDropdownSearch = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
            child: myDropDownRiderAndWareHouse,
          ),
        ],
      ),
    );

    var mySearchDataBtn = Container(
        width: SizeConfig.safeScreenWidth,
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ShowOrdersCount(
                text: selectedRecords.isNotEmpty ? 'Selected' : null,
                listLength: selectedRecords.isNotEmpty
                    ? selectedRecords.length
                    : searchedOrdersList.length,
                totalElements: searchedOrdersList.length,
              ),
            ),
            MyElevatedButton(
                text: 'Search',
                btnBackgroundColor: MyColors.btnColorGreen,
                onPressed: () {
                  if (selectedRider != null) {
                    loadData();
                  } else {
                    myToastError('Please Select Rider to Search');
                  }
                })
          ],
        ));

    final scannedOrdersDataList = ListView.builder(
        itemCount: scannedOrdersList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCard(
            dist: scannedOrdersList[index],
            needToHideCheckBox: true,
            deleteOnPressed: () {
              setState(() {
                selectedRecords.remove(scannedOrdersList[index].transactionId);
                scannedOrdersList.removeWhere((element) =>
                    element.trackingNumber ==
                    scannedOrdersList[index].trackingNumber);
              });
            },
          );
        });

    final searchedOrdersDataList = ListView.builder(
        itemCount: searchedOrdersList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCard(
            dist: searchedOrdersList[index],
            needToHideDeleteIcon: true,
            isSelected: selectedRecords
                .contains(searchedOrdersList[index].transactionId),
            onChangedCheckBox: (b) {
              onSelected(b!, searchedOrdersList[index]);
            },
          );
        });

    var generateReturnSheetButton = MyElevatedButton(
      text: 'Generate Return Sheet',
      btnBackgroundColor: MyColors.btnColorGreen,
      btnPaddingHorizontalSize: 8,
      onPressed: () {
        if (selectedRider != null && selectedRider!.isNotEmpty) {
          if (selectedWareHouse != null && selectedWareHouse!.isNotEmpty) {
            if (selectedRecords.isNotEmpty) {
              myShowConfirmationDialog(
                  title: 'Generate Return Sheet',
                  description:
                      'Are you sure you want to generate return sheet?',
                  onSavePressed: () {
                    myShowLoadingDialog(context);
                    requestData = GenerateReturnSheetRequestData(
                        riderId: tmpR?.riderId,
                        transactionIds: selectedRecords,
                        warehouseId: tmpW?.wareHouseId);
                    apiPostData
                        .postGenerateReturnSheet(requestData)
                        .then((value) {
                      if (value != null) {
                        if (mounted) {
                          // Fluttertoast.showToast(msg: value.statusMessage!);
                          // clearAllData();
                          removeDataLocally();
                          Get.isDialogOpen! ? tryToPop(context) : null;
                          myShowSuccessMSGDialog(
                              description:
                                  'Return sheet has been generated successfully',
                              customOnPressedOK: () {
                                Get.isDialogOpen! ? tryToPop(context) : null;
                                tryToPopTrue(context);
                              });
                        }
                      } else {
                        // Get.isDialogOpen! ? tryToPop(context) : null;
                      }
                    });
                  });
            } else {
              myToastError('Please scan/search Orders');
            }
          } else {
            myToastError('Please select Warehouse');
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
                  containerDropdownScan,
                  const MySpaceHeight(heightSize: 1.5),
                  ShowOrdersCount(
                    text: 'Scanned',
                    alignment: Alignment.centerRight,
                    listLength: selectedRecords.length,
                  ),
                  const MySpaceHeight(heightSize: 1.5),
                  Expanded(child: scannedOrdersDataList),
                  generateReturnSheetButton,
                ],
              ),
            ),

            /////////////************ Via Search ***********//////////////
            Padding(
              padding: MyVariables.scaffoldBodyPadding,
              child: Column(
                children: [
                  const MySpaceHeight(heightSize: 1.5),
                  containerDatePickers,
                  const MySpaceHeight(heightSize: 1),
                  containerDropdownSearch,
                  mySearchDataBtn,
                  const MySpaceHeight(heightSize: 1.5),
                  Expanded(
                      child: searchedOrdersList.isEmpty
                          ? const MyNoDataToShowWidget()
                          : searchedOrdersDataList),
                  generateReturnSheetButton,
                ],
              ),
            ),
          ]),
        ));
  }
}
