import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/merchant_controller.dart';
import 'package:backoffice_new/controllers/rider_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
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
import '../../custom/custom_widgets/my_card.dart';

class MarkPicked extends StatefulWidget {
  const MarkPicked({Key? key}) : super(key: key);

  @override
  _MarkPickedState createState() => _MarkPickedState();
}

class _MarkPickedState extends State<MarkPicked>
    with SingleTickerProviderStateMixin {
  RiderLookupDataDist? tmpR;

  final MerchantController merchantController = Get.put(MerchantController());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  MerchantLookupDataDist? tmpM;

  MarkPickedRequestData requestData = MarkPickedRequestData();
  final RiderController riderController = Get.put(RiderController());
  final _tabsLength = 2;

  List<int> selectedRecords = [];
  List<OrdersDataDist> scannedOrdersList = [];

  // List<LoadSheetOrdersByCriteriaDataDist> lsDataList = [];

  List<OrdersDataDist> ordersList = [];

  ApiPostData apiPostData = ApiPostData();
  ApiFetchData apiFetchData = ApiFetchData();

  String? selectedRider;
  String? selectedMerchent;
  String? orderTrackingNumber = '';
  late String currentDateString;

  // loadData(var merchantId, var riderId) async {
  //   if (selectedMerchent != null) {
  //     myShowLoadingDialog(context);
  //     apiFetchData
  //         .getLoadSheetOrdersByCriteria(
  //             riderId,
  //             merchantId,
  //             MyVariables.orderStatusIdBooked,
  //             MyVariables.loadSheetStatusIdNewAndPicked,
  //             fromDateController.text,
  //             toDateController.text,
  //             MyVariables.paginationDisable,
  //             0,
  //             MyVariables.size,
  //             MyVariables.sortDirection)
  //         .then((value) {
  //       if (value != null) {
  //         Get.isDialogOpen! ? tryToPop(context) : null;
  //         if (mounted) {
  //           if (value.lsOrdersDist!.isNotEmpty) {
  //             setState(() {
  //               clearData();
  //               lsDataList.addAll(value.lsOrdersDist!.toList());
  //             });
  //           } else {
  //             clearData();
  //             myToastSuccess(MyVariables.notFoundErrorMSG);
  //           }
  //         }
  //       } else {
  //         // Get.isDialogOpen! ? tryToPop(context) : null;
  //       }
  //     });
  //   } else {
  //     myToastError('Please select Merchant to search');
  //   }
  // }

  loadData() async {
    if (selectedMerchent != null) {
      myShowLoadingDialog(context);

      apiFetchData
          .getOrders(
              tmpM == null ? '' : tmpM!.merchantId,
              '',
              '',
              MyVariables.ordersStatusIdsToMarkPicked,
              '',
              '',
              fromDateController.text,
              toDateController.text,
              '',
              MyVariables.paginationDisable,
              0,
              MyVariables.size,
              MyVariables.sortDirection)
          .then((value) {
        if (value != null) {
          if (mounted) {
            if (value.dist!.isNotEmpty) {
              setState(() {
                clearData();
                ordersList.addAll(value.dist!);
              });
            } else {
              clearData();
              myToastSuccess(MyVariables.notFoundErrorMSG);
            }
            Get.isDialogOpen! ? tryToPop(context) : null;
          }
        }
      });
    } else {
      myToastError('Please Select Merchant');
    }
  }

  clearData() {
    setState(() {
      selectedRecords = [];
      scannedOrdersList = [];
      ordersList = [];
    });
  }

  removeFromList(List<int> records) {
    setState(() {
      for (int i = 0; i < records.length; i++) {
        ordersList
            .removeWhere((element) => element.transactionId == records[i]);
      }
    });
  }

  needtoReload() {
    setState(() {
      // selectedRecords = [];
      // scannedOrdersList = [];
      // selectedRider = null;
      // loadData(selectedMerchent == null ? '' : tmpM?.merchantId,
      //     selectedRider == null ? '' : tmpR?.riderId);
      removeFromList(selectedRecords);
      selectedRecords = [];
      scannedOrdersList = [];
      selectedRider = null;
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

  Future _scanQR() async {
    if (selectedMerchent != null) {
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
    } else {
      myToastError('Please select merchant to start scanning');
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
            tmpM == null ? '' : tmpM!.merchantId,
            '',
            '',
            MyVariables.ordersStatusIdsToMarkPicked,
            '',
            orderTrackingNumber,
            '',
            '',
            '',
            MyVariables.paginationDisable,
            0,
            MyVariables.size,
            MyVariables.sortDirection,
          )
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
            text: 'Mark Picked',
          ),
          flexibleSpace: const MyAppBarFlexibleContainer(),
          bottom: TabBar(tabs: [
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

    var containerDropdownScan = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(child: myDropDownMerchant),
          orderTrackingNumber!.isNotEmpty
              ? const MyLoadingIndicator()
              : Container(),
          const MySpaceWidth(widthSize: 2),
          Expanded(
            child: myDropDownRider,
          ),
        ],
      ),
    );

    var scanningCounter = ShowOrdersCount(
      text: 'Scanned',
      alignment: Alignment.centerRight,
      listLength: selectedRecords.length,
    );

    final searchedOrdersDataList = ListView.builder(
        itemCount: ordersList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCard(
            dist: ordersList[index],
            needToHideDeleteIcon: true,
            isSelected:
                selectedRecords.contains(ordersList[index].transactionId),
            onChangedCheckBox: (b) {
              onSelected(b!, ordersList[index]);
            },
          );
        });

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

    var mySearchDataBtn = Container(
        width: SizeConfig.safeScreenWidth,
        alignment: Alignment.centerRight,
        child: MyElevatedButton(
          text: 'Search',
          btnBackgroundColor: MyColors.btnColorGreen,
          onPressed: () {
            FocusScope.of(context).unfocus();
            // loadData(tmpM == null ? '' : tmpM!.merchantId,
            //     tmpR == null ? '' : tmpR!.riderId);
            loadData();
          },

          //     () async {
          //   if (selectedRider != null) {
          //     myShowLoadingDialog(context);
          //     apiFetchData
          //         .getOrders(
          //             '',
          //             //'',
          //             tmpR.riderId,
          //             MyVariables.ordersStatusIdsToMarkAttempted,
          //             orderTrackingNumber,
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
        ));

    var counter = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: ShowOrdersCount(
        text: selectedRecords.isNotEmpty ? 'Selected' : null,
        alignment: Alignment.centerLeft,
        listLength: selectedRecords.isNotEmpty
            ? selectedRecords.length
            : ordersList.length,
        totalElements: ordersList.length,
      ),
    );

    var markPickedButton = MyElevatedButton(
      text: 'Mark Picked',
      btnBackgroundColor: MyColors.btnColorGreen,
      btnPaddingHorizontalSize: 8,
      onPressed: () {
        if (selectedMerchent != null && selectedMerchent!.isNotEmpty) {
          if (selectedRider != null && selectedRider!.isNotEmpty) {
            if (selectedRecords.isNotEmpty) {
              Get.dialog(
                MyMarkPickedDialog(
                  merchantId: tmpM!.merchantId!,
                  riderId: tmpR!.riderId!,
                  transactionIds: selectedRecords,
                ),
                barrierDismissible: false,
              ).then((value) {
                if (value == true) {
                  needtoReload();
                }
              });
            } else {
              myToastError('Please select/scan orders');
            }
          } else {
            myToastError('Please select Rider');
          }
        } else {
          myToastError('Please select Merchant');
        }

        // if (selectedMerchent != null && selectedMerchent!.isNotEmpty) {
        //   if (selectedRider != null && selectedRider!.isNotEmpty) {
        //     if (selectedRecords.isNotEmpty) {
        //       myShowLoadingDialog(context);
        //       requestData = MarkPickedRequestData(
        //         merchantId: tmpM!.merchantId,
        //         riderId: tmpR!.riderId,
        //         transactionIds: selectedRecords,
        //       );

        //       apiPostData.patchMarkPicked(requestData).then((value) {
        //         if (value != null) {
        //           if (mounted) {
        //             // Fluttertoast.showToast(msg: value.statusMessage!);
        //             needtoReload();
        //             Get.isDialogOpen! ? tryToPop(context) : null;
        //             myShowSuccessMSGDialog(
        //               description: 'Orders marked as picked successfully',
        //             );
        //           }
        //         } else {
        //           // Get.isDialogOpen! ? tryToPop(context) : null;
        //         }
        //       });
        //     } else {
        //       myToastError('Please select/scan orders');
        //     }
        //   } else {
        //     myToastError('Please select Rider');
        //   }
        // } else {
        //   myToastError('Please select Merchant');
        // }
      },
    );

    return DefaultTabController(
        length: _tabsLength,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: MyColors.scaffoldBackgroundColor,
          appBar: appBar,
          body: TabBarView(children: [
            /////////////************ Via Scan ***********//////////////
            Padding(
              padding: MyVariables.scaffoldBodyPadding,
              child: Column(
                children: [
                  const MySpaceHeight(heightSize: 1.5),
                  containerDropdownScan,
                  const MySpaceHeight(heightSize: 0.5),
                  scanningCounter,
                  const MySpaceHeight(heightSize: 1.5),
                  Expanded(
                    child: scannedOrdersDataList,
                  ),
                  markPickedButton,
                ],
              ),
            ),

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
                      Expanded(child: counter),
                      Expanded(child: mySearchDataBtn)
                    ],
                  ),
                  const MySpaceHeight(heightSize: 1.5),
                  Expanded(
                    child: searchedOrdersDataList,
                  ),
                  markPickedButton,
                ],
              ),
            ),
          ]),
        ));
  }
}
