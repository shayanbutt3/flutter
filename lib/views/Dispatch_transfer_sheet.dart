import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../constants/size_config.dart';
import '../custom/custom_methods/my_methods.dart';
import '../custom/custom_widgets/custom_widgets.dart';
import '../custom/custom_widgets/my_card_transfer_sheet.dart';

class DispatchTransferSheet extends StatefulWidget {
  const DispatchTransferSheet({this.sheetDist, Key? key}) : super(key: key);
  final SheetsDataDist? sheetDist;

  @override
  _DispatchTransferSheetState createState() => _DispatchTransferSheetState();
}

class _DispatchTransferSheetState extends State<DispatchTransferSheet> {
  ApiFetchData apiFetchData = ApiFetchData();

  TextEditingController sheetNumberController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  List<SheetsDataDist> sheetList = [];
  List<int> selectedRecords = [];
  late String currentDateString;

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    currentDateString = myFormatDateOnly(now.toString());
    fromDateController = TextEditingController(text: currentDateString);
    toDateController = TextEditingController(text: currentDateString);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) => loadData());
  }

  loadData() {
    myShowLoadingDialog(context);
    apiFetchData
        .getSheets(
      '',
      '',
      MyVariables.sheetTypeIdTransfer,
      MyVariables.sheetStatusIdNew,
      sheetNumberController.text,
      fromDateController.text,
      toDateController.text,
      MyVariables.paginationDisable,
      0,
      MyVariables.size,
      MyVariables.sortDirection,
    )
        .then((value) {
      if (value != null) {
        if (mounted) {
          if (value.dist!.isNotEmpty) {
            setState(() {
              sheetList.addAll(value.dist!);
            });
          } else {
            myToastSuccess(MyVariables.notFoundErrorMSG);
          }
        }
      }
      Get.isDialogOpen! ? tryToPop(context) : null;
    });
  }

  onSelection(bool isSelected, SheetsDataDist dist) {
    setState(() {
      if (selectedRecords.contains(dist.sheetId)) {
        selectedRecords.remove(dist.sheetId);
      } else {
        selectedRecords.add(dist.sheetId!);
      }
    });
  }

  removeDataFromList(List<int> records) {
    setState(() {
      for (int i = 0; i < records.length; i++) {
        sheetList.removeWhere((element) => element.sheetId == records[i]);
      }
    });
  }

  removeDataLocally() {
    removeDataFromList(selectedRecords);
    setState(() {
      selectedRecords = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var appBar = AppBar(
      backgroundColor: MyVariables.appBarBackgroundColor,
      toolbarHeight: MyVariables.appbarHeight,
      title: const MyTextWidgetAppBarTitle(text: "Dispatch Transfer Sheet"),
      flexibleSpace: const MyAppBarFlexibleContainer(),
    );

    var row1 = Row(
      children: [
        Expanded(
          child: MyTextFieldDatePicker(
            text: 'From Date',
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
                  .then((value) {
                if (value != null) {
                  setState(() {
                    fromDateController.text =
                        myFormatDateOnly(value.toString());
                  });
                }
              });
            },
          ),
        ),
        const MySpaceWidth(widthSize: 2),
        Expanded(
          child: MyTextFieldDatePicker(
            text: 'To Date',
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
                  .then((value) {
                if (value != null) {
                  setState(() {
                    toDateController.text = myFormatDateOnly(value.toString());
                  });
                }
              });
            },
          ),
        ),
      ],
    );

    var row2 = Row(
      children: [
        Expanded(
          child: MyTextFieldCustom(
            controller: sheetNumberController,
            labelText: "Sheet Number",
            needToHideIcon: true,
            onChanged: (s) {
              setState(() {});
            },
          ),
        ),
        const MySpaceWidth(widthSize: 21),
        MyElevatedButton(
          btnBackgroundColor: MyColors.btnColorGreen,
          text: "Search",
          onPressed: () {
            FocusScope.of(context).unfocus();
            setState(() {
              sheetList = [];
              selectedRecords = [];
            });
            loadData();
          },
        )
      ],
    );

    var dispatchTransferSheetBtn = MyElevatedButton(
      btnBackgroundColor: MyColors.btnColorGreen,
      text: "Dispatch Transfer Sheet",
      onPressed: () {
        if (selectedRecords.isNotEmpty) {
          Get.dialog(MyDispatchTransferSheetDialog(
            sheetMasterIds: selectedRecords,
          )).then((value) {
            if (value == true) {
              removeDataLocally();
            }
          });
        } else {
          myToastError('Please select transfer sheet');
        }
      },
    );

    var listOfTransferSheet = ListView.builder(
        itemCount: sheetList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCardTransferSheet(
            sheetDist: sheetList[index],
            isSelected: selectedRecords.contains(sheetList[index].sheetId),
            onChangedCheckBox: (s) {
              onSelection(s!, sheetList[index]);
            },
          );
        });

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      backgroundColor: MyColors.scaffoldBackgroundColor,
      body: Padding(
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            const MySpaceHeight(heightSize: 1),
            row1,
            const MySpaceHeight(heightSize: 1),
            row2,
            const MySpaceHeight(heightSize: 1),
            ShowOrdersCount(
              text: selectedRecords.isNotEmpty ? 'Selected' : null,
              listLength: selectedRecords.isNotEmpty
                  ? selectedRecords.length
                  : sheetList.length,
              alignment: Alignment.centerRight,
              totalElements: sheetList.length,
            ),
            const MySpaceHeight(heightSize: 1),
            Expanded(
              child: sheetList.isEmpty
                  ? const MyNoDataToShowWidget()
                  : listOfTransferSheet,
            ),
            const MySpaceHeight(heightSize: 1),
            dispatchTransferSheetBtn
          ],
        ),
      ),
    ));
  }
}
