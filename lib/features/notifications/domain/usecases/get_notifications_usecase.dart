import '../repositories/notification_repository.dart';
import '../../data/models/notification_response.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<NotificationResponse> execute() async {
    return await repository.getNotifications();
  }
} 