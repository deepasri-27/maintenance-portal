import 'package:flutter/material.dart';
import 'package:maintenance_portal/core/constants/app_colors.dart';
import '../data/models/notification_response.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationItem notification =
        ModalRoute.of(context)!.settings.arguments as NotificationItem;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Details"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  notification.qmtxt,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                // Notification ID & Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Notification ID: ${notification.qmnum}",
                      style: const TextStyle(color: AppColors.textLight),
                    ),
                    Text(
                      notification.formattedDate,
                      style: const TextStyle(color: AppColors.textLight),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Priority
                Row(
                  children: [
                    const Icon(Icons.priority_high, size: 20, color: AppColors.textLight),
                    const SizedBox(width: 6),
                    const Text(
                      "Priority: ",
                      style: TextStyle(color: AppColors.textLight),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: notification.priorityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        notification.priorityText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: notification.priorityColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Equipment Information
                if (notification.equnr.isNotEmpty) ...[
                  const Text(
                    "Equipment Information",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(label: "Equipment Number", value: notification.equnr),
                  _InfoRow(label: "Plant", value: notification.iwerk),
                  _InfoRow(label: "Functional Location", value: notification.iloan),
                  const SizedBox(height: 20),
                ],

                // Technical Details
                const Text(
                  "Technical Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                _InfoRow(label: "Notification Type", value: notification.qmart),
                _InfoRow(label: "Artpr", value: notification.artpr),
                _InfoRow(label: "Ingrp", value: notification.ingrp),
                _InfoRow(label: "Arbplwerk", value: notification.arbplwerk),
                _InfoRow(label: "Swerk", value: notification.swerk),
                const SizedBox(height: 20),

                // Duration
                if (notification.auztv.isNotEmpty && notification.auztv != 'PT00H00M00S') ...[
                  const Text(
                    "Duration",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(label: "Processing Time", value: notification.auztv),
                  const SizedBox(height: 20),
                ],

                // Actions
                const Text(
                  "Actions",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
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
                          _showStatusUpdateDialog(context, notification);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.assignment),
                        label: const Text("Create Order"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Create order functionality coming soon"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context, NotificationItem notification) {
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
              value.isEmpty ? "N/A" : value,
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