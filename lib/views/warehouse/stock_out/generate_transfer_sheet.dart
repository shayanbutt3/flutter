import 'dart:io';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/warehouse_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class GenerateTransferSheet extends StatefulWidget {
  const GenerateTransferSheet({Key? key}) : super(key: key);

  @override
  _GenerateTransferSheetState createState() => _GenerateTransferSheetState();
}

class _GenerateTransferSheetState extends State<GenerateTransferSheet> {
  QRViewController? qRcontroller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  ApiFetchData apiFetchData = ApiFetchData();
  Pagination pagination = Pagination();

  WareHouseAllController wareHouseAllController =
      Get.put(WareHouseAllController());

  List<int> selectedRecords = [];
  List<OrdersDataDist> scannedOrdersList = [];
  String trackingNumber = '';

  String? selectedWarehouse;
  WareHouseDataDist tmpW = WareHouseDataDist();

  EmployeeProfileDataDist? employeeDataDist;

  void addToList(OrdersDataDist d) {
    setState(() {
      scannedOrdersList.insert(0, d);
      selectedRecords.add(d.transactionId!);
      trackingNumber = '';
      myToastSuccess(MyVariables.addedSuccessfullyMSG);
      FlutterBeep.beep(false);
    });
  }

  loadScanData() {
    apiFetchData
        .getOrders(
            '',
            '',
            '',
            '',
            '',
            trackingNumber,
            '',
            '',
            '',
            MyVariables.paginationDisable,
            0,
            MyVariables.size,
            MyVariables.sortDirection,
            orderPhysicalStatusIds:
                MyVariables.ordersPhysicalStatusIdsToGenerateTransferSheet)
        .then(
      (value) {
        if (value != null) {
          if (mounted) {
            if (value.dist!.isNotEmpty) {
              var data = scannedOrdersList.where(
                (element) =>
                    element.trackingNumber == value.dist![0].trackingNumber,
              );
              if (data.isNotEmpty) {
                myToastError('Already Exists');
                setState(() {
                  trackingNumber = '';
                });
              } else {
                var dist = value.dist![0];
                if (dist.transactionStatusId ==
                        int.parse(MyVariables.orderStatusIdPostExReceived) ||
                    dist.transactionStatusId ==
                        int.parse(
                            MyVariables.orderStatusIdArrivedAtDestination) ||
                    dist.transactionStatusId ==
                        int.parse(MyVariables.orderStatusIdTransitHub)) {
                  if (selectedWarehouse?.toLowerCase() ==
                      dist.cityName!.toLowerCase()) {
                    addToList(dist);
                  } else {
                    qRcontroller!.pauseCamera();
                    myShowConfirmationDialog(
                        title: 'Other City Parcel',
                        description:
                            'Are you sure you want to add this other city parcel into this selected city parcels?',
                        onSavePressed: () {
                          addToList(dist);
                          tryToPopTrue(context);
                          setState(() {
                            trackingNumber = '';
                          });
                          qRcontroller!.resumeCamera();
                        },
                        onPressedCustomCloseBtn: () {
                          tryToPop(context);
                          setState(() {
                            trackingNumber = '';
                          });
                          qRcontroller!.resumeCamera();
                        });
                  }
                } else if (dist.transactionStatusId ==
                        int.parse(MyVariables.orderStatusIdArrivedAtOrigin) ||
                    dist.transactionStatusId ==
                        int.parse(MyVariables.orderStatusIdCustomerRefused) ||
                    dist.transactionStatusId ==
                        int.parse(MyVariables.orderStatusIdReturnRequested)) {
                  if (selectedWarehouse!.toLowerCase() ==
                      dist.originCity!.toLowerCase()) {
                    addToList(dist);
                  } else {
                    qRcontroller!.pauseCamera();
                    myShowConfirmationDialog(
                        title: 'Other City Parcel',
                        description:
                            'Are you sure you want to add this other city parcel into this selected city parcels?',
                        onSavePressed: () {
                          addToList(dist);
                          setState(() {
                            trackingNumber = '';
                          });
                          tryToPopTrue(context);
                          qRcontroller!.resumeCamera();
                        },
                        onPressedCustomCloseBtn: () {
                          setState(() {
                            trackingNumber = '';
                          });
                          tryToPop(context);
                          qRcontroller!.resumeCamera();
                        });
                  }
                } else {
                  addToList(dist);
                  setState(() {
                    trackingNumber = '';
                  });
                }
              }
            } else {
              myToastError(MyVariables.scanningWrongOrderMSG);
              setState(() {
                trackingNumber = '';
              });
            }
          }
        }
      },
    );
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
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qRcontroller!.resumeCamera();
    } else if (Platform.isIOS) {
      qRcontroller!.resumeCamera();
    }
  }

  @override
  void initState() {
    loadEmployeeData();
    super.initState();
  }

  removeFromList(List<int> records) {
    for (int i = 0; i < records.length; i++) {
      setState(() {
        scannedOrdersList
            .removeWhere((element) => element.transactionId == records[i]);
      });
    }
  }

  removeDataLocally() {
    removeFromList(selectedRecords);
    setState(() {
      selectedRecords = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBar,
      child: SafeArea(
        child: AppBar(
          title: const MyTextWidgetAppBarTitle(text: 'Generate Transfer Sheet'),
          flexibleSpace: const MyAppBarFlexibleContainer(),
          backgroundColor: MyVariables.appBarBackgroundColor,
          elevation: 0,
          toolbarHeight: MyVariables.appbarHeight,
          actions: [
            IconButton(
              onPressed: () {
                if (selectedWarehouse != null &&
                    selectedWarehouse !=
                        MyVariables.wareHouseDropdownSelectAllText) {
                  Get.dialog(
                    _buildQrView(context),
                    barrierDismissible: false,
                  ).then((value) => qRcontroller?.dispose());
                } else {
                  myToastError('Please select WareHouse to start scanning');
                }
              },
              icon: const Icon(
                Icons.qr_code_scanner,
                size: 38,
              ),
            ),
          ],
        ),
      ),
    );

    var warehouseDropDown = MyDropDownWareHouse(
        selectedValue: selectedWarehouse,
        isExpanded: true,
        onChanged: (newVal) {
          var data = employeeDataDist!.employeeWareHouses!
              .where((element) => element.wareHouseName == newVal);
          if (selectedRecords.isNotEmpty) {
            myShowConfirmationDialog(
                title: 'Change WareHouse',
                description:
                    'By changing WareHouse all scanned data will be removed.',
                onSavePressed: () {
                  setState(() {
                    selectedRecords = [];
                    scannedOrdersList = [];
                    if (data.isNotEmpty) {
                      myToastError(
                          'Please select other ware house to generate transfer sheet');
                      selectedWarehouse = null;
                      tmpW = WareHouseDataDist();
                    } else {
                      selectedWarehouse = newVal.toString();
                      tmpW = wareHouseAllController.wareHouseLookupAllList
                          .firstWhere(
                              (element) =>
                                  element.wareHouseName == selectedWarehouse,
                              orElse: () => WareHouseDataDist());
                    }
                  });
                  tryToPop(context);
                });
          } else {
            if (data.isNotEmpty) {
              myToastError(
                  'Please select other ware house to generate transfer sheet');
              setState(() {
                selectedWarehouse = null;
                tmpW = WareHouseDataDist();
              });
            } else {
              setState(() {
                selectedWarehouse = newVal.toString();
                tmpW = wareHouseAllController.wareHouseLookupAllList.firstWhere(
                    (element) => element.wareHouseName == selectedWarehouse,
                    orElse: () => WareHouseDataDist());
              });
            }
          }
        },
        listOfItems: wareHouseAllController.wareHouseLookupAllList);
    var row = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(child: warehouseDropDown),
          const MySpaceWidth(widthSize: 2),
          trackingNumber.isNotEmpty
              ? const CircularProgressIndicator()
              : Container(),
          Expanded(
            child: ShowOrdersCount(
              text: 'Scanned',
              alignment: Alignment.centerRight,
              listLength: scannedOrdersList.length,
            ),
          ),
        ],
      ),
    );

    var list = ListView.builder(
      itemCount: scannedOrdersList.length,
      itemBuilder: (BuildContext context, index) {
        return MyCard(
          dist: scannedOrdersList[index],
          needToHideCheckBox: true,
          deleteOnPressed: () {
            setState(
              () {
                selectedRecords.remove(scannedOrdersList[index].transactionId);
                scannedOrdersList.removeWhere((element) =>
                    element.trackingNumber ==
                    scannedOrdersList[index].trackingNumber);
              },
            );
          },
        );
      },
    );

    var generateTransferSheetBtn = MyElevatedButton(
      text: 'Generate Transfer Sheet',
      onPressed: () {
        if (selectedRecords.isNotEmpty) {
          if (selectedWarehouse != null &&
              selectedWarehouse != 'All' &&
              tmpW.wareHouseId != null) {
            Get.dialog(
                    MyGenerateTransferSheetDialog(
                      transactionIds: selectedRecords,
                      wareHouseId: tmpW.wareHouseId!,
                    ),
                    barrierDismissible: false)
                .then((value) {
              if (value == true) {
                setState(() {
                  removeDataLocally();
                });
              }
            });
          } else {
            myToastError('Please select warehouse');
          }
        } else {
          myToastError('Please scan order');
        }
      },
      btnBackgroundColor: MyColors.btnColorGreen,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      backgroundColor: MyColors.scaffoldBackgroundColor,
      body: Padding(
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            row,
            const MySpaceHeight(heightSize: 1),
            Expanded(
                child: scannedOrdersList.isEmpty
                    ? const MyNoDataToShowWidget()
                    : list),
            generateTransferSheetBtn
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // var scanArea = (MediaQuery.of(context).size.width < 400 ||
    //         MediaQuery.of(context).size.height < 400)
    //     ? 150.0
    //     : 500.0;
    return StatefulBuilder(
        builder: ((context, setState) => Dialog(
            alignment: Alignment.center,
            backgroundColor: Colors.black54,
            insetPadding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockSizeHorizontal * 3,
              vertical: SizeConfig.safeBlockSizeVertical * 2,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(SizeConfig.safeBlockSizeHorizontal * 2))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                        borderColor: Colors.red,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: SizeConfig.safeBlockSizeHorizontal * 80),
                    onPermissionSet: (ctrl, p) =>
                        _onPermissionSet(context, ctrl, p),
                  ),
                ),
                const MySpaceHeight(heightSize: 3),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: MyElevatedButton(
                            text: 'Flash',
                            btnBackgroundColor: MyColors.btnColorGreen,
                            onPressed: () async {
                              await qRcontroller?.toggleFlash();
                              setState(() {});
                              qRcontroller?.getFlashStatus();
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: MyElevatedButton(
                            text: 'Switch Camera',
                            btnBackgroundColor: MyColors.btnColorGreen,
                            onPressed: () async {
                              await qRcontroller?.flipCamera();
                              setState(() {});
                              qRcontroller?.getCameraInfo();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  //     Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Container(
                  //       margin: const EdgeInsets.all(8),
                  //       child: MyElevatedButton(
                  //         text: 'Pause',
                  //         btnBackgroundColor: MyColors.btnColorGreen,
                  //         onPressed: () async {
                  //           await controller?.pauseCamera();
                  //         },
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: const EdgeInsets.all(8),
                  //       child: MyElevatedButton(
                  //         text: 'Resume',
                  //         btnBackgroundColor: MyColors.btnColorGreen,
                  //         onPressed: () async {
                  //           await controller?.resumeCamera();
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // )
                ),
                const MySpaceHeight(heightSize: 3),
                Flexible(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: MyElevatedButton(
                          text: 'Back',
                          onPressed: () {
                            Get.back();
                            qRcontroller!.dispose();
                          },
                        ),
                      ),
                    )
                  ],
                ))
              ],
            ))));
  }

  void _onQRViewCreated(QRViewController qRcontroller) {
    setState(() {
      this.qRcontroller = qRcontroller;
      qRcontroller.resumeCamera();
    });
    qRcontroller.scannedDataStream.listen((scanData) {
      setState(() {
        trackingNumber = scanData.code.toString().trim();
      });
      loadScanData();
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  void dispose() {
    qRcontroller?.dispose();
    super.dispose();
  }
}
