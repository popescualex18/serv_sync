import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/ui/shared/widgets/base_widget.dart';
import 'package:serv_sync/ui/shared/widgets/card/details_card.dart';
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
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<DailyMenuCubit>();
    _cubit.fetchData();
    _tabController =
        TabController(length: _cubit.categories.length, vsync: this);
    _selectedCategory = _cubit.categories.values.first;
  }

  @override
  void dispose() {
    _cubit.reset();
    super.dispose();
  }

  Widget buildChild(BuildContext context) {
    var state =
        context.select<DailyMenuCubit, DailyMenuState>((cubit) => cubit.state);
    var selectedMenus = state.selectedMenuItems;
    var menus = state.menuItems ?? [];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return _buildDesktopLayout(menus, selectedMenus);
        } else {
          return _buildMobileLayout(menus, selectedMenus);
        }
      },
    );
  }

  Widget _buildDesktopLayout(
      List<MenuItem> menus, List<MenuItem> selectedMenus) {
    return Column(
      children: [
        _buildTabBar(), // Desktop uses a TabBar
        SizedBox(height: 10),
        _buildSearchBar(),
        SizedBox(height: 10),
        Expanded(
          child: Row(
            children: [
              _buildMenuList(menus, flex: 1),
              VerticalDivider(width: 1, color: Colors.grey),
              _buildSelectedMenu(selectedMenus, flex: 1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
      List<MenuItem> menus, List<MenuItem> selectedMenus) {
    return Column(
      children: [
        _buildDropdown(), // Mobile uses a Dropdown
        SizedBox(height: 5),
        _buildSearchBar(),
        SizedBox(height: 10),
        Expanded(child: _buildMenuList(menus)),
        Divider(height: 2, color: Colors.grey),
        Expanded(
          child: _buildSelectedMenu(
            selectedMenus,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5), // Semi-transparent for a modern look

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: TabBar(
          isScrollable: true,
          controller: _tabController,
          indicator: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent], // Gradient effect
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[500],
          labelStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: (index) {
            _tabController.animateTo(
              index,
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            );
            _cubit.changeCategory(index);
          },
          tabs: _cubit.categories.values
              .map(
                (category) => Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18), // Better spacing
              child: Text(category),
            ),
          )
              .toList(),
        ),
      ),
    );
  }



  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      value: _selectedCategory,
      onChanged: (newValue) {
        _selectedCategory = newValue!;
        int index = _cubit.categories.values.toList().indexOf(newValue!);
        _cubit.changeCategory(index);
      },
      items: _cubit.categories.values
          .map((category) => DropdownMenuItem<String>(
                value: category,
                child: Text(category, style: TextStyle(fontSize: 18)),
              ))
          .toList(),

      style: TextStyle(fontSize: 18), // ✅ Ensure dropdown text is readable
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
    );
  }

  /// Search Bar (Common for both layouts)
  Widget _buildSearchBar() {
    return Padding(
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
    );
  }

  /// Available Menus List
  Widget _buildMenuList(List<MenuItem> menus, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: ListView.builder(
        itemCount: menus.length,
        itemBuilder: (context, index) {
          return DetailsCard(
            item: menus[index],
            actionButton: _addMenuActionButton(menus[index]),
            onEditClosed: () {
              _cubit.reset();
              _cubit.fetchData();
            },
          );
        },
      ),
    );
  }

  Widget _addMenuActionButton(MenuItem item) {
    return IconButton(
      icon: Icon(Icons.add_circle, color: Colors.greenAccent.shade700),
      onPressed: () => _cubit.addToCart(item),
    );
  }

  Widget _removeMenuActionButton(MenuItem item) {
    return IconButton(
      icon: Icon(Icons.remove_circle, color: Colors.red),
      onPressed: () => _cubit.removeFromCart(item),
    );
  }

  /// Selected Menu List with Save Button
  Widget _buildSelectedMenu(List<MenuItem> selectedMenus, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Meniuri selectate",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedMenus.length,
              itemBuilder: (context, index) {
                return DetailsCard(
                  item: selectedMenus[index],
                  actionButton: _removeMenuActionButton(selectedMenus[index]),
                  onEditClosed: () {
                    _cubit.menus.clear();
                    _cubit.dailyDefinitions.clear();
                    _cubit.fetchData();
                  },
                );
              },
            ),
          ),
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
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidgetWrapper(buildChild: buildChild);
  }
}
