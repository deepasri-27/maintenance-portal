import '../repositories/notification_repository.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/models/notification_response.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<NotificationResponse> getNotifications() async {
    try {
      final response = await remoteDataSource.getNotifications();
      return response;
    } catch (_) {
      // Re-throw the exception to be handled by the presentation layer
      rethrow;
    }
  }
} 