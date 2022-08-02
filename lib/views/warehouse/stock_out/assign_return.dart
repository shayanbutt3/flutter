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

import '../../../custom/custom_widgets/show_response_dialog.dart';

//// This will change transaction status to Return En-Route ////

class AssignReturn extends StatefulWidget {
  const AssignReturn({Key? key}) : super(key: key);

  @override
  _AssignReturnState createState() => _AssignReturnState();
}

class _AssignReturnState extends State<AssignReturn>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;

  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  final _tabsLength = 2;

  // List<RiderLookupDataDist> riderLookupList = [];
  // RiderController riderController = Get.find<RiderController>();
  final RiderController riderController = Get.put(RiderController());

  List<int> selectedRecords = [];
  List<OrdersDataDist> scannedOrdersList = [];
  List<SheetDetailDataDist> sheetDetailList = [];

  String? selectedRider;
  late RiderLookupDataDist tmpR;

  String? orderTrackingNumber = '';

  MarkReturnInTransitRequestData requestData = MarkReturnInTransitRequestData();

  int page = 0;

  // loadRiders() {
  //   apiFetchData.getRiderLookup().then((value) {
  //     if (value != null) {
  //       if (mounted) {
  //         setState(() {
  //           riderLookupList.addAll(value.dist!);
  //         });
  //       }
  //     }
  //   });
  // }

  loadData() async {
    if (selectedRider != null) {
      myShowLoadingDialog(context);
      apiFetchData
          .getSheetDetail(
        tmpR.riderId,
        MyVariables.orderStatusIdRiderAssignedToReturn,
        '',
        MyVariables.sheetTypeIdReturn,
        MyVariables.sheetStatusIdsNewAndPickedAndReturnInProgress,
        '',
        '',
        '',
        MyVariables.paginationDisable,
        page,
        MyVariables.size,
        MyVariables.sortDirection,
        sheetOrderStatusIds: MyVariables.orderStatusIdRiderAssignedToReturn,
      )
          .then((value) {
        if (value != null) {
          if (mounted) {
            Get.isDialogOpen! ? tryToPop(context) : null;
            if (value.dist!.isNotEmpty) {
              setState(() {
                clearData();
                sheetDetailList.addAll(value.dist!);
              });
            } else {
              clearData();
              myToastSuccess(MyVariables.notFoundErrorMSG);
            }
          }
        } else {
          // Get.isDialogOpen! ? tryToPop(context) : null;
        }
      });
    } else {
      myToastError('Please select Rider to search');
    }
  }

  removeFromList(List<int> records) {
    for (int i = 0; i < records.length; i++) {
      setState(() {
        sheetDetailList.removeWhere(
            (element) => element.transaction?.transactionId == records[i]);
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

  clearData() {
    setState(() {
      selectedRecords = [];
      scannedOrdersList = [];
      sheetDetailList = [];
    });
  }

  @override
  void initState() {
    super.initState();
    // loadRiders();

    // _tabController = TabController(length: _tabsLength, vsync: this);
  }

  Future _scanQR() async {
    if (selectedRider != null && selectedRider!.isNotEmpty) {
      // tmpR =
      //     // riderLookupList
      //     riderController.riderLookupList
      //         .firstWhere((element) => element.riderName == selectedRider);
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
      myToastError('Please select Rider to scan');
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
            .getSheetDetail(
            tmpR.riderId,
            MyVariables.orderStatusIdRiderAssignedToReturn,
            orderTrackingNumber,
            MyVariables.sheetTypeIdReturn,
            MyVariables.sheetStatusIdsNewAndPickedAndReturnInProgress,
            '',
            '',
            '',
            MyVariables.paginationDisable,
            page,
            MyVariables.size,
            MyVariables.sortDirection,
            sheetOrderStatusIds: MyVariables.orderStatusIdRiderAssignedToReturn,
          )
            .then((value) {
            if (value != null) {
              if (mounted) {
                if (value.dist!.isNotEmpty) {
                  var dist = value.dist![0].transaction!;
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
            text: 'Assign Return',
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

    var containerDropdownScan = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
            child: myDropDownRider,
          ),
          orderTrackingNumber!.isNotEmpty
              ? const MyLoadingIndicator()
              : Container(),
          Expanded(
              child: ShowOrdersCount(
            text: 'Scanned',
            alignment: Alignment.centerRight,
            listLength: selectedRecords.length,
          )),
        ],
      ),
    );

    var containerDropdownSearch = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
            child: myDropDownRider,
          ),
          Expanded(
              child: ShowOrdersCount(
            text: selectedRecords.isNotEmpty ? 'Selected' : null,
            alignment: Alignment.centerRight,
            listLength: selectedRecords.isNotEmpty
                ? selectedRecords.length
                : sheetDetailList.length,
            totalElements: sheetDetailList.length,
          )),
        ],
      ),
    );

    var mySearchDataBtn = Container(
        width: SizeConfig.safeScreenWidth,
        alignment: Alignment.centerRight,
        child: MyElevatedButton(
          text: 'Search',
          btnBackgroundColor: MyColors.btnColorGreen,
          onPressed: loadData,
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
        itemCount: sheetDetailList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCard(
            dist: sheetDetailList[index].transaction!,
            needToHideDeleteIcon: true,
            isSelected: selectedRecords
                .contains(sheetDetailList[index].transaction!.transactionId),
            onChangedCheckBox: (b) {
              onSelected(b!, sheetDetailList[index].transaction!);
            },
          );
        });

    var assignReturnButton = MyElevatedButton(
      text: 'Assign for Return',
      btnBackgroundColor: MyColors.btnColorGreen,
      btnPaddingHorizontalSize: 8,
      onPressed: () {
        if (selectedRider != null && selectedRider!.isNotEmpty) {
          if (selectedRecords.isNotEmpty) {
            myShowLoadingDialog(context);

            requestData = MarkReturnInTransitRequestData(
              transactionIds: selectedRecords,
            );

            apiPostData.patchMarkReturnInTransit(requestData).then((value) {
              if (value != null) {
                if (mounted) {
                  // Fluttertoast.showToast(msg: value.statusMessage!);
                  removeDataLocally();
                  Get.isDialogOpen! ? tryToPop(context) : null;
                  myShowSuccessMSGDialog(
                    description:
                        'Orders successfully assigned to rider for return',
                  );
                }
              } else {
                // Get.isDialogOpen! ? tryToPop(context) : null;
              }
            });
          } else {
            myToastError('Please scan orders');
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
                  Expanded(child: scannedOrdersDataList),
                  assignReturnButton,
                ],
              ),
            ),

            /////////////************ Via Search ***********//////////////
            Padding(
              padding: MyVariables.scaffoldBodyPadding,
              child: Column(
                children: [
                  const MySpaceHeight(heightSize: 1.5),
                  containerDropdownSearch,
                  mySearchDataBtn,
                  const MySpaceHeight(heightSize: 1.5),
                  Expanded(child: searchedOrdersDataList),
                  assignReturnButton,
                ],
              ),
            ),
          ]),
        ));
  }
}
