import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/loadsheet_controller.dart';
import 'package:backoffice_new/controllers/rider_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_confirmation_dialog.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom/custom_widgets/show_response_dialog.dart';

class AssignPickup extends StatefulWidget {
  const AssignPickup({Key? key}) : super(key: key);

  @override
  _AssignPickupState createState() => _AssignPickupState();
}

class _AssignPickupState extends State<AssignPickup> {
  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  AssignLoadSheetRequestData requestData = AssignLoadSheetRequestData();

  final RiderController riderController = Get.put(RiderController());
  final LoadSheetsController loadSheetsController =
      Get.put(LoadSheetsController());

  String? selectedRider;
  String? selectedLoadSheet;
  RiderLookupDataDist? tmpR;
  LoadSheetDataDist? tmpLoadSheet;

  List<OrdersDataDist> ordersList = [];
  Pagination pagination = Pagination();

  getLoadSheetDetail({
    required int loadsheetMasterId,
  }) async {
    myShowLoadingDialog(context);
    apiFetchData
        .getLoadSheetOrders(
            loadsheetMasterId, MyVariables.loadSheetOrderStatusOptionBooked)
        .then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            ordersList = [];
            ordersList.addAll(value.dist!);
            pagination = value.pagination!;
          });
          Get.isDialogOpen! ? tryToPop(context) : null;
        }
      } else {
        // Get.isDialogOpen! ? tryToPop(context) : null;
      }
    });
  }

  clearAllData() {
    setState(() {
      selectedLoadSheet = null;
      selectedRider = null;
      ordersList = [];
    });
  }

  removeFromList() {
    setState(() {
      loadSheetsController.loadsheetsListNew.removeWhere(
          (element) => element.loadSheetName == tmpLoadSheet?.loadSheetName);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = PreferredSize(
        preferredSize: MyVariables.preferredSizeAppBar,
        child: SafeArea(
          child: AppBar(
            toolbarHeight: MyVariables.appbarHeight,
            backgroundColor: MyVariables.appBarBackgroundColor,
            elevation: 0,
            title: const MyTextWidgetAppBarTitle(
              text: 'Assign Pickup',
            ),
            flexibleSpace: const MyAppBarFlexibleContainer(),
          ),
        ));

    final list = ListView.builder(
        itemCount: ordersList.length,
        itemBuilder: (context, index) {
          return MyCard(
            dist: ordersList[index],
            needToHideCheckBox: true,
            needToHideDeleteIcon: true,
          );
        });

    final loadSheets = SizedBox(
        width: SizeConfig.safeScreenWidth,
        child: MyDropDownLoadSheetsNew(
          isExpanded: true,
          selectedValue: selectedLoadSheet,
          onChanged: (val) {
            setState(() {
              selectedLoadSheet = val.toString();
              tmpLoadSheet = loadSheetsController.loadsheetsListNew.firstWhere(
                  (element) =>
                      element.loadSheetName ==
                      selectedLoadSheet?.split(" ")[0].toString().trim());
              getLoadSheetDetail(
                  loadsheetMasterId: tmpLoadSheet!.loadSheetMasterId!);
            });
          },
          listOfItems: loadSheetsController.loadsheetsListNew,
        ));

    final conatinerRider = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
              child: MyDropDownRider(
            selectedValue: selectedRider,
            onChanged: (val) {
              setState(() {
                selectedRider = val.toString();
                tmpR = riderController.riderLookupList.firstWhere(
                    (element) => element.riderName == selectedRider);
              });
            },
            listOfItems: riderController.riderLookupList,
          )),
          const MySpaceWidth(widthSize: 2),
          Expanded(
              child: ShowOrdersCount(
            listLength: ordersList.length,
            totalElements: pagination.totalElements,
            alignment: Alignment.centerRight,
          )),
        ],
      ),
    );

    var assignPickupBtn = MyElevatedButton(
      text: 'Assign Pickup',
      btnBackgroundColor: MyColors.btnColorGreen,
      btnPaddingHorizontalSize: 8,
      onPressed: () {
        if (selectedLoadSheet != null && selectedLoadSheet!.isNotEmpty) {
          if (ordersList.isNotEmpty) {
            if (selectedRider != null && selectedRider!.isNotEmpty) {
              myShowConfirmationDialog(
                  title: 'Assign Pickup',
                  description:
                      'Are you sure you want to assign this loadsheet for pickup?',
                  onSavePressed: () {
                    myShowLoadingDialog(context);
                    requestData = AssignLoadSheetRequestData(
                      loadSheetIds: [tmpLoadSheet!.loadSheetMasterId!],
                      riderId: tmpR!.riderId!,
                    );

                    apiPostData.patchAssignLoadSheet(requestData).then((value) {
                      if (value != null) {
                        if (mounted) {
                          clearAllData();
                          removeFromList();
                          Get.isDialogOpen! ? tryToPop(context) : null;
                          tryToPopTrue(context);
                          myShowSuccessMSGDialog(
                            description:
                                'Load sheet is assigned to rider successfully',
                          );
                        }
                      } else {}
                    });
                  });
            } else {
              myToastError('Please select Rider');
            }
          } else {
            myToastError('LoadSheet is empty please select another LoadSheet');
          }
        } else {
          myToastError('Please select LoadSheet');
        }
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffoldBackgroundColor,
      appBar: _appBar,
      body: Container(
        width: SizeConfig.safeScreenWidth,
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            const MySpaceHeight(heightSize: 1),
            loadSheets,
            const MySpaceHeight(heightSize: 1.5),
            conatinerRider,
            const MySpaceHeight(heightSize: 1.5),
            Expanded(
                child:
                    ordersList.isEmpty ? const MyNoDataToShowWidget() : list),
            assignPickupBtn,
          ],
        ),
      ),
    );
  }
}
