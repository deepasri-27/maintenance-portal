import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maintenance_portal/core/constants/app_colors.dart';
import 'package:maintenance_portal/core/constants/app_dims.dart';
import 'providers/workorder_provider.dart';
import '../data/models/workorder_response.dart';

class WorkOrderListScreen extends StatefulWidget {
  const WorkOrderListScreen({super.key});

  @override
  State<WorkOrderListScreen> createState() => _WorkOrderListScreenState();
}

class _WorkOrderListScreenState extends State<WorkOrderListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch work orders when screen loads - using a default plant code
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkOrderProvider>().fetchWorkOrders('1009');
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
          title: const Text('Work Orders'),
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
                context.read<WorkOrderProvider>().fetchWorkOrders('1009');
              },
            ),
          ],
        ),
        body: Consumer<WorkOrderProvider>(
          builder: (context, workOrderProvider, child) {
            if (workOrderProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (workOrderProvider.error != null) {
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
                      'Error loading work orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      workOrderProvider.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        workOrderProvider.clearError();
                        workOrderProvider.fetchWorkOrders('1009');
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (workOrderProvider.workOrders.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: AppColors.textLight,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No work orders found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No work orders are assigned to this plant',
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
                await workOrderProvider.fetchWorkOrders('1009');
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: workOrderProvider.workOrders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final workOrder = workOrderProvider.workOrders[index];
                  return WorkOrderCard(workOrder: workOrder);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class WorkOrderCard extends StatelessWidget {
  final WorkOrderItem workOrder;
  
  const WorkOrderCard({super.key, required this.workOrder});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDims.radius),
      splashColor: AppColors.primary.withOpacity(.1),
      onTap: () {
        print('Navigating to work order details with: ${workOrder.aufnr}');
        Navigator.pushNamed(
          context,
          '/workorder-details',
          arguments: workOrder,
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
                  backgroundColor: workOrder.orderTypeColor.withOpacity(0.2),
                  child: Icon(
                    Icons.assignment,
                    color: workOrder.orderTypeColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workOrder.ktext,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Order: ${workOrder.aufnr}',
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
                    color: workOrder.orderTypeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    workOrder.orderTypeText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: workOrder.orderTypeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.business, size: 16, color: AppColors.textLight),
                const SizedBox(width: 4),
                Text(
                  'Plant: ${workOrder.werks}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.work, size: 16, color: AppColors.textLight),
                const SizedBox(width: 4),
                Text(
                  workOrder.workCenterText,
                  style: TextStyle(
                    fontSize: 13,
                    color: workOrder.workCenterColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: AppColors.textLight),
                const SizedBox(width: 4),
                Text(
                  'Type: ${workOrder.auart}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.account_balance, size: 16, color: AppColors.textLight),
                const SizedBox(width: 4),
                Text(
                  'Company: ${workOrder.bukrs}',
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
