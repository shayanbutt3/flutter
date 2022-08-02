import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/view_remarks_card.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';

class ViewRemarks extends StatefulWidget {
  final int transactionId;
  final String transactionStatus;
  const ViewRemarks({
    required this.transactionId,
    required this.transactionStatus,
    Key? key,
  }) : super(key: key);
  @override
  _ViewRemarksState createState() => _ViewRemarksState();
}

class _ViewRemarksState extends State<ViewRemarks> {
  ApiFetchData apiFetchData = ApiFetchData();
  late int transactionId;
  late String transactionStatus;

  List<OrderRemarksDataDist> remarksList = [];
  Pagination pagination = Pagination();

  bool isLoadingListView = false;

  bool hasMoreData = true;

  bool isLoading = true;

  loadData() async {
    apiFetchData
        .getOrderRemarks(
      transactionId,
      MyVariables.paginationEnable,
      pagination.page ?? 0,
      MyVariables.size,
      MyVariables.sortDirection,
    )
        .then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            remarksList.addAll(value.dist!);
            pagination = value.pagination!;
            isLoadingListView = false;
            isLoading = false;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    transactionId = widget.transactionId;
    transactionStatus = widget.transactionStatus;
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    remarksList = [];
    pagination = Pagination();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var sizedBoxBetweenContainer =
        SizedBox(height: SizeConfig.blockSizeVertical * 2);

    final listView = NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoadingListView &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              scrollInfo.metrics.pixels != scrollInfo.metrics.minScrollExtent) {
            setState(() {
              isLoadingListView = true;
              if (pagination.page == pagination.totalPages) {
                isLoadingListView = false;
                hasMoreData = false;
              } else {
                setState(() {
                  pagination.page = pagination.page! + 1;
                  loadData();
                });
              }
            });
            return true;
          }
          return true;
        },
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(mainAxisSize: MainAxisSize.min, children: [
              for (int i = 0; i < remarksList.length; i++)
                ViewRemarksCARD(
                  dist: remarksList[i],
                  transactionStatus: transactionStatus,
                ),
              hasMoreData == false
                  ? const MyNoMoreDataContainer()
                  : Container(),
            ])
          ],
        ));

    return Container(
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
      decoration: BoxDecoration(
          color: MyColors.scaffoldBackgroundColor,
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.blockSizeHorizontal * 2))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: MyTextWidgetCustom(
              text: 'View Remarks',
              color: MyColors.headerTextBlueShadeColor,
              sizeBlockHorizontalDigit: 5,
              fontWeight: FontWeight.w500,
            ),
          ),
          sizedBoxBetweenContainer,
          isLoading == true
              ? const MyLoadingIndicator(centerIt: true)
              : remarksList.isEmpty
                  ? const MyNoDataToShowWidget()
                  : Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: listView),
                          isLoadingListView == true
                              ? const MyLoadingIndicator(centerIt: true)
                              : Container(),
                        ],
                      ),
                    ),
          FittedBox(
            child: SizedBox(
              width: SizeConfig.screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: MyElevatedButton(
                      btnPaddingHorizontalSize: 4,
                      text: 'Close',
                      onPressed: () {
                        tryToPop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
