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
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';

class MarkCustomerRefused extends StatefulWidget {
  const MarkCustomerRefused({Key? key}) : super(key: key);

  @override
  _MarkCustomerRefusedState createState() => _MarkCustomerRefusedState();
}

class _MarkCustomerRefusedState extends State<MarkCustomerRefused> {
  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  MerchantController merchantController = Get.put(MerchantController());

  List<OrdersDataDist> searchedOrdersList = [];
  List<OrdersDataDist> scannedOrdersList = [];
  List<int> selectedRecords = [];

  String? selectedMerchant;
  MerchantLookupDataDist? tmpM;
  String orderTrackingNumber = '';

  final tabLength = 2;
  late String currenDate;

  loadData() async {
    myShowLoadingDialog(context);
    apiFetchData
        .getOrders(
      tmpM == null ? '' : tmpM!.merchantId,
      '',
      '',
      MyVariables.orderStatusIdUnderVerification,
      '',
      '',
      fromDateController.text,
      toDateController.text,
      '',
      MyVariables.paginationDisable,
      0,
      MyVariables.size,
      MyVariables.sortDirection,
    )
        .then(
      (value) {
        if (value != null) {
          if (mounted) {
            if (value.dist!.isNotEmpty) {
              setState(
                () {
                  searchedOrdersList.addAll(value.dist!);
                },
              );
            } else {
              myToastSuccess(MyVariables.notFoundErrorMSG);
            }
          }
        }
        Get.isDialogOpen! ? tryToPop(context) : null;
      },
    );
  }

  Future scanQR() async {
    if (searchedOrdersList.isNotEmpty) {
      try {
        FlutterBarcodeScanner.getBarcodeStreamReceiver(
          'green',
          'Cancel',
          true,
          ScanMode.QR,
        )!
            .listen(
          (value) {
            if (value != '-1' && value.isNotEmpty) {
              if (!mounted) return;
              setState(
                () {
                  orderTrackingNumber = value.toString().trim();
                },
              );
              addToScannedList();
            }
          },
        );
      } on PlatformException {
        throw Exception('failed to load data');
      }
    } else {
      myToastError('Please Search Orders to Scan');
    }
  }

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    currenDate = myFormatDateOnly(now.toString());
    fromDateController = TextEditingController(text: currenDate);
    toDateController = TextEditingController(text: currenDate);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) => loadData());
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

  // removeDataFromList(List<int> records) {
  //   setState(() {
  //     for (int i = 0; i < records.length; i++) {
  //       searchedOrdersList
  //           .removeWhere((element) => element.transactionId == records[i]);
  //     }
  //   });
  // }

  removeDataLocally() {
    setState(
      () {
        selectedRecords = [];
        scannedOrdersList = [];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBarWithBottom,
      child: SafeArea(
        child: AppBar(
          elevation: 0,
          title: const MyTextWidgetAppBarTitle(text: "Mark Customer Refused"),
          backgroundColor: MyVariables.appBarBackgroundColor,
          flexibleSpace: const MyAppBarFlexibleContainer(),
          toolbarHeight: MyVariables.appbarHeight,
          iconTheme: MyVariables.appBarIconTheme,
          bottom: TabBar(tabs: [
            Tab(
              child: Text(
                "Pending Scan",
                style: MyVariables.tabBarTextStyle,
              ),
            ),
            Tab(
              child: Text(
                "Scanned",
                style: MyVariables.tabBarTextStyle,
              ),
            ),
          ]),
          actions: [
            IconButton(
              onPressed: () {
                scanQR();
              },
              icon: Icon(
                Icons.qr_code_scanner,
                size: SizeConfig.blockSizeHorizontal * 8,
              ),
            )
          ],
        ),
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
      },
    );

    var scannedOrdersDataList = ListView.builder(
      itemCount: scannedOrdersList.length,
      itemBuilder: (BuildContext context, index) {
        return MyCard(
          needToHideCheckBox: true,
          dist: scannedOrdersList[index],
          deleteOnPressed: () {
            removeAndInsertInList(scannedOrdersList[index]);
          },
        );
      },
    );

    var dateDropDownOnSearch = Row(
      children: [
        Expanded(
          child: MyTextFieldDatePicker(
            text: "From Date",
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
                  .then(
                (value) {
                  if (value != null) {
                    setState(
                      () {
                        fromDateController.text =
                            myFormatDateOnly(value.toString());
                      },
                    );
                  }
                },
              );
            },
          ),
        ),
        const MySpaceWidth(widthSize: 2),
        Expanded(
          child: MyTextFieldDatePicker(
            text: "To Date",
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
                  .then(
                (value) {
                  if (value != null) {
                    setState(
                      () {
                        toDateController.text =
                            myFormatDateOnly(value.toString());
                      },
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );

    var merchantDropDown = MyDropDownMerchant(
        selectedValue: selectedMerchant,
        onChanged: (value) {
          setState(
            () {
              selectedMerchant = value.toString();
              tmpM = merchantController.merchantLookupList.firstWhere(
                  (element) => element.merchantName == selectedMerchant);
            },
          );
        },
        listOfItems: merchantController.merchantLookupList);

    var scannedCounter = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: ShowOrdersCount(
        text: 'Scanned',
        alignment: Alignment.centerRight,
        listLength: scannedOrdersList.length,
      ),
    );

    var searchedCounter = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: ShowOrdersCount(
        text: 'Showing',
        alignment: Alignment.centerRight,
        listLength: searchedOrdersList.length,
      ),
    );

    var markCustomerRefusedBtn = MyElevatedButton(
      text: "Mark Customer Refused",
      btnBackgroundColor: MyColors.btnColorGreen,
      onPressed: () {
        if (selectedRecords.isNotEmpty) {
          Get.dialog(
                  MyMarkCustomerRefusedDialog(transactionIds: selectedRecords))
              .then((value) {
            if (value == true) {
              setState(() {
                removeDataLocally();
              });
            }
          });
        } else {
          myToastError('Please Scan Orders to Mark Customer Refused');
        }
      },
    );

    var merchantDropDownAndSearchBtn = Row(
      children: [
        Expanded(child: merchantDropDown),
        MySpaceWidth(widthSize: SizeConfig.safeBlockSizeVertical * 2.4),
        MyElevatedButton(
          text: "Search",
          btnBackgroundColor: MyColors.btnColorGreen,
          onPressed: () {
            FocusScope.of(context).unfocus();
            setState(
              () {
                selectedRecords = [];
                searchedOrdersList = [];
                scannedOrdersList = [];
              },
            );
            loadData();
          },
        )
      ],
    );

    var pendingScan = Padding(
      padding: MyVariables.scaffoldBodyPadding,
      child: Column(
        children: [
          const MySpaceHeight(heightSize: 1),
          dateDropDownOnSearch,
          const MySpaceHeight(heightSize: 1),
          merchantDropDownAndSearchBtn,
          const MySpaceHeight(heightSize: 1),
          searchedCounter,
          const MySpaceHeight(heightSize: 1),
          Expanded(
              child: searchedOrdersList.isEmpty
                  ? const MyNoDataToShowWidget()
                  : searchedOrdersDataList),
        ],
      ),
    );

    var scanned = Padding(
      padding: MyVariables.scaffoldBodyPadding,
      child: Column(
        children: [
          const MySpaceHeight(heightSize: 1),
          scannedCounter,
          const MySpaceHeight(heightSize: 1),
          Expanded(child: scannedOrdersDataList),
          markCustomerRefusedBtn
        ],
      ),
    );

    return DefaultTabController(
      length: tabLength,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.scaffoldBackgroundColor,
        appBar: appBar,
        body: TabBarView(
          children: [
            /////////////************ Pending Scan ***********//////////////
            pendingScan,
            /////////////************ Scanned ***********//////////////
            scanned,
          ],
        ),
      ),
    );
  }
}
