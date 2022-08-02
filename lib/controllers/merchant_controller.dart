import 'package:get/get.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';

class MerchantController extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();
  var merchantLookupList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMerchants();
  }

  fetchMerchants() async {
    var merchants = await apiFetchData.getMerchantLookup();

    merchantLookupList.value = merchants!.dist!;
  }
}
