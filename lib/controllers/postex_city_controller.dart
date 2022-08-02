import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class OperationalCityController extends GetxController {
  ApiFetchData apifetchData = ApiFetchData();
  var operationalCityLookupList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOperationalCity();
  }

  fetchOperationalCity() async {
    var operationalCity = await apifetchData.getOperationalCityLookup();
    operationalCityLookupList.value = operationalCity!.dist!;
  }
}
