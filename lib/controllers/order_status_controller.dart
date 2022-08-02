import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';
import 'package:get/get.dart';

class OrderStatusController extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();
  var orderStatusLookupList = <OrderStatusLookupDataDist>[].obs;

  @override
  onInit() {
    super.onInit();
    fetchOrderStatus();
  }

  fetchOrderStatus() async {
    var data = await apiFetchData.getOrderStatusCOD();
    orderStatusLookupList.addAll(data!.dist!);
  }
}
