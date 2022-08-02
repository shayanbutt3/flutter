import 'dart:convert';
import 'package:backoffice_new/custom/custom_widgets/show_response_dialog.dart';
import 'package:flutter/material.dart';
import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:get/get.dart';
import 'my_methods.dart';

myPrintInterceptData(
  String url,
  var header,
  Map res, {
  String? jsonBodyString,
}) {
  debugPrint('HTTPMethod >>>>>>>>>> Request Url >>>>>>>>>>>>>');
  debugPrint(url);
  debugPrint('HTTPMethod >>>>>>>>>> Request Header >>>>>>>>>>>>>');
  debugPrint(header);
  debugPrint('HTTPMethod >>>>>>>>>> Requested Data >>>>>>>>>>>>>');
  debugPrint(jsonBodyString);
  debugPrint('HTTPMethod >>>>>>>>>> Response Data >>>>>>>>>>>>>');
  debugPrint(res.toString());
}

myTokenExpiredMSG() {
  myToastError(MyVariables.tokenExpiredMSG);
}

myElseResponseMSG(String? message) {
  Get.isDialogOpen! ? Get.back() : null;
  myShowErrorMSGDialog(
      description: (message == null || message.isEmpty)
          ? MyVariables.nullValueErrorMSG
          : message);
}

Map<String, String> myHttpHeader(String token) {
  return {
    "Content-Type": "Application/json",
    "Accept": "*/*",
    "Authorization": "Bearer $token",
  };
}

Map<String, dynamic> myReponseDecoder(var response) {
  return jsonDecode(utf8.decode(response.bodyBytes));
}
