import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/size_config.dart';
import 'custom_widgets.dart';

class MyConfirmationDialog extends StatefulWidget {
  final String title;
  final String description;
  final Function() onSavePressed;
  final Function()? onPressedCustomCloseBtn;
  const MyConfirmationDialog(
      {required this.title,
      required this.description,
      required this.onSavePressed,
      this.onPressedCustomCloseBtn,
      Key? key})
      : super(key: key);
  @override
  _MyConfirmationDialogState createState() => _MyConfirmationDialogState();
}

class _MyConfirmationDialogState extends State<MyConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    const spaceBetweenColumnItems = MySpaceHeight(heightSize: 2);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyDialogContainer(listOfItems: [
        MyTextWidgetHeading(text: widget.title),
        spaceBetweenColumnItems,
        MyTextWidgetNormal(text: widget.description),
        spaceBetweenColumnItems,
        MyRowSaveCloseBtn(
          onPressedSaveBtn: widget.onSavePressed,
          onPressedCustomCloseBtn: widget.onPressedCustomCloseBtn,
        ),
      ]),
    );
  }
}

myShowConfirmationDialog(
    {required String title,
    required String description,
    required Function() onSavePressed,
    Function()? onPressedCustomCloseBtn}) {
  Get.dialog(
    MyConfirmationDialog(
      title: title,
      description: description,
      onSavePressed: onSavePressed,
      onPressedCustomCloseBtn: onPressedCustomCloseBtn,
    ),
    barrierDismissible: false,
  );
}
