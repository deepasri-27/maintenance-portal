import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maintenance_portal/core/constants/app_colors.dart';
import 'package:maintenance_portal/core/constants/app_dims.dart';
import 'providers/plant_provider.dart';
import '../data/models/plant_response.dart';
import '../../auth/presentation/providers/login_provider.dart';

class PlantListScreen extends StatefulWidget {
  const PlantListScreen({super.key});

  @override
  State<PlantListScreen> createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch plants when screen loads - using logged-in user's engineer ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginProvider = context.read<LoginProvider>();
      final engineerId = loginProvider.user?.maintenanceEngineer ?? '00000001';
      context.read<PlantProvider>().fetchPlants(engineerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/dashboard');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plants'),
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                final loginProvider = context.read<LoginProvider>();
                final engineerId = loginProvider.user?.maintenanceEngineer ?? '00000001';
                context.read<PlantProvider>().fetchPlants(engineerId);
              },
            ),
          ],
        ),
        body: Consumer<PlantProvider>(
          builder: (context, plantProvider, child) {
            if (plantProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (plantProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading plants',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      plantProvider.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        plantProvider.clearError();
                        final loginProvider = context.read<LoginProvider>();
                        final engineerId = loginProvider.user?.maintenanceEngineer ?? '00000001';
                        plantProvider.fetchPlants(engineerId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (plantProvider.plants.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.factory_outlined,
                      size: 64,
                      color: AppColors.textLight,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No plants found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No plants are assigned to this engineer',
                      style: TextStyle(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                final loginProvider = context.read<LoginProvider>();
                final engineerId = loginProvider.user?.maintenanceEngineer ?? '00000001';
                await plantProvider.fetchPlants(engineerId);
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: plantProvider.plants.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final plant = plantProvider.plants[index];
                  return PlantCard(plant: plant);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final PlantItem plant;
  
  const PlantCard({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDims.radius),
      splashColor: AppColors.primary.withOpacity(.1),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/plant-details',
          arguments: plant,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: plant.plantColor.withOpacity(0.2),
                  child: Icon(
                    Icons.factory,
                    color: plant.plantColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.name1,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Plant Code: ${plant.werks}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    plant.werks,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.textLight),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    plant.fullAddress,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppColors.textLight),
                const SizedBox(width: 4),
                Text(
                  'Engineer: ${plant.maintenanceEngineer}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
