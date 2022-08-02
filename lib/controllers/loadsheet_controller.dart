import 'package:backoffice_new/constants/variables/my_variables.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:get/get.dart';

class LoadSheetsController extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();

  var loadsheetsListNew = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  loadData() async {
    try {
      var data = await apiFetchData.getLoadSheets(
          MyVariables.loadSheetStatusIdNew,
          false,
          '',
          '',
          MyVariables.paginationDisable,
          0,
          MyVariables.size,
          MyVariables.sortDirection);

      loadsheetsListNew.value = data!.dist!;
    } catch (e) {
      rethrow;
    }
  }
}
