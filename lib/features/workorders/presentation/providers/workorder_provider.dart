import 'package:flutter/material.dart';
import '../../data/models/workorder_response.dart';
import '../../domain/usecases/get_workorders_usecase.dart';

class WorkOrderProvider with ChangeNotifier {
  final GetWorkOrdersUseCase getWorkOrdersUseCase;

  bool isLoading = false;
  String? error;
  List<WorkOrderItem> workOrders = [];

  WorkOrderProvider(this.getWorkOrdersUseCase);

  Future<void> fetchWorkOrders(String sowrk) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await getWorkOrdersUseCase.execute(sowrk);
      workOrders = response.results;
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

  int get totalCount => workOrders.length;
  
  int get preventiveMaintenanceCount => workOrders.where((w) => w.auart == 'PM01').length;
  
  int get correctiveMaintenanceCount => workOrders.where((w) => w.auart == 'PM02').length;
} 