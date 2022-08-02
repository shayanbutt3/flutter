import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:backoffice_new/custom/custom_methods/my_custom_http_method.dart';
import 'package:backoffice_new/custom/custom_widgets/custom_dialogs.dart';
import 'package:backoffice_new/models/response_model.dart';
import 'package:backoffice_new/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HTTPMethod {
  static Future<ResponseModel?> postR(String url, String jsonBodyString) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "Application/json", "Accept": "*/*"},
        body: jsonBodyString,
      );
      Map<String, dynamic> res = jsonDecode(response.body);

      myPrintInterceptData(url, '', res, jsonBodyString: jsonBodyString);

      if (res['statusCode'] == '200' || res['statusCode'] == '201') {
        ResponseModel result = ResponseModel.fromJson(res);
        return result;
      } else {
        myElseResponseMSG(res['statusMessage']);
        // tryToPop(Get.context!);
        return null;
      }
    } on SocketException catch (exc) {
      Get.dialog(const MyInternetErrorDialog(), barrierDismissible: false);
      throw exc.message;
      // return null; //by returning null its not showing dialog properly, open dialog and closed automatically.
    } on TimeoutException catch (t) {
      myToastError(t.toString());
      rethrow;
      // return null;
    } catch (e) {
      myToastError(e.toString());
      rethrow;
      // return null;
    }
  }

  static Future<ResponseModel?> postDataR(
      String url, String jsonBodyString, String token) async {
    SharedPreferences? localStorage = await SharedPreferences.getInstance();
    try {
      var response = await http.post(Uri.parse(url),
          // headers: {"Content-Type": "Application/json", "Accept": "*/*", "Authorization": "Bearer $token",},
          headers: myHttpHeader(token),
          body: jsonBodyString);

      // Map<String, dynamic> res = jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> res = myReponseDecoder(response);

      myPrintInterceptData(url, myHttpHeader(token).toString(), res,
          jsonBodyString: jsonBodyString);

      if (res['statusCode'] == '200' || res['statusCode'] == '201') {
        return ResponseModel.fromJson(res);
      } else if (response.statusCode == 401) {
        localStorage.remove('jwtToken');
        localStorage.clear();

        // if (Get.key.currentWidget == Login()) {
        //   debugPrint('if block is called from postDataR>>>>>>>>>');
        // } else {
        //   Get.offAll(() => Login());
        // }
        Get.offAll(() => const Login());
        myTokenExpiredMSG();

        return null;
      } else {
        myElseResponseMSG(res['statusMessage']);
        // tryToPop(Get.context!);
        return null;
      }
    } on SocketException catch (exc) {
      Get.dialog(const MyInternetErrorDialog(), barrierDismissible: false);

      throw exc.message;
    } on TimeoutException catch (t) {
      myToastError(t.toString());
      rethrow;
    } catch (e) {
      myToastError(e.toString());
      rethrow;
    }
  }

  static Future<ResponseModel?> getR(String url, String token) async {
    SharedPreferences? localStorage = await SharedPreferences.getInstance();
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: myHttpHeader(token),
      );

      Map<String, dynamic> res = myReponseDecoder(response);

      myPrintInterceptData(url, myHttpHeader(token).toString(), res);

      if (res['statusCode'] == '200' || res['statusCode'] == '201') {
        return ResponseModel.fromJson(res);
      } else if (response.statusCode == 401) {
        localStorage.remove('jwtToken');
        localStorage.clear();

        // if (Get.key.currentWidget == Login()) {
        //   debugPrint('if block is called from getR>>>>>>>>>');
        // } else {
        //   Get.offAll(() => Login());
        // }
        Get.offAll(() => const Login());
        myTokenExpiredMSG();

        return null;
      } else {
        myElseResponseMSG(res['statusMessage']);
        // tryToPop(Get.context!);
        return null;
      }
    } on SocketException catch (exc) {
      Get.dialog(const MyInternetErrorDialog(), barrierDismissible: false);

      throw exc.message;
    } on TimeoutException catch (t) {
      myToastError(t.toString());
      rethrow;
    } catch (e) {
      myToastError(e.toString());
      rethrow;
    }
  }

  static Future<ResponseModel?> patchR(
      String url, String jsonBodyString, String token) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    try {
      var response = await http.patch(
        Uri.parse(url),
        headers: myHttpHeader(token),
        body: jsonBodyString,
      );

      Map<String, dynamic> map = myReponseDecoder(response);

      myPrintInterceptData(
        url,
        myHttpHeader(token).toString(),
        map,
        jsonBodyString: jsonBodyString,
      );

      if (map['statusCode'] == '200' || map['statusCode'] == '201') {
        return ResponseModel.fromJson(map);
      } else if (response.statusCode == 401) {
        localStorage.remove('jwtToken');
        localStorage.clear();

        // if (Get.key.currentWidget == Login()) {
        //   debugPrint('if block is called from patchR>>>>>>>>>');
        // } else {
        //   Get.offAll(() => Login());
        // }
        Get.offAll(() => const Login());

        myTokenExpiredMSG();

        return null;
      } else {
        myElseResponseMSG(map['statusMessage']);
        // tryToPop(Get.context!);
        return null;
      }
    } on SocketException catch (exc) {
      Get.dialog(const MyInternetErrorDialog(), barrierDismissible: false);

      throw exc.message;
    } on TimeoutException catch (t) {
      myToastError(t.toString());
      rethrow;
    } catch (e) {
      myToastError(e.toString());
      rethrow;
    }
  }

  static Future<ResponseModel?> putR(
      String url, String jsonBodyString, String token) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    try {
      var response = await http.put(
        Uri.parse(url),
        headers: myHttpHeader(token),
        body: jsonBodyString,
      );

      Map<String, dynamic> map = myReponseDecoder(response);

      myPrintInterceptData(url, myHttpHeader(token).toString(), map,
          jsonBodyString: jsonBodyString);

      if (map['statusCode'] == '200' || map['statusCode'] == '201') {
        return ResponseModel.fromJson(map);
      } else if (response.statusCode == 401) {
        localStorage.remove('jwtToken');
        localStorage.clear();

        // if (Get.key.currentWidget == Login()) {
        //   debugPrint('if block is called from putR>>>>>>>>>');
        // } else {
        //   Get.offAll(() => Login());
        // }

        Get.offAll(() => const Login());

        myTokenExpiredMSG();

        return null;
      } else {
        myElseResponseMSG(map['statusMessage']);
        // tryToPop(Get.context!);
        return null;
      }
    } on SocketException catch (exc) {
      Get.dialog(const MyInternetErrorDialog(), barrierDismissible: false);

      throw exc.message;
    } on TimeoutException catch (t) {
      myToastError(t.toString());
      rethrow;
    } catch (e) {
      myToastError(e.toString());
      rethrow;
    }
  }

  static Future<ResponseModel?> deleteR(
      String url, String jsonBodyString, String token) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: myHttpHeader(token),
        body: jsonBodyString,
      );

      Map<String, dynamic> map = myReponseDecoder(response);

      myPrintInterceptData(url, myHttpHeader(token).toString(), map,
          jsonBodyString: jsonBodyString);

      if (map['statusCode'] == '200' || map['statusCode'] == '201') {
        return ResponseModel.fromJson(map);
      } else if (response.statusCode == 401) {
        localStorage.remove('jwtToken');
        localStorage.clear();

        // if (Get.key.currentWidget == Login()) {
        //   debugPrint('if block is called from deleteR>>>>>>>>>');
        // } else {
        //   Get.offAll(() => Login());
        // }
        Get.offAll(() => const Login());

        myTokenExpiredMSG();

        return null;
      } else {
        myElseResponseMSG(map['statusMessage']);
        // tryToPop(Get.context!);
        return null;
      }
    } on SocketException catch (exc) {
      Get.dialog(const MyInternetErrorDialog(), barrierDismissible: false);

      throw exc.message;
    } on TimeoutException catch (t) {
      myToastError(t.toString());
      rethrow;
    } catch (e) {
      myToastError(e.toString());
      rethrow;
    }
  }
}
