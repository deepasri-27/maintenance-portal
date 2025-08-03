import 'package:flutter/material.dart';
import '../../data/models/notification_response.dart';
import '../../domain/usecases/get_notifications_usecase.dart';

class NotificationProvider with ChangeNotifier {
  final GetNotificationsUseCase getNotificationsUseCase;

  bool isLoading = false;
  String? error;
  List<NotificationItem> notifications = [];

  NotificationProvider(this.getNotificationsUseCase);

  Future<void> fetchNotifications() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await getNotificationsUseCase.execute();
      notifications = response.results;
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

  int get totalCount => notifications.length;
  
  int get highPriorityCount => notifications.where((n) => n.priok == '1').length;
  
  int get mediumPriorityCount => notifications.where((n) => n.priok == '2').length;
  
  int get lowPriorityCount => notifications.where((n) => n.priok == '3').length;
} 