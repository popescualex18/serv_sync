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
            (SidebarCubit cubit) => cubit.state.selectedIndex);

    return AnimatedSidebar(
      expanded: MediaQuery.of(context).size.width > 600, // Responsive expansion
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
        var route = Data.sidebarItems[index];
         if(route.newRoute) {
           GoRouter.of(context).push(route.route);
           return;
         }
        context.read<SidebarCubit>().selectPage(route.route);
        GoRouter.of(context).go(route.route);
      },

      // 🎨 Light Theme Colors
      frameDecoration: BoxDecoration(
        color: Colors.white, // Bright background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Soft, subtle shadow
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      itemIconColor: Colors.blueGrey[700]!, // Soft blue-grey icons
      itemSelectedColor: Colors.lightBlueAccent, // Highlight for active item
      itemHoverColor: Colors.lightBlueAccent.withOpacity(0.2), // Hover effect
      itemTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      itemIconSize: 28,
      itemSelectedBorder: BorderRadius.circular(8),

      // 🌟 Animation Settings
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,

      // 🔹 Sidebar Header Customization
      headerIcon: Icons.widgets_rounded,
      headerIconSize: 34,
      headerIconColor: Colors.blueAccent, // Highlight color
      headerText: 'Navigation',
      headerTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),

      // Expand/Collapse Button Icons
      switchIconExpanded: Icons.menu_open_rounded,
      switchIconCollapsed: Icons.menu_rounded,

      // Sizing & Layout Adjustments
      minSize: 80,
      maxSize: 270,
      margin: const EdgeInsets.all(12),
      itemMargin: 12,
    );
  }
}
