import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:get/get.dart';

class MenuController extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();
  var isLoadingMenu = false.obs;
  var menuList = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadMenu();
  }

  loadMenu() async {
    try {
      isLoadingMenu(true);
      var data = await apiFetchData.getUserMenu();
      menuList.value = data!.dist!;
    } finally {
      isLoadingMenu(false);
    }
  }
}
