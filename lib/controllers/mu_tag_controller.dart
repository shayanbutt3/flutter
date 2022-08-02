import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:get/get.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';

class MuTagController extends GetxController {
  MasterUnitDataDist? tmpMu;

  ApiFetchData apiFetchData = ApiFetchData();
  var muTagLookupList = <MasterUnitDataDist>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMuTag();
  }

  fetchMuTag() async {
    var data = await apiFetchData.getMasterUnits(
      masterUnitStatusIds: MyVariables.masterUnitStatusIdReceived,
    );
    muTagLookupList.addAll(data!.dist!);
  }
}
