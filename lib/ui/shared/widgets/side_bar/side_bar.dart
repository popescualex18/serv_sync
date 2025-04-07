import 'package:animated_sidebar/animated_sidebar.dart';
import 'package:flutter/foundation.dart';
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
    if(kIsWeb) {
      return _buildDrawer(context, selectedIndex);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return _buildSidebar(context, selectedIndex);
        } else {
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
          .map(
            (item) => SidebarItem(
              icon: item.icon,
              text: item.label,
            ),
          )
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
            color: Colors.grey.withValues(alpha:0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      itemIconColor: Colors.blueGrey[700]!,
      itemSelectedColor: Colors.lightBlueAccent,
      itemHoverColor: Colors.lightBlueAccent.withValues(alpha:0.2),
      itemTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      itemIconSize: 28,
      itemSelectedBorder: BorderRadius.circular(8),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      headerIconSize: 34,
      headerIcon: Icons.restaurant,
      headerIconColor: Colors.blueAccent,
      headerText: 'La Neagtovo',
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

  Widget _buildDrawer(BuildContext context, int selectedIndex) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      elevation: 8,
      child: Column(
        children: [
          // Modern gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'La Neagtovo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4),

                ],
              ),
            ),
          ),

          // Modern List Tiles
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: Data.sidebarItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                var item = Data.sidebarItems[index];
                bool isSelected = selectedIndex == index;

                return Material(
                  color: isSelected
                      ? Colors.blueAccent.withOpacity(0.08)
                      : Colors.transparent,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Icon(
                      item.icon,
                      color:
                      isSelected ? Colors.blueAccent : Colors.grey.shade700,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 16,
                        color: isSelected ? Colors.blueAccent : Colors.black87,
                      ),
                    ),
                    selected: isSelected,
                    onTap: () {
                      Navigator.pop(context);
                      _navigate(context, index);
                    },
                  ),
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

    //context.read<SidebarCubit>().selectPage(route.route);
    GoRouter.of(context).go(route.route);
  }
}
