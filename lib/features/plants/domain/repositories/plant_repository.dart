import '../../data/models/plant_response.dart';

abstract class PlantRepository {
  Future<PlantResponse> getPlants(String maintenanceEngineer);
} 