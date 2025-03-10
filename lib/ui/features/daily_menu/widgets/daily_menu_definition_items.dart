import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/ui/state_management/cubits/daily_menu/daily_menu_cubit.dart';

class DailyMenuDefinitionItems extends StatefulWidget {
  final TabController tabController;
  const DailyMenuDefinitionItems({super.key, required this.tabController});

  @override
  State<DailyMenuDefinitionItems> createState() =>
      _DailyMenuDefinitionItemsState();
}

class _DailyMenuDefinitionItemsState extends State<DailyMenuDefinitionItems> {
  late final DailyMenuCubit _cubit;
  @override
  void initState() {
    _cubit = context.read<DailyMenuCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var selectedMenus = context.select<DailyMenuCubit, List<MenuItem>>(
            (cubit) => cubit.state.selectedMenuItems);
    return SingleChildScrollView(
      child: Column(
        children: selectedMenus.map((item) {
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent.shade100,
                child: Icon(Icons.fastfood, color: Colors.white),
              ),
              title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Pret: ${item.price.toString()}"),
              trailing: IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.greenAccent.shade700),
                onPressed: () => _cubit.removeFromCart(item),
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}
