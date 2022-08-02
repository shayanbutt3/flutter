import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_text_and_text_fields.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:version_check/version_check.dart';

class MyVersionCheckDialog extends StatefulWidget {
  const MyVersionCheckDialog({required this.versionCheck, Key? key})
      : super(key: key);

  final VersionCheck versionCheck;

  @override
  State<MyVersionCheckDialog> createState() => _MyVersionCheckDialogState();
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
                'Please update your app to continue.\n\nNote: In case you don\'t see update option at PlayStore please uninstall the app and install it again from PlayStore.\n\nThank you!'),
        const MySpaceHeight(heightSize: 1),
        Align(
          alignment: Alignment.centerRight,
          child: MyElevatedButton(
            btnBackgroundColor: MyColors.btnColorGreen,
            text: 'Update',
            onPressed: () async {
              await widget.versionCheck.launchStore();
            },
          ),
        )
      ]),
    );
  }
}

void myCustomShowUpdateDialog(BuildContext context, VersionCheck versionCheck) {
  Get.dialog(
      WillPopScope(
          child: MyVersionCheckDialog(
            versionCheck: versionCheck,
          ),
          onWillPop: () async => false),
      barrierDismissible: false);
}
