import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:get/get.dart';

class RolesLookupController extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();

  var rolesLookupList = <RolesLookupDataDist>[].obs;

  fetchRoles() async {
    try {
      var tmp = await apiFetchData.getRolesLookup(
          MyVariables.receivingTeamAccessLevel,
          MyVariables.receivingTeamActive);
      if (tmp != null) {
        rolesLookupList.value = tmp.dist!;
      }
    } finally {}
  }
}
