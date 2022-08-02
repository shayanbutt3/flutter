import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/merchant_controller.dart';
import 'package:backoffice_new/controllers/rider_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class RevertOrder extends StatefulWidget {
  const RevertOrder({Key? key}) : super(key: key);

  @override
  _RevertOrderState createState() => _RevertOrderState();
}

class _RevertOrderState extends State<RevertOrder> {
  ApiFetchData apiFetchData = ApiFetchData();

  final MerchantController merchantController = Get.put(MerchantController());
  final RiderController riderController = Get.put(RiderController());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController trackingNumberController = TextEditingController();

  List<OrdersDataDist> ordersList = [];
  Pagination pagination = Pagination();

  String? selectedMerchant;
  MerchantLookupDataDist? tmpM;
  String? selectedRider;
  RiderLookupDataDist? tmpR;

  late String currentDateString;
  bool isLoadingListView = false;
  bool hasMoreData = true;
  String? selectedStatus;

  var deliveredText = 'Delivered';
  var returnedText = 'Returned';

  loadData({
    bool? needToShowLoadingDialog,
    bool? needToMakeIsLoadingListViewTrue,
    bool? needToRemovePreviousData,
  }) async {
    needToShowLoadingDialog == true ? myShowLoadingDialog(context) : null;
    needToMakeIsLoadingListViewTrue == true
        ? setState(() {
            isLoadingListView = true;
          })
        : null;
    apiFetchData
        .getOrders(
            tmpM == null ? '' : tmpM!.merchantId,
            tmpR == null ? '' : tmpR!.riderId,
            '',
            selectedStatus == deliveredText
                ? MyVariables.orderStatusIdDelivered
                : selectedStatus == returnedText
                    ? MyVariables.orderStatusIdReturned
                    : MyVariables.orderStatusIdsDeliveredAndReturned,
            '',
            trackingNumberController.text,
            fromDateController.text,
            toDateController.text,
            '',
            MyVariables.paginationEnable,
            pagination.page == null ? 0 : pagination.page!,
            MyVariables.size,
            MyVariables.sortDirection,
            settled: false)
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

  removeDataLocally(OrdersDataDist dist) {
    setState(() {
      ordersList.removeWhere(
          (element) => element.transactionId == dist.transactionId);
      pagination.totalElements = pagination.totalElements! - 1;
    });
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
              return myCard(ordersList[index]);
            }));

    var spaceBetweenFieldsInColumn = const MySpaceHeight(heightSize: 1);
    var spaceBetweenFields = const MySpaceWidth(widthSize: 2);
    var row3 = Row(
      children: [
        Expanded(
          child: DropdownSearch(
            selectedItem: selectedStatus,
            items: [deliveredText, returnedText],
            dropdownSearchDecoration: InputDecoration(
              hintText: MyVariables.orderStatusDropdownHintText,
            ),
            mode: Mode.MENU,
            showSearchBox: false,
            showAsSuffixIcons: true,
            onChanged: (String? value) {
              setState(() {
                selectedStatus = value.toString();
              });
            },
          ),
        ),
        spaceBetweenFields,
        Expanded(
          child: MyTextFieldCustom(
            controller: trackingNumberController,
            needToHideIcon: true,
            labelText: "Tracking Number",
            onChanged: (a) {
              setState(() {});
            },
          ),
        ),
      ],
    );

    var myAppBar = PreferredSize(
        child: SafeArea(
          child: AppBar(
            flexibleSpace: const MyAppBarFlexibleContainer(),
            backgroundColor: MyVariables.appBarBackgroundColor,
            iconTheme: MyVariables.appBarIconTheme,
            toolbarHeight: MyVariables.appbarHeight,
            title: const MyTextWidgetAppBarTitle(text: "Revert Order"),
          ),
        ),
        preferredSize: MyVariables.preferredSizeAppBar);

    var row2 = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
            child: MyDropDownMerchant(
                selectedValue: selectedMerchant,
                onChanged: (val) {
                  setState(() {
                    selectedMerchant = val;
                    tmpM = merchantController.merchantLookupList.firstWhere(
                        (element) => element.merchantName == selectedMerchant);
                  });
                },
                listOfItems: merchantController.merchantLookupList),
          ),
          spaceBetweenFields,
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
                listOfItems: riderController.riderLookupList),
          ),
        ],
      ),
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
    var row4 = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
            child: ShowOrdersCount(
              listLength: ordersList.length,
              totalElements: pagination.totalElements,
            ),
          ),
          const MySpaceWidth(widthSize: 1),
          MyElevatedButton(
              text: 'Search',
              btnBackgroundColor: MyColors.btnColorGreen,
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
              }),
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            row4,
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

  Widget myCard(OrdersDataDist dist) {
    return GestureDetector(
      onLongPress: () {
        myShowBottomSheet(context, [
          MyListTileBottomSheetMenuItem(
            icon: Icons.subdirectory_arrow_left,
            onTap: () {
              tryToPop(context);
              Get.dialog(
                MyRevertOrderDialog(
                  dist: dist,
                ),
                barrierDismissible: false,
              ).then((value) {
                if (value == true) {
                  removeDataLocally(dist);
                }
              });
            },
            titleTxt: 'Revert Order',
          )
        ]);
      },
      child: MyCard(
        dist: dist,
        needToHideCheckBox: true,
        needToHideDeleteIcon: true,
      ),
    );
  }
}
