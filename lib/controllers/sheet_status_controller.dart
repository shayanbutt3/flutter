import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:get/get.dart';

class SheetStatusController extends GetxController {
  final ApiFetchData _apiFetchData = ApiFetchData();

  var sheetStatusLookupList = <SheetStatusLookupDataDist>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  loadData() async {
    try {
      var resp = await _apiFetchData.getSheetStatusLookup();
      sheetStatusLookupList.value = resp!.dist!;
    } finally {}
  }
}
