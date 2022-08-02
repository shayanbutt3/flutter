import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MerchantPickupAddressController extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();

  var pickupAddressLookupList = [].obs;

  fetchPickupAddressList(
    var merchantId,
    var cityId,
    BuildContext context,
  ) async {
    try {
      myShowLoadingDialog(context);
      var tmp =
          await apiFetchData.getMerchantPickupAddressLookup(merchantId, cityId);

      pickupAddressLookupList.value = tmp!.dist!;
    } finally {
      Get.isDialogOpen! ? tryToPop(context) : null;
    }
  }
}
