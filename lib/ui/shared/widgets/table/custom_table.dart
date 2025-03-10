import 'package:flutter/material.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/ui/shared/widgets/table/custom_table_column.dart';
import 'package:serv_sync/ui/shared/widgets/table/custom_table_data_row.dart';
import 'package:serv_sync/ui/shared/widgets/table/models/custom_table_setting.dart';

class CustomTable<T extends BaseEntity> extends StatelessWidget {
  final List<CustomTableSetting<T>> columns;
  final String? editRoute;
  final Future<void> Function(String id) onDelete;
  final List<T> data;
  const CustomTable({
    super.key,
    required this.columns,
    required this.data,
    required this.onDelete,
    this.editRoute,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Material(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [..._buildCells()],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomTableDataRow<T>(
                onDelete: onDelete,
                data: data[index],
                rowSettings: columns,
                editRoute: editRoute,
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCells() {
    return columns
        .map((column) => CustomTableCell(
              width: column.width,
              style: column.style,
              cellText: column.columnName,
            ))
        .toList(growable: false);
  }
}
