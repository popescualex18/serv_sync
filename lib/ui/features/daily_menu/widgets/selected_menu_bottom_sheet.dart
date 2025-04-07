import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/main.dart';
import 'package:serv_sync/ui/shared/widgets/card/details_card.dart';
import 'package:serv_sync/ui/state_management/cubits/daily_menu/daily_menu_cubit.dart';
import 'package:serv_sync/ui/state_management/states/daily_menu_state.dart';

class SelectedMenuBottomSheet extends StatelessWidget {
  const SelectedMenuBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton.extended(
        onPressed: () => _showSelectedMenusBottomSheet(context),
        label: Text("View Selected"),
        icon: Icon(Icons.shopping_cart),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  /// **Floating Action Button Opens Bottom Sheet**
  void _showSelectedMenusBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DailyMenuSelectedElements();
      },
    );
  }
}

class DailyMenuSelectedElements extends StatelessWidget {
  const DailyMenuSelectedElements({super.key});

  @override
  Widget build(BuildContext context) {
    var state =
        context.select<DailyMenuCubit, DailyMenuState>((cubit) => cubit.state);
    var selectedMenus = state.selectedMenuItems;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 640) {
          Navigator.pop(context);
        }
        return Padding(
          key: ValueKey(selectedMenus.length),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Meniuri selectate",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Divider(),
              selectedMenus.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Nu aveti meniuri selectate"),
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: selectedMenus.length,
                        itemBuilder: (context, index) {
                          return DetailsCard(
                            item: selectedMenus[index],
                            actionButton: IconButton(
                              icon:
                                  Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                locator
                                    .get<DailyMenuCubit>()
                                    .removeFromCart(selectedMenus[index]);
                                locator.get<DailyMenuCubit>().save();
                              },
                            ),
                            onEditClosed: () {
                              locator.get<DailyMenuCubit>().reset();
                              locator.get<DailyMenuCubit>().fetchData();
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
