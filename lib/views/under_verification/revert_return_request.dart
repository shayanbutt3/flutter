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
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class RevertReturnRequest extends StatefulWidget {
  const RevertReturnRequest({Key? key}) : super(key: key);

  @override
  _RevertReturnRequestState createState() => _RevertReturnRequestState();
}

class _RevertReturnRequestState extends State<RevertReturnRequest> {
  ApiFetchData apiFetchData = ApiFetchData();

  final MerchantController merchantController = Get.put(MerchantController());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController trackingNumberController = TextEditingController();

  List<OrdersDataDist> ordersList = [];
  Pagination pagination = Pagination();

  String? selectedMerchant;
  MerchantLookupDataDist? tmpM;
  late String currentDateString;
  bool isLoadingListView = false;
  bool hasMoreData = true;

  loadData(
      {bool? needToShowLoadingDialog,
      bool? needToMakeIsLoadingListViewTrue,
      bool? needToRemovePreviousData}) async {
    needToShowLoadingDialog == true ? myShowLoadingDialog(context) : null;
    needToMakeIsLoadingListViewTrue == true
        ? setState(() {
            isLoadingListView = true;
          })
        : null;

    apiFetchData
        .getOrders(
            tmpM == null ? '' : tmpM!.merchantId,
            '',
            '',
            MyVariables.orderStatusIdsToRevertReturnProcess,
            '',
            trackingNumberController.text,
            fromDateController.text,
            toDateController.text,
            '',
            MyVariables.paginationEnable,
            pagination.page == null ? 0 : pagination.page!,
            MyVariables.size,
            MyVariables.sortDirection)
        .then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            if (value.dist!.isNotEmpty) {
              if (needToRemovePreviousData == true) {
                ordersList = [];
                ordersList.addAll(value.dist!);
                pagination = value.pagination!;
              } else {
                ordersList.addAll(value.dist!);
                pagination = value.pagination!;
              }
            } else {
              myToastSuccess(MyVariables.notFoundErrorMSG);
            }
          });
          setState(() {
            isLoadingListView = false;
          });
          Get.isDialogOpen! ? tryToPop(context) : null;
        }
      }
    });
  }

  removeDatalocally(index) {
    ordersList.removeWhere(
        (element) => element.transactionId == ordersList[index].transactionId);
    pagination.totalElements = pagination.totalElements! - 1;
  }

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    currentDateString = myFormatDateOnly(now.toString());
    fromDateController = TextEditingController(text: currentDateString);
    toDateController = TextEditingController(text: currentDateString);
    SchedulerBinding.instance.addPostFrameCallback(
        (timeStamp) => loadData(needToShowLoadingDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var spaceBetweenFieldsInColumn = const MySpaceHeight(heightSize: 1);
    var spaceBetweenFields = const MySpaceWidth(widthSize: 2);

    var list = NotificationListener(
        onNotification: ordersList.isEmpty
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
                }
                return true;
              },
        child: ListView.builder(
            itemCount: ordersList.length,
            itemBuilder: (context, index) {
              return myCard(index);
            }));

    var myAppBar = PreferredSize(
      child: SafeArea(
        child: AppBar(
          backgroundColor: MyVariables.appBarBackgroundColor,
          iconTheme: MyVariables.appBarIconTheme,
          toolbarHeight: MyVariables.appbarHeight,
          flexibleSpace: const MyAppBarFlexibleContainer(),
          title: const MyTextWidgetAppBarTitle(text: "Revert Return Process"),
        ),
      ),
      preferredSize: MyVariables.preferredSizeAppBar,
    );

    var row1 = SizedBox(
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
    var row2 = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
              child: MyDropDownMerchant(
            selectedValue: selectedMerchant,
            onChanged: (val) {
              setState(() {
                selectedMerchant = val.toString();
                pagination.page = 0;
                tmpM = merchantController.merchantLookupList.firstWhere(
                    (element) => element.merchantName == selectedMerchant);
              });
            },
            listOfItems: merchantController.merchantLookupList,
          )),
          spaceBetweenFields,
          Expanded(
              child: MyTextFieldCustom(
            controller: trackingNumberController,
            needToHideIcon: true,
            labelText: 'Tracking Number',
            onChanged: (a) {
              setState(() {});
            },
          )),
        ],
      ),
    );
    var row3 = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
            child: ShowOrdersCount(
              listLength: ordersList.length,
              totalElements: pagination.totalElements,
            ),
          ),
          MyElevatedButton(
            btnBackgroundColor: MyColors.btnColorGreen,
            text: 'Search',
            onPressed: () {
              FocusScope.of(context).unfocus();
              ordersList = [];
              pagination = Pagination();
              setState(() {
                hasMoreData = true;
                loadData(
                  needToShowLoadingDialog: true,
                );
              });
            },
          )
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: myAppBar,
      backgroundColor: MyColors.scaffoldBackgroundColor,
      body: Container(
        width: SizeConfig.safeScreenWidth,
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            spaceBetweenFieldsInColumn,
            row1,
            spaceBetweenFieldsInColumn,
            row2,
            spaceBetweenFieldsInColumn,
            row3,
            spaceBetweenFieldsInColumn,
            Expanded(
                child:
                    ordersList.isEmpty ? const MyNoDataToShowWidget() : list),
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

  Widget myCard(int index) {
    return GestureDetector(
      onLongPress: () {
        myShowBottomSheet(context, [
          MyListTileBottomSheetMenuItem(
              titleTxt: 'Revert Return Process',
              icon: Icons.subdirectory_arrow_left,
              onTap: () {
                tryToPop(context);
                Get.dialog(MyRevertReturnProcessDialog(
                  transactionId: ordersList[index].transactionId!,
                )).then((value) {
                  if (value == true) {
                    setState(() {
                      removeDatalocally(index);
                    });
                  }
                });
              })
        ]);
      },
      child: MyCard(
        dist: ordersList[index],
        needToHideDeleteIcon: true,
        needToHideCheckBox: true,
      ),
    );
  }
}
