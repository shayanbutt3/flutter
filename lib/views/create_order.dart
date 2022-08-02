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
import 'package:backoffice_new/views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({Key? key}) : super(key: key);

  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  TextEditingController dateinputController = TextEditingController();
  final TextEditingController _orderreferencenumberController =
      TextEditingController();
  final TextEditingController _orderAmountController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerContactController =
      TextEditingController();
  final TextEditingController _orderAddressController = TextEditingController();
  TextEditingController _airwayBillController = TextEditingController();
  TextEditingController _itemsController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _orderDetailController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late CreateOrderRequestData createOrderRequestData;

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

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    currentDateString = myFormatDateOnly(now.toString());
    dateinputController = TextEditingController(text: currentDateString);
    _itemsController = TextEditingController(text: 1.toString());
    _airwayBillController = TextEditingController(text: 1.toString());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var titleTextColor = Colors.black;
    var titleTextFontWeight = FontWeight.bold;
    double titleTextSize = 3;

    var createOrderTextWidget = MyTextWidgetCustom(
      text: 'Create Order',
      color: Colors.white,
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
    var remarksTextWidget = MyTextWidgetCustom(
        text: 'Remarks',
        color: titleTextColor,
        fontWeight: titleTextFontWeight,
        sizeBlockHorizontalDigit: titleTextSize);
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

    var merchantDropDown = MyDropDownMerchant(
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: MyVariables.appbarHeight,
          elevation: 0,
          backgroundColor: Colors.black,
          title: createOrderTextWidget,
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
                    merchantDropDown,
                    spaceBetweenFields,
                    orderRefTextWidget,
                    spaceBetweenTitleAndField,
                    MyTextFieldCustom(
                      controller: _orderreferencenumberController,
                      maxlength: 50,
                      needValidator: true,
                      needToHideIcon: true,
                      hintText: "Order Reference Number",
                    ),
                    spaceBetweenFields,
                    orderDateTextWidget,
                    spaceBetweenTitleAndField,
                    MyTextFieldCustom(
                      controller: dateinputController,
                      needToDisableField: true,
                      needToHideIcon: true,
                    ),
                    spaceBetweenFields,
                    orderAmountTextWidget,
                    spaceBetweenTitleAndField,
                    MyTextFieldCustom(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _orderAmountController,
                      counterText: "",
                      maxlength: 6,
                      needToHideIcon: true,
                      needValidator: true,
                      hintText: "Order Amount",
                      textInputType: TextInputType.number,
                    ),
                    spaceBetweenFields,
                    cityTextWidget,
                    spaceBetweenTitleAndField,
                    operationalCityDropDown,
                    spaceBetweenFields,
                    customerNameTextWidget,
                    spaceBetweenTitleAndField,
                    MyTextFieldCustom(
                      controller: _customerNameController,
                      needValidator: true,
                      maxlength: 50,
                      needToHideIcon: true,
                      hintText: "Customer Name",
                    ),
                    spaceBetweenFields,
                    customerPhoneTextWidget,
                    spaceBetweenTitleAndField,
                    MyTextFieldCustom(
                      controller: _customerContactController,
                      maxlength: 15,
                      needToHideIcon: true,
                      needValidator: true,
                      hintText: "Customer Contact",
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputType: TextInputType.number,
                    ),
                    spaceBetweenFields,
                    orderAddressTextWidget,
                    spaceBetweenTitleAndField,
                    MyTextFieldCustom(
                      controller: _orderAddressController,
                      maxlength: 200,
                      hintText: "Order Address",
                      needToHideIcon: true,
                      needValidator: true,
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
                        if (value == null ||
                            value.isNotEmpty && int.parse(value) < 1) {
                          return 'Value cannot be less than 1';
                        } else if (value.isNotEmpty && int.parse(value) > 5) {
                          return 'Value cannot be greater than 5';
                        }
                        if (value.isEmpty) {
                          return 'Field is Required';
                        }
                      },
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      controller: _airwayBillController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        counterText: '',
                        border: MyVariables.textFormFieldBorder,
                        hintText: 'Airway Bill Copies',
                      ),
                    ),
                    spaceBetweenFields,
                    itemTextWidget,
                    spaceBetweenTitleAndField,
                    TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isNotEmpty && int.parse(value) < 1) {
                          return "Value cannot be less than 1";
                        } else if (value.isEmpty) {
                          return 'Field is Required';
                        }
                      },
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      controller: _itemsController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        counterText: '',
                        border: MyVariables.textFormFieldBorder,
                        hintText: 'Items',
                      ),
                    ),
                    spaceBetweenFields,
                    remarksTextWidget,
                    spaceBetweenTitleAndField,
                    MyTextFieldCustom(
                      controller: _remarksController,
                      maxlength: 300,
                      needToHideIcon: true,
                      hintText: "Remarks",
                    ),
                    spaceBetweenFields,
                    orderDetailTextWidget,
                    spaceBetweenTitleAndField,
                    MyTextFieldCustom(
                      controller: _orderDetailController,
                      maxlength: 500,
                      hintText: "Order Details",
                      needToHideIcon: true,
                    ),
                    spaceBetweenFields,
                    notesTextWidget,
                    spaceBetweenTitleAndField,
                    MyTextFieldCustom(
                      controller: _notesController,
                      maxlength: 300,
                      needToHideIcon: true,
                      hintText: "Notes",
                    ),
                    spaceBetweenFields,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MyElevatedButton(
                            text: 'Save',
                            btnBackgroundColor: MyColors.btnColorGreen,
                            onPressed: () {
                              if (_formkey.currentState!.validate() &&
                                  selectedMerchant != null &&
                                  selectedMerchant!.isNotEmpty &&
                                  selectedOrderType != null &&
                                  selectedOrderType!.isNotEmpty &&
                                  selectedOperationalCity != null &&
                                  selectedOperationalCity!.isNotEmpty) {
                                myShowLoadingDialog(context);
                                createOrderRequestData = CreateOrderRequestData(
                                    cityName: selectedOperationalCity,
                                    customerName: _customerNameController.text,
                                    customerPhone:
                                        _customerContactController.text,
                                    deliveryAddress:
                                        _orderAddressController.text,
                                    invoicePayment:
                                        int.parse(_orderAmountController.text),
                                    items: int.tryParse(_itemsController.text),
                                    invoiceDivision: int.tryParse(
                                        _airwayBillController.text),
                                    merchantId: tmpM.merchantId,
                                    orderDetail:
                                        _orderDetailController.text.isEmpty
                                            ? "N/A"
                                            : _orderDetailController.text,
                                    orderRefNumber:
                                        _orderreferencenumberController.text,
                                    orderTypeId: tmpT.orderTypeId,
                                    remarks: _remarksController.text,
                                    transactionNotes: _notesController.text);
                                apiPostData
                                    .createOrder(createOrderRequestData)
                                    .then((value) {
                                  if (value != null) {
                                    if (mounted) {
                                      Get.isDialogOpen == true
                                          ? Get.back()
                                          : null;
                                      myShowSuccessMSGDialog(
                                          description:
                                              'Order created successfully',
                                          customOnPressedOK: () {
                                            Get.isDialogOpen == true
                                                ? Get.back()
                                                : null;
                                            Get.off(() => const Dashboard());
                                          });
                                    }
                                  }
                                });
                              } else {
                                myToastError(
                                    'Please fill the form to create order');
                              }
                            },
                          ),
                        ),
                        const MySpaceWidth(widthSize: 1.5),
                        Expanded(
                          child: MyElevatedButton(
                            text: 'Close',
                            onPressed: () {
                              Get.off(() => const Dashboard());
                            },
                          ),
                        ),
                      ],
                    ),
                    spaceBetweenFields
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
