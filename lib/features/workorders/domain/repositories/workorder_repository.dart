import '../../data/models/workorder_response.dart';

abstract class WorkOrderRepository {
  Future<WorkOrderResponse> getWorkOrders(String sowrk);
} 