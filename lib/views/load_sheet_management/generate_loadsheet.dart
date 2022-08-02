import 'package:backoffice_new/controllers/city_controller.dart';
import 'package:backoffice_new/controllers/merchant_controller.dart';
import 'package:backoffice_new/controllers/pickup_address_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/my_card.dart';
import 'package:backoffice_new/custom/custom_widgets/show_confirmation_dialog.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/models/stock_in_model.dart';

import '../../custom/custom_widgets/show_response_dialog.dart';

class GenerateLoadSheet extends StatefulWidget {
  const GenerateLoadSheet({Key? key}) : super(key: key);

  @override
  _GenerateLoadSheetState createState() => _GenerateLoadSheetState();
}

class _GenerateLoadSheetState extends State<GenerateLoadSheet>
    with SingleTickerProviderStateMixin {
  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  final MerchantCityController merchantCityController =
      Get.put(MerchantCityController());
  final MerchantPickupAddressController pickupAddressController =
      Get.put(MerchantPickupAddressController());

  List<int> selectedRecords = [];
  List<OrdersDataDist> searchedOrdersList = [];

  GenerateLoadSheetRequestData requestData = GenerateLoadSheetRequestData();

  String? selectedPickupAddress;
  String? selectedCity;
  late MerchantCityLookupDataDist tmpC;
  late MerchantPickupAddressLookupDataDist tmpA;
  String? selectedMerchent;
  late MerchantLookupDataDist tmpM;
  final MerchantController merchantController = Get.put(MerchantController());

  String? orderTrackingNumber = '';

  loadData() async {
    if (selectedMerchent != null) {
      myShowLoadingDialog(context);
      apiFetchData
          .getOrders(
              tmpM.merchantId,
              '',
              '',
              MyVariables.orderStatusIdUnbooked,
              '',
              orderTrackingNumber,
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
            Get.isDialogOpen! ? tryToPop(context) : null;
            if (value.dist!.isNotEmpty) {
              setState(() {
                selectedRecords = [];
                searchedOrdersList = [];
                searchedOrdersList.addAll(value.dist!);
              });
            } else {
              setState(() {
                selectedRecords = [];
                searchedOrdersList = [];
              });
              myToastSuccess(MyVariables.notFoundErrorMSG);
            }
          }
        } else {
          // Get.isDialogOpen! ? tryToPop(context) : null;
        }
      });
    } else {
      myToastError('Please select Merchant to search');
    }
  }

  clearAllData() {
    setState(() {
      selectedCity = null;
      selectedRecords = [];
      selectedPickupAddress = null;
      searchedOrdersList = [];
    });
  }

  removeFromList(List<int> records) {
    for (int i = 0; i < records.length; i++) {
      setState(() {
        searchedOrdersList
            .removeWhere((element) => element.transactionId == records[i]);
      });
    }
  }

  removeDataLocally() {
    removeFromList(selectedRecords);
    setState(() {
      selectedRecords = [];
    });
  }

  onSelected(bool selected, OrdersDataDist ordersDataDist) {
    setState(() {
      if (selectedRecords.contains(ordersDataDist.transactionId)) {
        selectedRecords.remove(ordersDataDist.transactionId);
      } else if (selected) {
        selectedRecords.add(ordersDataDist.transactionId!);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var appBar = PreferredSize(
      preferredSize: MyVariables.preferredSizeAppBar,
      child: SafeArea(
        child: AppBar(
          elevation: 0,
          backgroundColor: MyVariables.appBarBackgroundColor,
          iconTheme: MyVariables.appBarIconTheme,
          toolbarHeight: MyVariables.appbarHeight,
          title: const MyTextWidgetAppBarTitle(
            text: 'Generate Load Sheet',
          ),
          flexibleSpace: const MyAppBarFlexibleContainer(),
        ),
      ),
    );

    var myDropDownMerchant = MyDropDownMerchant(
      selectedValue: selectedMerchent,
      onChanged: (val) {
        setState(() {
          clearAllData();
          selectedMerchent = val.toString();
          tmpM = merchantController.merchantLookupList.firstWhere(
              (element) => element.merchantName == selectedMerchent);
          merchantCityController.fetchMerchantCityList(
              tmpM.merchantId, context);
          merchantCityController.merchantCityList.value = [];
          pickupAddressController.pickupAddressLookupList.value = [];
        });
      },
      listOfItems: merchantController.merchantLookupList,
    );

    var myDropDownMerchantCity = MyDropDownMerchantCity(
      selectedValue: selectedCity,
      onChanged: (newValue) {
        setState(() {
          selectedCity = null;
          selectedPickupAddress = null;
          selectedCity = newValue.toString();
          tmpC = merchantCityController.merchantCityList
              .firstWhere((element) => element.cityName == selectedCity);
          pickupAddressController.fetchPickupAddressList(
              tmpM.merchantId, tmpC.cityId, context);
        });
      },
      listOfItems: merchantCityController.merchantCityList,
    );

    var myDropDownMerchantPickupAddress = MyDropDownMerchantPickupAddress(
      selectedValue: selectedPickupAddress,
      onChanged: (newValue) {
        setState(() {
          selectedPickupAddress = null;
          selectedPickupAddress = newValue.toString();
          tmpA = pickupAddressController.pickupAddressLookupList.firstWhere(
              (element) => element.address == selectedPickupAddress);
        });
      },
      listOfItems: pickupAddressController.pickupAddressLookupList,
    );

    var counter = SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: ShowOrdersCount(
        text: selectedRecords.isNotEmpty ? 'Selected' : null,
        alignment: Alignment.centerLeft,
        listLength: selectedRecords.isNotEmpty
            ? selectedRecords.length
            : searchedOrdersList.length,
        totalElements: searchedOrdersList.length,
      ),
    );

    var mySearchDataBtn = Container(
        width: SizeConfig.safeScreenWidth,
        alignment: Alignment.centerRight,
        child: MyElevatedButton(
          text: 'Search',
          btnBackgroundColor: MyColors.btnColorGreen,
          onPressed: loadData,
        ));

    final searchedOrdersDataList = ListView.builder(
        itemCount: searchedOrdersList.length,
        itemBuilder: (BuildContext context, index) {
          return MyCard(
            dist: searchedOrdersList[index],
            needToHideDeleteIcon: true,
            isSelected: selectedRecords
                .contains(searchedOrdersList[index].transactionId),
            onChangedCheckBox: (b) {
              onSelected(b!, searchedOrdersList[index]);
            },
          );
        });

    var generateLoadSheetButton = MyElevatedButton(
      text: 'Generate Load Sheet',
      btnBackgroundColor: MyColors.btnColorGreen,
      btnPaddingHorizontalSize: 8,
      onPressed: () {
        if (selectedCity != null && selectedCity!.isNotEmpty) {
          if (selectedPickupAddress != null &&
              selectedPickupAddress!.isNotEmpty) {
            if (selectedRecords.isNotEmpty) {
              myShowConfirmationDialog(
                  title: 'Generate LoadSheet',
                  description:
                      'Are you sure you want to generate loadsheet of these orders?',
                  onSavePressed: () {
                    myShowLoadingDialog(context);
                    requestData = GenerateLoadSheetRequestData(
                      merchantAddressId: tmpA.merchantAddressId,
                      merchantId: tmpM.merchantId,
                      transactionId: selectedRecords,
                    );
                    apiPostData
                        .postGenerateLoadSheet(requestData)
                        .then((value) {
                      if (value != null) {
                        if (mounted) {
                          Get.isDialogOpen! ? tryToPop(context) : null;
                          removeDataLocally();
                          tryToPopTrue(context);
                          myShowSuccessMSGDialog(
                            description:
                                'Load sheet has been generated successfully',
                          );
                        }
                      } else {
                        // Get.isDialogOpen! ? tryToPop(context) : null;
                      }
                    });
                  });
            } else {
              myToastError('Please select Record');
            }
          } else {
            myToastError('Please select Pickup Address');
          }
        } else {
          myToastError('Please select City');
        }
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffoldBackgroundColor,
      appBar: appBar,
      body: Padding(
        padding: MyVariables.scaffoldBodyPadding,
        child: Column(
          children: [
            const MySpaceHeight(heightSize: 1.5),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: myDropDownMerchant),
                    const MySpaceWidth(widthSize: 2),
                    Expanded(child: myDropDownMerchantCity),
                  ],
                ),
                const MySpaceHeight(heightSize: 1),
                myDropDownMerchantPickupAddress,
                const MySpaceHeight(heightSize: 1),
                Row(
                  children: [
                    Expanded(child: counter),
                    Expanded(child: mySearchDataBtn)
                  ],
                ),
              ],
            ),
            const MySpaceHeight(heightSize: 1.5),
            Expanded(
              child: searchedOrdersDataList,
            ),
            generateLoadSheetButton,
          ],
        ),
      ),
    );
  }
}
