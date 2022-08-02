import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
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
import 'package:get/get.dart';
import '../constants/size_config.dart';
import '../custom/custom_widgets/show_response_dialog.dart';

class DeManifestScreen extends StatefulWidget {
  const DeManifestScreen({Key? key}) : super(key: key);

  @override
  State<DeManifestScreen> createState() => _DeManifestScreenState();
}

class _DeManifestScreenState extends State<DeManifestScreen> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController mUTagController = TextEditingController();

  ApiPostData apiPostData = ApiPostData();
  DeManifestRequestData requestData = DeManifestRequestData();

  ApiFetchData apiFetchData = ApiFetchData();
  String? selectedMu;

  String? currentDateString;
  List<int> selectedRecords = [];
  List<MasterUnitDetailDataDist> searchedOrdersList = [];
  List<MasterUnitDetailDataDist> scannedOrdersList = [];
  String orderTrackingNumber = '';
  final _tabslength = 2;

  Future scanMu() async {
    try {
      await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      ).then((value) {
        if (value != '-1' && value.isNotEmpty) {
          if (!mounted) return;
          var muTag = value.trim().toString();
          var data = muTag;
          if (data.isNotEmpty) {
            setState(() {
              mUTagController.text = muTag;
              searchedOrdersList = [];
              loadData();
            });
          } else {
            myToastError('MU not found');
          }

          FlutterBeep.beep(false);
        }
      });
    } catch (e) {
      myToastError('exception: $e');
    }
  }

  Future scanQR() async {
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
            orderTrackingNumber = value.trim().toString();
          });
          addToScannedList();
        }
      });
    } catch (e) {
      myToastError('exception: $e');
    }
  }

  loadData() {
    myShowLoadingDialog(context);
    apiFetchData
        .getMasterUnitDetailData(
      masterUnitStatusIds: MyVariables.masterUnitStatusIdReceived,
      masterUnitTag: mUTagController.text,
      fromDate: fromDateController.text,
      toDate: toDateController.text,
    )
        .then((value) {
      if (value != null) {
        if (value.dist!.isNotEmpty) {
          if (mounted) {
            setState(() {
              for (var element in value.dist!) {
                if (element.transaction!.transactionPhysicalStatusId !=
                        int.parse(MyVariables
                            .orderPhysicalStatusWaitingForDelivery) &&
                    element.transaction!.transactionPhysicalStatusId !=
                        int.parse(
                            MyVariables.orderPhysicalStatusWaitingForTransit) &&
                    element.transaction!.transactionPhysicalStatusId !=
                        int.parse(MyVariables
                            .orderPhysicalStatusWaitingForFineSort) &&
                    element.transaction!.transactionPhysicalStatusId !=
                        int.parse(
                            MyVariables.orderPhysicalStatusWaitingForReturn) &&
                    element.transaction!.transactionPhysicalStatusId !=
                        int.parse(MyVariables
                            .orderPhysicalStatusWaitingForReturnLineHaul)) {
                  searchedOrdersList.add(element);
                }
              }
              Get.isDialogOpen! ? tryToPop(context) : null;
            });
          }
        } else {
          myToastError(MyVariables.notFoundErrorMSG);
          Get.isDialogOpen! ? tryToPop(context) : null;
        }
      }
    });
  }

  addToScannedList() {
    var data = searchedOrdersList.firstWhere(
        (element) => element.transaction!.trackingNumber == orderTrackingNumber,
        orElse: () => MasterUnitDetailDataDist());

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

  // removeFromList(List<int> records) {
  //   for (int i = 0; i < records.length; i++) {
  //     setState(() {
  //       searchedOrdersList.removeWhere(
  //           (element) => element.transaction?.transactionId == records[i]);
  //     });
  //   }
  // }

  removeAndInsertInList(MasterUnitDetailDataDist masterUnitDetailDataDist) {
    setState(() {
      scannedOrdersList.removeWhere((element) =>
          element.transaction!.transactionId ==
          masterUnitDetailDataDist.transaction!.transactionId);

      searchedOrdersList.insert(0, masterUnitDetailDataDist);

      selectedRecords.removeWhere((element) =>
          element == masterUnitDetailDataDist.transaction!.transactionId);
    });
  }

  removeDataLocally() {
    // removeFromList(selectedRecords);
    setState(() {
      scannedOrdersList = [];
      selectedRecords = [];
    });
  }

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    currentDateString = myFormatDateOnly(now.toString());
    fromDateController = TextEditingController(text: currentDateString);
    toDateController = TextEditingController(text: currentDateString);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBarWithBottom,
      child: SafeArea(
          child: AppBar(
        elevation: 0,
        backgroundColor: MyVariables.appBarBackgroundColor,
        iconTheme: MyVariables.appBarIconTheme,
        toolbarHeight: MyVariables.appbarHeight,
        title: const MyTextWidgetAppBarTitle(text: 'De Manifest'),
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
              tooltip: 'Scan MU Tag',
              onPressed: () {
                scanMu();
              },
              icon: Icon(
                Icons.qr_code_rounded,
                color: Colors.white,
                size: SizeConfig.blockSizeHorizontal * 8,
              )),
          IconButton(
              tooltip: 'Scan Orders',
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

    var searchedOrdersDataList = ListView.builder(
        itemCount: searchedOrdersList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCard(
            dist: searchedOrdersList[index].transaction!,
            needToHideDeleteIcon: true,
            needToHideCheckBox: true,
            isSelected: selectedRecords
                .contains(searchedOrdersList[index].transaction?.transactionId),
          );
        });

    final scannedOrdersDataList = ListView.builder(
      itemCount: scannedOrdersList.length,
      itemBuilder: (BuildContext context, index) {
        return MyCard(
          dist: scannedOrdersList[index].transaction!,
          needToHideDeleteIcon: false,
          needToHideCheckBox: true,
          deleteOnPressed: () {
            removeAndInsertInList(scannedOrdersList[index]);
          },
        );
      },
    );

    var datePicker = SizedBox(
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
          )),
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
                          toDateController.text =
                              myFormatDateOnly(value.toString());
                        });
                      }
                    });
                  }))
        ],
      ),
    );

    var textFormFieldforTrackingNumber = MyTextFieldCustom(
      controller: mUTagController,
      onChanged: (a) {
        setState(() {});
      },
      needToHideIcon: true,
      labelText: 'MU Tag',
    );

    var mySearchDataBtn = Container(
        width: SizeConfig.safeScreenWidth,
        alignment: Alignment.centerRight,
        child: MyElevatedButton(
            text: 'Search',
            btnBackgroundColor: MyColors.btnColorGreen,
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (mUTagController.text.isNotEmpty) {
                setState(() {
                  selectedRecords = [];
                  searchedOrdersList = [];
                  scannedOrdersList = [];
                });
                loadData();
              } else {
                myToastError('Please Enter MU Tag to Search');
              }
            }));

    var searchedCounter = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: ShowOrdersCount(
        text: 'Showing',
        alignment: Alignment.centerRight,
        listLength: searchedOrdersList.length,
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

    var deManifestBtn = MyElevatedButton(
        text: 'De Manifest',
        btnBackgroundColor: MyColors.btnColorGreen,
        btnPaddingHorizontalSize: 8,
        onPressed: () {
          if (selectedRecords.isNotEmpty) {
            Get.dialog(MyConfirmationDialog(
                title: 'De-Manifest',
                description:
                    'Are you sure you want to De Manifest these orders?',
                onSavePressed: () {
                  myShowLoadingDialog(context);
                  requestData = DeManifestRequestData(
                      masterUnitId: scannedOrdersList[0].masterUnitId,
                      transactionIds: selectedRecords);
                  apiPostData
                      .patchDeManifestMasterUnit(requestData)
                      .then((value) {
                    if (value != null) {
                      if (mounted) {
                        Get.isDialogOpen == true ? tryToPop(context) : null;
                        myShowSuccessMSGDialog(
                            description: 'De Mainfest Successfuly',
                            customOnPressedOK: () {
                              Get.isDialogOpen == true
                                  ? tryToPop(context)
                                  : null;
                              tryToPopTrue(context);
                              removeDataLocally();
                            });
                      }
                    }
                  });
                }));
          } else {
            myToastError('Please scan orders to De Manifest');
          }
        });

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
                    const MySpaceHeight(heightSize: 1),
                    datePicker,
                    const MySpaceHeight(heightSize: 1),
                    Row(
                      children: [
                        Expanded(child: textFormFieldforTrackingNumber),
                        const MySpaceWidth(widthSize: 1),
                        Expanded(child: mySearchDataBtn),
                      ],
                    ),
                    const MySpaceHeight(heightSize: 0.5),
                    Row(
                      children: [
                        Expanded(child: searchedCounter),
                      ],
                    ),
                    const MySpaceHeight(heightSize: 1),
                    Expanded(child: searchedOrdersDataList),
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
                    const MySpaceHeight(heightSize: 1),
                    Expanded(child: scannedOrdersDataList),
                    const MySpaceHeight(heightSize: 1),
                    deManifestBtn
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
