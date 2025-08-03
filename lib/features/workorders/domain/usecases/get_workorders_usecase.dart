import '../repositories/workorder_repository.dart';
import '../../data/models/workorder_response.dart';

class GetWorkOrdersUseCase {
  final WorkOrderRepository repository;

  GetWorkOrdersUseCase(this.repository);

  Future<WorkOrderResponse> execute(String sowrk) async {
    return await repository.getWorkOrders(sowrk);
  }
} 