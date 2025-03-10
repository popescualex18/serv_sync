import 'package:flutter/material.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/ui/navigation/app_router.dart';
import 'package:serv_sync/ui/shared/widgets/table/custom_table_column.dart';
import 'package:serv_sync/ui/shared/widgets/table/models/custom_table_setting.dart';

class CustomTableDataRow<T extends BaseEntity> extends StatelessWidget {
  final List<CustomTableSetting<T>> rowSettings;
  final T data;
  final String? editRoute;
  final Future<void> Function(String id) onDelete;
  const CustomTableDataRow({
    super.key,
    required this.rowSettings,
    required this.data,
    this.editRoute,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        children: [_buildDeleteCell(),..._buildCells()],
      ),
    );
  }

  List<Widget> _buildCells() {
    var cellIndex = 0;
    return rowSettings.map((column) {
      cellIndex++;
      var cellText = column.rowValueSelector(data);
      return CustomTableCell(
        width: column.width,
        cellText: cellText,
        onClick: cellIndex == 1 && editRoute != null
            ? () => AppRouter.router.go("$editRoute/${data.id}")
            : null,
      );
    }).toList(growable: false);
  }

  Widget _buildDeleteCell() {
    return IconButton(onPressed: () async=> await onDelete(data.id!) , icon: Icon(Icons.delete));
  }
}
