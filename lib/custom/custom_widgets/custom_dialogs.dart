import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/controllers/city_controller.dart';
import 'package:backoffice_new/controllers/pickup_address_controller.dart';
import 'package:backoffice_new/custom/custom_widgets/my_drop_downs.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:version_check/version_check.dart';

import 'show_response_dialog.dart';

class MyDialogStandard extends StatelessWidget {
  const MyDialogStandard({required this.childWidget, Key? key})
      : super(key: key);

  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      child: childWidget,
    );
  }
}

class MyInternetErrorDialog extends StatefulWidget {
  const MyInternetErrorDialog({Key? key}) : super(key: key);

  @override
  _MyInternetErrorDialogState createState() => _MyInternetErrorDialogState();
}

class _MyInternetErrorDialogState extends State<MyInternetErrorDialog> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(
        listOfItems: [
          const MyTextWidgetHeading(text: 'No Internet'),
          const MySpaceHeight(heightSize: 2),
          const MyTextWidgetNormal(
              text: 'Please check your internet and try again'),
          const MySpaceHeight(heightSize: 3),
          Align(
            alignment: Alignment.centerRight,
            child: MyElevatedButton(
              text: 'Close',
              onPressed: () {
                // Navigator.popUntil(context, (route) => false);
                Get.back();
                Get.isDialogOpen! ? Get.back() : null;
                // tryToPop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyRetryOrderDialog extends StatefulWidget {
  const MyRetryOrderDialog({required this.transactionIds, Key? key})
      : super(key: key);

  final List<int> transactionIds;

  @override
  State<MyRetryOrderDialog> createState() => _MyRetryOrderDialogState();
}

class _MyRetryOrderDialogState extends State<MyRetryOrderDialog> {
  TextEditingController controller = TextEditingController();
  ApiPostData apiPostData = ApiPostData();

  MarkRetryReAttemptRequestData requestData = MarkRetryReAttemptRequestData();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(
        listOfItems: [
          const MyTextWidgetHeading(text: 'Mark Retry'),
          const MySpaceHeight(heightSize: 2),
          MyTextFieldCustom(
            controller: controller,
            labelText: 'Remarks',
            needToHideIcon: true,
            needValidator: false,
            onChanged: (val) {
              setState(() {});
            },
          ),
          const MySpaceHeight(heightSize: 2),
          MyRowSaveCloseBtn(
            onPressedSaveBtn: () {
              FocusScope.of(context).unfocus();
              myShowLoadingDialog(context);
              requestData = MarkRetryReAttemptRequestData(
                remarks: controller.text.toString().trim(),
                transactionId: widget.transactionIds,
              );
              apiPostData.patchMarkRetry(requestData).then((value) {
                if (value != null) {
                  if (mounted) {
                    Get.isDialogOpen! ? tryToPopTrue(context) : null;
                    tryToPopTrue(context);
                    myShowSuccessMSGDialog(
                      description: 'Order marked retry successfully',
                    );
                  }
                } else {
                  // Get.isDialogOpen! ? tryToPop(context) : null;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class MyUnderVerificationDialog extends StatefulWidget {
  const MyUnderVerificationDialog(
      {required this.transactionId, required this.wareHouseId, Key? key})
      : super(key: key);

  final List<int> transactionId;
  final int wareHouseId;

  @override
  State<MyUnderVerificationDialog> createState() =>
      _MyUnderVerificationgState();
}

class _MyUnderVerificationgState extends State<MyUnderVerificationDialog> {
  TextEditingController controller = TextEditingController();
  ApiPostData apiPostData = ApiPostData();
  MarkDeliveryUnderReviewRequestData requestData =
      MarkDeliveryUnderReviewRequestData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(
        listOfItems: [
          const MyTextWidgetHeading(text: 'Mark Delivery Under Review'),
          const MySpaceHeight(heightSize: 2),
          MyTextFieldCustom(
            controller: controller,
            labelText: 'Remarks',
            needToHideIcon: true,
            needValidator: false,
            onChanged: (val) {
              setState(() {});
            },
          ),
          const MySpaceHeight(heightSize: 2),
          MyRowSaveCloseBtn(
            onPressedSaveBtn: () {
              myShowLoadingDialog(context);
              requestData = MarkDeliveryUnderReviewRequestData(
                remarks: controller.text.toString().trim(),
                transactionIds: widget.transactionId,
                wareHouseId: widget.wareHouseId,
              );
              apiPostData
                  .patchMarkDeliveryUnderReview(requestData)
                  .then((value) {
                if (value != null) {
                  if (mounted) {
                    Get.isDialogOpen! ? tryToPopTrue(context) : null;
                    myShowSuccessMSGDialog(
                        description:
                            'Order marked as delivery under review successfully',
                        customOnPressedOK: () {
                          Get.isDialogOpen == true ? tryToPop(context) : null;
                          tryToPopTrue(context);
                        });
                  }
                } else {}
              });
            },
          ),
        ],
      ),
    );
  }
}

class MyMarkReturnRequestDialog extends StatefulWidget {
  const MyMarkReturnRequestDialog({required this.transactionIds, Key? key})
      : super(key: key);

  final List<int> transactionIds;

  @override
  State<MyMarkReturnRequestDialog> createState() =>
      _MyMarkReturnRequestDialogState();
}

class _MyMarkReturnRequestDialogState extends State<MyMarkReturnRequestDialog> {
  TextEditingController controller = TextEditingController();
  ApiPostData apiPostData = ApiPostData();

  RemarksAndListTransactionIdsRequestData requestData =
      RemarksAndListTransactionIdsRequestData();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(
        listOfItems: [
          const MyTextWidgetHeading(text: 'Mark Return Request'),
          const MySpaceHeight(heightSize: 2),
          MyTextFieldCustom(
            controller: controller,
            labelText: 'Remarks',
            needToHideIcon: true,
            needValidator: false,
            onChanged: (val) {
              setState(() {});
            },
          ),
          const MySpaceHeight(heightSize: 2),
          MyRowSaveCloseBtn(
            onPressedSaveBtn: () {
              FocusScope.of(context).unfocus();
              myShowLoadingDialog(context);
              requestData = RemarksAndListTransactionIdsRequestData(
                remarks: controller.text,
                transactionIds: widget.transactionIds,
              );
              apiPostData.patchMarkReturnRequest(requestData).then((value) {
                if (value != null) {
                  // Fluttertoast.showToast(msg: value.statusMessage!);
                  Get.isDialogOpen! ? tryToPop(context) : null;
                  tryToPopTrue(context);
                  myShowSuccessMSGDialog(
                    description:
                        'Order marked as return requested successfully',
                  );
                } else {
                  // Get.isDialogOpen! ? tryToPop(context) : null;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class MyMarkDeliveredRequestDialog extends StatefulWidget {
  const MyMarkDeliveredRequestDialog(
      {required this.invoiceAmount, required this.transactionId, Key? key})
      : super(key: key);

  final String invoiceAmount;
  final int transactionId;

  @override
  State<MyMarkDeliveredRequestDialog> createState() =>
      _MyMarkDeliveredRequestDialogState();
}

class _MyMarkDeliveredRequestDialogState
    extends State<MyMarkDeliveredRequestDialog> {
  TextEditingController remarksController = TextEditingController();
  TextEditingController invoiceAmountController = TextEditingController();
  TextEditingController collectedAmountController = TextEditingController();
  ApiPostData apiPostData = ApiPostData();

  final _formKey = GlobalKey<FormState>();

  MarkDeliveredRequestData requestData = MarkDeliveredRequestData();

  @override
  void initState() {
    super.initState();
    invoiceAmountController.text = widget.invoiceAmount;
  }

  @override
  Widget build(BuildContext context) {
    var spaceBetweenFields = const MySpaceHeight(heightSize: 1);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(
        listOfItems: [
          const MyTextWidgetHeading(text: 'Mark Delivered'),
          const MySpaceHeight(heightSize: 2),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  MyTextFieldCustom(
                    controller: invoiceAmountController,
                    labelText: 'Invoice Amount',
                    needToHideIcon: true,
                    needValidator: false,
                    needToDisableField: true,
                    onChanged: (val) {
                      setState(() {});
                    },
                  ),
                  spaceBetweenFields,
                  // TextFormField(
                  //   controller: collectedAmountController,
                  //   keyboardType: TextInputType.number,
                  //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  //   decoration: InputDecoration(
                  //     labelText: 'Collected Amount',
                  //     labelStyle: TextStyle(
                  //       color: MyColors.tetxFieldIconsColor,
                  //     ),
                  //     border: MyVariables.textFormFieldBorder,
                  //   ),
                  //   validator: (text) {
                  //     if (text == null || text.isEmpty) {
                  //       return 'Please enter amount';
                  //     } else if (double.parse(text) <
                  //             double.parse(invoiceAmountController.text) &&
                  //         remarksController.text.trim().isEmpty) {
                  //       return 'Please enter the remarks';
                  //     } else if (double.parse(text) >
                  //         double.parse(invoiceAmountController.text)) {
                  //       return 'Please enter valid amount';
                  //     }
                  //   },
                  // ),
                  MyTextFieldCustom(
                    controller: collectedAmountController,
                    labelText: 'Collected Amount',
                    needToHideIcon: true,
                    needValidator: true,
                    onChanged: (val) {
                      setState(() {});
                    },
                    textInputType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  spaceBetweenFields,
                  MyTextFieldCustom(
                    controller: remarksController,
                    labelText: 'Remarks',
                    needToHideIcon: true,
                    onChanged: (val) {
                      setState(() {});
                    },
                  ),
                  const MySpaceHeight(heightSize: 2),
                  MyRowSaveCloseBtn(
                    onPressedSaveBtn: () {
                      if (_formKey.currentState!.validate()) {
                        var collected = collectedAmountController.text;
                        double parsedDoubleInvoice =
                            double.parse(invoiceAmountController.text);
                        double parsedDoubleAmount = double.parse(collected);
                        if (parsedDoubleAmount < parsedDoubleInvoice &&
                            remarksController.text.toString().trim().isEmpty) {
                          myToastError('Please fill remarks');
                        } else if (parsedDoubleAmount > parsedDoubleInvoice) {
                          myToastError('Please enter valid amount');
                        } else {
                          FocusScope.of(context).unfocus();
                          myShowLoadingDialog(context);
                          requestData = MarkDeliveredRequestData(
                            latitudeLongitude: '',
                            proofOfDeliveredImage: '',
                            transactionRemark: remarksController.text,
                            receivedAmount:
                                double.parse(collectedAmountController.text),
                            transactionId: widget.transactionId,
                          );
                          apiPostData
                              .patchMarkDelivered(requestData)
                              .then((value) {
                            if (value != null) {
                              // Fluttertoast.showToast(msg: value.statusMessage!);
                              Get.isDialogOpen! ? tryToPop(context) : null;
                              tryToPopTrue(context);
                              myShowSuccessMSGDialog(
                                description: 'Order delivered successfully',
                              );
                            } else {
                              // Get.isDialogOpen! ? tryToPop(context) : null;
                            }
                          });
                        }
                      } else {
                        myToastError('Please fill the fields');
                      }
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class MyGenerateTransferSheetDialog extends StatefulWidget {
  const MyGenerateTransferSheetDialog(
      {required this.transactionIds, required this.wareHouseId, Key? key})
      : super(key: key);

  final List<int> transactionIds;
  final int wareHouseId;

  @override
  State<MyGenerateTransferSheetDialog> createState() =>
      _MyGenerateTransferSheetDialogState();
}

class _MyGenerateTransferSheetDialogState
    extends State<MyGenerateTransferSheetDialog> {
  TextEditingController sheetTagController = TextEditingController();
  ApiPostData apiPostData = ApiPostData();
  GenerateTransferSheetRequestData requestData =
      GenerateTransferSheetRequestData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(
        listOfItems: [
          const MyTextWidgetHeading(text: 'Generate Transfer Sheet'),
          const MySpaceHeight(heightSize: 2),
          MyTextFieldCustom(
            controller: sheetTagController,
            labelText: 'Sheet Tag',
            needToHideIcon: true,
            needValidator: false,
            onChanged: (val) {
              setState(() {});
            },
          ),
          const MySpaceHeight(heightSize: 2),
          MyRowSaveCloseBtn(
            onPressedSaveBtn: () {
              if (sheetTagController.text.trim().isNotEmpty) {
                myShowLoadingDialog(context);

                requestData = GenerateTransferSheetRequestData(
                  sheetTag: sheetTagController.text,
                  transactionIds: widget.transactionIds,
                  wareHouseId: widget.wareHouseId,
                );

                apiPostData
                    .postGenerateTransferSheet(requestData)
                    .then((value) {
                  if (value != null) {
                    if (mounted) {
                      // Fluttertoast.showToast(msg: value.statusMessage!);
                      Get.isDialogOpen! ? tryToPop(context) : null;
                      Get.isDialogOpen! ? tryToPopTrue(context) : null;
                      myShowSuccessMSGDialog(
                        description:
                            'Transfer sheet has been generated successfully',
                      );
                    }
                  } else {
                    // Get.isDialogOpen! ? tryToPop(context) : null;
                  }
                });
              } else {
                myToastError('Please add sheet tag');
              }
            },
          ),
        ],
      ),
    );
  }
}

class RevertSheetConfirmationDialog extends StatefulWidget {
  final RevertSheetRequestData requestData;
  const RevertSheetConfirmationDialog({required this.requestData, Key? key})
      : super(key: key);
  @override
  _RevertSheetConfirmationDialogState createState() =>
      _RevertSheetConfirmationDialogState();
}

class _RevertSheetConfirmationDialogState
    extends State<RevertSheetConfirmationDialog> {
  ApiPostData apiPostData = ApiPostData();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    const spaceBetweenColumnItems = MySpaceHeight(heightSize: 2);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(listOfItems: [
        const MyTextWidgetHeading(text: 'Revert Sheet'),
        spaceBetweenColumnItems,
        const MyTextWidgetNormal(
            text: 'Are you sure you want to revert this sheet?'),
        spaceBetweenColumnItems,
        MyRowSaveCloseBtn(onPressedSaveBtn: () {
          myShowLoadingDialog(context);
          apiPostData.patchRevertSheet(widget.requestData).then((value) {
            if (value != null) {
              if (mounted) {
                Get.isDialogOpen == true ? Get.back() : null;
                tryToPopTrue(context);
                myShowSuccessMSGDialog(
                    description: 'Sheet has been reverted successfully');
              }
            } else {}
          });
        }),
      ]),
    );
  }
}

class MyRowSaveCloseBtn extends StatelessWidget {
  const MyRowSaveCloseBtn({
    Key? key,
    required this.onPressedSaveBtn,
    this.onPressedCustomCloseBtn,
  }) : super(key: key);

  final void Function()? onPressedSaveBtn;
  final void Function()? onPressedCustomCloseBtn;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.safeScreenWidth,
      child: Row(
        children: [
          Expanded(
              child: MyElevatedButton(
            text: 'Save',
            btnBackgroundColor: MyColors.btnColorGreen,
            onPressed: onPressedSaveBtn,
          )),
          const MySpaceWidth(widthSize: 2),
          Expanded(
              child: MyElevatedButton(
            text: 'Close',
            onPressed: onPressedCustomCloseBtn ??
                () {
                  tryToPop(context);
                },
          )),
        ],
      ),
    );
  }
}

class MyRevertOrderDialog extends StatefulWidget {
  const MyRevertOrderDialog({required this.dist, Key? key}) : super(key: key);

  final OrdersDataDist dist;

  @override
  _MyRevertOrderDialogState createState() => _MyRevertOrderDialogState();
}

class _MyRevertOrderDialogState extends State<MyRevertOrderDialog> {
  ApiPostData apiPostData = ApiPostData();
  // RevertOrderRequestData requestData = RevertOrderRequestData();
  MarkDeliveryEnRouteRequestData requestData = MarkDeliveryEnRouteRequestData();
  MarkReturnInTransitRequestData inTransitRequestData =
      MarkReturnInTransitRequestData();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: MyDialogContainer(listOfItems: [
          const MyTextWidgetHeading(text: 'Revert Order'),
          const MySpaceHeight(heightSize: 2),
          const MyTextWidgetNormal(
              text: 'Are you sure you want to Revert this Order?'),
          const MySpaceHeight(heightSize: 2),
          MyRowSaveCloseBtn(onPressedSaveBtn: () {
            myShowLoadingDialog(context);
            if (widget.dist.transactionStatusId ==
                int.parse(MyVariables.orderStatusIdDelivered)) {
              requestData = MarkDeliveryEnRouteRequestData(
                  transactionIds: [widget.dist.transactionId!]);
              apiPostData.patchMarkDeliveryEnRoute(requestData).then((value) {
                if (value != null) {
                  Get.isDialogOpen == true ? Get.back() : null;
                  tryToPopTrue(context);
                  myShowSuccessMSGDialog(
                    description: 'Order has been reverted successfully',
                  );
                }
              });
            } else if (widget.dist.transactionStatusId ==
                int.parse(MyVariables.orderStatusIdReturned)) {
              inTransitRequestData = MarkReturnInTransitRequestData(
                  transactionIds: [widget.dist.transactionId!]);
              apiPostData
                  .patchMarkReturnInTransit(inTransitRequestData)
                  .then((value) {
                if (value != null) {
                  Get.isDialogOpen == true ? Get.back() : null;
                  tryToPopTrue(context);
                  myShowSuccessMSGDialog(
                    description: 'Order has been reverted successfully',
                  );
                }
              });
            }
          }),
        ]));
  }
}

class MyRevertPickedOrderDialog extends StatefulWidget {
  const MyRevertPickedOrderDialog({required this.transactionIds, Key? key})
      : super(key: key);
  final List<int> transactionIds;

  @override
  _MyRevertPickedOrderDialogState createState() =>
      _MyRevertPickedOrderDialogState();
}

class _MyRevertPickedOrderDialogState extends State<MyRevertPickedOrderDialog> {
  ApiPostData apiPostData = ApiPostData();
  RevertPickedOrderRequestData requestData = RevertPickedOrderRequestData();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: MyDialogContainer(listOfItems: [
          const MyTextWidgetHeading(text: 'Revert Picked Order'),
          const MySpaceHeight(heightSize: 2),
          const MyTextWidgetNormal(
              text: 'Are you sure you want to revert this order?'),
          const MySpaceHeight(heightSize: 2),
          MyRowSaveCloseBtn(onPressedSaveBtn: () {
            requestData = RevertPickedOrderRequestData(
                transactionIds: widget.transactionIds);
            myShowLoadingDialog(context);
            apiPostData.patchRevertPickedOrder(requestData).then((value) {
              if (value != null) {
                if (mounted) {
                  Get.isDialogOpen! ? tryToPop(context) : null;
                  Get.isDialogOpen! ? tryToPopTrue(context) : null;
                  myShowSuccessMSGDialog(
                      description: 'Order has been reverted successfully');
                }
              }
            });
          })
        ]));
  }
}

class MyRevertReturnProcessDialog extends StatefulWidget {
  final int transactionId;
  const MyRevertReturnProcessDialog({required this.transactionId, Key? key})
      : super(key: key);

  @override
  _MyRevertReturnProcessDialogState createState() =>
      _MyRevertReturnProcessDialogState();
}

class _MyRevertReturnProcessDialogState
    extends State<MyRevertReturnProcessDialog> {
  TextEditingController controller = TextEditingController();
  ApiPostData apiPostData = ApiPostData();
  MarkRetryReAttemptRequestData requestData = MarkRetryReAttemptRequestData();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(listOfItems: [
        const MyTextWidgetHeading(text: 'Revert Return Process'),
        const MySpaceHeight(heightSize: 2),
        MyTextFieldCustom(
          controller: controller,
          labelText: 'Remarks',
          needToHideIcon: true,
          needValidator: false,
          onChanged: (val) {
            setState(() {});
          },
        ),
        const MySpaceHeight(heightSize: 2),
        MyRowSaveCloseBtn(onPressedSaveBtn: () {
          FocusScope.of(context).unfocus();
          myShowLoadingDialog(context);
          requestData = MarkRetryReAttemptRequestData(
              remarks: controller.text.toString().trim(),
              transactionId: [widget.transactionId]);
          apiPostData.patchMarkRetry(requestData).then((value) {
            if (value != null) {
              Get.isDialogOpen == true ? Get.back() : null;
              myShowSuccessMSGDialog(
                  description: 'Order reverted successfully',
                  customOnPressedOK: () {
                    Get.isDialogOpen == true ? Get.back() : null;
                    tryToPopTrue(context);
                  });
            }
          });
        })
      ]),
    );
  }
}

class MyMarkPickedDialog extends StatefulWidget {
  const MyMarkPickedDialog(
      {required this.merchantId,
      required this.riderId,
      required this.transactionIds,
      Key? key})
      : super(key: key);
  final int merchantId;
  final int riderId;
  final List<int> transactionIds;
  @override
  _MyMarkPickedDialogState createState() => _MyMarkPickedDialogState();
}

class _MyMarkPickedDialogState extends State<MyMarkPickedDialog> {
  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();

  MarkPickedRequestData requestData = MarkPickedRequestData();

  MerchantCityController cityController = Get.put(MerchantCityController());
  MerchantPickupAddressController pickupAddressController =
      Get.put(MerchantPickupAddressController());

  String? selectedCity;
  MerchantCityLookupDataDist? tmpC;

  String? selectedAddress;
  MerchantPickupAddressLookupDataDist? tmpA;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) =>
        cityController.fetchMerchantCityList(widget.merchantId, context));
  }

  @override
  Widget build(BuildContext context) {
    var cityDropDown = MyDropDownMerchantCity(
      needtoHideSearchBox: true,
      selectedValue: selectedCity,
      onChanged: (val) {
        setState(() {
          selectedCity = val.toString();
          selectedAddress = null;
          tmpC = cityController.merchantCityList
              .firstWhere((element) => element.cityName == selectedCity);
          pickupAddressController.fetchPickupAddressList(
              widget.merchantId, tmpC!.cityId, context);
        });
      },
      listOfItems: cityController.merchantCityList,
    );

    var addressDropDown = MyDropDownMerchantPickupAddress(
      needToHideSearchBox: true,
      selectedValue: selectedAddress,
      onChanged: (value) {
        setState(() {
          selectedAddress = value.toString();
          tmpA = pickupAddressController.pickupAddressLookupList
              .firstWhere((element) => element.address == selectedAddress);
        });
      },
      listOfItems: pickupAddressController.pickupAddressLookupList,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(
        listOfItems: [
          const MyTextWidgetHeading(text: 'Mark Picked'),
          const MySpaceHeight(heightSize: 1),
          cityDropDown,
          const MySpaceHeight(heightSize: 1),
          addressDropDown,
          const MySpaceHeight(heightSize: 2),
          MyRowSaveCloseBtn(
            onPressedSaveBtn: () {
              if (selectedAddress != null &&
                  selectedAddress!.isNotEmpty &&
                  tmpA != null) {
                requestData = MarkPickedRequestData(
                  merchantAddressId: tmpA!.merchantAddressId,
                  merchantId: widget.merchantId,
                  riderId: widget.riderId,
                  transactionIds: widget.transactionIds,
                );
                myShowLoadingDialog(context);
                apiPostData.patchMarkPicked(requestData).then((value) {
                  if (value != null) {
                    Get.isDialogOpen == true ? Get.back() : null;
                    myShowSuccessMSGDialog(
                      description: 'Orders has been picked successfully',
                      customOnPressedOK: () {
                        Get.isDialogOpen == true ? Get.back() : null;
                        tryToPopTrue(context);
                      },
                    );
                  }
                });
              } else {
                myToastError('Please select pickup address');
              }
            },
          ),
        ],
      ),
    );
  }
}

class MyDeManifestConfirmationDialog extends StatefulWidget {
  const MyDeManifestConfirmationDialog(
      {required this.masterUnitId, required this.transactionIds, Key? key})
      : super(key: key);
  final List<int>? transactionIds;
  final int? masterUnitId;
  @override
  _MyDeManifestConfirmationDialog createState() =>
      _MyDeManifestConfirmationDialog();
}

class _MyDeManifestConfirmationDialog
    extends State<MyDeManifestConfirmationDialog> {
  ApiPostData apiPostData = ApiPostData();
  DeManifestRequestData requestData = DeManifestRequestData();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    const spaceBetweenColumnItems = MySpaceHeight(heightSize: 2);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: MyDialogContainer(listOfItems: [
          const MyTextWidgetHeading(text: 'De-Manifest'),
          spaceBetweenColumnItems,
          const MyTextWidgetNormal(
              text: 'Are you sure you want to De Manifest these orders?'),
          spaceBetweenColumnItems,
          MyRowSaveCloseBtn(onPressedSaveBtn: () {
            myShowLoadingDialog(context);
            requestData = DeManifestRequestData(
                masterUnitId: widget.masterUnitId,
                transactionIds: widget.transactionIds);
            apiPostData.patchDeManifestMasterUnit(requestData).then((value) {
              if (value != null) {
                if (mounted) {
                  Get.isDialogOpen == true ? tryToPop(context) : null;
                  myShowSuccessMSGDialog(
                    description: 'De Mainfest Successfuly',
                  );
                }
              }
            });
          })
        ]));
  }
}

class MyHandoverConfirmationDialog extends StatefulWidget {
  const MyHandoverConfirmationDialog({required this.masterUnitIds, Key? key})
      : super(key: key);
  final List<int> masterUnitIds;

  @override
  _MyHandoverConfirmationDialogState createState() =>
      _MyHandoverConfirmationDialogState();
}

class _MyHandoverConfirmationDialogState
    extends State<MyHandoverConfirmationDialog> {
  ApiPostData apiPostData = ApiPostData();
  HandoverMasterUnitRequestData requestData = HandoverMasterUnitRequestData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(listOfItems: [
        const MyTextWidgetHeading(text: 'Handover'),
        const MyTextWidgetNormal(
            text: 'Are you sure you want to handover this MU?'),
        const MySpaceHeight(heightSize: 1),
        MyRowSaveCloseBtn(onPressedSaveBtn: () {
          myShowLoadingDialog(context);
          requestData = HandoverMasterUnitRequestData(
              masterUnitIds: widget.masterUnitIds);
          apiPostData.patchHandoverMasterUnit(requestData).then((value) {
            if (value != null) {
              Get.isDialogOpen == true ? Get.back() : null;
              myShowSuccessMSGDialog(
                  description: 'MU has been handed over sucessfully',
                  customOnPressedOK: () {
                    Get.isDialogOpen == true ? Get.back() : null;
                    tryToPopTrue(context);
                  });
            }
          });
        })
      ]),
    );
  }
}

class MyDispatchTransferSheetDialog extends StatefulWidget {
  const MyDispatchTransferSheetDialog({required this.sheetMasterIds, Key? key})
      : super(key: key);
  final List<int> sheetMasterIds;

  @override
  _MyDispatchTransferSheetDialogState createState() =>
      _MyDispatchTransferSheetDialogState();
}

class _MyDispatchTransferSheetDialogState
    extends State<MyDispatchTransferSheetDialog> {
  ApiPostData apiPostData = ApiPostData();
  DispatchTransferSheetRequestData requestData =
      DispatchTransferSheetRequestData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: MyDialogContainer(listOfItems: [
          const MyTextWidgetHeading(text: 'Diaptach Transfer Sheet'),
          const MySpaceHeight(heightSize: 1),
          const MyTextWidgetNormal(
              text:
                  'Are you sure you want to mark this transfer sheet as dispatched?'),
          const MySpaceHeight(heightSize: 1),
          MyRowSaveCloseBtn(onPressedSaveBtn: (() {
            myShowLoadingDialog(context);
            requestData = DispatchTransferSheetRequestData(
                sheetMasterIds: widget.sheetMasterIds);
            apiPostData.patchDispatchTransferSheet(requestData).then((value) {
              if (value != null) {
                Get.isDialogOpen == true ? Get.back() : null;
                myShowSuccessMSGDialog(
                    description: 'Your sheet has been dispatched successfully',
                    customOnPressedOK: () {
                      Get.isDialogOpen == true ? Get.back() : null;
                      tryToPopTrue(context);
                    });
              }
            });
          }))
        ]));
  }
}

class MyDeliveryRescheduleDialog extends StatefulWidget {
  const MyDeliveryRescheduleDialog(
      {required this.transactionIds, required this.wareHouseId, Key? key})
      : super(key: key);
  final List<int> transactionIds;
  final int wareHouseId;
  @override
  _MyDeliveryRescheduleDialogState createState() =>
      _MyDeliveryRescheduleDialogState();
}

class _MyDeliveryRescheduleDialogState
    extends State<MyDeliveryRescheduleDialog> {
  ApiPostData apiPostData = ApiPostData();
  DeliveryRescheduleRequestData requestData = DeliveryRescheduleRequestData();
  TextEditingController remarksController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: MyDialogContainer(listOfItems: [
          const MyTextWidgetHeading(text: 'Delivery Reschedule'),
          const MySpaceHeight(heightSize: 1),
          MyTextFieldCustom(
            controller: remarksController,
            onChanged: (s) {
              setState(() {});
            },
            labelText: 'Remarks',
            needToHideIcon: true,
          ),
          const MySpaceHeight(heightSize: 1),
          MyRowSaveCloseBtn(onPressedSaveBtn: () {
            FocusScope.of(context).unfocus();
            requestData = DeliveryRescheduleRequestData(
              transactionIds: widget.transactionIds,
              remarks: remarksController.text,
              wareHouseId: widget.wareHouseId,
            );
            myShowLoadingDialog(context);
            apiPostData.patchDeliveryReschedule(requestData).then((value) {
              if (value != null) {
                Get.isDialogOpen == true ? Get.back() : null;
                myShowSuccessMSGDialog(
                    description:
                        'Your orders has been marked as delievery rescheduled',
                    customOnPressedOK: () {
                      Get.isDialogOpen == true ? tryToPop(context) : null;
                      tryToPopTrue(context);
                    });
              }
            });
          })
        ]));
  }
}

class MyMarkMisrouteDialog extends StatefulWidget {
  const MyMarkMisrouteDialog({required this.transactionIds, Key? key})
      : super(key: key);

  final List<int> transactionIds;

  @override
  _MyMarkMisrouteDialogState createState() => _MyMarkMisrouteDialogState();
}

class _MyMarkMisrouteDialogState extends State<MyMarkMisrouteDialog> {
  ApiPostData apiPostData = ApiPostData();
  TextEditingController remarksController = TextEditingController();
  MarkMisrouteRequestData requestData = MarkMisrouteRequestData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(listOfItems: [
        const MyTextWidgetHeading(text: 'Mark Misroute'),
        const MySpaceHeight(heightSize: 1),
        MyTextFieldCustom(
            controller: remarksController,
            labelText: 'Remarks',
            needToHideIcon: true,
            onChanged: (val) {
              setState(() {});
            }),
        const MySpaceHeight(heightSize: 2),
        MyRowSaveCloseBtn(onPressedSaveBtn: () {
          FocusScope.of(context).unfocus();
          requestData = MarkMisrouteRequestData(
            remarks: remarksController.text.trim(),
            transactionIds: widget.transactionIds,
          );
          myShowLoadingDialog(context);
          apiPostData.patchMarkMisroute(requestData).then((value) {
            if (value != null) {
              Get.isDialogOpen == true ? tryToPop(context) : null;
              myShowSuccessMSGDialog(
                  description: 'Order marked as misroute successfully',
                  customOnPressedOK: () {
                    Get.isDialogOpen == true ? tryToPop(context) : null;
                    tryToPopTrue(context);
                  });
            }
          });
        })
      ]),
    );
  }
}

class MyRescheduleReturnDialog extends StatefulWidget {
  const MyRescheduleReturnDialog({required this.transactionIds, Key? key})
      : super(key: key);

  final List<int> transactionIds;
  @override
  _MyRescheduleReturnDialog createState() => _MyRescheduleReturnDialog();
}

class _MyRescheduleReturnDialog extends State<MyRescheduleReturnDialog> {
  ApiPostData apiPostData = ApiPostData();
  RescheduleReturnRequestData requestData = RescheduleReturnRequestData();
  TextEditingController remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    const spaceBetweenColumnItems = MySpaceHeight(heightSize: 2);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(listOfItems: [
        const MyTextWidgetHeading(text: 'Reschedule Return'),
        const MySpaceHeight(heightSize: 1),
        MyTextFieldCustom(
          controller: remarksController,
          labelText: 'Remarks',
          needToHideIcon: true,
          onChanged: (val) {
            setState(() {});
          },
        ),
        spaceBetweenColumnItems,
        MyRowSaveCloseBtn(onPressedSaveBtn: () {
          myShowLoadingDialog(context);
          requestData = RescheduleReturnRequestData(
              remarks: remarksController.text,
              transactionIds: widget.transactionIds);

          apiPostData.patchRescheduleReturn(requestData).then(
            (value) {
              if (value != null) {
                if (mounted) {
                  Get.isDialogOpen == true ? tryToPop(context) : null;
                  myShowSuccessMSGDialog(
                      description: 'Reschedule Return Successfully',
                      customOnPressedOK: () {
                        Get.isDialogOpen == true ? tryToPop(context) : null;
                        tryToPopTrue(context);
                      });
                }
              }
            },
          );
        }),
      ]),
    );
  }
}

class MyMarkCustomerRefusedDialog extends StatefulWidget {
  const MyMarkCustomerRefusedDialog({required this.transactionIds, Key? key})
      : super(key: key);
  final List<int> transactionIds;

  @override
  _MyMarkCustomerRefusedDialogState createState() =>
      _MyMarkCustomerRefusedDialogState();
}

class _MyMarkCustomerRefusedDialogState
    extends State<MyMarkCustomerRefusedDialog> {
  ApiPostData apiPostData = ApiPostData();
  MarkCustomerRefusedRequestData requestData = MarkCustomerRefusedRequestData();
  TextEditingController remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    const spaceBetweenColumnItems = MySpaceHeight(heightSize: 2);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: MyDialogContainer(listOfItems: [
          const MyTextWidgetHeading(text: 'Mark Customer Refused'),
          const MySpaceHeight(heightSize: 1),
          MyTextFieldCustom(
            controller: remarksController,
            labelText: 'Remarks',
            needToHideIcon: true,
            onChanged: (val) {
              setState(() {});
            },
          ),
          spaceBetweenColumnItems,
          MyRowSaveCloseBtn(onPressedSaveBtn: () {
            myShowLoadingDialog(context);
            requestData = MarkCustomerRefusedRequestData(
                transactionIds: widget.transactionIds,
                remarks: remarksController.text);
            apiPostData.patchMarkCustomerRefused(requestData).then((value) {
              if (value != null) {
                Get.isDialogOpen == true ? Get.back() : null;
                myShowSuccessMSGDialog(
                    description:
                        "Your order has been marked as customer refused",
                    customOnPressedOK: () {
                      Get.isDialogOpen == true ? Get.back() : null;
                      tryToPopTrue(context);
                    });
              }
            });
          })
        ]));
  }
}

class MarkLostDialog extends StatefulWidget {
  const MarkLostDialog({required this.transactionIds, Key? key})
      : super(key: key);
  final List<int> transactionIds;

  @override
  _MarkLostDialogState createState() => _MarkLostDialogState();
}

class _MarkLostDialogState extends State<MarkLostDialog> {
  ApiPostData apiPostData = ApiPostData();
  MarkLostRequestData requestData = MarkLostRequestData();
  TextEditingController remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(listOfItems: [
        const MyTextWidgetHeading(
          text: 'Mark Lost',
        ),
        const MySpaceHeight(heightSize: 1),
        MyTextFieldCustom(
          controller: remarksController,
          needToHideIcon: true,
          labelText: 'Remarks',
          onChanged: (s) {
            setState(() {});
          },
        ),
        const MySpaceHeight(heightSize: 2),
        MyRowSaveCloseBtn(onPressedSaveBtn: () {
          myShowLoadingDialog(context);
          requestData = MarkLostRequestData(
              transactionIds: widget.transactionIds,
              remarks: remarksController.text);
          apiPostData.patchMarkLost(requestData).then(
            (value) {
              if (value != null) {
                Get.isDialogOpen == true ? Get.back() : null;
                myShowSuccessMSGDialog(
                    description:
                        'Your order has been marked as lost successfully',
                    customOnPressedOK: () {
                      Get.isDialogOpen == true ? Get.back() : null;
                      tryToPopTrue(context);
                    });
              }
            },
          );
        })
      ]),
    );
  }
}

class MyVersionCheckDialog extends StatefulWidget {
  const MyVersionCheckDialog({required this.versionCheck, Key? key})
      : super(key: key);

  final VersionCheck versionCheck;

  @override
  _MyVersionCheckDialogState createState() => _MyVersionCheckDialogState();
}

class _MyVersionCheckDialogState extends State<MyVersionCheckDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(listOfItems: [
        const MyTextWidgetHeading(text: 'New Updates Available'),
        const MySpaceHeight(heightSize: 2),
        const MyTextWidgetNormal(
            text:
                'Please update your app to continue.\n\nNote: In case you don\'t see update option at PlayStore please uninstall the app and install it again.\n\nThank you!'),
        const MySpaceHeight(heightSize: 1),
        Align(
          alignment: Alignment.centerRight,
          child: MyElevatedButton(
            btnBackgroundColor: MyColors.btnColorGreen,
            text: 'Update',
            onPressed: () async {
              await widget.versionCheck.launchStore();
              tryToPop(context);
            },
          ),
        )
      ]),
    );
  }
}

class MyMarkAttemptConfirmationDialog extends StatefulWidget {
  const MyMarkAttemptConfirmationDialog(
      {required this.transactionIds, Key? key})
      : super(key: key);

  final List<int> transactionIds;

  @override
  State<MyMarkAttemptConfirmationDialog> createState() =>
      _MyMarkAttemptConfirmationDialogState();
}

class _MyMarkAttemptConfirmationDialogState
    extends State<MyMarkAttemptConfirmationDialog> {
  ApiFetchData apiFetchData = ApiFetchData();
  ApiPostData apiPostData = ApiPostData();
  List<AttemptReasonDataDist> reasonsList = [];
  int? id;
  String? radioItem;

  RemarksAndListTransactionIdsRequestData requestData =
      RemarksAndListTransactionIdsRequestData();
  loadReasonsData() {
    apiFetchData.getAttemptReason().then((value) {
      if (value != null) {
        if (mounted) {
          if (value.dist!.isNotEmpty) {
            setState(() {
              reasonsList.addAll(value.dist!);
            });
          } else {}
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadReasonsData();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(
        listOfItems: [
          const MyTextWidgetHeading(text: 'Mark Attempt'),
          Flexible(
            child: Column(
              children: reasonsList
                  .map((e) => RadioListTile(
                      title: MyTextWidgetCustom(text: e.attemptReason ?? ''),
                      value: e.attemptReasonId!,
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          radioItem = e.attemptReason!;
                          id = e.attemptReasonId;
                        });
                      }))
                  .toList(),
            ),
          ),
          MyRowSaveCloseBtn(
            onPressedSaveBtn: () {
              if (radioItem != null) {
                myShowLoadingDialog(context);
                requestData = RemarksAndListTransactionIdsRequestData(
                    transactionIds: widget.transactionIds,
                    remarks: radioItem.toString());
                apiPostData.patchMarkAttempted(requestData).then((value) {
                  if (value != null) {
                    Get.isDialogOpen == true ? Get.back() : null;
                    myShowSuccessMSGDialog(
                        description: 'Orders marked as attempted successfully',
                        customOnPressedOK: () {
                          Get.isDialogOpen == true ? Get.back() : null;
                          tryToPopTrue(context);
                        });
                  }
                });
              } else {
                myToastError('Select attempt reason');
              }
            },
          ),
        ],
      ),
    );
  }
}

class MyHandoverTransferSheetConfirmationDialog extends StatefulWidget {
  const MyHandoverTransferSheetConfirmationDialog(
      {required this.sheetMasterIds, Key? key})
      : super(key: key);
  final List<int>? sheetMasterIds;
  @override
  _MyHandoverTransferSheetConfirmationDialogState createState() =>
      _MyHandoverTransferSheetConfirmationDialogState();
}

class _MyHandoverTransferSheetConfirmationDialogState
    extends State<MyHandoverTransferSheetConfirmationDialog> {
  ApiPostData apiPostData = ApiPostData();
  HandoverTransferSheetRequestData requestData =
      HandoverTransferSheetRequestData();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(listOfItems: [
        const MyTextWidgetHeading(text: 'Handover TS'),
        const MySpaceHeight(heightSize: 1),
        const MyTextWidgetNormal(
            text: 'Are you sure you want to handover this transfer sheets ?'),
        const MySpaceHeight(heightSize: 1),
        MyRowSaveCloseBtn(onPressedSaveBtn: () {
          myShowLoadingDialog(context);
          requestData = HandoverTransferSheetRequestData(
              sheetMasterIds: widget.sheetMasterIds);
          apiPostData.patchHandoverTransferSheet(requestData).then((value) {
            if (value != null) {
              Get.isDialogOpen == true ? Get.back() : null;
              myShowSuccessMSGDialog(
                  description:
                      'Your transfer sheet has been handed over successfully',
                  customOnPressedOK: () {
                    Get.isDialogOpen == true ? Get.back() : null;
                    tryToPopTrue(context);
                  });
            }
          });
        })
      ]),
    );
  }
}
