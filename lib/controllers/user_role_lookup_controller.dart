import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:get/get.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';

class UserRolesLookupController extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();
  var userRolesLookupList = <UserRolesLookupDataDist>[].obs;

  fetchUserRoles() async {
    var data = await apiFetchData.getUserRolesLookup(
      MyVariables.receivingTeamAccessLevel,
      MyVariables.receivingTeamActive,
    );
    if (data != null) {
      userRolesLookupList.value = data.dist!;
    }
  }
}
