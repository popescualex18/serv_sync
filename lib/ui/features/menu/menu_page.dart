import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/main.dart';
import 'package:serv_sync/ui/navigation/app_router.dart';
import 'package:serv_sync/ui/shared/widgets/base_widget.dart';
import 'package:serv_sync/ui/shared/widgets/table/custom_table.dart';
import 'package:serv_sync/ui/shared/widgets/table/models/custom_table_setting.dart';
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () => AppRouter.router.go("/menu/manage"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text("Adauga"),
              ),
              SizedBox(width: 30),
              Expanded(
                child: AnimatedSearchBar(
                  searchDecoration: InputDecoration(
                    labelText: 'Cauta meniu',
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  label: "Cauta meniu",
                  onChanged: locator.get<MenuCubit>().filterMenus,
                  onClose: locator.get<MenuCubit>().clearFilter,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomTable(
                editRoute: "/menu/manage",
                onDelete: locator.get<MenuCubit>().delete,
                data: menus,
                columns: [
                  CustomTableSetting<MenuItem>(
                    columnName: "Nume",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    rowValueSelector: (item) => item.name,
                  ),
                  CustomTableSetting<MenuItem>(
                    width: 100,
                    columnName: "Pret",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    rowValueSelector: (item) => item.price.toString(),
                  ),
                  CustomTableSetting<MenuItem>(
                    width: 70,
                    columnName: "Paine",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    rowValueSelector: (item) => item.hasBread ? "Da" : "Nu",
                  ),
                  CustomTableSetting<MenuItem>(
                    width: 70,
                    columnName: "Mamaliga",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    rowValueSelector: (item) => item.hasPolenta ? "Da" : "Nu",
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidgetWrapper(
      buildChild: buildChild,
    );
  }
}
