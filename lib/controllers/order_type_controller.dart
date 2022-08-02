import 'package:get/get.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';

class OrderTypeController extends GetxController {
  ApiFetchData apifetchData = ApiFetchData();
  var orderTypeLookupList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderTypeData();
  }

  fetchOrderTypeData() async {
    var orders = await apifetchData.getOrderType();
    orderTypeLookupList.addAll(orders!.dist!);
  }
}
