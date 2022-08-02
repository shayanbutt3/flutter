import 'package:backoffice_new/controllers/merchant_controller.dart';
import 'package:backoffice_new/controllers/rider_controller.dart';
import 'package:backoffice_new/custom/custom_widgets/show_confirmation_dialog.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/services/api_post_data.dart';

import '../../../custom/custom_widgets/show_response_dialog.dart';

class StockInPicked extends StatefulWidget {
  const StockInPicked({Key? key}) : super(key: key);

  @override
  _StockInPickedState createState() => _StockInPickedState();
}

class _StockInPickedState extends State<StockInPicked>
    with SingleTickerProviderStateMixin {
  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  final tabsLength = 2;

  // late TabController _tabController;

  final RiderController _riderController = Get.put(RiderController());
  final MerchantController _merchantController = Get.put(MerchantController());
  // final OrdersController ordersController = Get.put(OrdersController());
  // final WareHouseController wareHouseController =
  //     Get.put(WareHouseController());

  final WareHouseController wareHouseController =
      Get.put(WareHouseController());

  // List<RiderLookupDataDist> riderLookupList = [];
  // List<MerchantLookupDataDist> merchantLookupList = [];

  // List<WareHouseDataDist> wareHouseLookupList = [];

  List<LoadSheetOrdersByCriteriaDataDist> lsDataList = [];
  Pagination pagination = Pagination();

  List<int> selectedRecords = [];
  List<OrdersDataDist> scannedOrdersList = [];

  String? selectedRider;
  String? selectedMerchant;
  String? selectedWareHouse;

  RiderLookupDataDist? tmpR;
  MerchantLookupDataDist? tmpM;
  WareHouseDataDist? tmpW;

  String? orderTrackingNumber = '';

  PickUpInboundRequestData requestData = PickUpInboundRequestData();

  // late List<bool> isSelected;

  int page = 0;
  bool isLoading = false;

  clearAllData() {
    setState(() {
      lsDataList = [];
      selectedRecords = [];
      scannedOrdersList = [];
    });
  }

  removeFromList(List<int> records) {
    for (int i = 0; i < records.length; i++) {
      setState(() {
        lsDataList.removeWhere(
            (element) => element.transaction?.transactionId == records[i]);
      });
    }
  }

  removeDataLocally() {
    removeFromList(selectedRecords);
    setState(() {
      selectedMerchant = null;
      selectedRider = null;
      selectedWareHouse = null;
      // Refreshing all above three dropdowns because of recommendation of Rida & Mohsin bhai
      selectedRecords = [];
      scannedOrdersList = [];
      // loadOrders(selectedMerchant == null ? '' : tmpM?.merchantId,
      //     selectedRider == null ? '' : tmpR?.riderId);
    });
  }

  // loadOrders(var merchantId, var riderId) {
  //   myShowLoadingDialog(context);
  //   apiFetchData
  //       .getOrders(
  //     merchantId,
  //     riderId,
  //     '',
  //     MyVariables.ordersStatusIdsToMakeOrdersInStockPicked,
  //     '',
  //     '',
  //     '',
  //     '',
  //     false,
  //     MyVariables.paginationDisable,
  //     page,
  //     MyVariables.size,
  //     MyVariables.sortDirection,
  //   )
  //       .then((value) {
  //     if (value != null) {
  //       Get.isDialogOpen! ? tryToPop(context) : null;
  //       if (mounted) {
  //         setState(() {
  //           clearAllData();
  //           ordersList.addAll(value.dist!.toList());
  //           pagination = value.pagination!;
  //           // isSelected = List<bool>.filled(ordersList.length, false);
  //         });
  //       }
  //     }
  //   });
  // }

  loadOrders(var merchantId, var riderId) {
    myShowLoadingDialog(context);
    apiFetchData
        .getLoadSheetOrdersByCriteria(
      riderId,
      merchantId,
      MyVariables.ordersStatusIdsToMakeOrdersInStockPicked,
      MyVariables.ordersStatusIdsToMakeOrdersInStockPicked,
      MyVariables.loadSheetStatusIdPickedAndComplete,
      '',
      '',
      MyVariables.paginationDisable,
      page,
      MyVariables.size,
      MyVariables.sortDirection,
    )
        .then((value) {
      if (value != null) {
        if (mounted) {
          Get.isDialogOpen! ? tryToPop(context) : null;
          if (value.lsOrdersDist!.isNotEmpty) {
            setState(() {
              clearAllData();
              lsDataList.addAll(value.lsOrdersDist!.toList());
              pagination = value.pagination!;
              // print(value.d);
            });
          } else {
            setState(() {
              clearAllData();
            });
            myToastSuccess(MyVariables.notFoundErrorMSG);
          }
        }
      }
    });
  }

  // onSelected(bool selected, OrdersDataDist ordersDataDist) {
  //   if (selectedRecords.contains(ordersDataDist.transactionId)) {
  //     setState(() {
  //       selectedRecords.remove(ordersDataDist.transactionId);
  //       scannedOrdersList.removeWhere((element) =>
  //           element.trackingNumber == ordersDataDist.trackingNumber);
  //     });
  //   } else if (selected) {
  //     selectedRecords.add(ordersDataDist.transactionId!);
  //     // scannedOrdersList.add(ordersDataDist);
  //     scannedOrdersList.insert(0, ordersDataDist);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // loadRiders();
    // loadMerchants();
    // loadWareHouses();

    // _tabController = TabController(length: tabsLength, vsync: this);
    // _tabController.addListener(_handleTabSelection);
  }

  // void _handleTabSelection() {
  //   if (!_tabController.indexIsChanging) {
  //     setState(() {
  //       switch (_tabController.index) {
  //         case 0:
  //           debugPrint('Tab 1 is showing');
  //           break;
  //         case 1:
  //           debugPrint('Tab 2 is showing');
  //       }
  //     });
  //   }
  // }

  Future _scanQR() async {
    if (lsDataList.isNotEmpty) {
      try {
        FlutterBarcodeScanner.getBarcodeStreamReceiver(
                'green', 'Cancel', true, ScanMode.QR)!
            .listen((value) {
          if (value != '-1' && value.isNotEmpty) {
            setState(() {
              orderTrackingNumber = value.toString().trim();
              var data = lsDataList.firstWhere(
                  (element) =>
                      element.transaction!.trackingNumber ==
                      orderTrackingNumber,
                  orElse: () => LoadSheetOrdersByCriteriaDataDist());

              if (data.transaction?.trackingNumber != null) {
                var scanned = selectedRecords.where(
                    (element) => element == data.transaction!.transactionId);
                if (scanned.isNotEmpty) {
                  myToastError('Already Exists');
                  orderTrackingNumber = '';
                } else {
                  selectedRecords.add(data.transaction!.transactionId!);
                  myToastSuccess('Added Successfully');
                  orderTrackingNumber = '';
                  FlutterBeep.beep(false);
                }
              } else {
                myToastError(MyVariables.scanningWrongOrderMSG);
                orderTrackingNumber = '';
              }
            });
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var appBar = PreferredSize(
      // preferredSize: MyVariables.preferredSizeAppBarWithBottom,
      preferredSize: MyVariables.preferredSizeAppBar,
      child: SafeArea(
        child: AppBar(
          elevation: 0,
          backgroundColor: MyVariables.appBarBackgroundColor,
          iconTheme: MyVariables.appBarIconTheme,
          toolbarHeight: MyVariables.appbarHeight,
          title: const MyTextWidgetAppBarTitle(
            // text: 'Stock In Picked',
            text: 'Pick Up Inbound',
          ),
          flexibleSpace: const MyAppBarFlexibleContainer(),
          // bottom: TabBar(controller: _tabController, tabs: [
          //   Tab(
          //     child: Text(
          //       'Via Scan',
          //       style: MyVariables.tabBarTextStyle,
          //     ),
          //   ),
          //   Tab(
          //     child: Text(
          //       'Via Search',
          //       style: MyVariables.tabBarTextStyle,
          //     ),
          //   ),
          // ]),
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

    var containerMerchantRiderDropdown = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
            child: MyDropDownMerchant(
              selectedValue: selectedMerchant,
              onChanged: (newValue) {
                setState(() {
                  // var d = merchantLookupList.firstWhere(
                  //     (element) => element.merchantName == newValue.toString());
                  // selectedMerchant = d.merchantName;
                  selectedMerchant = newValue.toString();
                  tmpM = _merchantController.merchantLookupList.firstWhere(
                      (element) => element.merchantName == selectedMerchant);
                });
              },
              listOfItems: _merchantController.merchantLookupList,
            ),
          ),
          const MySpaceWidth(widthSize: 3),
          Expanded(
            child: MyDropDownRider(
              selectedValue: selectedRider,
              onChanged: (newValue) {
                setState(() {
                  selectedRider = newValue.toString();
                  tmpR = _riderController.riderLookupList.firstWhere(
                      (element) => element.riderName == selectedRider);
                });
              },
              listOfItems: _riderController.riderLookupList,
              // riderController.riderLookupList!,
            ),
          ),
        ],
      ),
    );

    // var searchBtnContainer = Container(
    //   // width: SizeConfig.safeScreenWidth,
    //   alignment: Alignment.centerRight,
    //   child: MyElevatedButton(
    //     text: 'Search',
    //     btnBackgroundColor: MyColors.btnColorGreen,
    //     onPressed: () {
    //       loadOrders(tmpM == null ? '' : tmpM!.merchantId,
    //           tmpR == null ? '' : tmpR!.riderId);
    //     },
    //   ),
    // );

    final searchedDataList =
        // Obx(() {
        //   return
        ListView.builder(
            // itemCount: ordersController.ordersList!.length,
            itemCount: lsDataList.length,
            itemBuilder: (BuildContext context, index) {
              return MyCard(
                dist: lsDataList[index].transaction!,
                isSelected: selectedRecords.contains(lsDataList[index]
                    .transaction!
                    .transactionId), //isSelected[index],
                // onChangedCheckBox: (val) {
                //   setState(() {
                //     // isSelected[index] = val!;
                //     // onSelected(isSelected[index], ordersList[index]);
                //     onSelected(val!, ordersList[index]);
                //   });
                // },
                needToHideCheckBox: true,
                needToHideDeleteIcon: true,
                needToShowSelectionTick: true,
              );
              // });
            });

    var warehouseDropDown = Container(
      alignment: Alignment.centerLeft,
      child: MyDropDownWareHouse(
        isExpanded: true,
        selectedValue: selectedWareHouse,
        onChanged: (a) {
          setState(() {
            selectedWareHouse = a.toString();
            tmpW = wareHouseController.wareHouseLookupList.firstWhere(
                (element) => element.wareHouseName == selectedWareHouse,
                orElse: () => WareHouseDataDist());
          });
        },
        listOfItems:
            // wareHouseLookupList
            wareHouseController.wareHouseLookupList,
      ),
    );

    var wareHouseAndSearch = Row(
      children: [
        Expanded(child: warehouseDropDown),
        orderTrackingNumber!.isNotEmpty
            ? const MyLoadingIndicator()
            : Container(),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: MyElevatedButton(
              text: 'Search',
              btnBackgroundColor: MyColors.btnColorGreen,
              onPressed: () {
                loadOrders(tmpM == null ? '' : tmpM!.merchantId,
                    tmpR == null ? '' : tmpR!.riderId);
              },
            ),
          ),
        ),
      ],
    );

    var counter = ShowOrdersCount(
      text: selectedRecords.isEmpty ? 'Showing' : 'Scanned',
      alignment: Alignment.centerRight,
      listLength:
          selectedRecords.isEmpty ? lsDataList.length : selectedRecords.length,
      totalElements: lsDataList.length,
    );

    var stockInButton = MyElevatedButton(
      // text: 'Stock In Picked',
      text: 'Pick Up Inbound',
      btnBackgroundColor: MyColors.btnColorGreen,
      btnPaddingHorizontalSize: 8,
      onPressed: () {
        if (selectedWareHouse != null &&
            selectedWareHouse!.isNotEmpty &&
            selectedWareHouse != MyVariables.wareHouseDropdownSelectAllText &&
            tmpW?.wareHouseId != null) {
          if (selectedRecords.isNotEmpty) {
            myShowConfirmationDialog(
                title: 'Pick Up Inbound',
                description:
                    'Are you sure you want to mark these orders as PostEx. Received?',
                onSavePressed: () {
                  myShowLoadingDialog(context);

                  requestData = PickUpInboundRequestData(
                    transactionIds: selectedRecords,
                    wareHouseId: tmpW!.wareHouseId,
                  );

                  apiPostData.patchPickUpInbound(requestData).then((value) {
                    if (value != null) {
                      if (mounted) {
                        removeDataLocally();
                        Get.isDialogOpen! == true ? tryToPop(context) : null;
                        myShowSuccessMSGDialog(
                            description:
                                'Orders Marked as PostEx. Received successfully',
                            customOnPressedOK: () {
                              Get.isDialogOpen! == true
                                  ? tryToPop(context)
                                  : null;
                              tryToPopTrue(context);
                            });
                      }
                    } else {
                      // Get.isDialogOpen! ? tryToPop(context) : null;
                    }
                  });
                });
          } else {
            myToastError('Please scan orders');
          }
        } else {
          myToastError('Please select WareHouse');
        }
      },
    );

    return
        // DefaultTabController(
        //   length: tabsLength,
        //   child:
        Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffoldBackgroundColor,
      appBar: appBar,
      // drawer: MyAppDrawer(),
      body:
          // TabBarView(controller: _tabController, children: [
/////////////************ Via Scan ***********//////////////
          Padding(
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            const MySpaceHeight(heightSize: 1.5),
            containerMerchantRiderDropdown,
            const MySpaceHeight(heightSize: 1),
            wareHouseAndSearch,
            const MySpaceHeight(heightSize: 0.5),
            counter,
            const MySpaceHeight(heightSize: 1.5),
            Expanded(child: searchedDataList),
            stockInButton,
          ],
        ),
      ),

// /////////////************ Via Search ***********//////////////
//           Padding(
//             padding: MyVariables.scaffoldBodyPadding,
//             child: Column(
//               children: [
//                 containerDropdown,
//                 Row(
//                   children: [
//                     Expanded(
//                         child: scannedOrdersList.isNotEmpty
//                             ? showSelectedOrdersCount
//                             : ShowOrdersCount(
//                                 listLength: ordersList.length,
//                                 totalElements: pagination.totalElements)),
//                     Expanded(child: searchBtnContainer),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Expanded(child: warehouseDropDown),
//                     Expanded(child: Container()),
//                   ],
//                 ),
//                 const MySpaceHeight(heightSize: 1.5),

//                 // Obx(() {
//                 //   return
//                 Expanded(
//                     child:
//                         // ordersController.isLoading.value
//                         //     ? MyLoadingIndicator(
//                         //         centerIt: true,
//                         //       )
//                         // :
//                         searchedDataList),
//                 // }),
//                 stockInButton,
//               ],
//             ),
//           ),
      // ]),
      // ),
    );
  }
}
