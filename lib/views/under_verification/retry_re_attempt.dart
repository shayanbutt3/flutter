import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/merchant_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';

class RetryReAttempt extends StatefulWidget {
  const RetryReAttempt({Key? key}) : super(key: key);

  @override
  _RetryReAttemptState createState() => _RetryReAttemptState();
}

class _RetryReAttemptState extends State<RetryReAttempt> {
  ApiFetchData apiFetchData = ApiFetchData();

  TextEditingController trackingNumberController = TextEditingController();
  final MerchantController merchantController = Get.put(MerchantController());

  String? selectedMerchant;
  MerchantLookupDataDist? tmpM;

  List<int> selectedRecords = [];
  List<OrdersDataDist> searchedOrdersList = [];
  List<OrdersDataDist> scannedOrdersList = [];
  Pagination pagination = Pagination();

  String orderTrackingNumber = '';
  final _tabslength = 2;

  loadData({
    var merchantId,
    var trackingNumber,
  }) async {
    myShowLoadingDialog(context);
    apiFetchData
        .getOrders(
            merchantId ?? '',
            '',
            '',
            MyVariables.orderStatusIdUnderVerification,
            '',
            trackingNumber ?? '',
            '',
            '',
            '',
            MyVariables.paginationDisable,
            0,
            MyVariables.size,
            MyVariables.sortDirection)
        .then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            searchedOrdersList.addAll(value.dist!);
            pagination = value.pagination!;
          });
          Get.isDialogOpen! ? tryToPop(context) : null;
        }
      } else {
        // Get.isDialogOpen! ? tryToPop(context) : null;
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

  addToScannedList() {
    var data = searchedOrdersList.firstWhere(
        (element) => element.trackingNumber == orderTrackingNumber,
        orElse: () => OrdersDataDist());

    if (data.trackingNumber == null) {
      var dist = scannedOrdersList
          .where((element) => element.trackingNumber == orderTrackingNumber);

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
        selectedRecords.add(data.transactionId!);
        searchedOrdersList.remove(data);
        orderTrackingNumber = '';
        FlutterBeep.beep(false);
      });
    }
  }

  removeAndInsertInList(OrdersDataDist ordersDataDist) {
    setState(() {
      scannedOrdersList.removeWhere(
          (element) => element.transactionId == ordersDataDist.transactionId);

      searchedOrdersList.insert(0, ordersDataDist);

      selectedRecords
          .removeWhere((element) => element == ordersDataDist.transactionId);
    });
  }

  removeDataLocally() {
    setState(() {
      scannedOrdersList = [];
      selectedRecords = [];
    });
  }

  // removeFromList(List<int> transactionId) {
  //   setState(() {
  //     searchedOrdersList
  //         .removeWhere((element) => element.transactionId == transactionId);
  //     pagination.totalElements = pagination.totalElements! - 1;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
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
        title: const MyTextWidgetAppBarTitle(text: 'Mark Retry'),
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

    // final list = ListView.builder(
    //     itemCount: searchedOrdersList.length,
    //     itemBuilder: (context, index) {
    //       return myCard(context, searchedOrdersList[index]);
    //     });

    final container = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
              child: MyDropDownMerchant(
            selectedValue: selectedMerchant,
            onChanged: (val) {
              setState(() {
                selectedMerchant = val.toString();
                tmpM = merchantController.merchantLookupList.firstWhere(
                    (element) => element.merchantName == selectedMerchant);
              });
            },
            listOfItems: merchantController.merchantLookupList,
          )),
          const MySpaceWidth(widthSize: 2),
          Expanded(
              child: MyTextFieldCustom(
            controller: trackingNumberController,
            needToHideIcon: true,
            labelText: 'Tracking Number',
            onChanged: (a) {
              setState(() {});
            },
          )),
        ],
      ),
    );

    var searchedCounter = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: ShowOrdersCount(
        text: 'Showing',
        alignment: Alignment.centerLeft,
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

    final searchBtn = Container(
      width: SizeConfig.safeScreenWidth,
      alignment: Alignment.centerRight,
      child: MyElevatedButton(
        text: 'Search',
        btnBackgroundColor: MyColors.btnColorGreen,
        onPressed: () {
          setState(() {
            searchedOrdersList = [];
            scannedOrdersList = [];
            selectedRecords = [];
            FocusScope.of(context).unfocus();
            loadData(
              merchantId: tmpM == null ? '' : tmpM?.merchantId,
              trackingNumber: trackingNumberController.text.trim(),
            );
          });
        },
      ),
    );

    var searchedOrdersDataList = ListView.builder(
        itemCount: searchedOrdersList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCard(
            dist: searchedOrdersList[index],
            needToHideDeleteIcon: true,
            needToHideCheckBox: true,
          );
        });

    final scannedOrdersDataList = ListView.builder(
      itemCount: scannedOrdersList.length,
      itemBuilder: (BuildContext context, index) {
        return MyCard(
          dist: scannedOrdersList[index],
          needToHideDeleteIcon: false,
          needToHideCheckBox: true,
          deleteOnPressed: () {
            removeAndInsertInList(scannedOrdersList[index]);
          },
        );
      },
    );

    var retryBtn = MyElevatedButton(
        text: 'Mark Retry',
        btnBackgroundColor: MyColors.btnColorGreen,
        btnPaddingHorizontalSize: 8,
        onPressed: () {
          if (selectedRecords.isNotEmpty) {
            Get.dialog(MyRetryOrderDialog(transactionIds: selectedRecords),
                    barrierDismissible: false)
                .then((value) {
              if (value == true) {
                removeDataLocally();
              }
            });
          } else {
            myToastError('Please scan orders to Mark Retry');
          }
        });

    return DefaultTabController(
      length: _tabslength,
      child: Scaffold(
        appBar: appBar,
        body: TabBarView(children: [
          ///// Pending Scan //////////////

          Padding(
            padding: MyVariables.scaffoldBodyPadding,
            child: Column(children: [
              const MySpaceHeight(heightSize: 1),
              container,
              const MySpaceHeight(heightSize: 1),
              Row(
                children: [
                  Expanded(child: searchedCounter),
                  Expanded(child: searchBtn),
                ],
              ),
              const MySpaceHeight(heightSize: 1),
              Expanded(
                  child: searchedOrdersList.isEmpty
                      ? const MyNoDataToShowWidget()
                      : searchedOrdersDataList),
            ]),
          ),

          //////Scanned///////////
          Padding(
            padding: MyVariables.scaffoldBodyPadding,
            child: Column(children: [
              const MySpaceHeight(heightSize: 1),
              scannedCounter,
              const MySpaceHeight(heightSize: 1),
              Expanded(child: scannedOrdersDataList),
              const MySpaceHeight(heightSize: 1),
              retryBtn
            ]),
          ),
        ]),
      ),
    );
  }

  // Widget myCard(BuildContext context, OrdersDataDist dist) {
  //   return InkWell(
  //     // onLongPress: () {
  //     //   myShowBottomSheet(context, [
  //     // MyListTileBottomSheetMenuItem(
  //     //   titleTxt: 'Retry',
  //     //   icon: Icons.people,
  //     //   onTap: () {
  //     //     tryToPop(context);
  //     //     Get.dialog(MyRetryOrderDialog(transactionId: dist.transactionId!),
  //     //             barrierDismissible: false)
  //     //         .then((value) {
  //     //       if (value == true) {
  //     //         removeFromList(dist.transactionId!);
  //     //       }
  //     //     });
  //     //   },
  //     // ),
  //     //   ]);
  //     // },
  //     child: MyCard(
  //       dist: dist,
  //       needToHideCheckBox: true,
  //       needToHideDeleteIcon: true,
  //     ),
  //   );
  // }
}
