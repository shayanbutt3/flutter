import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:get/get.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';

class WareHouseController extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();
  var wareHouseLookupList = <WareHouseDataDist>[].obs;

  @override
  onInit() {
    super.onInit();
    fetchWareHouses();
  }

  fetchWareHouses() async {
    var data = await apiFetchData.getWareHouseLookup();

    // wareHouseLookupList.value = data!.dist!;
    wareHouseLookupList.addAll(data!.dist!);
  }
}

class WareHouseAllController extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();
  var wareHouseLookupAllList = <WareHouseDataDist>[].obs;

  @override
  onInit() {
    super.onInit();
    fetchWareHousesAll();
  }

  fetchWareHousesAll() async {
    var data = await apiFetchData.getWareHouseLookup(
        lookupOption: MyVariables.warehouseLookupOptionAll);

    wareHouseLookupAllList.addAll(data!.dist!);
  }
}

class WareHouseControllerHintText extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();

  var wareHouseLookupListHintText = <WareHouseDataDist>[
    WareHouseDataDist(
        wareHouseName: MyVariables.wareHouseDropdownSelectAllText),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWareHouseHintText();
  }

  fetchWareHouseHintText() async {
    var data = await apiFetchData.getWareHouseLookup();

    wareHouseLookupListHintText.addAll(data!.dist!);
  }
}
