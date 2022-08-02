import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card_transfer_sheet.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

class HandoverTransferSheetScreen extends StatefulWidget {
  const HandoverTransferSheetScreen({Key? key}) : super(key: key);

  @override
  _HandoverTransferSheetScreenState createState() =>
      _HandoverTransferSheetScreenState();
}

class _HandoverTransferSheetScreenState
    extends State<HandoverTransferSheetScreen> {
  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  List<SheetsDataDist> sheetDistList = [];
  List<int> selectedRecords = [];

  EmployeeProfileDataDist? employeeProfileDataDist;
  TextEditingController sheetTagController = TextEditingController();

  loadData() {
    myShowLoadingDialog(context);
    var wareHouseDist = '';
    var empWareHouses = '';
    if (employeeProfileDataDist?.employeeWareHouses != null) {
      var wareHouses = employeeProfileDataDist!.employeeWareHouses!;
      for (int i = 0; i < wareHouses.length; i++) {
        wareHouseDist = wareHouseDist + "${wareHouses[i].wareHouseId},";
      }
      setState(() {
        empWareHouses = wareHouseDist.replaceRange(
            wareHouseDist.length - 1, wareHouseDist.length, '');
      });
    }
    apiFetchData
        .getSheets(
            '',
            empWareHouses,
            '',
            MyVariables.sheetStatusIdReceived,
            '',
            '',
            '',
            MyVariables.paginationDisable,
            0,
            MyVariables.size,
            MyVariables.sortDirection,
            sheetTag: sheetTagController.text)
        .then((value) {
      if (value != null) {
        if (mounted) {
          if (value.dist!.isNotEmpty) {
            var dist = value.dist![0];
            var data = sheetDistList.where(
              (element) => element.sheetNumber == dist.sheetNumber,
            );
            if (data.isNotEmpty) {
              myToastError('Already Exist');
              setState(() {
                sheetTagController.text = '';
              });
            } else {
              setState(() {
                setState(() {
                  sheetDistList.insert(0, dist);
                  selectedRecords.add(dist.sheetId!);
                  sheetTagController.text = '';
                });
              });
            }
          } else {
            myToastSuccess(MyVariables.notFoundErrorMSG);
            setState(() {
              sheetTagController.text = '';
            });
          }
        }
      }
      Get.isDialogOpen! ? Get.back() : null;
    });
  }

  loadEmployeeProfileData() {
    apiFetchData.getEmployeeProfile().then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            employeeProfileDataDist = value.dist;
          });
        }
      }
    });
  }

  removeFromList(List<int> records) {
    for (int i = 0; i < records.length; i++) {
      setState(() {
        sheetDistList.removeWhere((element) => element.sheetId == records[i]);
      });
    }
  }

  removeDataLocally() {
    removeFromList(selectedRecords);
    setState(() {
      selectedRecords = [];
    });
  }

  // Future scanQR() async {
  //   try {
  //     await FlutterBarcodeScanner.scanBarcode(
  //             'green', 'Cancel', true, ScanMode.QR)
  //         .then((value) {
  //       if (value != '-1' && value.isNotEmpty) {
  //         setState(() {
  //           sheetTagController.text = value.toString().trim();
  //         });
  //         loadData();
  //       }
  //     });
  //   } catch (e) {
  //     myToastError('Exception: $e');
  //     rethrow;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    loadEmployeeProfileData();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var appBar = PreferredSize(
        child: SafeArea(
            child: AppBar(
          title: const MyTextWidgetAppBarTitle(text: 'Handover TS'),
          toolbarHeight: MyVariables.appbarHeight,
          backgroundColor: MyVariables.appBarBackgroundColor,
          flexibleSpace: const MyAppBarFlexibleContainer(),
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       scanQR();
          //     },
          //     icon: const Icon(Icons.qr_code_scanner),
          //     iconSize: SizeConfig.blockSizeHorizontal * 8,
          //   ),
          // ],
        )),
        preferredSize: MyVariables.preferredSizeAppBar);

    var textFieldAndSearchBtn = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
              child: MyTextFieldCustom(
            controller: sheetTagController,
            needToHideIcon: true,
            onChanged: (s) {
              setState(() {});
            },
            labelText: 'Sheet Tag',
          )),
          Flexible(
              child: Align(
            alignment: Alignment.centerRight,
            child: MyElevatedButton(
              text: 'Search',
              btnBackgroundColor: MyColors.btnColorGreen,
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (sheetTagController.text.isNotEmpty) {
                  loadData();
                } else {
                  myToastError('Enter sheet tag');
                }
              },
            ),
          ))
        ],
      ),
    );

    var list = ListView.builder(
        itemCount: sheetDistList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCardTransferSheet(
            sheetDist: sheetDistList[index],
            isSelected: selectedRecords.contains(sheetDistList[index].sheetId),
            needToHideCheckBox: true,
          );
        });

    var handoverTransferSheetBtn = MyElevatedButton(
      text: 'Handover TS',
      btnBackgroundColor: MyColors.btnColorGreen,
      onPressed: () {
        if (selectedRecords.isNotEmpty) {
          Get.dialog(MyHandoverTransferSheetConfirmationDialog(
            sheetMasterIds: selectedRecords,
          )).then((value) {
            if (value == true) {
              setState(() {
                removeDataLocally();
              });
            }
          });
        } else {
          myToastError('Please select orders');
        }
      },
    );
    return Scaffold(
        appBar: appBar,
        backgroundColor: MyColors.scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: MyVariables.scaffoldBodyPadding,
          child: Column(
            children: [
              const MySpaceHeight(heightSize: 0.5),
              textFieldAndSearchBtn,
              const MySpaceHeight(heightSize: 0.5),
              ShowOrdersCount(
                listLength: sheetDistList.length,
                alignment: Alignment.centerRight,
              ),
              Expanded(child: list),
              handoverTransferSheetBtn,
              const MySpaceHeight(heightSize: 0.5)
            ],
          ),
        ));
  }
}
