import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:get/get.dart';

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: FittedBox(
        child: Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.blockSizeHorizontal * 2))),
          child: Row(
            children: [
              const Flexible(child: MyLoadingIndicator()),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 4,
              ),
              Flexible(
                child: AutoSizeText(
                  'Please wait...',
                  style:
                      TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

myShowLoadingDialog(BuildContext context) {
  // showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return const LoadingDialog();
  //     });
  Get.dialog(
    const LoadingDialog(),
    barrierDismissible: false,
  );
}
