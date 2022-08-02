import 'package:backoffice_new/constants/size_config.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_text_and_text_fields.dart';

class MyToastDialog extends StatefulWidget {
  const MyToastDialog(
      {this.title,
      required this.description,
      this.buttonsRow,
      this.onPressedOK,
      this.isError,
      Key? key})
      : super(key: key);

  final String? title;
  final String description;
  final Widget? buttonsRow;
  final void Function()? onPressedOK;
  final bool? isError;

  @override
  State<MyToastDialog> createState() => _MyToastDialogState();
}

class _MyToastDialogState extends State<MyToastDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.elasticInOut);

    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final okButton = MyElevatedButton(
      onPressed: widget.onPressedOK ?? () {},
      text: 'OK',
      btnTextColor: Colors.white,
      btnBackgroundColor: Colors.blue,
      btnTextSizeBlock: 4,
    );

    const spaceBetweenItems = MySpaceHeight(heightSize: 1.5);

    final iconSize = SizeConfig.safeBlockSizeHorizontal * 15;

    final alertIcon = Icon(
      Icons.error_outlined,
      color: Colors.red,
      size: iconSize,
    );

    final succesIcon = Icon(
      // Icons.check_circle_outline,
      Icons.check_circle_rounded,
      color: MyColors.btnColorGreen,
      size: iconSize,
    );

    // final gifImageIcon = Image.asset(
    //   widget.isError == true
    //       ? "assets/gifs/alert-icon.png" //need to add gifs in the assets
    //       : "assets/gifs/success-tick-loop.gif",
    //   // "assets/gifs/success-tick-single.gif",
    //   // width: SizeConfig.safeBlockSizeHorizontal * 16,
    //   // height: SizeConfig.safeBlockSizeVertical * 16,
    //   scale: 1.5,
    //   gaplessPlayback: false,
    //   frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
    //     return child;
    //   },
    // );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ScaleTransition(
        scale: _animation,
        child: MyDialogContainer(
            crossAxisAlignment: CrossAxisAlignment.center,
            listOfItems: [
              // gifImageIcon,
              widget.isError == true ? alertIcon : succesIcon,
              spaceBetweenItems,
              MyTextWidgetHeading(
                text: widget.title ??
                    (widget.isError == true ? "Error" : "Success"),
                textAlign: TextAlign.center,
              ),
              spaceBetweenItems,
              MyTextWidgetCustom(
                text: widget.description,
                sizeBlockHorizontalDigit: 3,
                color: Colors.black87,
                textAlign: TextAlign.center,
              ),
              spaceBetweenItems,
              widget.buttonsRow == null ? okButton : widget.buttonsRow!,
            ]),
      ),
    );
  }
}

myShowSuccessMSGDialog({
  String? customTitle,
  required String description,
  Widget? buttonsRow,
  void Function()? customOnPressedOK,
}) {
  Get.dialog(
    MyToastDialog(
      title: customTitle,
      description: description,
      onPressedOK: buttonsRow == null
          ? customOnPressedOK ??
              () {
                // Get.isDialogOpen! ? tryToPop(context) : null;
                Get.isDialogOpen == true ? Get.back() : null;
              }
          : null,
      buttonsRow: buttonsRow,
    ),
    barrierDismissible: false,
  );
}

myShowErrorMSGDialog({
  String? customTitle,
  required String description,
  Widget? buttonsRow,
  void Function()? customOnPressedOK,
}) {
  Get.dialog(
    MyToastDialog(
      title: customTitle,
      description: description,
      onPressedOK: buttonsRow == null
          ? customOnPressedOK ??
              () {
                // Get.isDialogOpen! ? tryToPop(context) : null;
                Get.isDialogOpen == true ? Get.back() : null;
              }
          : null,
      buttonsRow: buttonsRow,
      isError: true,
    ),
    barrierDismissible: false,
  );
}
