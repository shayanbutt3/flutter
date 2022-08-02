import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/show_confirmation_dialog.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/custom/custom_widgets/show_response_dialog.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';
import '../constants/size_config.dart';

class DeManifestTsScreen extends StatefulWidget {
  const DeManifestTsScreen({Key? key}) : super(key: key);

  @override
  State<DeManifestTsScreen> createState() => _DeManifestTsScreenState();
}

class _DeManifestTsScreenState extends State<DeManifestTsScreen> {
  TextEditingController sheetTagController = TextEditingController();

  ApiFetchData apiFetchData = ApiFetchData();

  ApiPostData apiPostData = ApiPostData();
  DeManifestTransferSheetRequestData requestData =
      DeManifestTransferSheetRequestData();

  List<int> selectedRecords = [];
  List<SheetDetailDataDist> searchedOrdersList = [];
  List<SheetDetailDataDist> scannedOrdersList = [];
  String orderTrackingNumber = '';
  final _tabslength = 2;

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
          if (value != '-1' && value.isNotEmpty) {
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
      myToastError('Please Search Orders to Scan');
    }
  }

  loadData() {
    myShowLoadingDialog(context);
    apiFetchData
        .getSheetDetail(
      '',
      '',
      '',
      '',
      MyVariables.sheetStatusIdHandedover,
      '',
      '',
      '',
      MyVariables.paginationDisable,
      0,
      MyVariables.size,
      MyVariables.sortDirection,
      sheetTag: sheetTagController.text,
    )
        .then((value) {
      if (value != null) {
        if (value.dist!.isNotEmpty) {
          if (mounted) {
            setState(() {
              Get.isDialogOpen! ? tryToPop(context) : null;
              searchedOrdersList.addAll(value.dist!);
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
    setState(() {
      scannedOrdersList = [];
      selectedRecords = [];
    });
  }

  @override
  void initState() {
    super.initState();
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
        title: const MyTextWidgetAppBarTitle(text: 'De Manifest TS'),
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
              tooltip: 'Scan QR',
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

    var textFormFieldforSheetTag = MyTextFieldCustom(
      controller: sheetTagController,
      onChanged: (a) {
        setState(() {});
      },
      needToHideIcon: true,
      labelText: 'Sheet Tag',
    );

    var mySearchDataBtn = Container(
        width: SizeConfig.safeScreenWidth,
        alignment: Alignment.centerRight,
        child: MyElevatedButton(
            text: 'Search',
            btnBackgroundColor: MyColors.btnColorGreen,
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (sheetTagController.text.isNotEmpty) {
                setState(() {
                  selectedRecords = [];
                  searchedOrdersList = [];
                  scannedOrdersList = [];
                });
                loadData();
              } else {
                myToastError('Please Enter Sheet Tag to Search');
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

    var deManifestTsBtn = MyElevatedButton(
        text: 'De Manifest TS',
        btnBackgroundColor: MyColors.btnColorGreen,
        btnPaddingHorizontalSize: 8,
        onPressed: () {
          if (scannedOrdersList.isNotEmpty) {
            Get.dialog(MyConfirmationDialog(
                title: 'De-Manifest TS',
                description:
                    'Are you sure you want to De-Manifest scanned orders?',
                onSavePressed: () {
                  myShowLoadingDialog(context);
                  requestData = DeManifestTransferSheetRequestData(
                    sheetMasterId: scannedOrdersList[0].sheetId,
                    transactionIds: selectedRecords,
                  );
                  apiPostData
                      .patchDeManifestTransferSheet(requestData)
                      .then((value) {
                    if (value != null) {
                      if (mounted) {
                        Get.isDialogOpen == true ? tryToPop(context) : null;
                        myShowSuccessMSGDialog(
                            description:
                                'De Manifest Transfer Sheet Successfuly',
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
            myToastError('Please Scan Orders to De-Manifest TS');
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
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: textFormFieldforSheetTag,
                        ),
                        const MySpaceWidth(widthSize: 2),
                        Expanded(child: mySearchDataBtn),
                      ],
                    ),
                    const MySpaceHeight(heightSize: 1),
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
                    deManifestTsBtn
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
