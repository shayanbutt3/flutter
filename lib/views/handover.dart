import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/roles_Lookup_controller.dart';
import 'package:backoffice_new/controllers/user_role_lookup_controller.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card_mu.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';
import '../constants/size_config.dart';
import '../constants/variables/my_variables.dart';
import '../controllers/roles_Lookup_controller.dart';
import '../custom/custom_methods/my_methods.dart';

class HandOverScreen extends StatefulWidget {
  const HandOverScreen({Key? key}) : super(key: key);

  @override
  _HandOverScreenState createState() => _HandOverScreenState();
}

class _HandOverScreenState extends State<HandOverScreen> {
  ApiFetchData apifetchData = ApiFetchData();

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController muTagController = TextEditingController();
  UserRolesLookupController userRolesController =
      Get.put(UserRolesLookupController());
  RolesLookupController rolesController = Get.put(RolesLookupController());

  List<MasterUnitDataDist> searchedList = [];
  List<int> selectedRecords = [];

  String? selectedFromTeam;
  UserRolesLookupDataDist? tmpFT;

  String? selectedToTeam;
  RolesLookupDataDist? tmpTT;

  late String currentDate;
  String myFirstMileVariableValue = "First Mile";
  String myMidMileVariableValue = "Mid Mile";

  loadData() {
    myShowLoadingDialog(context);
    apifetchData
        .getMasterUnits(
      fromTeamIds: tmpFT!.roleId,
      toTeamIds: tmpTT!.roleId,
      masterUnitStatusIds: MyVariables.masterUnitStatusIdNew,
      masterUnitTag: muTagController.text,
      fromDate: fromDateController.text,
      toDate: toDateController.text,
    )
        .then((value) {
      if (value != null) {
        if (mounted) {
          if (value.dist!.isNotEmpty) {
            var dist = value.dist![0];
            var data = searchedList.where(
                (element) => element.masterUnitTag == dist.masterUnitTag);
            if (data.isNotEmpty) {
              myToastError('Already Exists');
              setState(() {
                muTagController.text = '';
              });
            } else {
              setState(() {
                searchedList.insert(0, dist);
                selectedRecords.add(dist.masterUnitId!);
                muTagController.text = '';
              });
            }
          } else {
            myToastSuccess(MyVariables.notFoundErrorMSG);
          }
        }
      }
      Get.isDialogOpen! ? tryToPop(context) : null;
    });
  }

  onLoadTeams() async {
    await userRolesController.fetchUserRoles();
    await rolesController.fetchRoles();
    setState(() {
      if (userRolesController.userRolesLookupList.length == 1) {
        for (int j = 0;
            j < userRolesController.userRolesLookupList.length;
            j++) {
          selectedFromTeam =
              userRolesController.userRolesLookupList[j].roleName;
          tmpFT = userRolesController.userRolesLookupList[j];
        }
      }
      if (selectedFromTeam == myFirstMileVariableValue) {
        selectedToTeam = myMidMileVariableValue;
        tmpTT = rolesController.rolesLookupList.firstWhere(
          (element) => element.roleName == selectedToTeam,
          orElse: () => RolesLookupDataDist(),
        );
      } else {
        selectedToTeam = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    currentDate = myFormatDateOnly(now.toString());
    fromDateController = TextEditingController(text: currentDate);
    toDateController = TextEditingController(text: currentDate);
    rolesController.fetchRoles();
    onLoadTeams();
  }

  Future _scanQR() async {
    if (selectedFromTeam != null && selectedFromTeam!.isNotEmpty) {
      if (selectedToTeam != null && selectedToTeam!.isNotEmpty) {
        try {
          await FlutterBarcodeScanner.scanBarcode(
                  'green', 'Cancel', true, ScanMode.QR)
              .then((value) {
            if (value != '-1' && value.isNotEmpty) {
              setState(() {
                muTagController.text = value.toString();
                FlutterBeep.beep(false);
              });
              loadData();
            }
          });
        } catch (e) {
          myToastError('Exception: $e');
          rethrow;
        }
      } else {
        myToastError("Please select to team");
      }
    } else {
      myToastError('Please select from team');
    }
  }

  removeFromList(List<int> records) {
    setState(() {
      for (int i = 0; i < records.length; i++) {
        searchedList
            .removeWhere((element) => element.masterUnitId == records[i]);
      }
    });
  }

  removeDataLocally() {
    removeFromList(selectedRecords);
    setState(() {
      selectedRecords = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var appBar = PreferredSize(
        child: SafeArea(
            child: AppBar(
          elevation: 0,
          title: const MyTextWidgetAppBarTitle(text: 'Handover'),
          toolbarHeight: MyVariables.appbarHeight,
          backgroundColor: MyVariables.appBarBackgroundColor,
          flexibleSpace: const MyAppBarFlexibleContainer(),
          actions: [
            IconButton(
              onPressed: () {
                _scanQR();
              },
              icon: const Icon(Icons.qr_code_scanner),
              iconSize: SizeConfig.blockSizeHorizontal * 8,
            )
          ],
        )),
        preferredSize: MyVariables.preferredSizeAppBar);

    var dateDropDowns = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
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
                      toDateController.text =
                          myFormatDateOnly(value.toString());
                    });
                  }
                });
              },
            ),
          ),
        ],
      ),
    );

    var searchedOrdersDataList = ListView.builder(
        itemCount: searchedList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCardMU(
            dist: searchedList[index],
            isSelected:
                selectedRecords.contains(searchedList[index].masterUnitId),
          );
        });

    var staticDropDowns = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
              child: MyDropDownUserRolesLookup(
                  selectedValue: selectedFromTeam,
                  onChanged: (s) {
                    setState(() {
                      selectedFromTeam = s.toString();
                      tmpFT =
                          userRolesController.userRolesLookupList.firstWhere(
                        (element) => element.roleName == selectedFromTeam,
                        orElse: () => UserRolesLookupDataDist(),
                      );
                      selectedFromTeam == myFirstMileVariableValue
                          ? selectedToTeam = myMidMileVariableValue
                          : selectedToTeam = null;
                      tmpTT = rolesController.rolesLookupList.firstWhere(
                        (element) => element.roleName == selectedToTeam,
                        orElse: () => RolesLookupDataDist(),
                      );
                    });
                  },
                  listOfItems: userRolesController.userRolesLookupList)),
          const MySpaceWidth(widthSize: 2),
          Expanded(
              child: MyDropDownRolesLookup(
                  selectedValue: selectedToTeam,
                  onChanged: (a) {
                    setState(() {
                      selectedToTeam = a.toString();
                      tmpTT = rolesController.rolesLookupList.firstWhere(
                        (element) => element.roleName == selectedToTeam,
                        orElse: () => RolesLookupDataDist(),
                      );
                    });
                  },
                  listOfItems: tmpFT?.roleId == MyVariables.roleIdFirstMile
                      ? rolesController.rolesLookupList
                          .where(
                              (obj) => obj.roleId == MyVariables.roleIdMidMile)
                          .toList()
                          .obs
                      : tmpFT?.roleId == MyVariables.roleIdMidMile
                          ? rolesController.rolesLookupList
                              .where((obj) =>
                                  obj.roleId == MyVariables.roleIdLastMile ||
                                  obj.roleId == MyVariables.roleIdReturnTeam)
                              .toList()
                              .obs
                          : tmpFT?.roleId == MyVariables.roleIdReturnTeam
                              ? rolesController.rolesLookupList
                                  .where((obj) =>
                                      obj.roleId == MyVariables.roleIdMidMile ||
                                      obj.roleId == MyVariables.roleIdLastMile)
                                  .toList()
                                  .obs
                              : tmpFT?.roleId == MyVariables.roleIdDebrefingTeam
                                  ? rolesController.rolesLookupList
                                      .where((obj) =>
                                          obj.roleId ==
                                              MyVariables.roleIdLastMile ||
                                          obj.roleId ==
                                              MyVariables.roleIdReturnTeam)
                                      .toList()
                                      .obs
                                  : [].obs))
        ],
      ),
    );

    var searchBtnAndTextField = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
              child: MyTextFieldCustom(
            controller: muTagController,
            labelText: 'Enter MU Tag',
            onChanged: (s) {
              setState(() {});
            },
            needToHideIcon: true,
          )),
          Flexible(
              child: Align(
            alignment: Alignment.centerRight,
            child: MyElevatedButton(
              text: 'Search',
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (selectedFromTeam != null && selectedFromTeam!.isNotEmpty) {
                  if (selectedToTeam != null && selectedToTeam!.isNotEmpty) {
                    if (muTagController.text.isNotEmpty) {
                      loadData();
                    } else {
                      myToastError('Enter MU tag');
                    }
                  } else {
                    myToastError('Select to team');
                  }
                } else {
                  myToastError('Select from team');
                }
              },
              btnBackgroundColor: MyColors.btnColorGreen,
            ),
          ))
        ],
      ),
    );

    var handoverBtn = MyElevatedButton(
      text: 'Handover',
      onPressed: () {
        if (selectedRecords.isNotEmpty) {
          Get.dialog(
                  MyHandoverConfirmationDialog(
                    masterUnitIds: selectedRecords,
                  ),
                  barrierDismissible: false)
              .then((value) {
            if (value == true) {
              setState(() {
                removeDataLocally();
              });
            }
          });
        } else {
          myToastError('Please select MU');
        }
      },
      btnBackgroundColor: MyColors.btnColorGreen,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      backgroundColor: MyColors.scaffoldBackgroundColor,
      body: Padding(
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            const MySpaceHeight(heightSize: 1),
            dateDropDowns,
            staticDropDowns,
            const MySpaceHeight(heightSize: 1),
            searchBtnAndTextField,
            const MySpaceHeight(heightSize: 1),
            ShowOrdersCount(
              text: selectedRecords.isNotEmpty ? 'selected' : 'Showing',
              listLength: searchedList.length,
              totalElements: searchedList.length,
              alignment: Alignment.centerRight,
            ),
            const MySpaceHeight(heightSize: 0.5),
            Expanded(
                child: searchedList.isEmpty
                    ? const MyNoDataToShowWidget()
                    : searchedOrdersDataList),
            handoverBtn
          ],
        ),
      ),
    );
  }
}
