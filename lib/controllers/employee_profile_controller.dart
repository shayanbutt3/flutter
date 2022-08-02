import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:get/get.dart';

class EmployeeProfileController extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();
  var isLoading = false.obs;
  var employeeProfileDataDist = EmployeeProfileDataDist().obs;

  loadProfileData() async {
    try {
      isLoading(true);
      var data = await apiFetchData.getEmployeeProfile();
      employeeProfileDataDist.value = data!.dist!;
    } finally {
      isLoading(false);
    }
  }
}
