import '../repositories/plant_repository.dart';
import '../../data/datasources/plant_remote_datasource.dart';
import '../../data/models/plant_response.dart';

class PlantRepositoryImpl implements PlantRepository {
  final PlantRemoteDataSource remoteDataSource;

  PlantRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PlantResponse> getPlants(String maintenanceEngineer) async {
    try {
      final response = await remoteDataSource.getPlants(maintenanceEngineer);
      return response;
    } catch (_) {
      // Re-throw the exception to be handled by the presentation layer
      rethrow;
    }
  }
} 