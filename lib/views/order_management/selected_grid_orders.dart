import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/views/order_detail.dart';
import 'package:backoffice_new/views/order_management/view_remarks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedGridOrders extends StatefulWidget {
  final String appBarTitleText;
  final int? wareHouseId;
  final int? transactionStatusId;
  final String fromDateTime;
  final String toDateTime;
  final String? transactionStatusIdsTotal;
  const SelectedGridOrders(
      {required this.appBarTitleText,
      this.wareHouseId,
      this.transactionStatusId,
      required this.fromDateTime,
      required this.toDateTime,
      this.transactionStatusIdsTotal,
      Key? key})
      : super(key: key);
  @override
  _ManageOrderState createState() => _ManageOrderState();
}

class _ManageOrderState extends State<SelectedGridOrders> {
  ApiFetchData apiFetchData = ApiFetchData();

  List<OrdersDataDist> ordersList = [];
  Pagination pagination = Pagination();

  bool isLoadingListView = false;
  bool hasMoreData = true;

  // String? fromDate;
  // String? toDate;
  // String? fromTime;
  // String? toTime;

  void loadData({
    bool? needToShowLoadingDialog,
    bool? needToMakeIsLoadingListViewTrue,
    bool? needToRemovePreviousData,
  }) {
    needToShowLoadingDialog == true ? myShowLoadingDialog(context) : null;
    if (needToMakeIsLoadingListViewTrue == true) {
      setState(() {
        isLoadingListView = true;
      });
    }
    apiFetchData
        .getOrders(
      '',
      '',
      '',
      widget.transactionStatusId ?? widget.transactionStatusIdsTotal ?? '',
      widget.wareHouseId ?? '',
      '',
      '',
      '',
      '',
      MyVariables.paginationEnable,
      pagination.page == null ? 0 : pagination.page!,
      MyVariables.size,
      MyVariables.sortDirection,
      filterDateType: FilterDateType.orderStatusChangedDate.name.toString(),
      fromDateTime: widget.fromDateTime,
      toDateTime: widget.toDateTime,
    )
        .then((value) {
      if (value != null) {
        if (mounted) {
          Get.isDialogOpen == true ? Get.back() : null;
          if (value.dist!.isNotEmpty) {
            if (needToRemovePreviousData == true) {
              setState(() {
                ordersList = [];
                ordersList.addAll(value.dist!);
                pagination = value.pagination!;
              });
            } else {
              setState(() {
                ordersList.addAll(value.dist!);
                pagination = value.pagination!;
              });
            }
          } else {
            if (pagination.page != null && pagination.page! > 0) {
            } else {
              setState(() {
                ordersList = [];
                pagination = Pagination();
              });
            }
            myToastSuccess(MyVariables.notFoundErrorMSG);
          }
          setState(() {
            isLoadingListView = false;
          });
        }
      }
    });
  }

  void reloadData() {
    setState(() {
      ordersList = [];
      pagination.page = 0;
      hasMoreData = true;
    });
    loadData(
      needToShowLoadingDialog: true,
      needToRemovePreviousData: true,
    );
  }

  // void separateDateTime() {
  //   setState(() {
  //     toDate = widget.toDateTime.substring(0, 10);
  //     fromDate = widget.fromDateTime.substring(0, 10);
  //     toTime = widget.toDateTime.substring(11);
  //     fromTime = widget.fromDateTime.substring(11);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // separateDateTime();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(
          needToShowLoadingDialog: true,
          needToRemovePreviousData: true,
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    const spaceBetweenBodyItemsRow = MySpaceHeight(heightSize: 1);
    var appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBar,
      child: SafeArea(
        child: AppBar(
          elevation: 0,
          backgroundColor: MyVariables.appBarBackgroundColor,
          toolbarHeight: MyVariables.appbarHeight,
          title: MyTextWidgetAppBarTitle(text: widget.appBarTitleText),
          flexibleSpace: const MyAppBarFlexibleContainer(),
        ),
      ),
    );

    var row1 = ShowOrdersCount(
      listLength: ordersList.length,
      totalElements: pagination.totalElements,
      alignment: Alignment.centerRight,
    );

    var listView = NotificationListener(
      onNotification: ordersList.isEmpty
          ? null
          : (ScrollNotification scrollNotification) {
              var metrics = scrollNotification.metrics;
              var pixels = metrics.pixels;
              if (isLoadingListView != true &&
                  (pixels == metrics.maxScrollExtent &&
                      pixels != metrics.minScrollExtent)) {
                if (pagination.page == pagination.totalPages) {
                  setState(() {
                    isLoadingListView = false;
                    hasMoreData = false;
                  });
                } else {
                  pagination.page = pagination.page! + 1;
                  loadData(
                    needToMakeIsLoadingListViewTrue: true,
                  );
                }
                return true;
              } else {
                return false;
              }
            },
      child: ListView.builder(
          itemCount: ordersList.length,
          itemBuilder: (BuildContext context, index) {
            return myCard(ordersList[index]);
          }),
    );

    return Scaffold(
      backgroundColor: MyColors.scaffoldBackgroundColor,
      appBar: appBar,
      body: Padding(
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            spaceBetweenBodyItemsRow,
            row1,
            spaceBetweenBodyItemsRow,
            Expanded(
                child: ordersList.isEmpty
                    ? const MyNoDataToShowWidget()
                    : listView),
            isLoadingListView == true
                ? const MyLoadingIndicator(
                    centerIt: true,
                  )
                : Container(),
            hasMoreData == false ? const MyNoDataToShowWidget() : Container(),
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
              icon: Icons.comment,
              titleTxt: 'View Remarks',
              onTap: () {
                tryToPop(context);
                Get.dialog(Dialog(
                  backgroundColor: Colors.transparent,
                  child: ViewRemarks(
                    transactionId: dist.transactionId!,
                    transactionStatus: dist.transactionStatus!,
                  ),
                ));
              },
            ),
            MyListTileBottomSheetMenuItem(
              icon: Icons.remove_red_eye_outlined,
              titleTxt: 'View System Logs',
              onTap: () {
                tryToPop(context);
                Get.to(() => OrderDetail(
                      trackingNumber: dist.trackingNumber!,
                      initialTabIndex: 1,
                    ));
              },
            ),
            // MyListTileBottomSheetMenuItem(
            //   icon: Icons.edit,
            //   titleTxt: 'Edit',
            //   onTap: () {
            //     tryToPop(context);
            //     Get.dialog(
            //             Dialog(
            //               insetPadding: EdgeInsets.all(
            //                   SizeConfig.blockSizeHorizontal * 2),
            //               child: EditOrder(dist: dist),
            //             ),
            //             barrierDismissible: false)
            //         .then((value) {
            //       if (value == true) {
            //         reloadData();
            //       }
            //     });
            //   },
            // ),
          ]);
        },
        child: MyCard(
          dist: dist,
          needToHideCheckBox: true,
          needToHideDeleteIcon: true,
          needToShowOrderType: true,
          needToShowStockInFlag: true,
        ));
  }
}
