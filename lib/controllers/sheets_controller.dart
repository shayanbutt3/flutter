import 'package:backoffice_new/custom/custom_methods/my_methods.dart';
import 'package:backoffice_new/custom/custom_widgets/show_loading_dialog.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:get/get.dart';

class SheetsController extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();
  var sheetsList = [].obs;

  loadData(
    var wareHouseId,
    var sheetTypeId,
    var sheetStatusIds,
    var fromDate,
    var toDate,
    var paginationEnDis,
    var page,
    var size,
    var sortDirection,
  ) async {
    try {
      myShowLoadingDialog(Get.context!);
      var tmpData = await apiFetchData.getSheets(
          '',
          wareHouseId,
          sheetTypeId,
          sheetStatusIds,
          '',
          fromDate,
          toDate,
          paginationEnDis,
          page,
          size,
          sortDirection);
      sheetsList.value = tmpData!.dist!;
    } finally {
      Get.isDialogOpen! ? tryToPop(Get.context!) : null;
    }
  }
}
