import 'package:get/get.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';

class RiderController extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();
  var isLoadingRiderLookup = true.obs;

  var riderLookupList = [].obs;
  // List<RiderLookupDataDist>? riderLookupList = <RiderLookupDataDist>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRidersList();
  }

  void fetchRidersList() async {
    try {
      isLoadingRiderLookup(true);
      var tmp = await apiFetchData.getRiderLookup();

      riderLookupList.value = tmp!.dist!;
      // riderLookupList = tmp!.dist;
    } finally {
      isLoadingRiderLookup(true);
    }
  }
}
