import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/core/constants/constants.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/ui/features/daily_menu/widgets/selected_menu_bottom_sheet.dart';
import 'package:serv_sync/ui/navigation/app_router.dart';
import 'package:serv_sync/ui/shared/widgets/base_widget.dart';
import 'package:serv_sync/ui/shared/widgets/card/details_card.dart';
import 'package:serv_sync/ui/shared/widgets/snack_bar/snackbar_provider.dart';
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
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '');
    _cubit = context.read<DailyMenuCubit>();
    _cubit.fetchData();

    _selectedCategory = Constants.categories.values.first;
  }

  @override
  void dispose() {
    _cubit.categoryIndex = 0;
    _cubit.reset();
    super.dispose();
  }

  Widget buildChild(BuildContext context) {
    var state =
        context.select<DailyMenuCubit, DailyMenuState>((cubit) => cubit.state);
    var selectedMenus = state.selectedMenuItems;
    var menus = state.menuItems;
    var menuNotFound = state.menuNotFound;
    return BlocListener<DailyMenuCubit, DailyMenuState>(
      listener: (BuildContext context, DailyMenuState state) {},
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return _buildDesktopLayout(menus, selectedMenus, menuNotFound);
          } else {
            return _buildMobileLayout(menus, selectedMenus, menuNotFound);
          }
        },
      ),
    );
  }

  /// **Desktop Layout**: Uses TabBar and side-by-side layout
  Widget _buildDesktopLayout(
      List<MenuItem> menus, List<MenuItem> selectedMenus, bool menuNotFound) {
    return Column(
      children: [
        _buildCategoryChips(), // Desktop uses a TabBar
        SizedBox(height: 10),
        _buildSearchBar(),
        SizedBox(height: 10),
        Expanded(
          child: Row(
            children: [
              _buildMenuList(menus, menuNotFound, flex: 1,),
              VerticalDivider(width: 1, color: Colors.grey),
              _buildSelectedMenu(selectedMenus, flex: 1),
            ],
          ),
        ),
      ],
    );
  }

  /// **Mobile Layout**: Uses Dropdown and Floating Action Button
  Widget _buildMobileLayout(
      List<MenuItem> menus, List<MenuItem> selectedMenus, bool menuNotFound) {
    return Stack(
      children: [
        Column(
          children: [
            _buildDropdown(), // Mobile uses a modern Dropdown
            SizedBox(height: 5),
            _buildSearchBar(),
            SizedBox(height: 10),
            Expanded(child: _buildMenuList(menus, menuNotFound)),
          ],
        ),
        SelectedMenuBottomSheet(),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Row(
          children: Constants.categories.entries.map((entry) {
            int index = Constants.categories.keys.toList().indexOf(entry.key);
            bool isSelected = _cubit.categoryIndex == index;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(entry.value),
                selected: isSelected,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                selectedColor: Colors.blueAccent,
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onSelected: (_) {
                  _cubit.changeCategory(index, filterText: _controller.text);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }


  Widget _removeMenuActionButton(MenuItem item) {
    return IconButton(
      icon: Icon(Icons.remove_circle, color: Colors.red),
      onPressed: () {
        _cubit.removeFromCart(item);
        _cubit.save();
        SnackbarProvider.success(
          context,
          "${item.name} a fost sters",
        );
      },
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
                    _controller.clear();
                    _cubit.reset();
                    _cubit.fetchData();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// **Modern Dropdown for Mobile**
  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        onChanged: (newValue) {
          setState(() {
            _selectedCategory = newValue!;
            int index = Constants.categories.values.toList().indexOf(newValue);
            _cubit.changeCategory(
              index,
              filterText: _controller.text,
            );
          });
        },
        items: Constants.categories.values
            .map((category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category, style: TextStyle(fontSize: 18)),
                ))
            .toList(),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey.shade200,
          prefixIcon: Icon(Icons.category),
        ),
      ),
    );
  }

  /// **Search Bar (Common for Both Layouts)**
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AnimatedSearchBar(
        controller: _controller,
        autoFocus: true,
        searchDecoration: InputDecoration(
          labelText: 'Search Menu',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        label: "Search Menu",
        onChanged: _cubit.filterMenus,
        onClose: _cubit.clearFilter,
      ),
    );
  }

  Widget _buildMenuList(List<MenuItem> menus, bool menuNotFound, {int flex = 1}) {
    if (menuNotFound) {
      return Expanded(
        flex: flex,
        child: Center(
          child: OutlinedButton.icon(
            onPressed: () async{
              await AppRouter.router.push("/menu/add", extra: menus.first);
              _controller.clear();
              _cubit.reset();
              _cubit.fetchData();
            },
            icon: Icon(Icons.add, color: Colors.blueAccent),
            label: Text(
              "Adaugă meniul",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueAccent,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              side: BorderSide(color: Colors.blueAccent, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
    }

    return Expanded(
      flex: flex,
      child: ListView.builder(
        itemCount: menus.length,
        itemBuilder: (context, index) {
          return DetailsCard(
            item: menus[index],
            actionButton: _addMenuActionButton(menus[index]),
            onEditClosed: () {
              _controller.clear();
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
      onPressed: () {
        _cubit.addToCart(item);
        _cubit.save();
        SnackbarProvider.success(
          context,
          "${item.name} a fost adaugat",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidgetWrapper(buildChild: buildChild);
  }
}
