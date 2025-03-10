import 'package:flutter/material.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';

class CustomTableSetting<T extends BaseEntity> {
  final String columnName;
  final TextStyle? style;
  final double? width;
  final String Function(T items) rowValueSelector;
  CustomTableSetting({
    required this.columnName,
    required this.rowValueSelector,
    this.style,
    this.width,
  });
}
