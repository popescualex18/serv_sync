import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/main.dart';
import 'package:serv_sync/ui/navigation/app_router.dart';
import 'package:serv_sync/ui/shared/widgets/base_widget.dart';
import 'package:serv_sync/ui/shared/widgets/buttons/action_button.dart';
import 'package:serv_sync/ui/shared/widgets/card/details_card.dart';
import 'package:serv_sync/ui/state_management/cubits/menu/menu_cubit.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    locator.get<MenuCubit>().loadMenus();
    super.initState();
  }

  @override
  void dispose() {
    locator.get<MenuCubit>().reset();
    super.dispose();
  }

  Widget buildChild(BuildContext context) {
    var menus =
        context.select<MenuCubit, List<MenuItem>>((cubit) => cubit.state);

    return Column(
      children: [
        // 🔹 Action Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ActionButton(
                onPressed: () => AppRouter.router.go("/menu/manage"),
                label: "Adaugă",
                icon: Icons.add_rounded,
              ),
              SizedBox(width: 16),
              Expanded(
                child: AnimatedSearchBar(
                  searchDecoration: InputDecoration(
                    labelText: 'Caută meniu',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  autoFocus: true,
                  label: "Caută meniu",
                  onChanged: locator.get<MenuCubit>().filterMenus,
                  onClose: locator.get<MenuCubit>().clearFilter,
                ),
              ),
            ],
          ),
        ),

        // 🔹 Menu List/Grid
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (menus.isEmpty) {
                return Center(
                  child: Text(
                    "Nu există meniuri disponibile",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    return DetailsCard(
                      item: menus[index],
                      actionButton: _actionButton(menus[index]),
                      onEditClosed: locator.get<MenuCubit>().loadMenus,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _actionButton(MenuItem item) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == "edit") {
          AppRouter.router.push("/menu/manage/${item.id}");
        } else if (value == "delete") {
          locator.get<MenuCubit>().delete(item.id!);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: "edit", child: Text("Editează")),
        PopupMenuItem(
            value: "delete",
            child: Text("Șterge", style: TextStyle(color: Colors.red))),
      ],
      icon: Icon(Icons.more_vert_rounded,
          size: 18, color: Colors.grey), // Smaller menu icon
      padding: EdgeInsets.zero, // Remove extra padding
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidgetWrapper(
      buildChild: buildChild,
    );
  }
}
