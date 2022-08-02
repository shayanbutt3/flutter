import 'package:backoffice_new/constants/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:backoffice_new/constants/variables/my_colors.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';

tryToPop(BuildContext context) {
  Navigator.canPop(context)
      ? Navigator.pop(context, false)
      : debugPrint('can\'t pop');
}

tryToPopTrue(BuildContext context) {
  Navigator.canPop(context)
      ? Navigator.pop(context, true)
      : debugPrint('can\'t pop');
}

myToastError(
  String errorText, {
  ToastGravity? toastGravity,
  Toast? toastLength,
  BuildContext? context,
}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: errorText,
    textColor: Colors.white,
    gravity: toastGravity ?? ToastGravity.TOP,
    backgroundColor: Colors.red,
    toastLength: toastLength ?? Toast.LENGTH_SHORT,
  );
}

myToastSuccess(
  String msg, {
  ToastGravity? toastGravity,
  Toast? toastLength,
}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: msg,
    textColor: Colors.white,
    gravity: toastGravity ?? ToastGravity.TOP,
    backgroundColor: Colors.green,
    toastLength: toastLength ?? Toast.LENGTH_SHORT,
  );
}

myAmountFormatter(var amount) {
  return MyVariables.formatAmount.format(double.parse(amount)).toString();
}

myGetDateTime() {
  var dateTime = DateTime.now();
  return dateTime;
}

myFormatDateTime(String dateTime) {
  return DateFormat.yMMMMd('en_US')
      .add_jm()
      .format(DateTime.parse(dateTime).toLocal());
}

myFormatDateTimeNumeric(String dateTime) {
  return DateFormat("yyyy-MM-dd")
      .add_jm()
      .format(DateTime.parse(dateTime).toLocal());
}

myFormatDateOnly(String dateTime) {
  return DateFormat("yyyy-MM-dd").format(DateTime.parse(dateTime));
}

String myFormatDateTimeISOandUTC() {
  DateTime now = DateTime.now();
  return now.toUtc().toIso8601String();
}

myFormatDateTimeISOandUTCwithSubtraction(Duration duration,
    {DateTime? customCurrentDateTime}) {
  DateTime now = DateTime.now();
  return customCurrentDateTime == null
      ? now.subtract(duration).toUtc().toIso8601String()
      : customCurrentDateTime.subtract(duration).toUtc().toIso8601String();
}

myFormatDateTimeISOandUTCwithSubtractionMonth(
    {required int months, DateTime? customCurrentDateTime}) {
  DateTime now = DateTime.now();
  DateTime dateTime = customCurrentDateTime ?? now;
  return DateTime(
    dateTime.year,
    (dateTime.month - months),
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
    dateTime.second,
    dateTime.millisecond,
  ).toUtc().toIso8601String();
}

myShowBottomSheet(BuildContext context, List<Widget> listOfItems) {
  SizeConfig().init(context);
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: MyVariables.scaffoldBodyPadding,
          decoration: BoxDecoration(
            color: MyColors.bottomSheetBackgroundColor,
            borderRadius: MyColors.bottomSheetBorderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 16,
                  height: SizeConfig.safeBlockSizeVertical,
                  decoration: BoxDecoration(
                      color: MyColors.bottomSheetLineColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(SizeConfig.blockSizeHorizontal * 3),
                      )),
                ),
              ),
              Column(
                children: listOfItems,
              ),
            ],
          ),
        );
      });

////////////// Both are working fine /////////////////
  // Get.bottomSheet(
  //     Container(
  //       padding: MyVariables.scaffoldBodyPadding,
  //       decoration: BoxDecoration(
  //         color: MyColors.bottomSheetBackgroundColor,
  //         borderRadius: MyColors.bottomSheetBorderRadius,
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Center(
  //             child: Container(
  //               width: SizeConfig.blockSizeHorizontal * 16,
  //               height: SizeConfig.safeBlockSizeVertical,
  //               decoration: BoxDecoration(
  //                   color: MyColors.bottomSheetLineColor,
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(SizeConfig.blockSizeHorizontal * 3),
  //                   )),
  //             ),
  //           ),
  //           Column(
  //             children: listOfItems,
  //           ),
  //         ],
  //       ),
  //     ),
  //     backgroundColor: Colors.transparent);
}
