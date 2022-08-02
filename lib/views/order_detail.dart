import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:collection/collection.dart';

class OrderDetail extends StatefulWidget {
  final String trackingNumber;
  final int? initialTabIndex;

  const OrderDetail(
      {required this.trackingNumber, this.initialTabIndex, Key? key})
      : super(key: key);
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  // TabController? _tabController;
  ApiFetchData apiFetchData = ApiFetchData();

  late String trackingNumber;

  int tabsLength = 2;
  late int initialTabIndex;

  OrdersDataDist? dist;

  bool isLoadingLogs = true;

  List<SystemLogsDataDist> logsList = [];

  loadData() async {
    apiFetchData
        .getOrders(
            '',
            '',
            '',
            '',
            '',
            trackingNumber,
            '',
            '',
            '',
            MyVariables.paginationDisable,
            0,
            MyVariables.size,
            MyVariables.sortDirection)
        .then((value) {
      if (value != null) {
        if (value.dist!.isNotEmpty) {
          if (mounted) {
            setState(() {
              dist = value.dist?[0];
            });
            loadSystemLogs(dist!.transactionId!);
          }
        } else {
          myToastSuccess(MyVariables.notFoundErrorMSG);
        }
      }
    });
  }

  loadSystemLogs(int transactionId) {
    setState(() {
      isLoadingLogs = true;
    });
    apiFetchData.getSystemLogs(transactionId).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            isLoadingLogs = false;
            logsList.addAll(value.dist!);
          });
        }
      } else {
        setState(() {
          isLoadingLogs = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initialTabIndex =
        widget.initialTabIndex == null ? 0 : widget.initialTabIndex!;
    trackingNumber = widget.trackingNumber;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final _appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBarWithBottom,
      child: SafeArea(
        child: AppBar(
          elevation: 0,
          toolbarHeight: MyVariables.appbarHeight,
          backgroundColor: MyVariables.appBarBackgroundColor,
          flexibleSpace: const MyAppBarFlexibleContainer(),
          title: const MyTextWidgetAppBarTitle(
            text: 'Order Detail',
          ),
          bottom: TabBar(tabs: [
            Tab(
              child: AutoSizeText(
                'Order Details',
                style: MyVariables.tabBarTextStyle,
              ),
            ),
            Tab(
              child: AutoSizeText(
                'System Logs',
                style: MyVariables.tabBarTextStyle,
              ),
            ),
          ]),
        ),
      ),
    );
    var mySpaceHeight = const MySpaceHeight(heightSize: 2);
    var myRowSpaceHeight = const MySpaceHeight(heightSize: 1);
    var myLineSeparator = Center(
        child: Container(
      width: SizeConfig.safeBlockSizeHorizontal * 80,
      height: SizeConfig.safeBlockSizeVertical * 0.08,
      decoration: const BoxDecoration(
        color: Colors.black54,
      ),
    ));

    var orderDetailColumn = SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mySpaceHeight,
        const MyTextWidgetHeading(text: 'Basic Information'),
        mySpaceHeight,
        Row(
          children: [
            Expanded(
              child: MyTitleValueColumn(
                title: 'Merchant Name',
                value: dist?.merchantName ?? '',
              ),
            ),
            Expanded(
              child: MyTitleValueColumn(
                title: 'Order Ref#',
                value: dist?.orderRefNumber ?? '',
              ),
            ),
          ],
        ),
        myRowSpaceHeight,
        Row(
          children: [
            Expanded(
              child: MyTitleValueColumn(
                title: 'Tracking#',
                value: dist?.trackingNumber ?? '',
              ),
            ),
            Expanded(
              child: MyTitleValueColumn(
                title: 'Order Detail',
                value: dist?.orderDetail ?? '',
              ),
            ),
          ],
        ),
        myRowSpaceHeight,
        Row(
          children: [
            Expanded(
              child: MyTitleValueColumn(
                title: 'Order Type',
                value: dist?.transactionType ?? '',
              ),
            ),
            Expanded(
              child: MyTitleValueColumn(
                title: 'Status',
                value: dist?.transactionStatus ?? '',
              ),
            ),
          ],
        ),
        myRowSpaceHeight,
        Row(
          children: [
            Expanded(
              child: MyTitleValueColumn(
                title: 'Order Date',
                value: dist?.transactionDate == null
                    ? '-'
                    : myFormatDateOnly(dist!.transactionDate.toString()),
              ),
            ),
            Expanded(
              child: MyTitleValueColumn(
                title: 'Order Delivery Date',
                value: dist?.orderDeliveryDate == null
                    ? '-'
                    : myFormatDateOnly(dist!.orderDeliveryDate.toString()),
              ),
            ),
          ],
        ),
        myRowSpaceHeight,
        Row(
          children: [
            Expanded(
              child: MyTitleValueColumn(
                title: 'Warehouse',
                value: dist?.wareHouseCityName == null
                    ? '-'
                    : dist!.wareHouseCityName.toString(),
              ),
            ),
            Expanded(
              child: MyTitleValueColumn(
                title: 'Rider Name',
                value:
                    dist?.riderName == null ? '-' : dist!.riderName.toString(),
              ),
            ),
          ],
        ),
        myRowSpaceHeight,
        Row(
          children: [
            Expanded(
              child: MyTitleValueColumn(
                title: 'Physical Status',
                value: dist?.transactionPhysicalStatus == null
                    ? '-'
                    : dist!.transactionPhysicalStatus.toString(),
              ),
            ),
          ],
        ),
        mySpaceHeight,
        myLineSeparator,
        mySpaceHeight,
        const MyTextWidgetHeading(text: 'Payment Details'),
        mySpaceHeight,
        Row(
          children: [
            Expanded(
              child: MyTitleValueColumn(
                title: 'Invoice Amount',
                value: dist?.invoicePayment == null
                    ? '-'
                    : myAmountFormatter(dist?.invoicePayment),
              ),
            ),
            Expanded(
              child: MyTitleValueColumn(
                title: 'Upfront Payment Date',
                value: dist?.upfrontPaymentDate == null
                    ? '-'
                    : myFormatDateTimeNumeric(dist!.upfrontPaymentDate!),
              ),
            ),
          ],
        ),
        myRowSpaceHeight,
        Row(
          children: [
            Expanded(
              child: MyTitleValueColumn(
                title: 'Upfront Payment',
                value: dist?.upfrontPayment == null
                    ? '-'
                    : myAmountFormatter(dist?.upfrontPayment),
              ),
            ),
            Expanded(
              child: MyTitleValueColumn(
                title: 'Order Tax',
                value: dist?.transactionTax == null
                    ? '-'
                    : myAmountFormatter(dist?.transactionTax),
              ),
            ),
          ],
        ),
        myRowSpaceHeight,
        Row(
          children: [
            Expanded(
              child: MyTitleValueColumn(
                title: 'Order Fee',
                value: dist?.transactionFee == null
                    ? '-'
                    : myAmountFormatter(dist?.transactionFee),
              ),
            ),
            Expanded(
              child: MyTitleValueColumn(
                title: 'Balance Adjustment',
                value: dist?.balancePayment == null
                    ? '-'
                    : myAmountFormatter(dist?.balancePayment),
              ),
            ),
          ],
        ),
        dist == null || dist!.reversalDate == null
            ? Container()
            : myRowSpaceHeight,
        dist == null || dist!.reversalDate == null
            ? Container()
            : Row(
                children: [
                  Expanded(
                    child: MyTitleValueColumn(
                      title: 'Reversal Tax',
                      value: dist?.reversalTax == null
                          ? '-'
                          : myAmountFormatter(dist?.reversalTax),
                    ),
                  ),
                  Expanded(
                    child: MyTitleValueColumn(
                      title: 'Reversal Fee',
                      value: dist?.reversalFee == null
                          ? '-'
                          : myAmountFormatter(dist?.reversalFee),
                    ),
                  ),
                ],
              ),
        dist == null || dist!.receivedPaymentDate == null
            ? Container()
            : myRowSpaceHeight,
        dist == null || dist!.receivedPaymentDate == null
            ? Container()
            : Row(
                children: [
                  Expanded(
                    child: MyTitleValueColumn(
                      title: 'Received Amount',
                      value: dist?.receivedAmount == null
                          ? '-'
                          : myAmountFormatter(dist?.receivedAmount),
                    ),
                  ),
                  Expanded(
                    child: MyTitleValueColumn(
                      title: 'Received Payment Date',
                      value: dist?.receivedPaymentDate == null
                          ? '-'
                          : myFormatDateTimeNumeric(
                              (dist?.receivedPaymentDate.toString())!),
                    ),
                  ),
                ],
              ),
        dist == null || dist!.reversalDate == null
            ? Container()
            : mySpaceHeight,
        dist == null || dist!.reversalDate == null
            ? Container()
            : Row(
                children: [
                  Expanded(
                    child: MyTitleValueColumn(
                      title: 'Reversal Date',
                      value: dist?.reversalDate == null
                          ? '-'
                          : myFormatDateTimeNumeric(
                              (dist?.reversalDate.toString())!),
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
        mySpaceHeight,
        myLineSeparator,
        mySpaceHeight,
        const MyTextWidgetHeading(text: 'Customer Details'),
        mySpaceHeight,
        Row(
          children: [
            Expanded(
              child: MyTitleValueColumn(
                title: 'Customer Name',
                value: dist?.customerName ?? '',
              ),
            ),
            Expanded(
              child: MyTitleValueColumn(
                title: 'Customer Phone',
                value: dist?.customerPhone ?? '',
              ),
            ),
          ],
        ),
        myRowSpaceHeight,
        Row(
          children: [
            Expanded(
              child: MyTitleValueColumn(
                title: 'Order Address',
                value: dist?.deliveryAddress ?? '',
              ),
            ),
            Expanded(
              child: MyTitleValueColumn(
                title: 'City',
                value: dist?.cityName ?? '',
              ),
            ),
          ],
        ),
        myRowSpaceHeight,
      ],
    ));

    final systemLogsTable = Expanded(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: SizeConfig.safeScreenWidth,
              child: DataTable(
                // dividerThickness: 1,
                // headingRowHeight: SizeConfig.blockSizeVertical * 10,
                // headingRowColor: MaterialStateColor.resolveWith(
                //     (states) => Color(0xFFF3F4F8)),
                headingRowColor:
                    MaterialStateProperty.all(const Color(0xFFF3F4F8)),
                showBottomBorder: true,
                showCheckboxColumn: false,
                columnSpacing: SizeConfig.blockSizeHorizontal * 3,
                dataRowHeight: SizeConfig.safeBlockSizeVertical * 8,
                columns: const [
                  // DataColumn(
                  //   label: Text(
                  //     "Index",
                  //     style: TextStyle(
                  //       color: Colors.deepOrange,
                  //     ),
                  //   ),
                  // ),
                  DataColumn(
                    label: Text(
                      "Logs Message",
                      style: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Date/Time',
                      style: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "User Name",
                      style: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ],
                rows: logsList
                    // .map((e) => DataRow(cells: [
                    .mapIndexed((index, e) => DataRow(cells: [
                          // DataCell(SizedBox(
                          //     width: SizeConfig.safeBlockSizeHorizontal * 2,
                          //     child: AutoSizeText(
                          //       index.toString(),
                          //     ))),
                          DataCell(SizedBox(
                              width: SizeConfig.safeBlockSizeHorizontal * 35,
                              child: AutoSizeText(
                                e.logDetail!.toString(),
                              ))),
                          DataCell(SizedBox(
                            width: SizeConfig.safeBlockSizeHorizontal * 25,
                            child: AutoSizeText(
                              myFormatDateTimeNumeric(e.createDatetime!) +
                                  (e.applicationType == null
                                      ? '-'
                                      : '\n\nFrom:\n${e.applicationType}\n'),
                            ),
                          )),
                          DataCell(
                            SizedBox(
                              width: SizeConfig.safeBlockSizeHorizontal * 20,
                              child: AutoSizeText(
                                e.userName!.toString(),
                              ),
                            ),
                          ),
                        ]))
                    .toList()
                    .reversed
                    .toList(),
              ),
            )));

    return DefaultTabController(
      length: tabsLength,
      initialIndex: initialTabIndex,
      child: Scaffold(
        appBar: _appBar,
        body: TabBarView(
          children: [
            /////////////**** Order Detail Tab ****///////////
            Container(
              width: SizeConfig.safeScreenWidth,
              padding: MyVariables.scaffoldBodyPadding,
              child: dist == null
                  ? const MyLoadingIndicator(
                      centerIt: true,
                    )
                  : orderDetailColumn,
            ),
            /////////////**** System Logs Tab ****///////////
            Container(
              width: SizeConfig.safeScreenWidth,
              padding: MyVariables.scaffoldBodyPadding,
              child: isLoadingLogs == true
                  ? const MyLoadingIndicator(
                      centerIt: true,
                    )
                  : logsList.isNotEmpty
                      ? Column(children: [
                          const MySpaceHeight(heightSize: 2),
                          systemLogsTable
                        ])
                      : const MyNoDataToShowWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
