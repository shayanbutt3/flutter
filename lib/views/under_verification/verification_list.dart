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
import 'package:get/get.dart';

class VerficationList extends StatefulWidget {
  const VerficationList({Key? key}) : super(key: key);

  @override
  _VerificationListState createState() => _VerificationListState();
}

class _VerificationListState extends State<VerficationList> {
  ApiFetchData apiFetchData = ApiFetchData();

  TextEditingController trackingNumberController = TextEditingController();
  final MerchantController merchantController = Get.put(MerchantController());

  String? selectedMerchant;
  MerchantLookupDataDist? tmpM;

  List<OrdersDataDist> ordersList = [];
  Pagination pagination = Pagination();

  loadData({
    var merchantId,
    var trackingNumber,
  }) async {
    myShowLoadingDialog(context);
    apiFetchData
        .getOrders(
            merchantId ?? '',
            '',
            '',
            MyVariables.orderStatusIdUnderVerification,
            '',
            trackingNumber ?? '',
            '',
            '',
            '',
            MyVariables.paginationDisable,
            0,
            MyVariables.size,
            MyVariables.sortDirection)
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

  removeFromList(int transactionId) {
    setState(() {
      ordersList
          .removeWhere((element) => element.transactionId == transactionId);
      pagination.totalElements = pagination.totalElements! - 1;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
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
              text: 'Verification List',
            ),
            flexibleSpace: const MyAppBarFlexibleContainer(),
          ),
        ));

    final list = ListView.builder(
        itemCount: ordersList.length,
        itemBuilder: (context, index) {
          return myCard(context, ordersList[index]);
        });

    final container = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
              child: MyDropDownMerchant(
            selectedValue: selectedMerchant,
            onChanged: (val) {
              setState(() {
                selectedMerchant = val.toString();
                tmpM = merchantController.merchantLookupList.firstWhere(
                    (element) => element.merchantName == selectedMerchant);
              });
            },
            listOfItems: merchantController.merchantLookupList,
          )),
          const MySpaceWidth(widthSize: 2),
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

    final searchBtn = SizedBox(
        width: SizeConfig.safeScreenWidth,
        child: Row(
          children: [
            Expanded(
                child: ShowOrdersCount(
              listLength: ordersList.length,
              totalElements: pagination.totalElements,
            )),
            Expanded(
              child: MyElevatedButton(
                text: 'Search',
                btnBackgroundColor: MyColors.btnColorGreen,
                onPressed: () {
                  loadData(
                    merchantId: tmpM == null ? '' : tmpM?.merchantId,
                    trackingNumber: trackingNumberController.text.trim(),
                  );
                },
              ),
            ),
          ],
        ));

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
            container,
            const MySpaceHeight(heightSize: 1.5),
            searchBtn,
            const MySpaceHeight(heightSize: 1.5),
            Expanded(
                child:
                    ordersList.isEmpty ? const MyNoDataToShowWidget() : list),
          ],
        ),
      ),
    );
  }

  Widget myCard(BuildContext context, OrdersDataDist dist) {
    return InkWell(
      onLongPress: () {
        myShowBottomSheet(context, [
          MyListTileBottomSheetMenuItem(
            titleTxt: 'Retry',
            icon: Icons.people,
            onTap: () {
              tryToPop(context);
              // showDialog(
              //     barrierDismissible: false,
              //     useSafeArea: true,
              //     context: context,
              //     builder: (BuildContext context) {
              //       return MyDialogStandard(
              //         childWidget: MyReAttemptOrderDialog(
              //             transactionId: dist.transactionId!),
              //       );
              //     }).then((value) {
              //   if (value == true) {
              //     // needToRefreshList();
              //     loadData(
              //       merchantId: tmpM == null ? '' : tmpM?.merchantId,
              //       trackingNumber: trackingNumberController.text.trim(),
              //     );
              //   }
              // });
              Get.dialog(
                      MyRetryOrderDialog(transactionIds: [dist.transactionId!]),
                      barrierDismissible: false)
                  .then((value) {
                if (value == true) {
                  removeFromList(dist.transactionId!);
                }
              });
            },
          ),
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
