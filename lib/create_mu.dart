import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/roles_Lookup_controller.dart';
import 'package:backoffice_new/controllers/user_role_lookup_controller.dart';
import 'package:backoffice_new/controllers/warehouse_controller.dart';
import 'package:backoffice_new/create_mu_dialog.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
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

import 'models/stock_in_model.dart';

class CreateMuScreen extends StatefulWidget {
  const CreateMuScreen({Key? key}) : super(key: key);

  @override
  State<CreateMuScreen> createState() => _CreateMuScreenState();
}

class _CreateMuScreenState extends State<CreateMuScreen> {
  final WareHouseController wareHouseController =
      Get.put(WareHouseController());
  final RolesLookupController rolesLookupController =
      Get.put(RolesLookupController());
  final UserRolesLookupController userRolesLookupController =
      Get.put(UserRolesLookupController());

  List<OrdersDataDist> searchedOrdersList = [];
  List<OrdersDataDist> scannedOrdersList = [];
  List<int> selectedRecords = [];
  String orderTrackingNumber = '';

  String? selectedWareHouse;
  WareHouseDataDist? tmpW;

  String? selectedFromTeam;
  UserRolesLookupDataDist? tmpFT;
  String? selectedToTeam;
  RolesLookupDataDist? tmpTT;

  String myVariableFirstMile = "First Mile";
  String myVariableMidMile = "Mid Mile";

  final _tabslength = 2;
  ApiFetchData apiFetchData = ApiFetchData();

  loadData() {
    myShowLoadingDialog(context);
    apiFetchData
        .getOrders(
      '',
      '',
      '',
      tmpFT?.roleId == MyVariables.midMileRoleId &&
              tmpTT?.roleId == MyVariables.lastMileRoleId
          ? MyVariables.orderStatusIdsToLoadForMidMileLastMile
          : tmpFT?.roleId == MyVariables.midMileRoleId &&
                  tmpTT?.roleId == MyVariables.returnTeamRoleId
              ? MyVariables.orderStatusIdsToLoadForMidMileReturnTeam
              : tmpFT?.roleId == MyVariables.debriefingTeamRoleId &&
                      tmpTT?.roleId == MyVariables.returnTeamRoleId
                  ? MyVariables.orderStatusIdsToLoadForDebrieferTeamReturnTeam
                  : tmpFT?.roleId == MyVariables.debriefingTeamRoleId &&
                          tmpTT?.roleId == MyVariables.lastMileRoleId
                      ? MyVariables.orderStatusIdsToLoadForDebrieferTeamLastMile
                      : tmpFT?.roleId == MyVariables.returnTeamRoleId &&
                              tmpTT?.roleId == MyVariables.midMileRoleId
                          ? MyVariables.orderStatusIdsToLoadForReturnTeamMidMile
                          : tmpFT?.roleId == MyVariables.returnTeamRoleId &&
                                  tmpTT?.roleId == MyVariables.lastMileRoleId
                              ? MyVariables
                                  .orderStatusIdsToLoadForReturnTeamLastMile
                              : '',
      tmpW!.wareHouseId,
      '',
      '',
      '',
      '',
      MyVariables.paginationDisable,
      0,
      MyVariables.size,
      MyVariables.sortDirection,
      orderPhysicalStatusIds: tmpFT?.roleId == MyVariables.firstMileRoleId &&
              tmpTT?.roleId == MyVariables.midMileRoleId
          ? MyVariables.orderPhysicalStatusWaitingForMidMile
          : tmpFT?.roleId == MyVariables.midMileRoleId &&
                  tmpTT?.roleId == MyVariables.lastMileRoleId
              ? MyVariables.orderPhysicalStatusIdsToLoadForMidMileLastMile
              : tmpFT?.roleId == MyVariables.midMileRoleId &&
                      tmpTT?.roleId == MyVariables.returnTeamRoleId
                  ? MyVariables.orderPhysicalStatusIdsToLoadForMidMileReturnTeam
                  : tmpFT?.roleId == MyVariables.debriefingTeamRoleId &&
                          tmpTT?.roleId == MyVariables.returnTeamRoleId
                      ? MyVariables
                          .orderPhysicalStatusIdsToLoadForDebrieferTeamReturnTeam
                      : tmpFT?.roleId == MyVariables.debriefingTeamRoleId &&
                              tmpTT?.roleId == MyVariables.lastMileRoleId
                          ? MyVariables
                              .orderPhysicalStatusIdsToLoadForDebrieferTeamLastMile
                          : tmpFT?.roleId == MyVariables.returnTeamRoleId &&
                                  tmpTT?.roleId == MyVariables.midMileRoleId
                              ? MyVariables
                                  .orderPhysicalStatusIdsToLoadForReturnTeamMidMile
                              : tmpFT?.roleId == MyVariables.returnTeamRoleId &&
                                      tmpTT?.roleId ==
                                          MyVariables.lastMileRoleId
                                  ? MyVariables
                                      .orderPhysicalStatusIdsToLoadForReturnTeamLastMile
                                  : '',
    )
        .then((value) {
      if (value != null) {
        if (value.dist!.isNotEmpty) {
          if (mounted) {
            setState(() {
              searchedOrdersList.addAll(value.dist!);
            });
          }
        } else {
          myToastSuccess(MyVariables.notFoundErrorMSG);
        }
        Get.isDialogOpen! ? tryToPop(context) : null;
      }
    });
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

  Future _scanQR() async {
    try {
      FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      )!
          .listen((value) {
        if (value.isNotEmpty && value != '-1') {
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

  removeAndInsertInList(OrdersDataDist ordersDataDist) {
    setState(() {
      scannedOrdersList.removeWhere(
          (element) => element.transactionId == ordersDataDist.transactionId);
      searchedOrdersList.insert(0, ordersDataDist);
      selectedRecords
          .removeWhere((element) => element == ordersDataDist.transactionId);
    });
  }

  onLoadTeams() async {
    await userRolesLookupController.fetchUserRoles();
    await rolesLookupController.fetchRoles();
    setState(() {
      if (userRolesLookupController.userRolesLookupList.length == 1) {
        for (int i = 0;
            i < userRolesLookupController.userRolesLookupList.length;
            i++) {
          selectedFromTeam =
              userRolesLookupController.userRolesLookupList[i].roleName;
          tmpFT = userRolesLookupController.userRolesLookupList[i];
        }
        selectedToTeam = tmpFT?.roleId == MyVariables.firstMileRoleId
            ? myVariableMidMile
            : selectedToTeam;
        tmpTT = rolesLookupController.rolesLookupList.firstWhere(
          (element) => element.roleName == selectedToTeam,
          orElse: () => RolesLookupDataDist(),
        );
      }
    });
  }

  @override
  void initState() {
    onLoadTeams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var appbar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBarWithBottom,
      child: SafeArea(
          child: AppBar(
        title: const MyTextWidgetAppBarTitle(text: 'Create MU'),
        iconTheme: MyVariables.appBarIconTheme,
        toolbarHeight: MyVariables.appbarHeight,
        flexibleSpace: const MyAppBarFlexibleContainer(),
        elevation: 0,
        backgroundColor: MyVariables.appBarBackgroundColor,
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
              onPressed: searchedOrdersList.isNotEmpty
                  ? _scanQR
                  : () {
                      myToastError('Please search orders to scan');
                    },
              icon: Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: SizeConfig.blockSizeHorizontal * 8,
              ))
        ],
      )),
    );
    var warehouseDropDown = Container(
      alignment: Alignment.centerLeft,
      child: MyDropDownWareHouse(
        selectedValue: selectedWareHouse,
        isExpanded: true,
        onChanged: (val) {
          setState(() {
            selectedWareHouse = val.toString();
            tmpW = wareHouseController.wareHouseLookupList.firstWhere(
                (element) => element.wareHouseName == selectedWareHouse,
                orElse: () => WareHouseDataDist());
          });
        },
        listOfItems: wareHouseController.wareHouseLookupList,
      ),
    );

    var receivingTeamDropDown = MyDropDownUserRolesLookup(
      selectedValue: selectedFromTeam,
      isExpanded: true,
      onChanged: (val) {
        setState(() {
          selectedFromTeam = val.toString();
          tmpFT = userRolesLookupController.userRolesLookupList.firstWhere(
              (element) => element.roleName == selectedFromTeam,
              orElse: () => UserRolesLookupDataDist());
        });
        selectedToTeam = tmpFT?.roleId == MyVariables.firstMileRoleId
            ? userRolesLookupController.userRolesLookupList[1].roleName
            : null;
        tmpTT = rolesLookupController.rolesLookupList.firstWhere(
          (element) => element.roleName == selectedToTeam,
          orElse: () => RolesLookupDataDist(),
        );
      },
      listOfItems: userRolesLookupController.userRolesLookupList,
    );

    var receivingToTeamDropDown = Container(
      alignment: Alignment.centerLeft,
      child: MyDropDownRolesLookup(
        selectedValue: selectedToTeam,
        isExpanded: true,
        onChanged: (val) {
          setState(() {
            selectedToTeam = val.toString();
            tmpTT = rolesLookupController.rolesLookupList.firstWhere(
                (element) => element.roleName == selectedToTeam,
                orElse: () => RolesLookupDataDist());
          });
        },
        listOfItems: tmpFT?.roleId == MyVariables.firstMileRoleId
            ? rolesLookupController.rolesLookupList
                .where(
                  (element) => element.roleId == MyVariables.midMileRoleId,
                )
                .toList()
                .obs
            : tmpFT?.roleId == MyVariables.midMileRoleId
                ? rolesLookupController.rolesLookupList
                    .where((element) =>
                        element.roleId == MyVariables.lastMileRoleId ||
                        element.roleId == MyVariables.returnTeamRoleId)
                    .toList()
                    .obs
                : tmpFT?.roleId == MyVariables.debriefingTeamRoleId
                    ? rolesLookupController.rolesLookupList
                        .where(
                          (element) =>
                              element.roleId == MyVariables.returnTeamRoleId ||
                              element.roleId == MyVariables.lastMileRoleId,
                        )
                        .toList()
                        .obs
                    : tmpFT?.roleId == MyVariables.returnTeamRoleId
                        ? rolesLookupController.rolesLookupList
                            .where(
                              (element) =>
                                  element.roleId == MyVariables.midMileRoleId ||
                                  element.roleId == MyVariables.lastMileRoleId,
                            )
                            .toList()
                            .obs
                        : [].obs,
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

    var scannedCounter = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: ShowOrdersCount(
        text: 'Scanned',
        alignment: Alignment.centerRight,
        listLength: scannedOrdersList.length,
      ),
    );

    var searchBtn = Container(
        width: SizeConfig.safeScreenWidth,
        alignment: Alignment.centerRight,
        child: MyElevatedButton(
            text: 'Search',
            btnBackgroundColor: MyColors.btnColorGreen,
            onPressed: () {
              if (selectedFromTeam != null) {
                if (selectedToTeam != null) {
                  if (selectedWareHouse != null &&
                      selectedWareHouse!.isNotEmpty &&
                      selectedWareHouse !=
                          MyVariables.wareHouseDropdownSelectAllText &&
                      tmpW?.wareHouseId != null) {
                    setState(() {
                      selectedRecords = [];
                      searchedOrdersList = [];
                      scannedOrdersList = [];
                    });
                    loadData();
                  } else {
                    myToastError('Please Select Warehouse to Search');
                  }
                } else {
                  myToastError('Please Select To Team to Search');
                }
              } else {
                myToastError('Please Select From Team to Search');
              }
            }));

    var createMuBtn = Container(
        width: SizeConfig.safeScreenWidth,
        alignment: Alignment.center,
        child: MyElevatedButton(
            text: 'Create MU',
            btnBackgroundColor: MyColors.btnColorGreen,
            onPressed: () {
              if (selectedRecords.isNotEmpty) {
                Get.dialog(
                  CreateMuDialog(
                    fromTeamId: tmpFT!.roleId,
                    toTeamId: tmpTT!.roleId,
                    transactionIds: selectedRecords,
                    wareHouseId: tmpW!.wareHouseId,
                  ),
                  barrierDismissible: false,
                ).then((value) {
                  if (value == true) {
                    setState(() {
                      scannedOrdersList = [];
                    });
                  }
                });
              } else {
                myToastError('Please scan orders to Create MU');
              }
            }));

    final searchedorderslist = ListView.builder(
      itemCount: searchedOrdersList.length,
      itemBuilder: (BuildContext context, index) {
        return MyCard(
          dist: searchedOrdersList[index],
          needToHideDeleteIcon: true,
          needToHideCheckBox: true,
        );
      },
    );

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

    return DefaultTabController(
      length: _tabslength,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.scaffoldBackgroundColor,
        appBar: appbar,
        body: TabBarView(
          children: [
            //////Pending Scan///////

            Padding(
              padding: MyVariables.scaffoldBodyPadding,
              child: Column(
                children: [
                  const MySpaceHeight(heightSize: 1.5),
                  Row(
                    children: [
                      Expanded(child: receivingTeamDropDown),
                      const MySpaceWidth(widthSize: 1.5),
                      Expanded(child: receivingToTeamDropDown),
                    ],
                  ),
                  const MySpaceHeight(heightSize: 1.5),
                  Row(
                    children: [
                      Expanded(child: warehouseDropDown),
                      Expanded(child: searchBtn),
                    ],
                  ),
                  const MySpaceHeight(heightSize: 0.5),
                  searchedCounter,
                  const MySpaceHeight(heightSize: 1.5),
                  Expanded(child: searchedorderslist),
                ],
              ),
            ),

            ////////Scanned////////

            Padding(
              padding: MyVariables.scaffoldBodyPadding,
              child: Column(
                children: [
                  const MySpaceHeight(heightSize: 1.5),
                  Row(
                    children: [Expanded(child: scannedCounter)],
                  ),
                  orderTrackingNumber.isNotEmpty
                      ? const MyLoadingIndicator()
                      : Container(),
                  const MySpaceHeight(heightSize: 1.5),
                  Expanded(child: scannedOrdersDataList),
                  const MySpaceHeight(heightSize: 1.5),
                  createMuBtn
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
