import '../repositories/plant_repository.dart';
import '../../data/models/plant_response.dart';

class GetPlantsUseCase {
  final PlantRepository repository;

  GetPlantsUseCase(this.repository);

  Future<PlantResponse> execute(String maintenanceEngineer) async {
    return await repository.getPlants(maintenanceEngineer);
  }
} 