import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/employee_profile_controller.dart';
import 'package:backoffice_new/create_mu.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:backoffice_new/views/de_manifest_screen.dart';
import 'package:backoffice_new/views/handover.dart';
import 'package:backoffice_new/views/dispatch_transfer_sheet.dart';
import 'package:backoffice_new/views/load_sheet_management/generate_loadsheet.dart';
import 'package:backoffice_new/views/reschedule_delivery.dart';
import 'package:backoffice_new/views/mark_misroute.dart';
import 'package:backoffice_new/views/under_verification/mark_customer_refused.dart';
import 'package:backoffice_new/views/order_management/mark_lost.dart';
import 'package:backoffice_new/views/order_management/mark_picked.dart';
import 'package:backoffice_new/controllers/user_menu_controller.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/models/user/user_model.dart';
import 'package:backoffice_new/views/dashboard.dart';
import 'package:backoffice_new/views/order_management/mark_attempted.dart';
import 'package:backoffice_new/views/order_management/mark_delivered.dart';
import 'package:backoffice_new/views/order_management/mark_returned.dart';
import 'package:backoffice_new/views/order_management/revert_pickup_order.dart';
import 'package:backoffice_new/views/reports.dart/delivery_sheet.dart';
import 'package:backoffice_new/views/reschedule_return_screen.dart';
import 'package:backoffice_new/views/rider_management/assign_pickup.dart';
import 'package:backoffice_new/views/rider_management/generate_delivery_sheet.dart';
import 'package:backoffice_new/views/rider_management/generate_return_sheet.dart';
import 'package:backoffice_new/views/rider_management/revert_order.dart';
import 'package:backoffice_new/views/rider_management/revert_return_sheet.dart';
import 'package:backoffice_new/views/rider_management/revert_delivery_sheet.dart';
import 'package:backoffice_new/views/under_verification/revert_return_request.dart';
import 'package:backoffice_new/views/under_verification/mark_return_request.dart';
import 'package:backoffice_new/views/under_verification/mark_under_verification.dart';
import 'package:backoffice_new/views/under_verification/retry_re_attempt.dart';
import 'package:backoffice_new/views/under_verification/verification_list.dart';
import 'package:backoffice_new/views/user_profile.dart';
import 'package:backoffice_new/views/warehouse/stock_out/assign_delivery.dart';
import 'package:backoffice_new/views/warehouse/stock_out/assign_return.dart';
import 'package:backoffice_new/views/warehouse/stock_out/generate_transfer_sheet.dart';
import 'package:backoffice_new/views/warehouse/stock_in/stock_in_others.dart';
import 'package:backoffice_new/views/warehouse/stock_in/stock_in_picked.dart';
import 'package:backoffice_new/views/warehouse/stock_in/stock_in_transferred.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppDrawer extends StatefulWidget {
  const MyAppDrawer({Key? key}) : super(key: key);

  @override
  _MyAppDrawerState createState() => _MyAppDrawerState();
}

class _MyAppDrawerState extends State<MyAppDrawer> {
  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  final MenuController menuController = Get.find<MenuController>();
  final EmployeeProfileController employeeProfileController =
      Get.find<EmployeeProfileController>();

  // String? userPhone;

  late SharedPreferences localStorage;

  _onItemSelect(int menuId) {
    tryToPop(context);
    setState(() {
      switch (menuId) {
        case MyVariables.childMenuIdAssignDeliveries:
          Get.to(() => const AssignDelivery());
          break;
        case MyVariables.childMenuIdAssignReturn:
          Get.to(() => const AssignReturn());
          break;
        case MyVariables.childMenuIdAssignPickup:
          Get.to(() => const AssignPickup());
          break;
        case MyVariables.childMenuIdGenerateDeliverySheet:
          Get.to(() => const GenerateDeliverySheet());
          break;
        case MyVariables.childMenuIdGenerateLoadSheet:
          Get.to(() => const GenerateLoadSheet());
          break;
        case MyVariables.childMenuIdGenerateReturnSheet:
          Get.to(() => const GenerateReturnSheet());
          break;
        case MyVariables.childMenuIdMarkAttempt:
          Get.to(() => const MarkAttempted());
          break;
        case MyVariables.childMenuIdMarkDelivered:
          Get.to(() => const MarkDelivered());
          break;
        case MyVariables.childMenuIdMarkPicked:
          Get.to(() => const MarkPicked());
          break;
        case MyVariables.childMenuIdMarkRetry:
          Get.to(() => const RetryReAttempt());
          break;
        case MyVariables.childMenuIdMarkReturnRequest:
          Get.to(() => const MarkReturnRequest());
          break;
        case MyVariables.childMenuIdMarkDeliveryUnderReview:
          Get.to(() => const MarkUnderVerification());
          break;
        case MyVariables.childMenuIdPickupInbound:
          Get.to(() => const StockInPicked());
          break;
        case MyVariables.childMenuIdTransferInbound:
          Get.to(() => const StockInTransferred());
          break;
        case MyVariables.childMenuIdSheetClearanceInbound:
          Get.to(() => const StockInOthers());
          break;
        case MyVariables.childMenuIdMarkReturn:
          Get.to(() => const MarkReturned());
          break;
        case MyVariables.childMenuIdDeliverySheetLogs:
          Get.to(() => const DeliverySheetReport());
          break;
        case MyVariables.childMenuIdRevertOrder:
          Get.to(() => const RevertOrder());
          break;
        case MyVariables.childMenuIdRevertReturnSheet:
          Get.to(() => const RevertReturnSheet());
          break;
        case MyVariables.childMenuIdRevertDeliverySheet:
          Get.to(() => const RevertDeliverySheet());
          break;
        case MyVariables.childMenuIdRevertPicked:
          Get.to(() => const RevertPickedOrder());
          break;
        case MyVariables.childMenuIdRevertReturnProcess:
          Get.to(() => const RevertReturnRequest());
          break;
        case MyVariables.childMenuIdDeManifestMU:
          Get.to(() => const DeManifestScreen());
          break;
        case MyVariables.childMenuIdCreateMU:
          Get.to(() => const CreateMuScreen());
          break;
        case MyVariables.childMenuIdDispatchTransferSheet:
          Get.to(() => const DispatchTransferSheet());
          break;
        case MyVariables.childMenuIdMarkReturnReschedule:
          Get.to(() => const RescheduleReturnScreen());
          break;
        case MyVariables.childMenuIdMarkCustomerRefused:
          Get.to(() => const MarkCustomerRefused());
          break;
        case MyVariables.childMenuIdMarkLost:
          Get.to(() => const MarkLost());
          break;
        case MyVariables.childMenuIdGenerateTransferSheet:
          Get.to(() => const GenerateTransferSheet());
          break;
        case MyVariables.childMenuIdMarkDeliveryReschedule:
          Get.to(() => const MarkDeliveryReschdule());
          break;
        case MyVariables.childMenuIdHandoverMU:
          Get.to(() => const HandOverScreen());
          break;
        case MyVariables.childMenuIdMarkMisroute:
          Get.to(() => const MarkMisroute());
          break;
        case MyVariables.childMenuIdPendingVerifications:
          Get.to(() => const VerficationList());
          break;
        default:
          Get.to(() => const Dashboard());
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Colors.white;

    var profileContainer = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Obx(() {
        return employeeProfileController.isLoading.value == true
            ? const MyTextWidgetNormal(text: 'Loading...')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextWidgetCustom(
                    text: employeeProfileController
                            .employeeProfileDataDist.value.firstName ??
                        '',
                    color: textColor,
                    maxLines: 1,
                  ),
                  MyTextWidgetCustom(
                    text: employeeProfileController
                            .employeeProfileDataDist.value.email1 ??
                        '',
                    color: textColor,
                    sizeBlockHorizontalDigit: 3,
                    maxLines: 2,
                  ),
                  MyTextWidgetCustom(
                    text: employeeProfileController.employeeProfileDataDist
                            .value.employeeWareHouses?[0].wareHouseName ??
                        '',
                    color: textColor,
                    sizeBlockHorizontalDigit: 3,
                    maxLines: 1,
                  ),
                ],
              );
      }),
    );

//// Custom account header
    var userAccountsDrawerHeader = Container(
      width: SizeConfig.safeScreenWidth,
      margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1.3),
      // padding: EdgeInsets.symmetric(
      //     vertical: SizeConfig.safeBlockSizeVertical * 3,
      //     horizontal: SizeConfig.safeBlockSizeHorizontal * 3),
      padding: EdgeInsets.only(
        top: SizeConfig.safeBlockSizeVertical * 3,
        bottom: SizeConfig.safeBlockSizeVertical * 1.5,
        left: SizeConfig.safeBlockSizeHorizontal * 3,
        right: SizeConfig.safeBlockSizeHorizontal * 3,
      ),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: SizeConfig.safeBlockSizeHorizontal * 8,
            backgroundColor: MyColors.textColorGreen,
            child: MyTextWidgetCustom(
              text: employeeProfileController
                          .employeeProfileDataDist.value.firstName ==
                      null
                  ? ''
                  : employeeProfileController
                      .employeeProfileDataDist.value.firstName![0]
                      .toString(),
              color: textColor,
              fontWeight: FontWeight.bold,
              sizeBlockHorizontalDigit: 8,
            ),
          ),
          const MySpaceHeight(heightSize: 2.5),
          Row(
            children: [
              Expanded(
                  child: InkWell(
                      onTap: () {
                        tryToPop(context);
                        Get.to(() => Profile(
                            data: employeeProfileController
                                .employeeProfileDataDist.value));
                      },
                      child: profileContainer)),
              Expanded(
                // child: InkWell(
                //   onTap: () {
                //     tryToPop(context);
                //     ModalRoute.of(context)?.settings.name == '/Dashboard'
                //         ? null
                //         : Get.off(() => const Dashboard());
                //   },
                //   // child: MyTextWidgetCustom(
                //   //   text: 'Dashboard',
                //   //   color: MyColors.textColorGreen,
                //   //   fontWeight: FontWeight.w500,
                //   //   sizeBlockHorizontalDigit: 6,
                //   //   maxLines: 1,
                //   //   textAlign: TextAlign.right,
                //   // ),
                //   child: Align(
                //     alignment: Alignment.centerRight,
                //     child: Icon(
                //       Icons.home,
                //       color: Colors.white,
                //       size: SizeConfig.blockSizeHorizontal * 10,
                //     ),
                //   ),
                // ),
                child: IconButton(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    tryToPop(context);
                    ModalRoute.of(context)?.settings.name == '/Dashboard'
                        ? null
                        : Get.off(() => const Dashboard());
                  },
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: SizeConfig.blockSizeHorizontal * 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

//// Menu From Api with MenuController
    var menuItemsContainer = Container(
      color: Colors.black,
      width: SizeConfig.safeScreenWidth,
      child: Obx(() {
        return menuController.isLoadingMenu.value == true
            ? const MyLoadingIndicator(
                centerIt: true,
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: menuController.menuList.length,
                itemBuilder: (BuildContext context, index) {
                  List<MenuChild> child =
                      menuController.menuList[index].childMenuList!;
                  return Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Colors.white54,
                      colorScheme: const ColorScheme.light(
                        primary: Colors.white,
                      ),
                    ),
                    child: menuController.menuList[index].allowed == true &&
                            (menuController.menuList[index].menuId ==
                                    MyVariables.parentMenuIdOrderManagement ||
                                menuController.menuList[index].menuId ==
                                    MyVariables.parentMenuIdPickupManagement ||
                                menuController.menuList[index].menuId ==
                                    MyVariables
                                        .parentMenuIdTransfersManagement ||
                                menuController.menuList[index].menuId ==
                                    MyVariables
                                        .parentMenuIdDeliveryManagement ||
                                menuController.menuList[index].menuId ==
                                    MyVariables.parentMenuIdDeBriefing ||
                                menuController.menuList[index].menuId ==
                                    MyVariables.parentMenuIdReturnManagement ||
                                menuController.menuList[index].menuId ==
                                    MyVariables.parentMenuIdMuManagement ||
                                menuController.menuList[index].menuId ==
                                    MyVariables.parentMenuIdReports)
                        ? ExpansionTile(
                            title: MyTextWidgetCustom(
                              text: menuController.menuList[index].menuOption ??
                                  '',
                              color: Colors.white,
                              sizeBlockHorizontalDigit: 5,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              ListView.builder(
                                  itemCount: child.length,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (BuildContext context, i) {
                                    return child[i].allowed == true &&
                                            (child[i].menuId == MyVariables.childMenuIdPickupInbound ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdTransferInbound ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdSheetClearanceInbound ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdAssignDeliveries ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdAssignReturn ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdGenerateTransferSheet ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdDispatchTransferSheet ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdMarkReturn ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdMarkReturnRequest ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdMarkDeliveryUnderReview ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdMarkRetry ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdGenerateDeliverySheet ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdGenerateReturnSheet ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdGenerateLoadSheet ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdAssignPickup ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdMarkDelivered ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdMarkPicked ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdMarkAttempt ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdDeliverySheetLogs ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdRevertOrder ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdRevertReturnSheet ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdRevertDeliverySheet ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdRevertPicked ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdRevertReturnProcess ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdCreateMU ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdDeManifestMU ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdMarkReturnReschedule ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdMarkDeliveryReschedule ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdMarkCustomerRefused ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdMarkMisroute ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdHandoverMU ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdMarkLost ||
                                                child[i].menuId ==
                                                    MyVariables
                                                        .childMenuIdDispatchTransferSheet ||
                                                child[i].menuId == MyVariables.childMenuIdPendingVerifications)
                                        ? InkWell(
                                            onTap: () {
                                              _onItemSelect(child[i].menuId!);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: SizeConfig
                                                        .safeBlockSizeHorizontal *
                                                    7,
                                                vertical: SizeConfig
                                                        .safeBlockSizeVertical *
                                                    0.8,
                                              ),
                                              child: MyTextWidgetCustom(
                                                text: child[i].menuOption ?? '',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                sizeBlockHorizontalDigit: 3.5,
                                              ),
                                            ))
                                        : Container();
                                  }),
                            ],
                          )
                        : Container(),
                  );
                });
      }),
    );

    var signoutBtn = TextButton(
      onPressed: () async {
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
      },
      child: const MyTextWidgetCustom(
        text: 'Sign Out',
        color: Colors.white,
        sizeBlockHorizontalDigit: 5,
      ),
    );

    return SafeArea(
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.black,
          backgroundColor: Colors.black,
          textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.green)),
        ),
        child: Drawer(
          child: Container(
            height: SizeConfig.safeScreenHeight,
            width: SizeConfig.safeScreenWidth,
            color: Colors.green,
            child: Column(
              children: [
                userAccountsDrawerHeader,
                Expanded(child: menuItemsContainer),
                signoutBtn,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyMenuItem extends StatelessWidget {
  const MyMenuItem({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);
  final String text;
  final void Function()? onTap;
  final menuItemTextColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 2,
            left: SizeConfig.blockSizeHorizontal * 4,
            bottom: SizeConfig.blockSizeVertical * 2),
        child: MyTextWidgetCustom(
          text: text,
          color: menuItemTextColor,
          sizeBlockHorizontalDigit: 4,
        ),
      ),
    );
  }
}
