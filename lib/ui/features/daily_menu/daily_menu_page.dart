import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/ui/features/daily_menu/widgets/daily_menu_definition_items.dart';
import 'package:serv_sync/ui/shared/widgets/base_widget.dart';
import 'package:serv_sync/ui/shared/widgets/buttons/action_button.dart';
import 'package:serv_sync/ui/state_management/cubits/daily_menu/daily_menu_cubit.dart';
import 'package:serv_sync/ui/state_management/states/daily_menu_state.dart';

class DailyMenuPage extends StatefulWidget {
  const DailyMenuPage({super.key});

  @override
  State<DailyMenuPage> createState() => _DailyMenuPageState();
}

class _DailyMenuPageState extends State<DailyMenuPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final DailyMenuCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<DailyMenuCubit>();
    _cubit.fetchData();
    _tabController =
        TabController(length: _cubit.categories.length, vsync: this);
  }

  @override
  void dispose() {
    _cubit.reset();
    super.dispose();
  }

  Widget buildChild(BuildContext context) {

    var state = context.select<DailyMenuCubit,DailyMenuState>(
        (cubit) => cubit.state);
    var selectedMenus = state.selectedMenuItems;
    var menus = state.menuItems ?? [];
    print("start ${DateTime.now()}");
    var widget = Column(
      children: [
        // Full Width Tab Bar
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
          ),
          child: TabBar(
            onTap: _cubit.changeCategory,
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            tabs: _cubit.categories.values
                .map((category) => Tab(text: category))
                .toList(),
          ),
        ),
        SizedBox(height: 10),
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AnimatedSearchBar(
            searchDecoration: InputDecoration(
              labelText: 'Cauta meniu',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
            label: "Cauta meniu",
            onChanged: _cubit.filterMenus,
            onClose: _cubit.clearFilter,
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: Row(
            children: [
              // Left Side: Available Menus
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(menus[index].name,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle:
                            Text("Pret: ${menus[index].price.toString()}"),
                        trailing: IconButton(
                          icon: Icon(Icons.add_circle,
                              color: Colors.greenAccent.shade700),
                          onPressed: () => _cubit.addToCart(menus[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
              VerticalDivider(width: 1, color: Colors.grey),
              // Right Side: Selected Menus
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Selected Items",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedMenus.length,
                        itemBuilder: (context, index) {
                          var item = selectedMenus[index];
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text("Pret: ${item.price} RON"),
                            trailing: IconButton(
                              icon:
                                  Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () => _cubit.removeFromCart(item),
                            ),
                          );
                        },
                      ),
                    ),
                    // Save Button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: _cubit.save,
                        icon: Icon(Icons.save),
                        label: Text("Save"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
    print("ended ${DateTime.now()}");
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidgetWrapper(buildChild: buildChild);
  }
}
