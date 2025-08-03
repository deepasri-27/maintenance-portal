import '../repositories/workorder_repository.dart';
import '../../data/datasources/workorder_remote_datasource.dart';
import '../../data/models/workorder_response.dart';

class WorkOrderRepositoryImpl implements WorkOrderRepository {
  final WorkOrderRemoteDataSource remoteDataSource;

  WorkOrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<WorkOrderResponse> getWorkOrders(String sowrk) async {
    try {
      final response = await remoteDataSource.getWorkOrders(sowrk);
      return response;
    } catch (_) {
      // Re-throw the exception to be handled by the presentation layer
      rethrow;
    }
  }
} 