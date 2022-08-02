import 'package:get/get.dart';
import 'package:backoffice_new/models/stock_in_model.dart';
import 'package:backoffice_new/services/api_fetch_data.dart';

class OrdersController extends GetxController {
  ApiFetchData apiFetchData = ApiFetchData();
  var isLoading = false.obs;

  // List<OrdersDataDist>? ordersList = <OrdersDataDist>[].obs;
  var ordersList = [].obs;
  Pagination? ordersPagination;

  fetchOrders(
      var merchantId,
      var riderId,
      var riderAssigned,
      var orderStatusIds,
      var wareHouseIds,
      var trackingNumber,
      var inStock,
      var paginationEnDis,
      int page,
      int size,
      var sortDirection) async {
    try {
      isLoading(true);
      var tmp = await apiFetchData.getOrders(
          merchantId,
          riderId,
          riderAssigned,
          orderStatusIds,
          wareHouseIds,
          trackingNumber,
          '',
          '',
          inStock,
          paginationEnDis,
          page,
          size,
          sortDirection);

      ordersList.value = tmp!.dist!;
      // ordersList.addAll(tmp!.dist!.toList());

      ordersPagination = tmp.pagination;
    } finally {
      isLoading(false);
    }
  }
}
