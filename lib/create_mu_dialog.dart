import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/custom/custom_widgets/show_response_dialog.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/services/api_post_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';

class CreateMuDialog extends StatefulWidget {
  const CreateMuDialog(
      {required this.fromTeamId,
      required this.toTeamId,
      required this.transactionIds,
      required this.wareHouseId,
      Key? key})
      : super(key: key);
  final int? fromTeamId;
  final int? toTeamId;
  final List<int> transactionIds;
  final int? wareHouseId;

  @override
  State<CreateMuDialog> createState() => _CreateMuState();
}

class _CreateMuState extends State<CreateMuDialog> {
  TextEditingController muTagController = TextEditingController();

  String orderTrackingNumber = '';
  ApiPostData apiPostData = ApiPostData();
  CreateMURequestData muRequestData = CreateMURequestData();

  Future _scanQR() async {
    try {
      await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      ).then(
        (value) {
          if (value.isNotEmpty && value != '-1') {
            if (!mounted) return;

            setState(() {
              orderTrackingNumber = value.toString().trim();
              muTagController.text = orderTrackingNumber;
              orderTrackingNumber = '';
            });

            FlutterBeep.beep(false);
          }
        },
      );
    } catch (e) {
      myToastError('exception: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: MyDialogContainer(
          crossAxisAlignment: CrossAxisAlignment.center,
          listOfItems: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                    child: MyTextWidgetHeading(
                  text: 'Create MU',
                )),
                Expanded(
                    child: IconButton(
                  alignment: Alignment.topRight,
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: _scanQR,
                )),
              ],
            ),
            const MySpaceHeight(heightSize: 2),
            MyTextFieldCustom(
              needToHideIcon: true,
              controller: muTagController,
              labelText: 'Enter MU Tag',
            ),
            const MySpaceHeight(heightSize: 2),
            MyRowSaveCloseBtn(
              onPressedSaveBtn: () {
                FocusScope.of(context).unfocus;
                setState(() {
                  if (muTagController.text.isNotEmpty) {
                    myShowLoadingDialog(context);
                    muRequestData = CreateMURequestData(
                        fromTeamId: widget.fromTeamId,
                        masterUnitTag: muTagController.text,
                        toTeamId: widget.toTeamId,
                        transactionIds: widget.transactionIds,
                        wareHouseId: widget.wareHouseId);
                    apiPostData.postCreateMU(muRequestData).then((value) {
                      if (value != null) {
                        if (mounted) {
                          Get.isDialogOpen == true ? Get.back() : null;
                          myShowSuccessMSGDialog(
                              description: 'MU has been created successfully',
                              customOnPressedOK: () {
                                Get.isDialogOpen == true ? Get.back() : null;
                                tryToPopTrue(context);
                              });
                        }
                      }
                    });
                  } else {
                    myToastError('Please Enter or Scan MU Tag');
                  }
                });
              },
            )
          ],
        ));
  }
}
