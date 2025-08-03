import 'package:flutter/material.dart';
import 'package:maintenance_portal/core/constants/app_colors.dart';
import '../data/models/workorder_response.dart';

class WorkOrderDetailScreen extends StatelessWidget {
  const WorkOrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('WorkOrderDetailScreen: Building with arguments: ${ModalRoute.of(context)?.settings.arguments}');
    final WorkOrderItem? workOrder =
        ModalRoute.of(context)?.settings.arguments as WorkOrderItem?;
    
    print('WorkOrderDetailScreen: Parsed workOrder: ${workOrder?.aufnr}');
    
    if (workOrder == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Work Order Details"),
          backgroundColor: AppColors.primary,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              SizedBox(height: 16),
              Text(
                'Work Order Not Found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'The work order details could not be loaded.',
                style: TextStyle(
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Order Details"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with work order icon and title
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: workOrder.orderTypeColor.withOpacity(0.2),
                      child: Icon(
                        Icons.assignment,
                        color: workOrder.orderTypeColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workOrder.ktext,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: workOrder.orderTypeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              workOrder.orderTypeText,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: workOrder.orderTypeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Work Order Information
                const Text(
                  "Work Order Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _InfoRow(label: "Order Number", value: workOrder.aufnr),
                _InfoRow(label: "Order Type", value: workOrder.auart),
                _InfoRow(label: "Order Category", value: workOrder.autyp),
                _InfoRow(label: "Plant", value: workOrder.werks),
                _InfoRow(label: "Company Code", value: workOrder.bukrs),
                const SizedBox(height: 20),

                // Work Center Information
                const Text(
                  "Work Center Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _InfoRow(label: "Work Center", value: workOrder.vaplz),
                _InfoRow(label: "Work Center Name", value: workOrder.workCenterText),
                _InfoRow(label: "Application", value: workOrder.kappl),
                _InfoRow(label: "Calculation Schema", value: workOrder.kalsm),
                const SizedBox(height: 20),

                // Cost Center Information
                const Text(
                  "Cost Center Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _InfoRow(label: "Cost Center", value: workOrder.kostl.isEmpty ? 'Not specified' : workOrder.kostl),
                const SizedBox(height: 20),

                // Work Center Display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: workOrder.workCenterColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: workOrder.workCenterColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.work, color: workOrder.workCenterColor),
                          const SizedBox(width: 8),
                          Text(
                            "Assigned Work Center",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: workOrder.workCenterColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        workOrder.workCenterText,
                        style: TextStyle(
                          fontSize: 14,
                          color: workOrder.workCenterColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Actions
                const Text(
                  "Actions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text("Update Status"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _showStatusUpdateDialog(context, workOrder);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.assignment_turned_in),
                        label: const Text("Complete Order"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Complete order functionality coming soon"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.print),
                    label: const Text("Print Work Order"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Print functionality coming soon"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context, WorkOrderItem workOrder) {
    String selectedStatus = "Open";
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Status"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Select new status:"),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: ["Open", "In Progress", "Completed", "Cancelled"].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Status updated to '$selectedStatus'"),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textLight,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 