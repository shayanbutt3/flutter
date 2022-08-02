import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/controllers/employee_profile_controller.dart';
import 'package:backoffice_new/controllers/user_menu_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card_loadsheet.dart';
import 'package:backoffice_new/custom/custom_widgets/new_version_available.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:backoffice_new/views/city_lead_dashboard.dart';
import 'package:backoffice_new/views/login.dart';
import 'package:backoffice_new/views/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/my_app_drawer.dart';
import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:version_check/version_check.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({this.needToLoadMenu, this.needToLoadProfile, Key? key})
      : super(key: key);

  final bool? needToLoadMenu;
  final bool? needToLoadProfile;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  MenuController menuController = Get.put(MenuController());
  EmployeeProfileController employeeProfileController =
      Get.put(EmployeeProfileController());

  List<LoadSheetDataDist> loadSheetsList = [];
  Pagination pagination = Pagination();

  bool isLoadingListView = false;
  bool hasMoreData = true;

  bool isAdmin = false;

  late SharedPreferences localStorage;

  // final newVersion = NewVersion(
  //   androidId: "com.postex.backoffice",
  // );

  loadData(
      {bool? needToShowLoadingDialog,
      bool? needToMakeIsLoadingListViewTrue}) async {
    needToShowLoadingDialog == true ? myShowLoadingDialog(context) : null;
    needToMakeIsLoadingListViewTrue == true
        ? setState(() {
            isLoadingListView = true;
          })
        : null;
    apiFetchData
        .getLoadSheets(
            MyVariables.loadSheetStatusIdForPendingPickups,
            '',
            '', //myFormatDateOnly(myGetDateTime().toString()),
            '', //myFormatDateOnly(myGetDateTime().toString()),
            MyVariables.paginationEnable,
            pagination.page == null ? 0 : pagination.page!,
            MyVariables.size,
            MyVariables.sortDirection)
        .then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            loadSheetsList.addAll(value.dist!);
            pagination = value.pagination!;
            isLoadingListView = false;
          });
          Get.isDialogOpen! ? tryToPop(context) : null;
        }
      } else {
        // Get.isDialogOpen! ? tryToPop(context) : null;
      }
    });
  }

  checkIsAdmin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userTypeId = sharedPreferences.getString('userTypeId');
    if (userTypeId != null) {
      if (int.parse(userTypeId) == MyVariables.userTypeIdAdmin) {
        isAdmin = true;
      } else {
        isAdmin = false;
      }
    }
  }

  void signOut() async {
    myShowLoadingDialog(context);
    apiPostData.logout().then((value) async {
      if (value != null) {
        Get.isDialogOpen! ? tryToPop(context) : null;

        localStorage = await SharedPreferences.getInstance();
        localStorage.remove('jwtToken');
        localStorage.clear();
        menuController.menuList.value = [];
        myToastSuccess('Logged out successfully');
        Get.offAll(() => const Login());
      } else {}
    });
  }

  // void _checkNewVersion() async {
  //   final status = await newVersion.getVersionStatus();

  //   if (status!.canUpdate) {
  //     signOut();
  //   } else {}
  // }

  final versionCheck = VersionCheck(
    packageName: 'com.postex.backoffice',
    showUpdateDialog: myCustomShowUpdateDialog,
  );

  checkVersion() async {
    await versionCheck.checkVersion(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => loadData(needToShowLoadingDialog: true));

    // menuController.menuList.isEmpty ? menuController.loadMenu() : null;
    widget.needToLoadMenu == true ? menuController.loadMenu() : null;
    widget.needToLoadProfile == true
        ? employeeProfileController.loadProfileData()
        : null;
    // loadData();

    checkIsAdmin();
    // _checkNewVersion();
    checkVersion();
  }

  Future _scanQR() async {
    FlutterBarcodeScanner.scanBarcode('green', 'Cancel', true, ScanMode.QR)
        .then((value) {
      if (value != '-1' && value.isNotEmpty) {
        Get.to(OrderDetail(trackingNumber: value.trim()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var list = NotificationListener(
        onNotification: loadSheetsList.isEmpty
            ? null
            : (ScrollNotification scrollInfo) {
                var metrics = scrollInfo.metrics;
                var pixels = metrics.pixels;
                if (!isLoadingListView &&
                    pixels == metrics.maxScrollExtent &&
                    pixels != metrics.minScrollExtent) {
                  setState(() {
                    if (pagination.page! == pagination.totalPages!) {
                      isLoadingListView = false;
                      hasMoreData = false;
                    } else {
                      pagination.page = pagination.page! + 1;
                      loadData(needToMakeIsLoadingListViewTrue: true);
                    }
                  });
                  return true;
                }
                return false;
              },
        child: ListView.builder(
            itemCount: loadSheetsList.length,
            itemBuilder: (context, index) {
              return MyCardLoadSheet(
                dist: loadSheetsList[index],
              );
            }));

    // final list = FutureBuilder(
    //     future: apiFetchData.getLoadSheets(
    //         MyVariables.loadSheetStatusIdForPendingPickups,
    //         MyVariables.paginationDisable,
    //         0,
    //         MyVariables.size,
    //         MyVariables.sortDirection),
    //     builder:
    //         (BuildContext context, AsyncSnapshot<LoadSheetData?> snapshot) {
    //       if (snapshot.hasData) {
    //         var data = snapshot.data!;
    //         WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //           setState(() {
    //             loadSheetsList = data.dist!;
    //             pagination = data.pagination!;
    //           });
    //         });
    //         return ListView.builder(
    //             itemCount: loadSheetsList.length,
    //             itemBuilder: (context, index) {
    //               return MyCardLoadSheet(
    //                 dist: loadSheetsList[index],
    //               );
    //             });
    //       } else if (snapshot.hasError) {
    //         return Center(
    //           child: MyTextWidgetCustom(
    //             text: 'Error Occured: ${snapshot.error}',
    //             color: Colors.red,
    //             sizeBlockHorizontalDigit: 5,
    //           ),
    //         );
    //       } else {
    //         return const MyLoadingIndicator(
    //           centerIt: true,
    //         );
    //       }
    //     });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffoldBackgroundColor,
      appBar: PreferredSize(
          child: SafeArea(
            child: AppBar(
              elevation: 0,
              backgroundColor: MyVariables.appBarBackgroundColor,
              iconTheme: MyVariables.appBarIconTheme,
              toolbarHeight: MyVariables.appbarHeight,
              title: const MyTextWidgetAppBarTitle(
                text: 'Dashboard',
              ),
              flexibleSpace: const MyAppBarFlexibleContainer(),
              actions: [
                // isAdmin == true
                //     ?
                IconButton(
                    onPressed: () {
                      Get.to(() => const CityLeadDashboard());
                    },
                    tooltip: 'City-Lead-Dashboard',
                    icon: Icon(
                      Icons.home_work_outlined,
                      size: SizeConfig.safeBlockSizeHorizontal * 8,
                    )),
                // : Container(),
                IconButton(
                  icon: Icon(
                    Icons.qr_code_scanner,
                    size: SizeConfig.safeBlockSizeHorizontal * 8,
                  ),
                  onPressed: _scanQR,
                ),
                // TextButton(
                //     onPressed: () {},
                //     child: const MyTextWidgetCustom(
                //       text: 'Track Order',
                //       color: Colors.white,
                //       sizeBlockHorizontalDigit: 4,
                //     )),
                IconButton(
                    onPressed: () {
                      Get.offAll(() => const Dashboard(
                            needToLoadMenu: true,
                            needToLoadProfile: true,
                          ));
                    },
                    icon: Icon(
                      Icons.refresh_outlined,
                      size: SizeConfig.safeBlockSizeHorizontal * 8,
                    )),
                const MySpaceWidth(widthSize: 2),
              ],
            ),
          ),
          preferredSize: MyVariables.preferredSizeAppBar),
      drawer: const MyAppDrawer(),
      body: Container(
        width: SizeConfig.safeScreenWidth,
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            const MySpaceHeight(heightSize: 1),
            const MyTextWidgetHeading(
              text: 'Pending Pickups',
            ),
            const MySpaceHeight(heightSize: 1),
            ShowOrdersCount(
              listLength: loadSheetsList.length,
              alignment: Alignment.centerRight,
              totalElements: pagination.totalElements,
            ),
            const MySpaceHeight(heightSize: 1.5),
            Expanded(child: list),
            isLoadingListView == true
                ? const MyLoadingIndicator(
                    centerIt: true,
                  )
                : Container(),
            hasMoreData == false ? const MyNoMoreDataContainer() : Container(),
          ],
        ),
      ),
    );
  }
}
