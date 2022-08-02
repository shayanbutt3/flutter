import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/merchant_controller.dart';
import 'package:backoffice_new/controllers/order_type_controller.dart';
import 'package:backoffice_new/controllers/postex_city_controller.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/custom/custom_widgets/show_response_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditOrder extends StatefulWidget {
  final OrdersDataDist dist;
  const EditOrder({Key? key, required this.dist}) : super(key: key);

  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  TextEditingController dateinputController = TextEditingController();
  TextEditingController _orderreferencenumberController =
      TextEditingController();
  TextEditingController _orderAmountController = TextEditingController();
  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _customerContactController = TextEditingController();
  TextEditingController _orderAddressController = TextEditingController();
  TextEditingController _airwayBillController = TextEditingController();
  TextEditingController _itemsController = TextEditingController();
  //final TextEditingController _remarksController = TextEditingController();
  TextEditingController _orderDetailController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  UpdateOrderRequestData? updateOrderRequestData;

  final OperationalCityController operationalCityController =
      Get.put(OperationalCityController());
  final MerchantController merchantController = Get.put(MerchantController());
  final OrderTypeController orderTypeController =
      Get.put(OrderTypeController());

  String? selectedOperationalCity;
  late OperationalCityDataDist tmpC;

  String? selectedMerchant;
  late MerchantLookupDataDist tmpM;

  String? selectedOrderType;
  late OrderTypeDataDist tmpT;

  final _formkey = GlobalKey<FormState>();
  late String currentDateString;

  bool isAdmin = false;

  checkIsAdmin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userTypeId = sharedPreferences.getString('userTypeId');
    if (userTypeId != null) {
      if (int.parse(userTypeId) == MyVariables.userTypeIdAdmin) {
        setState(() {
          isAdmin = false;
        });
      } else {
        setState(() {
          isAdmin = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    currentDateString =
        myFormatDateOnly(widget.dist.transactionDate.toString());
    dateinputController = TextEditingController(text: currentDateString);
    _itemsController =
        TextEditingController(text: widget.dist.items.toString());
    _airwayBillController =
        TextEditingController(text: widget.dist.invoiceDivision.toString());
    _orderAmountController =
        TextEditingController(text: widget.dist.invoicePayment);
    selectedMerchant = widget.dist.merchantName;
    _orderreferencenumberController =
        TextEditingController(text: widget.dist.orderRefNumber);
    _customerNameController =
        TextEditingController(text: widget.dist.customerName);
    _customerContactController =
        TextEditingController(text: widget.dist.customerPhone);
    selectedOperationalCity = widget.dist.cityName;
    _orderAddressController =
        TextEditingController(text: widget.dist.deliveryAddress);
    selectedOrderType = widget.dist.orderType;
    _orderDetailController =
        TextEditingController(text: widget.dist.orderDetail);
    _notesController =
        TextEditingController(text: widget.dist.transactionNotes);
    checkIsAdmin();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var titleTextColor = Colors.black;
    var titleTextFontWeight = FontWeight.bold;
    double titleTextSize = 3;

    var editOrderTextWidget = MyTextWidgetCustom(
      text: 'Edit Order',
      color: Colors.black,
      fontWeight: FontWeight.normal,
      sizeBlockHorizontalDigit: SizeConfig.blockSizeHorizontal * 1,
    );
    var merchantTextWidget = MyTextWidgetCustom(
      text: 'Merchant*',
      color: titleTextColor,
      fontWeight: titleTextFontWeight,
      sizeBlockHorizontalDigit: titleTextSize,
    );
    var orderDateTextWidget = MyTextWidgetCustom(
      text: "Order Date",
      color: titleTextColor,
      fontWeight: titleTextFontWeight,
      sizeBlockHorizontalDigit: titleTextSize,
    );
    var orderAmountTextWidget = MyTextWidgetCustom(
      text: 'Order Amount*',
      color: titleTextColor,
      fontWeight: titleTextFontWeight,
      sizeBlockHorizontalDigit: titleTextSize,
    );
    var orderRefTextWidget = MyTextWidgetCustom(
        text: 'Order Reference*',
        color: titleTextColor,
        fontWeight: titleTextFontWeight,
        sizeBlockHorizontalDigit: titleTextSize);
    var cityTextWidget = MyTextWidgetCustom(
        text: 'City*',
        color: titleTextColor,
        fontWeight: titleTextFontWeight,
        sizeBlockHorizontalDigit: titleTextSize);
    var customerNameTextWidget = MyTextWidgetCustom(
        text: 'Customer Name*',
        color: titleTextColor,
        fontWeight: titleTextFontWeight,
        sizeBlockHorizontalDigit: titleTextSize);
    var customerPhoneTextWidget = MyTextWidgetCustom(
        text: 'Customer Contact*',
        color: titleTextColor,
        fontWeight: titleTextFontWeight,
        sizeBlockHorizontalDigit: titleTextSize);
    var orderAddressTextWidget = MyTextWidgetCustom(
        text: 'Order Address*',
        color: titleTextColor,
        fontWeight: titleTextFontWeight,
        sizeBlockHorizontalDigit: titleTextSize);
    var orderTypeTextWidget = MyTextWidgetCustom(
        text: 'Order Type*',
        color: titleTextColor,
        fontWeight: titleTextFontWeight,
        sizeBlockHorizontalDigit: titleTextSize);
    var airwayBillTextWidget = MyTextWidgetCustom(
        text: 'Airway Bill Copies*',
        color: titleTextColor,
        fontWeight: titleTextFontWeight,
        sizeBlockHorizontalDigit: titleTextSize);
    var itemTextWidget = MyTextWidgetCustom(
        text: 'Items*',
        color: titleTextColor,
        fontWeight: titleTextFontWeight,
        sizeBlockHorizontalDigit: titleTextSize);
    // var remarksTextWidget = MyTextWidgetCustom(
    //     text: 'Remarks',
    //     color: titleTextColor,
    //     fontWeight: titleTextfontWeight,
    //     sizeBlockHorizontalDigit: titleTextSize);
    var orderDetailTextWidget = MyTextWidgetCustom(
        text: 'Order Detail',
        color: titleTextColor,
        fontWeight: titleTextFontWeight,
        sizeBlockHorizontalDigit: titleTextSize);
    var notesTextWidget = MyTextWidgetCustom(
        text: 'Notes',
        color: titleTextColor,
        fontWeight: titleTextFontWeight,
        sizeBlockHorizontalDigit: titleTextSize);

    var myDropDownMerchant = MyDropDownMerchant(
      selectedValue: selectedMerchant,
      onChanged: (value) {
        setState(() {
          selectedMerchant = value.toString();
          tmpM = merchantController.merchantLookupList.firstWhere(
              (element) => element.merchantName == selectedMerchant);
        });
      },
      listOfItems: merchantController.merchantLookupList,
    );
    var orderTypeDropDown = MyDropDownOrderType(
      selectedValue: selectedOrderType,
      onChanged: (newValue) {
        setState(() {
          selectedOrderType = newValue.toString();
          tmpT = orderTypeController.orderTypeLookupList
              .firstWhere((element) => element.orderType == selectedOrderType);
        });
      },
      listOfItems: orderTypeController.orderTypeLookupList,
    );
    var operationalCityDropDown = MyDropDownOperationalCity(
      selectedValue: selectedOperationalCity,
      onChanged: (newValue) {
        setState(() {
          selectedOperationalCity = newValue.toString();
          tmpC = operationalCityController.operationalCityLookupList
              .firstWhere((element) => element.name == selectedOperationalCity);
        });
      },
      listOfItems: operationalCityController.operationalCityLookupList,
    );
    var spaceBetweenTitleAndField = const MySpaceHeight(heightSize: 1);
    var spaceBetweenFields = const MySpaceHeight(heightSize: 2);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 1,
        backgroundColor: Colors.white,
        title: editOrderTextWidget,
        actions: [
          IconButton(
            onPressed: () {
              tryToPop(context);
            },
            icon: const Icon(Icons.cancel_outlined),
            color: Colors.black,
          )
        ],
      ),
      body: Padding(
        padding: MyVariables.scaffoldBodyPadding,
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spaceBetweenFields,
                  merchantTextWidget,
                  spaceBetweenTitleAndField,
                  myDropDownMerchant,
                  spaceBetweenFields,
                  orderRefTextWidget,
                  spaceBetweenTitleAndField,
                  MyTextFieldCustom(
                    hintText: 'Order Ref Number',
                    maxlength: 50,
                    needToHideIcon: true,
                    needValidator: true,
                    controller: _orderreferencenumberController,
                  ),
                  spaceBetweenFields,
                  orderDateTextWidget,
                  spaceBetweenTitleAndField,
                  MyTextFieldCustom(
                    needToDisableField: true,
                    controller: dateinputController,
                    needToHideIcon: true,
                  ),
                  spaceBetweenFields,
                  orderAmountTextWidget,
                  spaceBetweenTitleAndField,
                  MyTextFieldCustom(
                    needToDisableField: isAdmin ? true : false,
                    hintText: 'Order Amount',
                    maxlength: 6,
                    needToHideIcon: true,
                    textInputType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      // FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: _orderAmountController,
                    needValidator: true,
                  ),
                  spaceBetweenFields,
                  cityTextWidget,
                  spaceBetweenTitleAndField,
                  operationalCityDropDown,
                  spaceBetweenFields,
                  customerNameTextWidget,
                  spaceBetweenTitleAndField,
                  MyTextFieldCustom(
                    hintText: 'Customer Name',
                    maxlength: 50,
                    controller: _customerNameController,
                    needToHideIcon: true,
                    needValidator: true,
                  ),
                  spaceBetweenFields,
                  customerPhoneTextWidget,
                  spaceBetweenTitleAndField,
                  MyTextFieldCustom(
                    hintText: 'Customer Phone',
                    textInputType: TextInputType.phone,
                    controller: _customerContactController,
                    needValidator: true,
                    needToHideIcon: true,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    maxlength: 15,
                  ),
                  spaceBetweenFields,
                  orderAddressTextWidget,
                  spaceBetweenTitleAndField,
                  MyTextFieldCustom(
                    controller: _orderAddressController,
                    needValidator: true,
                    needToHideIcon: true,
                    maxlength: 200,
                  ),
                  spaceBetweenFields,
                  orderTypeTextWidget,
                  spaceBetweenTitleAndField,
                  orderTypeDropDown,
                  spaceBetweenFields,

                  airwayBillTextWidget,
                  spaceBetweenTitleAndField,
                  TextFormField(
                    validator: (value) {
                      if (value!.isNotEmpty && int.parse(value) < 1) {
                        return 'Value cannot be less than 1';
                      }
                      if (value.isNotEmpty && int.parse(value) > 5) {
                        return 'Value cannot be greater than 5';
                      }
                      if (value.isEmpty) {
                        return "Field is Required";
                      }
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    controller: _airwayBillController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  ),
                  spaceBetweenFields,

                  itemTextWidget,
                  spaceBetweenTitleAndField,
                  TextFormField(
                    validator: (value) {
                      if (value!.isNotEmpty && int.parse(value) < 1) {
                        return 'Value cannot be less than 1';
                      }
                      if (value.isEmpty) {
                        return "Field is Required";
                      }
                    },
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    controller: _itemsController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  ),
                  // spaceBetweenFields,
                  // remarksTextWidget,
                  // spaceBetweenTitleAndField,
                  // MyTextFieldCustom(
                  //   hintText: 'Remarks',
                  //   maxlength: 300,
                  //   controller: _remarksController,
                  //   needToHideIcon: true,
                  // ),
                  spaceBetweenFields,
                  orderDetailTextWidget,
                  spaceBetweenTitleAndField,
                  MyTextFieldCustom(
                    hintText: 'Order Detail',
                    maxlength: 500,
                    controller: _orderDetailController,
                    needToHideIcon: true,
                  ),
                  spaceBetweenFields,

                  notesTextWidget,
                  spaceBetweenTitleAndField,
                  MyTextFieldCustom(
                    hintText: 'Notes',
                    maxlength: 300,
                    controller: _notesController,
                    needToHideIcon: true,
                  ),
                  spaceBetweenFields,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: MyElevatedButton(
                          text: 'Save',
                          btnBackgroundColor: MyColors.btnColorGreen,
                          onPressed: () async {
                            if (_formkey.currentState!.validate() &&
                                selectedMerchant != null &&
                                selectedMerchant!.isNotEmpty) {
                              if (selectedOrderType != null &&
                                  selectedOrderType!.isNotEmpty) {
                                if (selectedOperationalCity != null &&
                                    selectedOperationalCity!.isNotEmpty) {
                                  updateOrderRequestData =
                                      UpdateOrderRequestData(
                                          cityName: selectedOperationalCity,
                                          customerId: widget.dist.customerId,
                                          customerName:
                                              _customerNameController.text,
                                          customerPhone:
                                              _customerContactController.text,
                                          deliveryAddress:
                                              _orderAddressController.text,
                                          invoiceDivison: int.parse(
                                              _airwayBillController.text),
                                          invoicePayment: double.parse(
                                              _orderAmountController.text),
                                          items:
                                              int.parse(_itemsController.text),
                                          notes: _notesController.text,
                                          orderDetail: _orderDetailController
                                                  .text.isEmpty
                                              ? " "
                                              : _orderDetailController.text,
                                          orderRefNumber:
                                              _orderreferencenumberController
                                                  .text,
                                          orderTypeId: widget.dist.orderTypeId);

                                  myShowLoadingDialog(context);
                                  apiPostData
                                      .patchUpdateOrder(updateOrderRequestData!,
                                          widget.dist.transactionId)
                                      .then((value) {
                                    if (value != null) {
                                      if (mounted) {
                                        Get.isDialogOpen!
                                            ? tryToPop(
                                                context,
                                              )
                                            : null;
                                        myShowSuccessMSGDialog(
                                          description:
                                              'Order has been Edited Successfully',
                                          customOnPressedOK: () {
                                            Get.isDialogOpen == true
                                                ? Get.back()
                                                : null;
                                            tryToPopTrue(context);
                                          },
                                        );
                                      }
                                    }
                                  });
                                } else {
                                  myToastError('Please Select City');
                                }
                              } else {
                                myToastError('Please Select OrderType');
                              }
                            } else {
                              myToastError('Please Select Merchant');
                            }
                          },
                        ),
                      ),
                      const MySpaceWidth(widthSize: 1.5),
                      Expanded(
                        child: MyElevatedButton(
                            text: 'Close',
                            onPressed: () {
                              tryToPop(context);
                            }),
                      ),
                    ],
                  ),
                  spaceBetweenFields,
                ]),
          ),
        ),
      ),
    );
  }
}
