import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maintenance_portal/core/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../auth/presentation/providers/login_provider.dart';
import '../../notifications/presentation/providers/notification_provider.dart';
import '../../plants/presentation/providers/plant_provider.dart';
import '../../workorders/presentation/providers/workorder_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications, plants, and work orders when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
      final loginProvider = context.read<LoginProvider>();
      final engineerId = loginProvider.user?.maintenanceEngineer ?? '00000001';
      context.read<PlantProvider>().fetchPlants(engineerId);
      context.read<WorkOrderProvider>().fetchWorkOrders('1009');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      drawer: const _AppDrawer(),
      appBar: AppBar(
        title: const Text('Maintenance Dashboard'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 24),

            // Grid of Dashboard Cards
                    Consumer3<NotificationProvider, PlantProvider, WorkOrderProvider>(
          builder: (context, notificationProvider, plantProvider, workOrderProvider, child) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
                    return GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _DashboardCard(
                          label: "Total Notifications",
                          count: notificationProvider.totalCount,
                          icon: Icons.notifications,
                          color: Colors.black87,
                        ),
                        _DashboardCard(
                          label: "High Priority",
                          count: notificationProvider.highPriorityCount,
                          icon: Icons.priority_high,
                          color: Colors.red,
                        ),
                        _DashboardCard(
                          label: "Medium Priority",
                          count: notificationProvider.mediumPriorityCount,
                          icon: Icons.priority_high,
                          color: Colors.orange,
                        ),
                                      _DashboardCard(
                label: "Plants",
                count: plantProvider.totalCount,
                icon: Icons.factory,
                color: Colors.green,
              ),
              _DashboardCard(
                label: "Work Orders",
                count: workOrderProvider.totalCount,
                icon: Icons.assignment,
                color: Colors.orange,
              ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class _DashboardCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const _DashboardCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color),
          ),
          const Spacer(),
          Text(
            "$count",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}


class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
        ),
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                ),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.build_circle, color: Colors.orange),
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Maintenance Portal",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _DrawerItem(
                icon: Icons.dashboard_outlined,
                label: "Dashboard",
                onTap: () => Navigator.pop(context),
              ),
              _DrawerItem(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                onTap: () {
                  Navigator.pop(context);                 // close drawer first
                  Navigator.pushReplacementNamed(context, '/notifications');
                  // Navigator.pushReplacementNamed(context, '/dashboard');
                },
              ),
              _DrawerItem(
                icon: Icons.factory_outlined,
                label: 'Plants',
                onTap: () {
                  Navigator.pop(context);                 // close drawer first
                  Navigator.pushReplacementNamed(context, '/plants');
                  // Navigator.pushReplacementNamed(context, '/dashboard');
                },
              ),
              _DrawerItem(
                icon: Icons.assignment_outlined,
                label: 'Work Orders',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/workorders');
                },
              ),
              _DrawerItem(
                icon: Icons.add_circle_outline,
                label: "Create Notification",
                onTap: () => Navigator.pushNamed(context, '/create-notification'), // if implemented
              ),
              _DrawerItem(
                icon: Icons.settings_outlined,
                label: "Settings",
                onTap: () => Navigator.pushNamed(context, '/settings'), // if implemented
              ),
              _DrawerItem(
                icon: Icons.person_outline,
                label: "Profile",
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
              const Spacer(),
              const Divider(color: Colors.white30),
              _DrawerItem(
                icon: Icons.logout,
                label: "Logout",
                onTap: () {
                  // Use the login provider to logout
                  context.read<LoginProvider>().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}

