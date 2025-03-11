import 'package:animated_sidebar/animated_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serv_sync/ui/shared/widgets/side_bar/models/side_bar_item_model.dart';
import 'package:serv_sync/ui/state_management/cubits/side_bar/sidebar_cubit.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    var selectedIndex = context.select<SidebarCubit, int>(
          (SidebarCubit cubit) => cubit.state.selectedIndex,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // ✅ Desktop: Show Sidebar
          return _buildSidebar(context, selectedIndex);
        } else {
          // ✅ Mobile: Show Drawer
          return _buildDrawer(context, selectedIndex);
        }
      },
    );
  }

  /// 📌 Desktop Sidebar
  Widget _buildSidebar(BuildContext context, int selectedIndex) {
    return AnimatedSidebar(
      expanded: true, // Always expanded on desktop
      items: Data.sidebarItems
          .map((item) => SidebarItem(icon: item.icon, text: item.label))
          .toList(),
      selectedIndex: selectedIndex,
      autoSelectedIndex: false,
      onItemSelected: (index) {
        _navigate(context, index);
      },
      frameDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      itemIconColor: Colors.blueGrey[700]!,
      itemSelectedColor: Colors.lightBlueAccent,
      itemHoverColor: Colors.lightBlueAccent.withOpacity(0.2),
      itemTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      itemIconSize: 28,
      itemSelectedBorder: BorderRadius.circular(8),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      headerIcon: Icons.widgets_rounded,
      headerIconSize: 34,
      headerIconColor: Colors.blueAccent,
      headerText: 'Navigation',
      headerTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      switchIconExpanded: Icons.menu_open_rounded,
      switchIconCollapsed: Icons.menu_rounded,
      minSize: 80,
      maxSize: 270,
      margin: const EdgeInsets.all(12),
      itemMargin: 12,
    );
  }

  /// 📌 Mobile Drawer
  Widget _buildDrawer(BuildContext context, int selectedIndex) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Center(
              child: Text(
                'Navigation',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Data.sidebarItems.length,
              itemBuilder: (context, index) {
                var item = Data.sidebarItems[index];
                return ListTile(
                  leading: Icon(item.icon, color: selectedIndex == index ? Colors.blueAccent : Colors.black87),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                      color: selectedIndex == index ? Colors.blueAccent : Colors.black87,
                    ),
                  ),
                  selected: selectedIndex == index,
                  onTap: () {
                    Navigator.pop(context); // Close Drawer
                    _navigate(context, index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 📌 Navigation Handler
  void _navigate(BuildContext context, int index) {
    var route = Data.sidebarItems[index];

    if (route.newRoute) {
      GoRouter.of(context).push(route.route);
      return;
    }

    context.read<SidebarCubit>().selectPage(route.route);
    GoRouter.of(context).go(route.route);
  }
}
