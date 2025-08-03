import 'package:flutter/material.dart';
import '../../data/models/plant_response.dart';
import '../../domain/usecases/get_plants_usecase.dart';

class PlantProvider with ChangeNotifier {
  final GetPlantsUseCase getPlantsUseCase;

  bool isLoading = false;
  String? error;
  List<PlantItem> plants = [];

  PlantProvider(this.getPlantsUseCase);

  Future<void> fetchPlants(String maintenanceEngineer) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await getPlantsUseCase.execute(maintenanceEngineer);
      plants = response.results;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    error = null;
    notifyListeners();
  }

  int get totalCount => plants.length;
} 