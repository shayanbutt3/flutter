import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/sheets_controller.dart';
import 'package:backoffice_new/controllers/warehouse_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/show_confirmation_dialog.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../custom/custom_widgets/show_response_dialog.dart';

class StockInTransferred extends StatefulWidget {
  const StockInTransferred({Key? key}) : super(key: key);

  @override
  _StockInTransferredState createState() => _StockInTransferredState();
}

class _StockInTransferredState extends State<StockInTransferred>
    with SingleTickerProviderStateMixin {
  final WareHouseController wareHouseController =
      Get.put(WareHouseController());
  final SheetsController sheetsController = Get.put(SheetsController());
  TextEditingController sheetTagController = TextEditingController();

  ApiPostData apiPostData = ApiPostData();
  TransferInboundRequestData requestData = TransferInboundRequestData();
  TransitHubRequestData transitHubRequestData = TransitHubRequestData();
  WaitingForTransferDeManifestOrderRequestData
      waitingForTransferDeManifestOrderRequestData =
      WaitingForTransferDeManifestOrderRequestData();

  SharedPreferences? localStorage;

  List<int> selectedRecords = [];
  List<SheetDetailDataDist> searchedOrdersList = [];
  String orderTrackingNumber = '';

  ApiFetchData apiFetchData = ApiFetchData();

  EmployeeProfileDataDist? employeeDataDist;
  SheetDetailDataDist? sheetDetailDataDist;

  Future _scanQR() async {
    if (searchedOrdersList.isNotEmpty) {
      try {
        FlutterBarcodeScanner.getBarcodeStreamReceiver(
                'green', 'Cancel', true, ScanMode.QR)!
            .listen((value) {
          if (value != '-1' && value.isNotEmpty) {
            var tmpVal = value.toString().trim();
            if (tmpVal.startsWith('-', 2)) {
              var data = searchedOrdersList.firstWhere(
                  (element) =>
                      element.transaction?.trackingNumber ==
                      value.toString().trim(),
                  orElse: () => SheetDetailDataDist());
              if (data.transaction?.trackingNumber != null) {
                var scanned = selectedRecords.where(
                    (element) => element == data.transaction?.transactionId);
                if (scanned.isNotEmpty) {
                  myToastError('Already Exists');
                } else {
                  setState(() {
                    selectedRecords.add(data.transaction!.transactionId!);
                  });
                  myToastSuccess('Added Successfully');
                  FlutterBeep.beep(false);
                }
              } else {
                myToastError(MyVariables.scanningWrongOrderMSG);
              }
            } else {
              myToastError(MyVariables.scanningWrongQRMSG);
            }
          }
        });
      } catch (e) {
        myToastError('Exception: $e');
        rethrow;
      }
    } else {
      myToastError('Please search orders to scan');
    }
  }

  loadData() async {
    if (sheetTagController.text.isNotEmpty) {
      myShowLoadingDialog(context);
      apiFetchData
          .getSheetDetail(
        '',
        MyVariables.orderStatusIdsToTransferInbound,
        '',
        '',
        MyVariables.sheetStatusIdsDispatchedAndStockInProgress,
        '',
        '',
        '',
        MyVariables.paginationDisable,
        0,
        MyVariables.size,
        MyVariables.sortDirection,
        sheetOrderStatusIds: MyVariables.orderStatusIdsToTransferInbound,
        sheetTag: sheetTagController.text,
      )
          .then((value) async {
        if (value != null) {
          if (mounted) {
            Get.isDialogOpen! ? tryToPop(context) : null;
            if (value.dist!.isNotEmpty) {
              var dist = value.dist![0];
              var data = employeeDataDist!.employeeWareHouses!.where(
                  (element) =>
                      element.wareHouseId == dist.transaction!.wareHouseId);
              if (data.isNotEmpty) {
                localStorage = await SharedPreferences.getInstance();
                bool? isUserCityHasMultipleWarehouse =
                    localStorage!.getBool('isUserCityHasMultipleWarehouse');
                if (isUserCityHasMultipleWarehouse == true) {
                  setState(() {
                    searchedOrdersList.addAll(value.dist!);
                  });
                } else {
                  myShowConfirmationDialog(
                      title: 'Transfer Inbound',
                      description:
                          'This city has only one warehouse.\nAre you sure you want to receive this sheet?',
                      onSavePressed: () {
                        myShowLoadingDialog(context);
                        waitingForTransferDeManifestOrderRequestData =
                            WaitingForTransferDeManifestOrderRequestData(
                          sheetId: dist.sheetId,
                        );
                        apiPostData
                            .patchWaitingForTransferDeManifestOrder(
                                waitingForTransferDeManifestOrderRequestData)
                            .then((value) {
                          if (value != null) {
                            if (mounted) {
                              myShowSuccessMSGDialog(
                                  description:
                                      'Status update to De Manifest TS Successfully',
                                  customOnPressedOK: () {
                                    tryToPop(context);
                                    tryToPop(context);
                                    tryToPopTrue(context);
                                    removeDataLocally();
                                  });
                            }
                          }
                        });
                      },
                      onPressedCustomCloseBtn: () {
                        setState(() {
                          sheetTagController.text = '';
                          tryToPop(context);
                        });
                      });
                }
              } else {
                myShowConfirmationDialog(
                    title: 'Transfer Inbound',
                    description:
                        'This sheet is not for your warehouse.\nAre you sure you want to move it to transit Hub',
                    onSavePressed: () {
                      myShowLoadingDialog(context);
                      transitHubRequestData = TransitHubRequestData(
                        sheetId: dist.sheetId,
                      );
                      apiPostData
                          .patchTransitHub(transitHubRequestData)
                          .then((value) {
                        if (value != null) {
                          if (mounted) {
                            myShowSuccessMSGDialog(
                              description:
                                  'Status update to Transit Hub Successfully',
                              customOnPressedOK: () {
                                tryToPop(context);
                                tryToPop(context);
                                tryToPopTrue(context);
                                removeDataLocally();
                              },
                            );
                          }
                        }
                      });
                    },
                    onPressedCustomCloseBtn: () {
                      setState(() {
                        sheetTagController.text = '';
                        tryToPop(context);
                      });
                    });
              }
            } else {
              myToastSuccess(MyVariables.notFoundErrorMSG);
            }
          }
        } else {
          // Get.isDialogOpen! ? tryToPop(context) : null;
        }
      });
    } else {
      myToastError('Please Enter Sheet Tag to Search');
    }
  }

  loadEmployeeData() {
    apiFetchData.getEmployeeProfile().then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            employeeDataDist = value.dist;
          });
        }
      }
    });
  }

  @override
  void initState() {
    loadEmployeeData();
    super.initState();
  }

  removeDataLocally() {
    setState(() {
      selectedRecords = [];
      searchedOrdersList = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBar,
      child: SafeArea(
        child: AppBar(
          elevation: 0,
          backgroundColor: MyVariables.appBarBackgroundColor,
          iconTheme: MyVariables.appBarIconTheme,
          toolbarHeight: MyVariables.appbarHeight,
          title: const MyTextWidgetAppBarTitle(text: 'Transfer Inbound'),
          flexibleSpace: const MyAppBarFlexibleContainer(),
          actions: [
            IconButton(
                onPressed: _scanQR,
                tooltip: 'Scan QR',
                icon: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: SizeConfig.blockSizeHorizontal * 8,
                ))
          ],
        ),
      ),
    );

    // var warehouseDropDown = Container(
    //   alignment: Alignment.centerLeft,
    //   child: MyDropDownWareHouse(
    //     isExpanded: true,
    //     selectedValue: selectedWareHouse,
    //     onChanged: (a) {
    //       setState(() {
    //         selectedWareHouse = a.toString();
    //         tmpW = wareHouseController.wareHouseLookupList.firstWhere(
    //             (element) => element.wareHouseName == selectedWareHouse);
    //         selectedSheet = null;
    //         sheetsController.loadData(
    //             tmpW?.wareHouseId,
    //             MyVariables.sheetTypeIdTransfer,
    //             MyVariables.sheetStatusIdsDispatchedAndStockInProgress,
    //             '',
    //             '',
    //             MyVariables.paginationDisable,
    //             0,
    //             MyVariables.size,
    //             MyVariables.sortDirection);
    //       });
    //     },
    //     listOfItems: wareHouseController.wareHouseLookupList,
    //   ),
    // );

    var textFormFieldforSheetTag = MyTextFieldCustom(
      controller: sheetTagController,
      onChanged: (a) {
        setState(() {});
      },
      needToHideIcon: true,
      labelText: 'Sheet Tag',
    );

    // var sheetNumbersDropDown = Container(
    //   alignment: Alignment.centerLeft,
    //   child: MyDropDownSheetNumbers(
    //     isExpanded: true,
    //     selectedValue: selectedSheet,
    //     onChanged: (newSheet) {
    //       setState(() {
    //         selectedSheet = newSheet.toString();
    //         tmpS = sheetsController.sheetsList.firstWhere((element) =>
    //             element.sheetNumber ==
    //             selectedSheet?.split(" ")[0].toString().trim());
    //         searchedOrdersList = [];
    //       });
    //       var data = employeeDataDist!.employeeWareHouses!
    //           .where((element) => element.wareHouseId == tmpW!.wareHouseId);
    //       if (data.isEmpty) {
    //         myShowConfirmationDialog(
    //             title: 'Transfer Inbound',
    //             description:
    //                 'Are you sure you want to inbound this sheet, as this sheet is not for your warehouse.\nPacel\'s status will be changed to Transit Hub.',
    //             onSavePressed: () {
    //               myShowLoadingDialog(context);
    //               transitHubRequestData = TransitHubRequestData(
    //                 sheetId: tmpS!.sheetId,
    //               );
    //               apiPostData
    //                   .patchTransitHub(transitHubRequestData)
    //                   .then((value) {
    //                 if (value != null) {
    //                   if (mounted) {
    //                     myShowSuccessMSGDialog(
    //                       description:
    //                           'Status update to Transit Hub successfully',
    //                       customOnPressedOK: () {
    //                         tryToPop(context);
    //                         tryToPop(context);
    //                         tryToPop(context);
    //                         removeDataLocally();
    //                       },
    //                     );
    //                   }
    //                 }
    //               });
    //             },
    //             onPressedCustomCloseBtn: () {
    //               setState(() {
    //                 selectedWareHouse = null;
    //                 tmpW = null;
    //                 selectedSheet = null;
    //                 tmpS = null;
    //                 tryToPop(context);
    //               });
    //             });
    //       }
    //     },
    //     listOfItems: sheetsController.sheetsList,
    //   ),
    // );

    var counter = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: ShowOrdersCount(
        text: 'Showing',
        alignment: Alignment.centerRight,
        listLength: searchedOrdersList.length,
      ),
    );

    var mySearchDataBtn = Container(
      alignment: Alignment.centerRight,
      child: MyElevatedButton(
          text: 'Search',
          btnBackgroundColor: MyColors.btnColorGreen,
          onPressed: () {
            FocusScope.of(context).unfocus();
            setState(() {
              searchedOrdersList = [];
              selectedRecords = [];
            });
            loadData();
          }),
    );

    final searchedOrdersDataList = ListView.builder(
        itemCount: searchedOrdersList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCard(
            dist: searchedOrdersList[index].transaction!,
            isSelected: selectedRecords
                .contains(searchedOrdersList[index].transaction!.transactionId),
            needToHideDeleteIcon: true,
            needToHideCheckBox: true,
            needToShowSelectionTick: true,
          );
        });

    var stockInTransferredButton = MyElevatedButton(
      text: 'Transfer Inbound',
      btnBackgroundColor: MyColors.btnColorGreen,
      btnPaddingHorizontalSize: 8,
      onPressed: () {
        //  if (selectedWareHouse != null && selectedWareHouse!.isNotEmpty) {
        if (selectedRecords.isNotEmpty) {
          myShowConfirmationDialog(
              title: 'Transfer Inbound',
              description:
                  'Are you sure you want to mark these parcels as Inbound?',
              onSavePressed: () {
                myShowLoadingDialog(context);
                requestData = TransferInboundRequestData(
                  transactionIds: selectedRecords,
                );

                apiPostData.patchTransferInbound(requestData).then((value) {
                  if (value != null) {
                    if (mounted) {
                      removeDataLocally();
                      Get.isDialogOpen! ? tryToPop(context) : null;
                      myShowSuccessMSGDialog(
                          description: 'Orders Inbounded successfully',
                          customOnPressedOK: () {
                            Get.isDialogOpen! ? tryToPop(context) : null;
                            tryToPopTrue(context);
                          });
                    }
                  }
                });
              });
        } else {
          myToastError('Please scan Orders');
        }
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffoldBackgroundColor,
      appBar: appBar,
      body: Padding(
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            const MySpaceHeight(heightSize: 1),
            Row(
              children: [
                Expanded(flex: 2, child: textFormFieldforSheetTag),
                const MySpaceWidth(widthSize: 2),
                Expanded(child: mySearchDataBtn)
              ],
            ),
            const MySpaceHeight(heightSize: 1),
            Row(
              children: [
                Expanded(child: counter),
              ],
            ),
            const MySpaceHeight(heightSize: 1.5),
            Expanded(
              child: searchedOrdersDataList,
            ),
            stockInTransferredButton,
          ],
        ),
      ),
    );
  }
}
