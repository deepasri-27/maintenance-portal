import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maintenance_portal/features/auth/data/datasources/login_remote_datasource.dart';
import 'package:maintenance_portal/features/auth/domain/repositories/login_repository_impl.dart';
import 'package:maintenance_portal/features/auth/domain/usecases/login_usecase.dart';
import 'package:maintenance_portal/features/auth/presentation/providers/login_provider.dart';
import 'package:maintenance_portal/features/auth/presentation/login_screen.dart';
import 'package:maintenance_portal/features/dashboard/presentation/dashboard_screen.dart';
import 'package:maintenance_portal/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:maintenance_portal/features/notifications/domain/repositories/notification_repository_impl.dart';
import 'package:maintenance_portal/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:maintenance_portal/features/notifications/presentation/providers/notification_provider.dart';
import 'package:maintenance_portal/features/notifications/presentation/notification_list_screen.dart';
import 'package:maintenance_portal/features/notifications/presentation/notification_detail_screen.dart';
import 'package:maintenance_portal/features/plants/data/datasources/plant_remote_datasource.dart';
import 'package:maintenance_portal/features/plants/domain/repositories/plant_repository_impl.dart';
import 'package:maintenance_portal/features/plants/domain/usecases/get_plants_usecase.dart';
import 'package:maintenance_portal/features/plants/presentation/providers/plant_provider.dart';
import 'package:maintenance_portal/features/plants/presentation/plant_list_screen.dart';
import 'package:maintenance_portal/features/plants/presentation/plant_detail_screen.dart';
import 'package:maintenance_portal/features/workorders/data/datasources/workorder_remote_datasource.dart';
import 'package:maintenance_portal/features/workorders/domain/repositories/workorder_repository_impl.dart';
import 'package:maintenance_portal/features/workorders/domain/usecases/get_workorders_usecase.dart';
import 'package:maintenance_portal/features/workorders/presentation/providers/workorder_provider.dart';
import 'package:maintenance_portal/features/workorders/presentation/workorder_list_screen.dart';
import 'package:maintenance_portal/features/workorders/presentation/workorder_detail_screen.dart';
import 'core/constants/app_theme.dart';
import 'features/profile/presentation/profile_screen.dart';

void main() {
  runApp(const MaintenancePortal());
}

class MaintenancePortal extends StatelessWidget {
  const MaintenancePortal({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final remoteDataSource = LoginRemoteDataSource();
            final repository = LoginRepositoryImpl(remoteDataSource: remoteDataSource);
            final useCase = LoginUseCase(repository);
            return LoginProvider(useCase);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final remoteDataSource = NotificationRemoteDataSource();
            final repository = NotificationRepositoryImpl(remoteDataSource: remoteDataSource);
            final useCase = GetNotificationsUseCase(repository);
            return NotificationProvider(useCase);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final remoteDataSource = PlantRemoteDataSource();
            final repository = PlantRepositoryImpl(remoteDataSource: remoteDataSource);
            final useCase = GetPlantsUseCase(repository);
            return PlantProvider(useCase);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final remoteDataSource = WorkOrderRemoteDataSource();
            final repository = WorkOrderRepositoryImpl(remoteDataSource: remoteDataSource);
            final useCase = GetWorkOrdersUseCase(repository);
            return WorkOrderProvider(useCase);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Maintenance Portal',
        theme: buildAppTheme(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
                  routes: {
            '/login': (context) => const LoginScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/notifications': (context) => const NotificationListScreen(),
            '/notification-details': (context) => const NotificationDetailScreen(),
            '/plants': (context) => const PlantListScreen(),
            '/plant-details': (context) => const PlantDetailScreen(),
            '/workorders': (context) => const WorkOrderListScreen(),
            '/workorder-details': (context) => const WorkOrderDetailScreen(),
            '/profile': (context) => const ProfileScreen(),
          },
      ),
    );
  }
}
