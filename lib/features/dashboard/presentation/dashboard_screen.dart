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
      backgroundColor: AppColors.background,
      drawer: const _AppDrawer(),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () => Navigator.pushNamed(context, '/notifications'),
              ),
              const SizedBox(width: 8),
            ],
          ),
          
          // Dashboard Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.secondary.withOpacity(0.1),
                          AppColors.accent.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.waving_hand_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Good ${_getGreeting()}!",
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Ready to manage your maintenance tasks?",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Quick Stats Section
                  Text(
                    "Quick Overview",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Stats Grid
                  Consumer3<NotificationProvider, PlantProvider, WorkOrderProvider>(
                    builder: (context, notificationProvider, plantProvider, workOrderProvider, child) {
                      return Column(
                        children: [
                          // First Row
                          Row(
                            children: [
                              Expanded(
                                child: _ModernDashboardCard(
                                  title: "Notifications",
                                  count: notificationProvider.totalCount,
                                  icon: Icons.notifications_active_rounded,
                                  color: AppColors.secondary,
                                  onTap: () => Navigator.pushNamed(context, '/notifications'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ModernDashboardCard(
                                  title: "High Priority",
                                  count: notificationProvider.highPriorityCount,
                                  icon: Icons.priority_high_rounded,
                                  color: AppColors.error,
                                  onTap: () => Navigator.pushNamed(context, '/notifications'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Second Row
                          Row(
                            children: [
                              Expanded(
                                child: _ModernDashboardCard(
                                  title: "Plants",
                                  count: plantProvider.totalCount,
                                  icon: Icons.factory_rounded,
                                  color: AppColors.success,
                                  onTap: () => Navigator.pushNamed(context, '/plants'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ModernDashboardCard(
                                  title: "Work Orders",
                                  count: workOrderProvider.totalCount,
                                  icon: Icons.assignment_rounded,
                                  color: AppColors.warning,
                                  onTap: () => Navigator.pushNamed(context, '/workorders'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Quick Actions Section
                  Text(
                    "Quick Actions",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionButton(
                          title: "View Profile",
                          icon: Icons.person_rounded,
                          color: AppColors.accent,
                          onTap: () => Navigator.pushNamed(context, '/profile'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionButton(
                          title: "Refresh Data",
                          icon: Icons.refresh_rounded,
                          color: AppColors.secondary,
                          onTap: () {
                            context.read<NotificationProvider>().fetchNotifications();
                            final loginProvider = context.read<LoginProvider>();
                            final engineerId = loginProvider.user?.maintenanceEngineer ?? '00000001';
                            context.read<PlantProvider>().fetchPlants(engineerId);
                            context.read<WorkOrderProvider>().fetchWorkOrders('1009');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}


class _ModernDashboardCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ModernDashboardCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "$count",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
                      child: Icon(Icons.build_circle, color: AppColors.accent),
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
