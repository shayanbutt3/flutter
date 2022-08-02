import 'dart:convert';
import 'package:backoffice_new/constants/http_methods.dart';
import 'package:backoffice_new/constants/urls.dart';
import 'package:backoffice_new/models/response_model.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/models/stock_out_model.dart';
import 'package:backoffice_new/models/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiPostData {
  SharedPreferences? localStorage;

  Future<UserLoginResponse?> login(UserLoginRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String url = Urls.loginUrl();

    ResponseModel? model =
        await HTTPMethod.postR(url, jsonEncode(requestData.toJson()));

    if (model == null) {
      return null;
    } else {
      UserLoginResponse result = UserLoginResponse.fromJson(model.dist);
      localStorage!.setString('userId', result.userId.toString().trim());
      localStorage!.setString('email', result.email.toString().trim());
      localStorage!
          .setString('userTypeId', result.userTypeId.toString().trim());
      localStorage!
          .setString('employeeId', result.employeeId.toString().trim());
      localStorage!.setBool('isUserCityHasMultipleWarehouse',
          result.isUserCityHasMultipleWarehouse ?? false);
      localStorage!.setString(
          'lastLoginDateTime', result.lastLoginDateTime.toString().trim());
      localStorage!.setString('fullName', result.fullName.toString().trim());
      localStorage!.setString('jwtToken', result.jwtToken.toString().trim());

      return result;
    }
  }

  Future<ResponseModel?> logout() async {
    UserLogoutRequestData requestData = UserLogoutRequestData();
    localStorage = await SharedPreferences.getInstance();
    String? email = localStorage!.getString('email');
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.logoutUrl();

    requestData = UserLogoutRequestData(
      email: email,
      jwtToken: token,
    );

    ResponseModel? model = await HTTPMethod.postDataR(
        url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchMarkStockIn(
      MarkStockInRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');

    String url = Urls.getMarkStockInUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);
    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchPickUpInbound(
      PickUpInboundRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');

    String url = Urls.getPickUpInboundUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);
    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchMarkDeliveryEnRoute(
      MarkDeliveryEnRouteRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getMarkDeliveryEnRouteUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);
    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchMarkReturnInTransit(
      MarkReturnInTransitRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getMarkReturnInTransitUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);
    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> postGenerateDeliverySheet(
      GenerateDeliverySheetRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getGenerateDeliverySheetUrl();

    ResponseModel? model = await HTTPMethod.postDataR(
        url, jsonEncode(requestData.toJson()), token ?? '');
    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> postGenerateReturnSheet(
      GenerateReturnSheetRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getGenerateReturnSheetUrl();

    ResponseModel? model = await HTTPMethod.postDataR(
        url, jsonEncode(requestData.toJson()), token ?? '');
    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> postGenerateTransferSheet(
      GenerateTransferSheetRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getGenerateTransferSheetUrl();

    ResponseModel? model = await HTTPMethod.postDataR(
        url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchMarkDeliveryUnderReview(
      MarkDeliveryUnderReviewRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');

    String url = Urls.getMarkDeliveryUnderReviewUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchMarkRetry(
      MarkRetryReAttemptRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');

    String url = Urls.getMarkRetryUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchMarkReturnRequest(
      RemarksAndListTransactionIdsRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getMarkReturnRequestUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchMarkPicked(
      MarkPickedRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getMarkPickedUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchMarkAttempted(
      RemarksAndListTransactionIdsRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getMarkAttemptedUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchMarkDelivered(
      MarkDeliveredRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getMarkDeliveredUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchMarkReturned(
      RemarksAndListTransactionIdsRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getMarkReturnedUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> postGenerateLoadSheet(
      GenerateLoadSheetRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getGenerateLoadSheetUrl();

    ResponseModel? model = await HTTPMethod.postDataR(
        url, jsonEncode(requestData.toJson()), token ?? '');
    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchAssignLoadSheet(
      AssignLoadSheetRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getAssignLoadSheetUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> createOrder(CreateOrderRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getCreateOrderUrl();
    ResponseModel? model = await HTTPMethod.postDataR(
        url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchUpdateOrder(
      UpdateOrderRequestData requestData, var transactionId) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getUpdateOrderUrl(transactionId);
    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);
    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchRevertOrder(
      RevertOrderRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getRevertOrderUrl();
    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchRevertPickedOrder(
      RevertPickedOrderRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage?.getString('jwtToken');
    String url = Urls.getRevertPickedOrderUrl();
    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchRevertSheet(
      RevertSheetRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getRevertSheetUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchDeManifestMasterUnit(
      DeManifestRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getDeManifestMasterUnitUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchHandoverMasterUnit(
      HandoverMasterUnitRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getHandoverUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchDispatchTransferSheet(
      DispatchTransferSheetRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getDispatchTransferSheetUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);
    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchDeliveryReschedule(
      DeliveryRescheduleRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getDeliveryRescheduleUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> postCreateMU(CreateMURequestData muRequestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getCreateMuUrl();

    ResponseModel? model = await HTTPMethod.postDataR(
        url, jsonEncode(muRequestData.toJson()), token ?? '');

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchMarkMisroute(
      MarkMisrouteRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getMarkMisrouteUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchRescheduleReturn(
      RescheduleReturnRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getRescheduleReturnUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchMarkCustomerRefused(
      MarkCustomerRefusedRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String? url = Urls.getMarkCustomerRefusedUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchMarkLost(MarkLostRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getMarkLostUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchTransferInbound(
      TransferInboundRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getTransferInboundUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchTransitHub(
      TransitHubRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getTransitHubUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchDeManifestTransferSheet(
      DeManifestTransferSheetRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getDeManifestTransferSheetUrl();
    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchWaitingForTransferDeManifestOrder(
      WaitingForTransferDeManifestOrderRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getwaitingForTransferDeManifestOrderUrl();
    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }

  Future<ResponseModel?> patchHandoverTransferSheet(
      HandoverTransferSheetRequestData requestData) async {
    localStorage = await SharedPreferences.getInstance();
    String? token = localStorage!.getString('jwtToken');
    String url = Urls.getHandoverTransferSheetUrl();

    ResponseModel? model =
        await HTTPMethod.patchR(url, jsonEncode(requestData.toJson()), token!);

    if (model == null) {
      return null;
    } else {
      return model;
    }
  }
}
