import '../../data/models/notification_response.dart';

abstract class NotificationRepository {
  Future<NotificationResponse> getNotifications();
} 